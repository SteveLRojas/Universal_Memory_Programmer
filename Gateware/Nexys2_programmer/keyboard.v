module keyboard(
		input wire clk,
		input wire reset, 
		input wire A,
		input wire CE,
		input wire WREN,
		input wire REN,
		input wire ps2_clk_d,
		input wire ps2_data_d,
		output wire ps2_clk_q,
		output wire ps2_data_q,
		output wire rx_int,
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

assign data_write = CE & WREN & ~A;
assign data_read = CE & REN & ~A;
assign rx_int = rx_ready;

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		rx_overwrite <= 1'b0;
		tx_overwrite <= 1'b0;
		to_CPU <= 8'h00;
	end
	else
	begin
		to_CPU <= A ? {2'b00, rx_queue_full, tx_queue_empty, ~rx_queue_empty, ~tx_queue_full, rx_overwrite, tx_overwrite} : rx_queue_data;
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
ps2_host ps2_host_inst(clk, reset, ps2_clk_d, ps2_data_d, tx_data, tx_req, ps2_clk_q, ps2_data_q, rx_data, rx_ready, tx_ready);
endmodule
