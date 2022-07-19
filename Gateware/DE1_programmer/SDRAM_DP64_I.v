module SDRAM_DP64_I(
		input wire clk,
		input wire rst,
		
		input wire[13:0] p1_address,
		input wire[5:0] p1_page,
		output wire[63:0] p1_data,
		input wire p1_req,
		output wire p1_ready,
		
		input wire[12:0] p2_address,
		input wire[6:0] p2_page,
		input wire[63:0] p2_to_mem,
		output wire[63:0] p2_from_mem,
		input wire p2_req,
		input wire p2_wren,
		output wire p2_ready,
		
		output wire sdram_cke,
		output wire sdram_cs_n,
		output wire sdram_wre_n,
		output wire sdram_cas_n,
		output wire sdram_ras_n,
		output reg[11:0] sdram_a,
		output reg[1:0] sdram_ba,
		output reg[1:0] sdram_dqm,
		inout wire[15:0] sdram_dq,
		
		output wire init_req,
		input wire init_ready,
		output wire[11:0] init_address,
		input wire[15:0] init_data);
		
reg ready1;
reg ready2;
reg read_req;
reg p1_req_flag;
reg p2_req_flag;
reg prev_p1_req;
reg prev_p2_req;
reg gate_out;
reg[2:0] sdram_cmd;
reg[2:0] init_refresh_count;	//initially set to 7. On refresh the number of refresh cycles performed will be this number plus one.
reg[9:0] refresh_timer;
reg[1:0] word_address;
reg init_flag;
reg refresh_flag;
reg[19:0] address_hold;
reg[63:0] data_hold;
reg[15:0] data_out;
reg[15:0] p1_data0, p1_data1, p1_data2, p1_data3;
reg[15:0] p2_data0, p2_data1, p2_data2, p2_data3;
reg wren;

assign p1_ready = ready1;
assign p2_ready = ready2;
assign init_req = read_req;
assign sdram_cke = 1'b1;
assign sdram_cs_n = 1'b0;
assign {sdram_ras_n, sdram_cas_n, sdram_wre_n} = sdram_cmd;
assign sdram_dq = gate_out ? data_out : 16'hZZZZ;
assign p1_data = {p1_data3, p1_data2, p1_data1, p1_data0};
assign p2_from_mem = {p2_data3, p2_data2, p2_data1, p2_data0};
assign init_address = {address_hold[9:0], word_address};

localparam [2:0] SDRAM_CMD_LOADMODE  = 3'b000;
localparam [2:0] SDRAM_CMD_REFRESH   = 3'b001;
localparam [2:0] SDRAM_CMD_PRECHARGE = 3'b010;
localparam [2:0] SDRAM_CMD_ACTIVE    = 3'b011;
localparam [2:0] SDRAM_CMD_WRITE     = 3'b100;
localparam [2:0] SDRAM_CMD_READ      = 3'b101;
localparam [2:0] SDRAM_CMD_NOP       = 3'b111;

//SDRAM controller states
reg[5:0] state;
localparam[5:0]
			S_RESET = 6'h00,
			S_INIT_DEVICE = 6'h01,
			S_INIT_DEVICE_NOP = 6'h02,
			S_MODE = 6'h03,
			S_MODE_NOP = 6'h04,
			S_IDLE = 6'h05,
			
			S_ACTIVATE_P1 = 6'h06,
			S_ACTIVATE_P1_NOP = 6'h07,
			S_READ_P1 = 6'h08,
			S_READ_P1_NOP1 = 6'h09,
			S_READ_P1_NOP2 = 6'h0A,
			S_READ_P1_DATA0 = 6'h0B,
			S_READ_P1_DATA1 = 6'h0C,
			S_READ_P1_DATA2 = 6'h0D,
			S_READ_P1_DATA3 = 6'h0E,
			
			S_ACTIVATE_P2 = 6'H0F,
			S_ACTIVATE_P2_NOP = 6'H10,
			S_READ_P2 = 6'H11,
			S_READ_P2_NOP1 = 6'H12,
			S_READ_P2_NOP2 = 6'H13,
			S_READ_P2_DATA0 = 6'H14,
			S_READ_P2_DATA1 = 6'H15,
			S_READ_P2_DATA2 = 6'H16,
			S_READ_P2_DATA3 = 6'H17,
			S_WRITE_P2 = 6'H18,
			S_WRITE_P2_DATA1 = 6'H19,
			S_WRITE_P2_DATA2 = 6'H1A,
			S_WRITE_P2_DATA3 = 6'H1B,
			S_WRITE_P2_NOP1 = 6'H1C,
			S_WRITE_P2_NOP2 = 6'H1D,
			//USE S_IDLE AS S_WRITE_P2_NOP3
			
			S_REFRESH = 6'H1E,
			S_REFRESH_NOP1 = 6'H1F,
			S_REFRESH_NOP2 = 6'H20,
			S_REFRESH_NOP3 = 6'H21,
			
			S_INIT_DATA = 6'H22,
			S_READ = 6'H23,
			S_WRITE_ACTIVATE = 6'H24,
			S_WRITE_ACTIVATE_NOP = 6'H25,
			S_WRITE_DATA = 6'H26,
			S_WRITE_DATA1 = 6'h27,
			S_WRITE_DATA2 = 6'h28,
			S_WRITE_DATA3 = 6'h29,
			S_WRITE_DATA_NOP1 = 6'H2A,
			S_WRITE_DATA_NOP2 = 6'H2B,
			S_INC = 6'H2C;
			
always @(posedge clk)
begin
	if(rst)
	begin
		state <= S_RESET;
		p1_req_flag <= 1'b0;
		p2_req_flag <= 1'b0;
		prev_p1_req <= 1'b0;
		prev_p2_req <= 1'b0;
		gate_out <= 1'b0;
		address_hold <= 20'h000;
		word_address <= 2'b00;
		ready1 <= 1'b0;
		ready2 <= 1'b0;
		read_req <= 1'b0;
		refresh_timer <= 10'h00;
		refresh_flag <= 1'b1;
	end
	else
	begin
		prev_p1_req <= p1_req;
		prev_p2_req <= p2_req;
		if(p1_req & ~prev_p1_req)
			p1_req_flag <= 1'b1;
		if(p2_req & ~prev_p2_req)
			p2_req_flag <= 1'b1;
		if(refresh_timer == 10'd390)
		begin
			refresh_timer <= 10'h00;
			refresh_flag <= 1'b1;
		end
		else
			refresh_timer <= refresh_timer + 10'h01;
		case(state)
			S_RESET:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				gate_out <= 1'b0;
				sdram_dqm <= 2'b11;
				init_refresh_count <= 3'b111;
				init_flag <= 1'b1;
				state <= S_INIT_DEVICE;
			end
			S_INIT_DEVICE:
			begin
				sdram_cmd <= SDRAM_CMD_PRECHARGE;
				sdram_a[10] <= 1'b1;	//precharge all
				gate_out <= 1'b0;
				sdram_dqm <= 2'b11;
				state <= S_INIT_DEVICE_NOP;
			end
			S_INIT_DEVICE_NOP:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				gate_out <= 1'b0;
				sdram_dqm <= 2'b11;
				state <= S_MODE;
			end
			S_MODE:
			begin
				sdram_cmd <= SDRAM_CMD_LOADMODE;
				sdram_a <= 12'b000000100010;	//burst length 4, sequential, CAS latency 2, burst read and write.
				sdram_ba <= 2'b00;
				gate_out <= 1'b0;
				sdram_dqm <= 2'b11;
				state <= S_MODE_NOP;
			end
			S_MODE_NOP:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				gate_out <= 1'b0;
				sdram_dqm <= 2'b11;
				state <= S_REFRESH;
			end
			S_IDLE:
			begin
				ready1 <= 1'b0;
				ready2 <= 1'b0;
				if(refresh_flag)
				begin
					state <= S_REFRESH;
				end
				else if(p1_req || p1_req_flag)	//port 1 is read only
				begin
					address_hold <= {p1_page, p1_address};
					wren <= 1'b0;
					state <= S_ACTIVATE_P1;
					p1_req_flag <= 1'b0;
				end
				else if(p2_req || p2_req_flag)	//port 2 is read and write
				begin
					address_hold <= {p2_page, p2_address};
					p2_req_flag <= 1'b0;
					wren <= p2_wren;
					data_hold <= p2_to_mem[63:0];
					state <= S_ACTIVATE_P2;
				end
				else
				begin
					//wren <= 1'b0;
					state <= state;
				end
			end
			S_ACTIVATE_P1:
			begin
				sdram_cmd <= SDRAM_CMD_ACTIVE;	//send activate command
				sdram_ba <= address_hold[19:18];	//set bank
				sdram_a[11:0] <= address_hold[17:6];	//set row
				sdram_dqm <= 2'b11;
				state <= S_ACTIVATE_P1_NOP;
			end
			S_ACTIVATE_P1_NOP:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				sdram_dqm <= 2'b11;
				gate_out <= 1'b0;
				state <= S_READ_P1;
			end
			S_READ_P1:
			begin
				sdram_cmd <= SDRAM_CMD_READ;
				sdram_a[11] <= 1'b0;
				sdram_a[9:8] <= 2'b00;
				sdram_a[7:0] <= {address_hold[5:0], 2'b00};	//set column
				sdram_a[10] <= 1'b1;	//auto precharge
				sdram_dqm <= 2'b00;
				gate_out <= 1'b0;
				state <= S_READ_P1_NOP1;
			end
			S_READ_P1_NOP1:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				sdram_dqm <= 2'b00;
				gate_out <= 1'b0;
				state <= S_READ_P1_NOP2;
			end
			S_READ_P1_NOP2:
			begin
				//sdram_cmd <= SDRAM_CMD_NOP;
				//sdram_dqm <= 2'b00;
				//gate_out <= 1'b0;
				state <= S_READ_P1_DATA0;
			end
			S_READ_P1_DATA0:
			begin
				p1_data0 <= sdram_dq;
				state <= S_READ_P1_DATA1;
			end
			S_READ_P1_DATA1:
			begin
				p1_data1 <= sdram_dq;
				state <= S_READ_P1_DATA2;
			end
			S_READ_P1_DATA2:
			begin
				p1_data2 <= sdram_dq;
				state <= S_READ_P1_DATA3;
			end
			S_READ_P1_DATA3:
			begin
				p1_data3 <= sdram_dq;
				ready1 <= 1'b1;
				if(refresh_flag)
					state <= S_REFRESH;
				else
					state <= S_IDLE;
			end
			S_ACTIVATE_P2:
			begin
				sdram_cmd <= SDRAM_CMD_ACTIVE;	//send activate command
				sdram_ba <= address_hold[19:18];	//set bank
				sdram_a[11:0] <= address_hold[17:6];	//set row
				sdram_dqm <= 2'b11;
				state <= S_ACTIVATE_P2_NOP;
			end
			S_ACTIVATE_P2_NOP:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				sdram_dqm <= 2'b11;
				gate_out <= 1'b0;
				if(wren)
					state <= S_WRITE_P2;
				else
					state <= S_READ_P2;
			end
			S_READ_P2:
			begin
				sdram_cmd <= SDRAM_CMD_READ;
				sdram_a[11] <= 1'b0;
				sdram_a[9:8] <= 2'b00;
				sdram_a[7:0] <= {address_hold[5:0], 2'b00};	//set column
				sdram_a[10] <= 1'b1;	//auto precharge
				sdram_dqm <= 2'b00;
				gate_out <= 1'b0;
				state <= S_READ_P2_NOP1;
			end
			S_READ_P2_NOP1:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				sdram_dqm <= 2'b00;
				gate_out <= 1'b0;
				state <= S_READ_P2_NOP2;
			end
			S_READ_P2_NOP2:
			begin
				state <= S_READ_P2_DATA0;
			end
			S_READ_P2_DATA0:
			begin
				p2_data0 <= sdram_dq;
				state <= S_READ_P2_DATA1;
			end
			S_READ_P2_DATA1:
			begin
				p2_data1 <= sdram_dq;
				state <= S_READ_P2_DATA2;
			end
			S_READ_P2_DATA2:
			begin
				p2_data2 <= sdram_dq;
				state <= S_READ_P2_DATA3;
			end
			S_READ_P2_DATA3:
			begin
				p2_data3 <= sdram_dq;
				ready2 <= 1'b1;
				if(refresh_flag)
					state <= S_REFRESH;
				else
					state <= S_IDLE;
			end
			S_WRITE_P2:
			begin
				sdram_cmd <= SDRAM_CMD_WRITE;
				sdram_a[11] <= 1'b0;
				sdram_a[9:8] <= 2'b00;
				sdram_a[7:0] <= {address_hold[5:0], 2'b00};	//set col
				sdram_a[10] <= 1'b1;	//automatic precharge
				sdram_dqm <= 2'b00;
				gate_out <= 1'b1;
				data_out <= data_hold[15:0];
				state <= S_WRITE_P2_DATA1;
			end
			S_WRITE_P2_DATA1:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				data_out <= data_hold[31:16];
				state <= S_WRITE_P2_DATA2;
			end
			S_WRITE_P2_DATA2:
			begin
				data_out <= data_hold[47:32];
				state <= S_WRITE_P2_DATA3;
			end
			S_WRITE_P2_DATA3:
			begin
				data_out <= data_hold[63:48];
				state <= S_WRITE_P2_NOP1;
			end
			S_WRITE_P2_NOP1:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				sdram_dqm <= 2'b11;
				gate_out <= 1'b0;
				state <= S_WRITE_P2_NOP2;
			end
			S_WRITE_P2_NOP2:
			begin
				ready2 <= 1'b1;
				state <= S_IDLE;
			end
			S_REFRESH:
			begin
				ready1 <= 1'b0;
				ready2 <= 1'b0;
				sdram_cmd <= SDRAM_CMD_REFRESH;
				sdram_dqm <= 2'b11;
				state <= S_REFRESH_NOP1;
			end
			S_REFRESH_NOP1:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				state <= S_REFRESH_NOP2;
			end
			S_REFRESH_NOP2:
			begin
				state <= S_REFRESH_NOP3;
			end
			S_REFRESH_NOP3:
			begin
				if(~(|init_refresh_count))
					refresh_flag <= 1'b0;
				else
					init_refresh_count <= init_refresh_count - 3'b001;
				if(init_flag)
					state <= S_INIT_DATA;
				else
					state <= S_IDLE;
			end
			S_INIT_DATA:
			begin
				if(refresh_flag)
				begin
					state <= S_REFRESH;
				end
				else
				begin
					read_req <= 1'b1;
					state <= S_READ;
				end
			end
			S_READ:
			begin
				read_req <= 1'b0;
				if(init_ready)
				begin
					word_address <= word_address + 2'b01;
					case(word_address)
						2'b00: data_hold[15:0] <= init_data;
						2'b01: data_hold[31:16] <= init_data;
						2'b10: data_hold[47:32] <= init_data;
						2'b11: data_hold[63:48] <= init_data;
					endcase
					if(&word_address)
						state <= S_WRITE_ACTIVATE;
					else
						state <= S_INIT_DATA;
				end
			end
			S_WRITE_ACTIVATE:
			begin
				sdram_cmd <= SDRAM_CMD_ACTIVE;	//send activate command
				sdram_ba <= address_hold[19:18];	//set bank
				sdram_a[11:0] <= address_hold[17:6];	//set row
				sdram_dqm <= 2'b11;
				state <= S_WRITE_ACTIVATE_NOP;
			end
			S_WRITE_ACTIVATE_NOP:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				sdram_dqm <= 2'b11;
				gate_out <= 1'b0;
				state <= S_WRITE_DATA;
			end
			S_WRITE_DATA:
			begin
				sdram_cmd <= SDRAM_CMD_WRITE;
				sdram_a[11] <= 1'b0;
				sdram_a[9:8] <= 2'b00;
				sdram_a[7:0] <= {address_hold[5:0], 2'b00};	//set col
				sdram_a[10] <= 1'b1;	//automatic precharge
				sdram_dqm <= 2'b00;
				gate_out <= 1'b1;
				data_out <= data_hold[15:0];
				state <= S_WRITE_DATA1;
			end
			S_WRITE_DATA1:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				data_out <= data_hold[31:16];
				state <= S_WRITE_DATA2;
			end
			S_WRITE_DATA2:
			begin
				data_out <= data_hold[47:32];
				state <= S_WRITE_DATA3;
			end
			S_WRITE_DATA3:
			begin
				data_out <= data_hold[63:48];
				state <= S_WRITE_DATA_NOP1;
			end
			S_WRITE_DATA_NOP1:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				sdram_dqm <= 2'b11;
				gate_out <= 1'b0;
				state <= S_WRITE_DATA_NOP2;
			end
			S_WRITE_DATA_NOP2:
			begin
				state <= S_INC;
			end
			S_INC:
			begin
				address_hold <= address_hold + 20'h001;
				if(address_hold == 20'h03FF)
				begin
					init_flag <= 1'b0;
					state <= S_IDLE;
				end
				else
				begin
					state <= S_INIT_DATA;
				end
			end
			default: ;
		endcase
	end
end
		
endmodule
