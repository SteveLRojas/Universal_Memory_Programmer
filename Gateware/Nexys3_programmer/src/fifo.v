module fifo
	#(
		parameter BUS_WIDTH=8,
		parameter NUM_WORDS=8
	)
	(
		input wire clk,
		input wire reset,
		input wire push,
		input wire pop,
		output wire full,
		output wire empty,
		input wire[BUS_WIDTH-1:0] din, 
		output wire[BUS_WIDTH-1:0] dout
	);
		
reg[$clog2(NUM_WORDS):0] read_addr;
reg[$clog2(NUM_WORDS):0] write_addr;	//these have an extra bit so we can easily tell if the fifo is empty or full
wire addr_comp;
(* ramstyle = "logic" *) reg[BUS_WIDTH-1:0] queue_mem[NUM_WORDS-1:0];

assign addr_comp = |(read_addr[$clog2(NUM_WORDS)-1:0] ^ write_addr[$clog2(NUM_WORDS)-1:0]);
assign dout = queue_mem[read_addr[$clog2(NUM_WORDS)-1:0]];
assign empty = ~(addr_comp | (read_addr[$clog2(NUM_WORDS)] ^ write_addr[$clog2(NUM_WORDS)]));
assign full = ~addr_comp & (read_addr[$clog2(NUM_WORDS)] ^ write_addr[$clog2(NUM_WORDS)]);

always @(posedge clk)
begin
	if(reset)
	begin
		read_addr <= {($clog2(NUM_WORDS)+1){1'b0}};
		write_addr <= {($clog2(NUM_WORDS)+1){1'b0}};
	end
	else
	begin
		if(push)
		begin
			write_addr <= write_addr + ($clog2(NUM_WORDS)+1)'('h1);
			queue_mem[write_addr[$clog2(NUM_WORDS)-1:0]] <= din;
		end
		if(pop)
		begin
			read_addr <= read_addr + ($clog2(NUM_WORDS)+1)'('h1);
		end
	end
end
endmodule//: fifo
