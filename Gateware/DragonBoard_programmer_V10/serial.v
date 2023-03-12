module serial(
		input wire clk, 
		input wire reset,
		input wire A,
		input wire CE,
		input wire WREN,
		input wire REN,
		input wire rx,
		output wire tx,
		output wire rx_int,
		output wire tx_int,
		output reg[7:0] to_CPU,
		input wire[7:0] from_CPU);
//Note that the latency for this module is 2 clk cycles.
// Status bits:
//	bit 0: TX overwrite
// bit 1: RX overwrite
// bit 2: TX ready
// bit 3: RX ready
// bit 4: TX queue empty
// bit 5: RX queue full
// bit 6: reserved
// bit 7: busy flag
reg rx_overwrite;
reg tx_overwrite;
wire rx_queue_full;
wire rx_queue_empty;
wire tx_queue_full;
wire tx_queue_empty;	//status bits.
wire[7:0] rx_queue_data;
wire rx_ready;
wire data_write;
wire data_read;
reg busy;
wire[7:0] status;

assign data_write = CE & WREN & ~A;
assign data_read = CE & REN & ~A;
assign tx_int = tx_queue_empty;
assign rx_int = rx_ready;
assign status = {busy, 1'b0, rx_queue_full, tx_queue_empty, ~rx_queue_empty, ~tx_queue_full, rx_overwrite, tx_overwrite};

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		rx_overwrite <= 1'b0;
		tx_overwrite <= 1'b0;
		to_CPU <= 8'h00;
		busy <= 1'b0;
	end
	else
	begin
		to_CPU <= A ? status : rx_queue_data;
		busy <= data_read | data_write;
		if(data_write && tx_queue_full)	//write new and queue full
		begin
			tx_overwrite <= 1'b1;
		end
		if(CE && REN && A)	// read status
		begin
			tx_overwrite <= 1'b0;	//these are held for only one read cycle.
			rx_overwrite <= 1'b0;
		end
		if(rx_queue_full & rx_ready)	//receive new and queue full
		begin
			rx_overwrite <= 1'b1;
		end
	end
end

wire tx_ready;
wire[7:0] rx_data;
wire[7:0] tx_data;
wire tx_req;
reg tx_active;

always @(posedge clk or posedge reset)
begin
	if(reset)
		tx_active <= 1'b0;
	else
	begin
		if(tx_req)
			tx_active <= 1'b1;
		if(tx_ready)
			tx_active <= 1'b0;
	end
end

assign tx_req = ~tx_active && ~tx_queue_empty;

queue_8_8 tx_queue(.clk(clk), .reset(reset), .push(data_write), .pop(tx_req), .full(tx_queue_full), .empty(tx_queue_empty), .din(from_CPU), .dout(tx_data));
queue_8_8 rx_queue(.clk(clk), .reset(reset), .push(rx_ready), .pop(data_read), .full(rx_queue_full), .empty(rx_queue_empty), .din(rx_data), .dout(rx_queue_data));
UART UART_inst(.clk(clk), .reset(reset), .tx_req(tx_req), .tx_data(tx_data), .rx(rx), .tx(tx), .rx_data(rx_data), .tx_ready(tx_ready), .rx_ready(rx_ready));
endmodule

/*module queue_8_8(input wire clk, reset, push, pop, output reg full, empty, input wire[7:0] din, output reg[7:0] dout);
reg[2:0] read_addr;
reg[2:0] write_addr;
reg prev_push;
reg prev_pop;
wire addr_comp;
(* ramstyle = "logic" *) reg[7:0] queue_mem[7:0];

assign addr_comp = |(read_addr ^ write_addr);

initial
begin
	read_addr = 3'h0;
	write_addr = 3'h0;
	full = 1'b0;
	empty = 1'b1;
end

always @(posedge clk)
begin
	prev_push <= push;
	prev_pop <= pop;
	dout <= queue_mem[read_addr];
	if(reset)
	begin
		read_addr <= 3'h0;
		write_addr <= 3'h0;
		full <= 1'b0;
		empty <= 1'b1;
	end
	else
	begin
		if(push)
		begin
			write_addr <= write_addr + 3'h1;
			queue_mem[write_addr] <= din;
		end
		if(pop)
		begin
			read_addr <= read_addr + 3'h1;
		end
		if(addr_comp)
		begin
			full <= 1'b0;
			empty <= 1'b0;
		end
		else
		begin
			if(prev_push & ~prev_pop)
				full <= 1'b1;
			if(prev_pop & ~prev_push)
				empty <= 1'b1;
		end
	end
end
endmodule*/
