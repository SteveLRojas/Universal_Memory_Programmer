module memory_arbiter(
		input wire clk,
		input wire rst,
		
		input wire[17:0] arbiter_p1_address,
		input wire[63:0] arbiter_p1_to_mem,
		output wire[63:0] arbiter_p1_from_mem,
		input wire arbiter_p1_req,
		input wire arbiter_p1_wren,
		output logic arbiter_p1_ready,
		
		input wire[17:0] arbiter_p2_address,
		input wire[63:0] arbiter_p2_to_mem,
		output wire[63:0] arbiter_p2_from_mem,
		input wire arbiter_p2_req,
		input wire arbiter_p2_wren,
		output logic arbiter_p2_ready,
		
		input wire[7:0] memory_from_mem,
		output wire[20:0] memory_p1_address,
		output logic[7:0] memory_p1_to_mem,
		output logic memory_p1_req,
		output logic memory_p1_wren,
		input wire memory_p1_ready,
		input wire[2:0] memory_p1_offset
	);
		
	reg p1_req_flag;
	reg p2_req_flag;
	reg prev_p1_req;
	reg prev_p2_req;
	
	reg[7:0] port1_from_mem[7:0];
	reg[7:0] port1_to_mem[7:0];
	reg[7:0] port2_from_mem[7:0];
	reg[7:0] port2_to_mem[7:0];
	
	reg[17:0] mem_address_base;
	reg[2:0] burst_offset;
	
	enum logic[3:0] {S_IDLE, S_PORT1_READ, S_PORT1_WRITE, S_PORT2_READ, S_PORT2_WRITE} state;
	
	assign arbiter_p1_from_mem = {port1_from_mem[7], port1_from_mem[6], port1_from_mem[5], port1_from_mem[4], port1_from_mem[3], port1_from_mem[2], port1_from_mem[1], port1_from_mem[0]};
	assign arbiter_p2_from_mem = {port2_from_mem[7], port2_from_mem[6], port2_from_mem[5], port2_from_mem[4], port2_from_mem[3], port2_from_mem[2], port2_from_mem[1], port2_from_mem[0]};
	assign memory_p1_address = {mem_address_base, 3'h0};
	
	always_ff @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			p1_req_flag <= 1'b0;
			p2_req_flag <= 1'b0;
			prev_p1_req <= 1'b0;
			prev_p2_req <= 1'b0;
			port1_from_mem[0] <= 8'h0;
			port1_from_mem[1] <= 8'h0;
			port1_from_mem[2] <= 8'h0;
			port1_from_mem[3] <= 8'h0;
			port1_from_mem[4] <= 8'h0;
			port1_from_mem[5] <= 8'h0;
			port1_from_mem[6] <= 8'h0;
			port1_from_mem[7] <= 8'h0;
			port1_to_mem[0] <= 8'h0;
			port1_to_mem[1] <= 8'h0;
			port1_to_mem[2] <= 8'h0;
			port1_to_mem[3] <= 8'h0;
			port1_to_mem[4] <= 8'h0;
			port1_to_mem[5] <= 8'h0;
			port1_to_mem[6] <= 8'h0;
			port1_to_mem[7] <= 8'h0;
			port2_from_mem[0] <= 8'h0;
			port2_from_mem[1] <= 8'h0;
			port2_from_mem[2] <= 8'h0;
			port2_from_mem[3] <= 8'h0;
			port2_from_mem[4] <= 8'h0;
			port2_from_mem[5] <= 8'h0;
			port2_from_mem[6] <= 8'h0;
			port2_from_mem[7] <= 8'h0;
			port2_to_mem[0] <= 8'h0;
			port2_to_mem[1] <= 8'h0;
			port2_to_mem[2] <= 8'h0;
			port2_to_mem[3] <= 8'h0;
			port2_to_mem[4] <= 8'h0;
			port2_to_mem[5] <= 8'h0;
			port2_to_mem[6] <= 8'h0;
			port2_to_mem[7] <= 8'h0;
			mem_address_base <= 18'h0000;
			memory_p1_to_mem <= 8'h00;
			burst_offset <= 3'h0;
			memory_p1_req <= 1'b0;
			memory_p1_wren <= 1'b0;
			arbiter_p1_ready <= 1'b0;
			arbiter_p2_ready <= 1'b0;
			state <= S_IDLE;
		end
		else
		begin
			prev_p1_req <= arbiter_p1_req;
			prev_p2_req <= arbiter_p2_req;
			if(arbiter_p1_req & ~prev_p1_req)
				p1_req_flag <= 1'b1;
			if(arbiter_p2_req & ~prev_p2_req)
				p2_req_flag <= 1'b1;
				
			case(state)
				S_IDLE:
				begin
					burst_offset <= 3'h0;
					arbiter_p1_ready <= 1'b0;
					arbiter_p2_ready <= 1'b0;
					if(p1_req_flag | (arbiter_p1_req & ~prev_p1_req))
					begin
						p1_req_flag <= 1'b0;
						port1_to_mem[0] <= arbiter_p1_to_mem[7:0];
						port1_to_mem[1] <= arbiter_p1_to_mem[15:8];
						port1_to_mem[2] <= arbiter_p1_to_mem[23:16];
						port1_to_mem[3] <= arbiter_p1_to_mem[31:24];
						port1_to_mem[4] <= arbiter_p1_to_mem[39:32];
						port1_to_mem[5] <= arbiter_p1_to_mem[47:40];
						port1_to_mem[6] <= arbiter_p1_to_mem[55:48];
						port1_to_mem[7] <= arbiter_p1_to_mem[63:56];
						mem_address_base <= arbiter_p1_address[17:0];
						memory_p1_req <= 1'b1;
						memory_p1_wren <= arbiter_p1_wren;
						if(arbiter_p1_wren)
							state <= S_PORT1_WRITE;
						else
							state <= S_PORT1_READ;
					end
					else if(p2_req_flag | (arbiter_p2_req & ~prev_p2_req))
					begin
						p2_req_flag <= 1'b0;
						port2_to_mem[0] <= arbiter_p2_to_mem[7:0];
						port2_to_mem[1] <= arbiter_p2_to_mem[15:8];
						port2_to_mem[2] <= arbiter_p2_to_mem[23:16];
						port2_to_mem[3] <= arbiter_p2_to_mem[31:24];
						port2_to_mem[4] <= arbiter_p2_to_mem[39:32];
						port2_to_mem[5] <= arbiter_p2_to_mem[47:40];
						port2_to_mem[6] <= arbiter_p2_to_mem[55:48];
						port2_to_mem[7] <= arbiter_p2_to_mem[63:56];
						mem_address_base <= arbiter_p2_address[17:0];
						memory_p1_req <= 1'b1;
						memory_p1_wren <= arbiter_p2_wren;
						if(arbiter_p2_wren)
							state <= S_PORT2_WRITE;
						else
							state <= S_PORT2_READ;
					end
				end
				S_PORT1_READ:
				begin
					memory_p1_req <= 1'b0;
					if(memory_p1_ready)
					begin
						if(&memory_p1_offset)
						begin
							arbiter_p1_ready <= 1'b1;
							state <= S_IDLE;
						end
						port1_from_mem[memory_p1_offset] <= memory_from_mem;
					end
				end
				S_PORT1_WRITE:
				begin
					memory_p1_req <= 1'b0;
					if(memory_p1_ready)
					begin
						burst_offset <= burst_offset + 3'h1;
						if(&burst_offset)
						begin
							arbiter_p1_ready <= 1'b1;
							state <= S_IDLE;
						end
						memory_p1_to_mem <= port1_to_mem[burst_offset];
					end
				end
				S_PORT2_READ:
				begin
					memory_p1_req <= 1'b0;
					if(memory_p1_ready)
					begin
						if(&memory_p1_offset)
						begin
							arbiter_p2_ready <= 1'b1;
							state <= S_IDLE;
						end
						port2_from_mem[memory_p1_offset] <= memory_from_mem;
					end
				end
				S_PORT2_WRITE:
				begin
					memory_p1_req <= 1'b0;
					if(memory_p1_ready)
					begin
						burst_offset <= burst_offset + 3'h1;
						if(&burst_offset)
						begin
							arbiter_p2_ready <= 1'b1;
							state <= S_IDLE;
						end
						memory_p1_to_mem <= port2_to_mem[burst_offset];
					end
				end
				default: ;
			endcase
		end
	end

endmodule
