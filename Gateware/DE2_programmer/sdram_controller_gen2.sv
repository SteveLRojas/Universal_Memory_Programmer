module sdram_controller_gen2
	#(
		parameter BUS_WIDTH=8,
		parameter PORT_ADDRESS_BITS=21,
		parameter SDRAM_ADDRESS_BITS=11,
		parameter DQM_BITS=1,
		parameter NUM_BANKS=2,
		parameter BANK_NUM_ROWS=2048,
		parameter BANK_NUM_COLUMNS=512,
		parameter BURST_LENGTH=8,
		parameter MEM_CLK_KHZ=50000,
		parameter REFRESH_CYCLES=4096,
		parameter REFRESH_INTERVAL_MS=64,
		parameter CAS_LATENCY=3,
		parameter TRP=30,
		parameter TRSA=20,
		parameter TRCD=30,
		parameter TRC=80,
		parameter TRAS_MIN=50
	)
	(
		input wire clk,
		input wire rst,
		
		input wire[PORT_ADDRESS_BITS-1:0] p1_address,
		input wire[BUS_WIDTH-1:0] p1_to_mem,
		output reg[BUS_WIDTH-1:0] from_mem,
		input wire p1_req,
		input wire p1_wren,
		output wire p1_ready,
		output reg p1_valid,
		output wire[2:0] p1_offset,
		
		output wire sdram_cke,
		output wire sdram_cs_n,
		output wire sdram_wre_n,
		output wire sdram_cas_n,
		output wire sdram_ras_n,
		output reg[SDRAM_ADDRESS_BITS-1:0] sdram_a,
		output reg[$clog2(NUM_BANKS)-1:0] sdram_ba,
		output reg[DQM_BITS-1:0] sdram_dqm,
		inout wire[BUS_WIDTH-1:0] sdram_dq
	);
    //TODO: enforce tDPL
	localparam[2:0] MODE_BURST_LENGTH = 3'($clog2(BURST_LENGTH));
	localparam[0:0] MODE_BURST_TYPE = 1'b1;
	localparam[2:0] MODE_CAS_LATENCY = 3'(CAS_LATENCY);
	localparam[0:0] MODE_WRITE_BURST_TYPE = 1'b0;
	
	localparam COLUMN_ADDRESS_BITS = $clog2(BANK_NUM_COLUMNS);
	localparam ROW_ADDRESS_BITS = $clog2(BANK_NUM_ROWS);
	localparam BANK_ADDRESS_BITS = $clog2(NUM_BANKS);
	
	localparam[10:0] REFRESH_TIMER_COUNT = 11'(MEM_CLK_KHZ / (REFRESH_CYCLES / REFRESH_INTERVAL_MS));
	localparam[3:0] TRP_CLK_CYCLES = 4'((TRP * MEM_CLK_KHZ + 999999) / 1000000);
	localparam[3:0] TRSA_CLK_CYCLES = 4'( (TRSA * MEM_CLK_KHZ + 999999) / 1000000 );
	localparam[3:0] TRCD_CLK_CYCLES = 4'( (TRCD * MEM_CLK_KHZ + 999999) / 1000000 );
	localparam[3:0] TRC_CLK_CYCLES = 4'( (TRC * MEM_CLK_KHZ + 999999) / 1000000 );
	localparam[3:0] TRAS_MIN_CLK_CYCLES = 4'( (TRAS_MIN * MEM_CLK_KHZ + 999999) / 1000000 );
	
	localparam [2:0] SDRAM_CMD_LOADMODE  = 3'b000;
	localparam [2:0] SDRAM_CMD_REFRESH   = 3'b001;
	localparam [2:0] SDRAM_CMD_PRECHARGE = 3'b010;
	localparam [2:0] SDRAM_CMD_ACTIVE    = 3'b011;
	localparam [2:0] SDRAM_CMD_WRITE     = 3'b100;
	localparam [2:0] SDRAM_CMD_READ      = 3'b101;
	localparam [2:0] SDRAM_CMD_NOP       = 3'b111;

	enum logic[5:0] {
			S_CMD_INIT_DEVICE,
			S_CMD_INIT_WAIT,
			S_CMD_MODE,
			S_CMD_MODE_WAIT,
			S_CMD_IDLE,

			S_CMD_CHECK_BANK,
			S_CMD_PRECHARGE,
			S_CMD_PRECHARGE_WAIT,
			S_CMD_ACTIVATE,
			S_CMD_ACTIVATE_WAIT,
			
			S_CMD_READ,
			S_CMD_WRITE_NOP,
			S_CMD_WRITE,
			
			S_CMD_PRECHARGE_ALL,
			S_CMD_PRECHARGE_ALL_WAIT,
			S_CMD_REFRESH,
			S_CMD_REFRESH_WAIT } cmd_state;

	enum logic[4:0] {
			S_IO_IDLE,
			S_IO_FROM_MEM,
			S_IO_TO_MEM } io_state;

	reg gate_out;
	reg[2:0] sdram_cmd;
	reg[2:0] init_refresh_count;	//initially set to 7. On refresh the number of refresh cycles performed will be this number plus one.
	reg[10:0] refresh_timer;
	
	reg[2:0] burst_count;
	reg[3:0] cycle_count;
	reg[2:0] cycles_remaining;
	reg[CAS_LATENCY-1:0] cas_shift;
	
	reg[PORT_ADDRESS_BITS-1:0] address_hold;
	reg[BUS_WIDTH-1:0] data_out;
	reg wren;
	reg refresh_flag;

	reg[NUM_BANKS-1:0] has_open_row;
	reg[ROW_ADDRESS_BITS-1:0] open_row_address[NUM_BANKS-1:0];
	
	wire[NUM_BANKS-1:0] tras_min_ready;
	wire current_bank_activated;
	wire current_row_activated;
	wire ready_for_read_cmd;
	wire ready_for_precharge;

	assign p1_offset = burst_count;
	assign p1_ready = (cmd_state == S_CMD_IDLE) & ~refresh_flag;
	assign sdram_cke = 1'b1;
	assign sdram_cs_n = 1'b0;
	assign {sdram_ras_n, sdram_cas_n, sdram_wre_n} = sdram_cmd;
	assign sdram_dq = gate_out ? data_out : {BUS_WIDTH{1'bZ}};

	assign current_bank_activated = has_open_row[address_hold[BANK_ADDRESS_BITS+COLUMN_ADDRESS_BITS-1 : COLUMN_ADDRESS_BITS]];
	assign current_row_activated = (open_row_address[address_hold[BANK_ADDRESS_BITS+COLUMN_ADDRESS_BITS-1 : COLUMN_ADDRESS_BITS]] == address_hold[PORT_ADDRESS_BITS-1 : BANK_ADDRESS_BITS+COLUMN_ADDRESS_BITS]);
	assign ready_for_read_cmd = ((io_state == S_IO_IDLE) & ~|cas_shift) | ((io_state == S_IO_FROM_MEM) & (cycles_remaining < CAS_LATENCY)) | ((io_state == S_IO_TO_MEM) & (cycles_remaining < (CAS_LATENCY - 1)));
    assign ready_for_precharge = (io_state == S_IO_IDLE) & ~|cas_shift & tras_min_ready[address_hold[BANK_ADDRESS_BITS+COLUMN_ADDRESS_BITS-1 : COLUMN_ADDRESS_BITS]];
    
    generate
        if(TRAS_MIN_CLK_CYCLES > (TRCD_CLK_CYCLES + 3))
        begin
            logic[3:0] tras_min_timers[NUM_BANKS-1:0];
				genvar d;
            for(d = 0; d < NUM_BANKS; d = d + 1)
				begin : tras_ready_block
                assign tras_min_ready[d] = ~|tras_min_timers[d];
				end

            always @(posedge clk)
            begin
                if(rst)
                begin
                    for(integer d = 0; d < NUM_BANKS; d = d + 1)
                    begin
                        tras_min_timers[d] <= 4'h0;
                    end
                end
                else
                begin
                    for(integer d = 0; d < NUM_BANKS; d = d + 1)
                    begin
                        if(|tras_min_timers[d])
                            tras_min_timers[d] <= tras_min_timers[d] - 4'h1;
                    end
                    
                    if(cmd_state == S_CMD_ACTIVATE)
                        tras_min_timers[address_hold[BANK_ADDRESS_BITS+COLUMN_ADDRESS_BITS-1 : COLUMN_ADDRESS_BITS]] <= TRAS_MIN_CLK_CYCLES;
                end
            end
        end
        else
        begin
            assign tras_min_ready = {NUM_BANKS{1'b1}};
        end
    endgenerate

	always_ff @(posedge clk)
	begin
		if(rst)
		begin
			io_state <= S_IO_IDLE;
			cmd_state <= S_CMD_INIT_DEVICE;
			sdram_cmd <= SDRAM_CMD_NOP;
			gate_out <= 1'b0;
			sdram_dqm <= {DQM_BITS{1'b0}};
			address_hold <= {PORT_ADDRESS_BITS{1'b0}};
			p1_valid <= 1'b0;
			init_refresh_count <= 3'b111;
			refresh_timer <= 11'h00;
			refresh_flag <= 1'b1;
			cycle_count <= 4'h0;
			cycles_remaining <= 3'h0;
			burst_count <= 3'h0;
			cas_shift <= CAS_LATENCY'('h0);
			has_open_row <= NUM_BANKS'('h0);
		end
		else
		begin
			//refresh timer
			if(refresh_timer == REFRESH_TIMER_COUNT)
			begin
				refresh_timer <= 11'h00;
				refresh_flag <= 1'b1;
			end
			else
				refresh_timer <= refresh_timer + 11'h01;
				
			//CAS latency shifter
			cas_shift <= {1'b0, cas_shift[CAS_LATENCY-1 : CAS_LATENCY-2]};

			case(io_state)
				S_IO_IDLE:
				begin
					if(cas_shift[0])
					begin
						io_state <= S_IO_FROM_MEM;
						p1_valid <= 1'b0;
						burst_count <= 3'h0;
					end
					else if((cmd_state == S_CMD_WRITE_NOP) & ~|cas_shift)  //check cas_shift for pending reads
					begin
						io_state <= S_IO_TO_MEM;
						p1_valid <= 1'b1;
						burst_count <= 3'h1;
					end
					else
					begin
						p1_valid <= 1'b0;
						burst_count <= 3'h0;
					end
					cycles_remaining <= BURST_LENGTH - 1;
					gate_out <= 1'b0;
					sdram_dqm <= (|cas_shift) ? {DQM_BITS{1'b0}} : {DQM_BITS{1'b1}};
				end
				
				S_IO_FROM_MEM:
				begin
					burst_count <= p1_valid ? burst_count + 3'h1 : 3'h0;
					cycles_remaining <= cycles_remaining - 3'h1;
					p1_valid <= 1'b1;
					from_mem <= sdram_dq;
					if(~|cycles_remaining)
					begin
						io_state <= S_IO_IDLE;
					end
				end
				
				S_IO_TO_MEM:
				begin
					burst_count <= p1_valid ? burst_count + 3'h1 : 3'h0;
					cycles_remaining <= cycles_remaining - 3'h1;
					data_out <= p1_to_mem;
					sdram_dqm <= {DQM_BITS{1'b0}};
					gate_out <= 1'b1;
					if(~|cycles_remaining)
					begin
						p1_valid <= 1'b0;
						io_state <= S_IO_IDLE;
					end
				end
				default: ;
			endcase // io_state


			case(cmd_state)
				S_CMD_INIT_DEVICE:
				begin
					sdram_cmd <= SDRAM_CMD_PRECHARGE;
					sdram_a <= SDRAM_ADDRESS_BITS'('h0);
					sdram_a[10] <= 1'b1;	//precharge all
					cycle_count <= 4'h0;
					cmd_state <= S_CMD_INIT_WAIT;
				end
				S_CMD_INIT_WAIT:
				begin
					sdram_cmd <= SDRAM_CMD_NOP;
					cycle_count <= cycle_count + 4'h1;
					if(cycle_count == TRP_CLK_CYCLES)
						cmd_state <= S_CMD_MODE;
				end
				S_CMD_MODE:
				begin
					sdram_cmd <= SDRAM_CMD_LOADMODE;
					sdram_a <= SDRAM_ADDRESS_BITS'('h0);
					sdram_a <= {{(SDRAM_ADDRESS_BITS-10){1'b0}}, MODE_WRITE_BURST_TYPE, 2'b00, MODE_CAS_LATENCY, MODE_BURST_TYPE, MODE_BURST_LENGTH};
					sdram_ba <= {$clog2(NUM_BANKS){1'b0}};
					cycle_count <= 4'h0;
					cmd_state <= S_CMD_MODE_WAIT;
				end
				S_CMD_MODE_WAIT:
				begin
					sdram_cmd <= SDRAM_CMD_NOP;
					cycle_count <= cycle_count + 4'h1;
					if(cycle_count == TRSA_CLK_CYCLES)
						cmd_state <= S_CMD_PRECHARGE_ALL;
				end

				S_CMD_IDLE:
				begin
					//p1_ready <= 1'b0;
					sdram_cmd <= SDRAM_CMD_NOP;
					if(refresh_flag)
					begin
						cmd_state <= S_CMD_PRECHARGE_ALL;
					end
					else if(p1_req)	//port 1 is read and write
					begin
						address_hold <= p1_address;
						//req_flag <= 1'b0;
						wren <= p1_wren;
						cmd_state <= S_CMD_CHECK_BANK;
					end
				end
				S_CMD_CHECK_BANK:
				begin
					if(current_bank_activated)
					begin
						if(current_row_activated)
						begin
							if(wren)
								cmd_state <= S_CMD_WRITE_NOP;
							else
								cmd_state <= S_CMD_READ;
						end
						else
						begin
							cmd_state <= S_CMD_PRECHARGE;
						end
					end
					else
					begin
						cmd_state <= S_CMD_ACTIVATE;
					end
				end
				S_CMD_PRECHARGE:
				begin
					//if(io_state == S_IO_IDLE)	//TODO: do this earlier for reads?
					if(ready_for_precharge)
					begin
						sdram_cmd <= SDRAM_CMD_PRECHARGE;
						sdram_ba[BANK_ADDRESS_BITS-1:0] <= address_hold[BANK_ADDRESS_BITS+COLUMN_ADDRESS_BITS-1 : COLUMN_ADDRESS_BITS];	//set bank
						sdram_a <= SDRAM_ADDRESS_BITS'('h0);
						sdram_a[10] <= 1'b0;	//precharge only the selected bank
						cycle_count <= 4'h0;
						cmd_state <= S_CMD_PRECHARGE_WAIT;
					end
				end
				S_CMD_PRECHARGE_WAIT:
				begin
					sdram_cmd <= SDRAM_CMD_NOP;
					cycle_count <= cycle_count + 4'h1;
					if(cycle_count == (TRP_CLK_CYCLES-1))
					begin
						cmd_state <= S_CMD_ACTIVATE;
					end
				end
				S_CMD_ACTIVATE:
				begin
					sdram_cmd <= SDRAM_CMD_ACTIVE;	//send activate command
					sdram_ba[BANK_ADDRESS_BITS-1:0] <= address_hold[BANK_ADDRESS_BITS+COLUMN_ADDRESS_BITS-1 : COLUMN_ADDRESS_BITS];	//set bank
					sdram_a <= SDRAM_ADDRESS_BITS'('h0);
					sdram_a[ROW_ADDRESS_BITS-1:0] <= address_hold[PORT_ADDRESS_BITS-1 : BANK_ADDRESS_BITS+COLUMN_ADDRESS_BITS];	//set row
					has_open_row[address_hold[BANK_ADDRESS_BITS+COLUMN_ADDRESS_BITS-1 : COLUMN_ADDRESS_BITS]] <= 1'b1;
					open_row_address[address_hold[BANK_ADDRESS_BITS+COLUMN_ADDRESS_BITS-1 : COLUMN_ADDRESS_BITS]] <= address_hold[PORT_ADDRESS_BITS-1 : BANK_ADDRESS_BITS+COLUMN_ADDRESS_BITS];
					cycle_count <= 4'h0;
					cmd_state <= S_CMD_ACTIVATE_WAIT;
				end
				S_CMD_ACTIVATE_WAIT:
				begin
					sdram_cmd <= SDRAM_CMD_NOP;
					cycle_count <= cycle_count + 4'h1;
					if(cycle_count == (TRCD_CLK_CYCLES-1))
					begin
						if(wren)
							cmd_state <= S_CMD_WRITE_NOP;
						else
							cmd_state <= S_CMD_READ;
					end					
				end

				S_CMD_READ:
				begin
					if(ready_for_read_cmd)
					begin
						sdram_cmd <= SDRAM_CMD_READ;
						sdram_a <= SDRAM_ADDRESS_BITS'('h0);
						sdram_a[10] <= 1'b0;	//no auto precharge
						sdram_a[COLUMN_ADDRESS_BITS-1:0] <= address_hold[COLUMN_ADDRESS_BITS-1:0];	//set column
						sdram_dqm <= {DQM_BITS{1'b0}};
						cas_shift[CAS_LATENCY-1] <= 1'b1;
						//p1_ready <= 1'b1;
						cmd_state <= S_CMD_IDLE;
					end
				end

				S_CMD_WRITE_NOP:
				begin
					if((io_state == S_IO_IDLE) & ~|cas_shift)  //check cas_shift for pending reads
					begin
						cmd_state <= S_CMD_WRITE;
					end
				end
				S_CMD_WRITE:
				begin
					sdram_cmd <= SDRAM_CMD_WRITE;
					sdram_a <= SDRAM_ADDRESS_BITS'('h0);
					sdram_a[10] <= 1'b0;	//no automatic precharge
					sdram_a[COLUMN_ADDRESS_BITS-1:0] <= address_hold[COLUMN_ADDRESS_BITS-1:0];	//set column
					//p1_ready <= 1'b1;
					cmd_state <= S_CMD_IDLE;
				end

				S_CMD_PRECHARGE_ALL:
				begin
					//if((io_state == S_IO_IDLE) & ~|cas_shift)  //check cas_shift for pending reads
					if(ready_for_precharge)
					begin
						sdram_cmd <= SDRAM_CMD_PRECHARGE;
						sdram_a <= SDRAM_ADDRESS_BITS'('h0);
						sdram_a[10] <= 1'b1;	//precharge all banks
						has_open_row <= NUM_BANKS'('h0);
						cycle_count <= 4'h0;
						cmd_state <= S_CMD_PRECHARGE_ALL_WAIT;
					end
				end
				S_CMD_PRECHARGE_ALL_WAIT:
				begin
					sdram_cmd <= SDRAM_CMD_NOP;
					cycle_count <= cycle_count + 4'h1;
					if(cycle_count == (TRP_CLK_CYCLES-1))
					begin
						cmd_state <= S_CMD_REFRESH;
					end
				end
				S_CMD_REFRESH:
				begin
					//p1_ready <= 1'b0;
					sdram_cmd <= SDRAM_CMD_REFRESH;
					cycle_count <= 4'h0;
					cmd_state <= S_CMD_REFRESH_WAIT;
				end
				S_CMD_REFRESH_WAIT:
				begin
					sdram_cmd <= SDRAM_CMD_NOP;
					cycle_count <= cycle_count + 4'h1;
					if(cycle_count == (TRC_CLK_CYCLES-1))
					begin
						if(init_refresh_count == 3'h0)
							refresh_flag <= 1'b0;
						else
							init_refresh_count <= init_refresh_count - 3'b001;
						cmd_state <= S_CMD_IDLE;
					end
				end
				default: ;
			endcase // cmd_state
		end
	end
endmodule : sdram_controller_gen2
