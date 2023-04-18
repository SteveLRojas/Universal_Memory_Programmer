module Nexys3_memory_controller(
		input wire clk,
		input wire rst,
		//Port 1 (Flash)
		input wire[22:0] p1_address,
		input wire[15:0] p1_to_mem,
		output reg[15:0] p1_from_mem,
		input wire p1_req,
		input wire p1_wren,
		output reg p1_ready,
		//Port 2 (PSRAM)
		input wire[22:0] p2_address,
		input wire[15:0] p2_to_mem,
		output reg[15:0] p2_from_mem,
		input wire p2_req,
		input wire p2_wren,
		output reg p2_ready,
		//Flash and PSRAM interface
		output reg[22:0] shared_a,
		inout wire[15:0] shared_d,
		output reg shared_oe_n,
		output reg shared_we_n,
		output reg flash_ce_n,
		output reg flash_reset_n,
		output reg psram_ce_n,
		output reg shared_adv_n,	//address valid
		output wire psram_cre,		//control register enable
		output wire shared_clk,
		output wire psram_lb_n,		//lower byte enable
		output wire psram_ub_n);	//upper byte enable

	localparam[10:0] FLASH_CYCLES_RESET = 11'd1250;	//num reset cycles - 2
	localparam[10:0] FLASH_CYCLES_PAGE = 11'd3;		//page miss access time - 1
	localparam[10:0] FLASH_CYCLES_WORD = 11'd1;		//page hit access time - 1
	localparam[10:0] FLASH_CYCLES_RELEASE = 11'd7;	//num cycles after reset release - 1
	localparam[10:0] FLASH_CYCLES_WRITE = 11'd2;	//write cycle time - 1
	localparam[10:0] FLASH_CYCLES_RECOVER = 11'd0;	//write recovery before read time - 2
	localparam[10:0] FLASH_CYCLES_DEACTIVATE = 1'd0;	//OE high to output high-Z - 1
	
	localparam[10:0] PSRAM_CYCLES_READ = 11'd4;
	localparam[10:0] PSRAM_CYCLES_WRITE = 11'd4;
	localparam[10:0] PSRAM_CYCLES_DEACTIVATE = 11'd0;

	reg[22:0] flash_prev_addr;
	reg[10:0] shared_cycle;
	reg[15:0] shared_data;
	reg flash_prev_addr_valid;
	reg shared_gate_out;
	reg prev_p1_req;
	reg p1_req_flag;
	reg prev_p2_req;
	reg p2_req_flag;

	wire page_miss;
	wire shared_ready;
	wire p1_request;
	wire p2_request;
	
	reg[3:0] state;
	localparam[3:0] S_INIT = 4'h0;
	localparam[3:0] S_FLASH_RESET = 4'h1;
	localparam[3:0] S_FLASH_RELEASE = 4'h2;
	localparam[3:0] S_FLASH_IDLE = 4'h3;
	localparam[3:0] S_FLASH_READ = 4'h4;
	localparam[3:0] S_FLASH_WRITE = 4'h5;
	localparam[3:0] S_FLASH_DEAC = 4'h6;
	localparam[3:0] S_PSRAM_IDLE = 4'h7;
	localparam[3:0] S_PSRAM_READ = 4'h8;
	localparam[3:0] S_PSRAM_WRITE = 4'h9;
	localparam[3:0] S_PSRAM_DEAC = 4'hA;

	assign page_miss = ~flash_prev_addr_valid | (|(flash_prev_addr[22:3] ^ p1_address[22:3]));
	assign shared_ready = ~|shared_cycle;
	assign psram_cre = 1'b0;
	assign shared_clk = 1'b0;
	assign psram_lb_n = 1'b0;
	assign psram_ub_n = 1'b0;
	assign shared_d = shared_gate_out ? shared_data : 16'hzzzz;
	assign p1_request = (p1_req & ~prev_p1_req) | p1_req_flag;
	assign p2_request = (p2_req & ~prev_p2_req) | p2_req_flag;

	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			state <= S_INIT;
			shared_cycle <= 11'h000;
			flash_reset_n <= 1'b0;
			flash_prev_addr <= 23'h000000;
			flash_prev_addr_valid <= 1'b0;
			flash_ce_n <= 1'b0;
			psram_ce_n <= 1'b1;
			shared_adv_n <= 1'b0;
			shared_a <= 23'h000000;
			shared_data <= 16'h0000;
			shared_gate_out <= 1'b0;
			shared_we_n <= 1'b0;
			shared_oe_n <= 1'b0;
			p1_ready <= 1'b0;
			p1_from_mem <= 16'h0000;
			prev_p1_req <= 1'b0;
			p1_req_flag <= 1'b0;
			p2_ready <= 1'b0;
			p2_from_mem <= 16'h0000;
			prev_p2_req <= 1'b0;
			p2_req_flag <= 1'b0;
		end
		else
		begin
			prev_p1_req <= p1_req;
			prev_p2_req <= p2_req;
			if(p1_req & ~prev_p1_req)
				p1_req_flag <= 1'b1;
			if(p2_req & ~prev_p2_req)
				p2_req_flag <= 1'b1;
			case(state)
				S_INIT:
				begin
					shared_cycle <= FLASH_CYCLES_RESET;
					state <= S_FLASH_RESET;
					shared_we_n <= 1'b1;
					shared_oe_n <= 1'b1;
					shared_adv_n <= 1'b1;
					flash_reset_n <= 1'b0;
				end
				S_FLASH_RESET:
				begin
					shared_cycle <= shared_cycle - 11'h001;
					if(shared_ready)
					begin
						state <= S_FLASH_RELEASE;
						shared_cycle <= FLASH_CYCLES_RELEASE;
						flash_reset_n <= 1'b1;
					end
				end
				S_FLASH_RELEASE:
				begin
					p1_ready <= 1'b0;
					p2_ready <= 1'b0;
					shared_cycle <= shared_cycle - 11'h001;
					if(shared_ready)
					begin
						state <= S_FLASH_IDLE;
					end
				end
				S_FLASH_IDLE:
				begin
					p1_ready <= 1'b0;
					if(p1_request)
					begin
						p1_req_flag <= 1'b0;
						shared_adv_n <= 1'b0;
						flash_prev_addr <= p1_address;
						flash_prev_addr_valid <= ~p1_wren;
						shared_a <= p1_address;
						shared_data <= p1_to_mem;
						shared_oe_n <= p1_wren;
						shared_gate_out <= p1_wren;
						shared_we_n <= ~p1_wren;
						if(p1_wren)
						begin
							state <= S_FLASH_WRITE;
							shared_cycle <= FLASH_CYCLES_WRITE;
						end
						else
						begin
							state <= S_FLASH_READ;
							shared_cycle <= page_miss ? FLASH_CYCLES_PAGE : FLASH_CYCLES_WORD;
						end
					end
					else if(p2_request)
					begin
						flash_ce_n <= 1'b1;
						state <= S_FLASH_DEAC;
						shared_cycle <= FLASH_CYCLES_DEACTIVATE;
					end
				end
				S_FLASH_READ:
				begin
					shared_cycle <= shared_cycle - 11'h001;
					if(shared_ready)
					begin
						p1_ready <= 1'b1;
						p1_from_mem <= shared_d;
						shared_oe_n <= 1'b1;
						//shared_adv_n <= 1'b1;
						state <= S_FLASH_IDLE;
					end
				end
				S_FLASH_WRITE:
				begin
					shared_cycle <= shared_cycle - 11'h001;
					if(shared_ready)
					begin
						p1_ready <= 1'b1;
						shared_gate_out <= 1'b0;
						shared_we_n <= 1'b1;
						//shared_adv_n <= 1'b1;
						shared_cycle <= FLASH_CYCLES_RECOVER;
						state <= S_FLASH_RELEASE;
					end
				end
				S_FLASH_DEAC:
				begin
					shared_cycle <= shared_cycle - 11'h001;
					flash_prev_addr_valid <= 1'b0;
					if(shared_ready)
					begin
						p2_req_flag <= 1'b0;
						shared_adv_n <= 1'b0;
						psram_ce_n <= 1'b0;
						shared_a <= p2_address;
						shared_data <= p2_to_mem;
						shared_oe_n <= p2_wren;
						shared_gate_out <= p2_wren;
						shared_we_n <= ~p2_wren;
						if(p2_wren)
						begin
							state <= S_PSRAM_WRITE;
							shared_cycle <= PSRAM_CYCLES_WRITE;
						end
						else
						begin
							state <= S_PSRAM_READ;
							shared_cycle <= PSRAM_CYCLES_READ;
						end
					end
				end
				S_PSRAM_IDLE:
				begin
					p2_ready <= 1'b0;
					if(p1_request)
					begin
						psram_ce_n <= 1'b1;
						state <= S_PSRAM_DEAC;
						shared_cycle <= PSRAM_CYCLES_DEACTIVATE;
					end
					else if(p2_request)
					begin
						p2_req_flag <= 1'b0;
						shared_adv_n <= 1'b0;
						shared_a <= p2_address;
						shared_data <= p2_to_mem;
						shared_oe_n <= p2_wren;
						shared_gate_out <= p2_wren;
						shared_we_n <= ~p2_wren;
						if(p2_wren)
						begin
							state <= S_PSRAM_WRITE;
							shared_cycle <= PSRAM_CYCLES_WRITE;
						end
						else
						begin
							state <= S_PSRAM_READ;
							shared_cycle <= PSRAM_CYCLES_READ;
						end
					end
				end
				S_PSRAM_READ:
				begin
					shared_cycle <= shared_cycle - 11'h001;
					if(shared_ready)
					begin
						p2_ready <= 1'b1;
						p2_from_mem <= shared_d;
						shared_oe_n <= 1'b1;
						shared_adv_n <= 1'b1;
						state <= S_PSRAM_IDLE;
					end
				end
				S_PSRAM_WRITE:
				begin
					shared_cycle <= shared_cycle - 11'h001;
					if(shared_ready)
					begin
						p2_ready <= 1'b1;
						shared_gate_out <= 1'b0;
						shared_we_n <= 1'b1;
						shared_adv_n <= 1'b1;
						state <= S_PSRAM_IDLE;
					end
				end
				S_PSRAM_DEAC:
				begin
					shared_cycle <= shared_cycle - 11'h001;
					if(shared_ready)
					begin
						p1_req_flag <= 1'b0;
						shared_adv_n <= 1'b0;
						flash_prev_addr <= p1_address;
						flash_prev_addr_valid <= ~p1_wren;
						flash_ce_n <= 1'b0;
						shared_a <= p1_address;
						shared_data <= p1_to_mem;
						shared_oe_n <= p1_wren;
						shared_gate_out <= p1_wren;
						shared_we_n <= ~p1_wren;
						if(p1_wren)
						begin
							state <= S_FLASH_WRITE;
							shared_cycle <= FLASH_CYCLES_WRITE;
						end
						else
						begin
							state <= S_FLASH_READ;
							shared_cycle <= page_miss ? FLASH_CYCLES_PAGE : FLASH_CYCLES_WORD;
						end
					end
				end
				default: ;
			endcase
		end
	end

endmodule