module DE2_SRAM_controller(
		input wire clk,
		input wire rst,
		//Port 1
		input wire[17:0] p1_address,
		input wire[15:0] p1_to_mem,
		output reg[15:0] p1_from_mem,
		input wire p1_req,
		input wire p1_wren,
		output reg p1_ready,
		//SRAM interface
		output reg[17:0] sram_a,
		inout wire[15:0] sram_d,
		output reg sram_we_n,
		output wire sram_ce_n,
		output reg sram_oe_n,
		output wire sram_lb_n,
		output wire sram_ub_n);

	localparam[3:0] SRAM_CYCLES_READ = 4'd0;		//read cycle time - 1
	localparam[3:0] SRAM_CYCLES_WRITE = 4'd0;		//write cycle time - 1

	reg[3:0] sram_cycle;
	reg[15:0] sram_data;
	reg sram_gate_out;
	reg prev_p1_req;
	reg p1_req_flag;

	wire sram_ready;
	wire p1_request;
	
	reg[3:0] state;
	localparam[3:0] S_SRAM_IDLE = 4'h0;
	localparam[3:0] S_SRAM_READ = 4'h1;
	localparam[3:0] S_SRAM_WRITE = 4'h2;

	assign sram_ready = ~|sram_cycle;
	assign sram_ce_n = 1'b0;
	assign sram_lb_n = 1'b0;
	assign sram_ub_n = 1'b0;
	assign sram_d = sram_gate_out ? sram_data : 16'hzzzz;
	assign p1_request = (p1_req & ~prev_p1_req) | p1_req_flag;

	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			state <= S_SRAM_IDLE;
			sram_cycle <= 4'h0;
			sram_a <= 18'h00000;
			sram_data <= 16'h0000;
			sram_gate_out <= 1'b0;
			sram_we_n <= 1'b1;
			sram_oe_n <= 1'b0;
			p1_ready <= 1'b0;
			p1_from_mem <= 16'h0000;
			prev_p1_req <= 1'b0;
			p1_req_flag <= 1'b0;
		end
		else
		begin
			prev_p1_req <= p1_req;
			if(p1_req & ~prev_p1_req)
				p1_req_flag <= 1'b1;
			case(state)
				S_SRAM_IDLE:
				begin
					p1_ready <= 1'b0;
					if(p1_request)
					begin
						p1_req_flag <= 1'b0;
						sram_a <= p1_address;
						sram_data <= p1_to_mem;
						sram_oe_n <= p1_wren;
						sram_gate_out <= p1_wren;
						sram_we_n <= ~p1_wren;
						if(p1_wren)
						begin
							state <= S_SRAM_WRITE;
							sram_cycle <= SRAM_CYCLES_WRITE;
						end
						else
						begin
							state <= S_SRAM_READ;
							sram_cycle <= SRAM_CYCLES_READ;
						end
					end
				end
				S_SRAM_READ:
				begin
					sram_cycle <= sram_cycle - 4'h1;
					if(sram_ready)
					begin
						p1_ready <= 1'b1;
						p1_from_mem <= sram_d;
						sram_oe_n <= 1'b1;
						state <= S_SRAM_IDLE;
					end
				end
				S_SRAM_WRITE:
				begin
					sram_cycle <= sram_cycle - 4'h1;
					if(sram_ready)
					begin
						p1_ready <= 1'b1;
						sram_gate_out <= 1'b0;
						sram_we_n <= 1'b1;
						state <= S_SRAM_IDLE;
					end
				end
				default: ;
			endcase
		end
	end

endmodule
