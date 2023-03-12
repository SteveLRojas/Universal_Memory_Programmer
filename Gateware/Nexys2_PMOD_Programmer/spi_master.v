module spi_master(
		input wire clk,
		input wire rst,

		input wire[7:0] clk_div,
		input wire cpol,
		input wire cpha,

		output reg sck,
		output wire mosi,
		input wire miso,

		input wire transfer_req,
		output wire transfer_ready,
		output wire transfer_done,
		input wire[7:0] to_agent,
		output wire[7:0] from_agent);

	wire load_en;
	wire shift_en;
	wire next_load_en;
	wire next_shift_en;
	reg load_en_q;
	reg shift_en_q;

	wire timer_pulse;
	wire last_cycle;
	reg prev_last_cycle;

	reg[3:0] cycle_count;
	reg[7:0] timer;
	reg transfer_active;

	wire done;
	reg prev_done;
	reg done_hold;
	reg prev_done_hold;

	wire[7:0] load_data;
	reg[7:0] load_data_hold;

	reg[7:0] tx_shift;
	reg[7:0] rx_shift;

	assign timer_pulse = ~|timer;
	assign last_cycle = &cycle_count;
	
	assign next_load_en = last_cycle & transfer_req;
	assign load_en = cpha ? load_en_q : next_load_en;
	assign load_data = cpha ? load_data_hold : to_agent;

	assign next_shift_en = transfer_active & cycle_count[0];
	assign shift_en = cpha ? shift_en_q : next_shift_en;
	
	assign done = cpha ? prev_done_hold : done_hold;
	assign transfer_ready = last_cycle & timer_pulse;
	assign transfer_done = done & ~prev_done;
	assign mosi = tx_shift[7];
	assign from_agent = rx_shift;

	always @(posedge clk)
	begin
		prev_done <= done;

		if(timer_pulse)
		begin
			load_en_q <= next_load_en;
			shift_en_q <= next_shift_en;
			prev_last_cycle <= last_cycle;
			prev_done_hold <= done_hold;
			load_data_hold <= to_agent;
		end

		if(timer_pulse)
			done_hold <= last_cycle & ~prev_last_cycle & transfer_active;

		if(shift_en & timer_pulse)
		begin
			tx_shift <= {tx_shift[6:0], load_data[0]};
			rx_shift <= {rx_shift[6:0], miso};
		end
		if(load_en & timer_pulse)
			tx_shift <= load_data;

		if(timer_pulse)
		begin
			if(last_cycle)
				sck <= cpol;
			else
				sck <= ~sck;
		end
	end

	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			cycle_count <= 4'h0;
			timer <= 8'h00;
			transfer_active <= 1'b0;
		end
		else
		begin
			if(timer == clk_div)
				timer <= 8'h0;
			else
				timer <= timer + 8'h01;

			if(timer_pulse)
			begin
				if(~last_cycle)
					cycle_count <= cycle_count + 4'h1;
				else if(transfer_req)
					cycle_count <= 4'h0;
			end

			if(timer_pulse & last_cycle)
				transfer_active <= transfer_req;
		end
	end

endmodule
