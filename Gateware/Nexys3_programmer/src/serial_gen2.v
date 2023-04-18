//Note that the latency for this module is 2 clk cycles.
// RS-232 module address map
// 0 data register
// 1 status register
//		bit 0: TX overwrite
//		bit 1: RX overwrite
//		bit 2: TX ready
//		bit 3: RX ready
//		bit 4: TX queue empty
//		bit 5: RX queue full
// 2 clk_div_l
// 3 clk_div_h

// Status bits:
//	bit 0: TX overwrite
// bit 1: RX overwrite
// bit 2: TX ready
// bit 3: RX ready
// bit 4: TX queue empty
// bit 5: RX queue full
// bit 6: reserved
// bit 7: busy flag

module serial_gen2(
		input wire clk, 
		input wire reset,
		input wire[1:0] addr,
		input wire en,
		input wire wren,
		input wire ren,
		input wire rx,
		output wire tx,
		output wire rx_int,
		output wire tx_int,
		output reg[7:0] to_cpu,
		input wire[7:0] from_cpu);


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
	wire busy;
	wire[7:0] status;
	
	reg[7:0] clk_div_l;
	reg[7:0] clk_div_h;

	assign data_write = en & wren & (addr == 2'b00);
	assign data_read = en & ren & (addr == 2'b00);
	assign tx_int = tx_queue_empty;
	assign rx_int = rx_ready;
	assign busy = (addr == 2'b00) & en & (ren | wren);
	assign status = {busy, 1'b0, rx_queue_full, tx_queue_empty, ~rx_queue_empty, ~tx_queue_full, rx_overwrite, tx_overwrite};

	always @(posedge clk or posedge reset)
	begin
		if(reset)
		begin
			rx_overwrite <= 1'b0;
			tx_overwrite <= 1'b0;
			to_cpu <= 8'h00;
			//busy <= 1'b0;
		end
		else
		begin
			case(addr)
				2'b00: to_cpu <= rx_queue_data;
				2'b01:
				begin
					to_cpu <= status;
					if(en & ren)
					begin
						tx_overwrite <= 1'b0;	//these are held for only one read cycle.
						rx_overwrite <= 1'b0;
					end
				end
				2'b10: to_cpu <= clk_div_l;
				2'b11: to_cpu <= clk_div_h;
			endcase
			
			if(en & wren)
			begin
				if((addr == 2'b00) & tx_queue_full)
				begin
					tx_overwrite <= 1'b1;
				end
				
				if(addr == 2'b10)
				begin
					clk_div_l <= from_cpu;
				end
				if(addr == 2'b11)
				begin
					clk_div_h <= from_cpu;
				end
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
	
	queue_8_8 tx_queue(
		.clk(clk),
		.reset(reset),
		.push(data_write),
		.pop(tx_req),
		.full(tx_queue_full),
		.empty(tx_queue_empty),
		.din(from_cpu),
		.dout(tx_data)
	);
	
	queue_8_8 rx_queue(
		.clk(clk),
		.reset(reset),
		.push(rx_ready),
		.pop(data_read),
		.full(rx_queue_full),
		.empty(rx_queue_empty),
		.din(rx_data),
		.dout(rx_queue_data)
	);
			
	uart_gen2 uart_inst(
		.clk(clk),
		.reset(reset),
		.clk_div({clk_div_h, clk_div_l}),
		.tx_req(tx_req),
		.tx_data(tx_data),
		.rx(rx),
		.tx(tx),
		.rx_data(rx_data),
		.tx_ready(tx_ready),
		.rx_ready(rx_ready)
	);
endmodule
