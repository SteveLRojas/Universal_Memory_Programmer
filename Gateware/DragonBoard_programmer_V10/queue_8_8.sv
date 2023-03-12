module queue_8_8(
		input logic clk,
		input logic reset,
		input logic push,
		input logic pop,
		output logic full,
		output logic empty,
		input logic[7:0] din, 
		output logic[7:0] dout
		);
		
logic[3:0] read_addr;
logic[3:0] write_addr;	//these have an extra bit so we can easily tell if the fifo is empty or full
logic addr_comp;
(* ramstyle = "logic" *) reg[7:0] queue_mem[7:0];

assign addr_comp = |(read_addr[2:0] ^ write_addr[2:0]);
assign dout = queue_mem[read_addr[2:0]];
assign empty = ~(addr_comp | (read_addr[3] ^ write_addr[3]));
assign full = ~addr_comp & (read_addr[3] ^ write_addr[3]);

initial
begin
	read_addr = 4'h0;
	write_addr = 4'h0;
end

always @(posedge clk)
begin
	if(reset)
	begin
		read_addr <= 4'h0;
		write_addr <= 4'h0;
	end
	else
	begin
		if(push)
		begin
			write_addr <= write_addr + 4'h1;
			queue_mem[write_addr[2:0]] <= din;
		end
		if(pop)
		begin
			read_addr <= read_addr + 4'h1;
		end
	end
end
endmodule: queue_8_8
