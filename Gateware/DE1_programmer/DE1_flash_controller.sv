module DE1_flash_controller(
		input wire clk,
		input wire rst,
		//Port 1
		input wire[21:0] p1_address,
		input wire[7:0] p1_to_mem,
		output reg[7:0] p1_from_mem,
		input wire p1_req,
		input wire p1_wren,
		output reg p1_ready,
		//Flash interface
		output reg[21:0] flash_a,
		inout wire[7:0] flash_d,
		output reg flash_we_n,
		output reg flash_reset_n,
		output wire flash_ce_n,
		output reg flash_oe_n);

	localparam[11:0] FLASH_CYCLES_PAGE = 12'd6;		//page miss access time - 1
	localparam[11:0] FLASH_CYCLES_WORD = 12'd1;		//page hit access time - 1
	localparam[11:0] FLASH_CYCLES_RESET = 12'd2500;	//num reset cycles - 2
	localparam[11:0] FLASH_CYCLES_RELEASE = 12'd3;	//num cycles after reset release - 1
	localparam[11:0] FLASH_CYCLES_WRITE = 12'd2;		//write cycle time - 1
	localparam[11:0] FLASH_CYCLES_RECOVER = 12'd0;	//write recovery before read time - 2

	reg[21:0] flash_prev_addr;
	reg[11:0] flash_cycle;
	reg[7:0] flash_data;
	reg flash_prev_addr_valid;
	reg flash_gate_out;
	reg prev_p1_req;
	reg p1_req_flag;

	wire page_miss;
	wire flash_ready;
	wire p1_request;
	
	reg[3:0] state;
	localparam[3:0] S_INIT = 4'h0;
	localparam[3:0] S_FLASH_RESET = 4'h1;
	localparam[3:0] S_FLASH_RELEASE = 4'h2;
	localparam[3:0] S_FLASH_ACTIVATE = 4'h3;
	localparam[3:0] S_FLASH_READ = 4'h4;
	localparam[3:0] S_FLASH_WRITE = 4'h5;

	assign page_miss = ~flash_prev_addr_valid | (|(flash_prev_addr[21:3] ^ p1_address[21:3]));
	assign flash_ready = ~|flash_cycle;
	assign flash_ce_n = 1'b0;
	assign flash_d = flash_gate_out ? flash_data : 8'hzz;
	assign p1_request = (p1_req & ~prev_p1_req) | p1_req_flag;

	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			state <= S_INIT;
			flash_cycle <= 12'h000;
			flash_reset_n <= 1'b0;
			flash_prev_addr <= 22'h000000;
			flash_a <= 22'h000000;
			flash_data <= 8'h00;
			flash_prev_addr_valid <= 1'b0;
			flash_gate_out <= 1'b0;
			flash_we_n <= 1'b0;
			flash_oe_n <= 1'b0;
			p1_ready <= 1'b0;
			p1_from_mem <= 8'h00;
			prev_p1_req <= 1'b0;
			p1_req_flag <= 1'b0;
		end
		else
		begin
			prev_p1_req <= p1_req;
			if(p1_req & ~prev_p1_req)
				p1_req_flag <= 1'b1;
			case(state)
				S_INIT:
				begin
					flash_cycle <= FLASH_CYCLES_RESET;
					state <= S_FLASH_RESET;
					flash_we_n <= 1'b1;
					flash_oe_n <= 1'b1;
					flash_reset_n <= 1'b0;
				end
				S_FLASH_RESET:
				begin
					flash_cycle <= flash_cycle - 12'h001;
					if(flash_ready)
					begin
						state <= S_FLASH_RELEASE;
						flash_cycle <= FLASH_CYCLES_RELEASE;
						flash_reset_n <= 1'b1;
					end
				end
				S_FLASH_RELEASE:
				begin
					p1_ready <= 1'b0;
					flash_cycle <= flash_cycle - 12'h001;
					if(flash_ready)
					begin
						state <= S_FLASH_ACTIVATE;
					end
				end
				S_FLASH_ACTIVATE:
				begin
					p1_ready <= 1'b0;
					if(p1_request)
					begin
						p1_req_flag <= 1'b0;
						flash_a <= p1_address;
						flash_prev_addr <= p1_address;
						flash_prev_addr_valid <= ~p1_wren;
						flash_data <= p1_to_mem;
						flash_oe_n <= p1_wren;
						flash_gate_out <= p1_wren;
						flash_we_n <= ~p1_wren;
						if(p1_wren)
						begin
							state <= S_FLASH_WRITE;
							flash_cycle <= FLASH_CYCLES_WRITE;
						end
						else
						begin
							state <= S_FLASH_READ;
							flash_cycle <= page_miss ? FLASH_CYCLES_PAGE : FLASH_CYCLES_WORD;
						end
					end
				end
				S_FLASH_READ:
				begin
					flash_cycle <= flash_cycle - 12'h001;
					if(flash_ready)
					begin
						p1_ready <= 1'b1;
						p1_from_mem <= flash_d;
						flash_oe_n <= 1'b1;
						state <= S_FLASH_ACTIVATE;
					end
				end
				S_FLASH_WRITE:
				begin
					flash_cycle <= flash_cycle - 12'h001;
					if(flash_ready)
					begin
						p1_ready <= 1'b1;
						flash_gate_out <= 1'b0;
						flash_we_n <= 1'b1;
						flash_cycle <= FLASH_CYCLES_RECOVER;
						state <= S_FLASH_RELEASE;
					end
				end
				default: ;
			endcase
		end
	end

endmodule
