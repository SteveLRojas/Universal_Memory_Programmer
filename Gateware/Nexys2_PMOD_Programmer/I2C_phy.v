module I2C_phy(
		input wire clk,
		input wire rst,
		input wire start_req,
		input wire stop_req,
		input wire write_req,
		input wire read_req,
		output reg ready,
		input wire master_ack,
		output wire slave_ack,
		input wire[7:0] data_from_master,
		output wire[7:0] data_from_slave,
		inout wire i2c_sda,
		inout wire i2c_scl);
		
wire clk_p1;	//2MHz clock phase 1
wire clk_p2;	//2MHz clock phase 2
reg clk_i2c;	//1MHz I2C clock
reg clk_active;
reg tx_active;
reg rx_active;
//reg[4:0] clk_div;
reg[5:0] clk_div;

reg prev_start_req;
reg prev_stop_req;
reg prev_write_req;
reg prev_read_req;
reg start_req_flag;
reg stop_req_flag;
reg write_req_flag;
reg read_req_flag;

reg[10:0] tx_frame;	//sda control, d7:d0, ack, frame end marker
reg[8:0] rx_frame;	//shifts left
wire tx_done;
wire rx_done;

//assign clk_p1 = (clk_div == 5'h00);
//assign clk_p2 = (clk_div == 5'h0C);
assign clk_p1 = (clk_div == 6'h00);
assign clk_p2 = (clk_div == 6'd25);
assign tx_done = &tx_frame[8:0] & tx_active;
assign rx_done = &tx_frame[8:0] & rx_active;
assign i2c_scl = clk_i2c ? 1'bz : 1'b0;
assign i2c_sda = tx_frame[10] ? 1'bz : 1'b0;
assign data_from_slave = rx_frame[8:1];
assign slave_ack = ~rx_frame[0];

initial
begin
	clk_i2c = 1'b1;
	tx_frame = 11'b111_1111_1111;
	clk_active = 1'b0;
	tx_active = 1'b0;
	rx_active = 1'b0;
end

always @(posedge clk)
begin
	ready <= 1'b0;
	if(rst)
	begin
		//clk_div <= 5'h00;
		clk_div <= 6'h00;
		clk_i2c <= 1'b1;
		tx_frame[10] <= 1'b1;
		clk_active <= 1'b0;
		tx_active <= 1'b0;
		rx_active <= 1'b0;
		prev_start_req <= 1'b0;
		prev_stop_req <= 1'b0;
		prev_write_req <= 1'b0;
		prev_read_req <= 1'b0;
		start_req_flag <= 1'b0;
		stop_req_flag <= 1'b0;
		write_req_flag <= 1'b0;
		read_req_flag <= 1'b0;
	end
	else
	begin
		prev_start_req <= start_req;
		prev_stop_req <= stop_req;
		prev_write_req <= write_req;
		prev_read_req <= read_req;
		
		if(start_req & ~prev_start_req)
			start_req_flag <= 1'b1;
		if(stop_req & ~prev_stop_req)
			stop_req_flag <= 1'b1;
		if(write_req & ~prev_write_req)
			write_req_flag <= 1'b1;
		if(read_req & ~prev_read_req)
			read_req_flag <= 1'b1;
			
		//if(clk_div == 5'd24)
		//	clk_div <= 5'd00;
		//else
		//	clk_div <= clk_div + 5'h01;
		if(clk_div == 6'd49)
			clk_div <= 6'd00;
		else
			clk_div <= clk_div + 6'h01;

		if(clk_active & clk_p2)
			clk_i2c <= ~clk_i2c;

		if((tx_active | rx_active) & clk_p1 & ~clk_i2c)
			tx_frame <= {tx_frame[9:0], 1'b1};
		if((tx_active | rx_active) & clk_p1 & clk_i2c)
			rx_frame <= {rx_frame[7:0], i2c_sda};
			
		if(start_req_flag & clk_p1 & clk_i2c)	//start clock
			clk_active <= 1'b1;
		if(start_req_flag & clk_p1 & ~clk_i2c)	//make sure data line is high
			tx_frame[10] <= 1'b1;
		if(start_req_flag & clk_p1 & clk_i2c & clk_active)
		begin
			clk_active <= 1'b0;	//stop clock
			tx_frame[10] <= 1'b0;	//while clock is high bring data line low
			start_req_flag <= 1'b0;
			ready <= 1'b1;
		end
		
		if(stop_req_flag & clk_p1 & clk_i2c)	//start clock
			clk_active <= 1'b1;
		if(stop_req_flag & clk_p1 & ~clk_i2c)	//make sure data line is low
			tx_frame[10] <= 1'b0;
		if(stop_req_flag & clk_p1 & clk_i2c & clk_active)
		begin
			clk_active <= 1'b0;	//stop clock
			tx_frame[10] <= 1'b1;	//while clock is high bring data line high
			stop_req_flag <= 1'b0;
			ready <= 1'b1;
		end
		
		if(write_req_flag & clk_p1 & clk_i2c)	//load data
		begin
			clk_active <= 1'b1;
			tx_active <= 1'b1;
			write_req_flag <= 1'b0;
			tx_frame[9:0] <= {data_from_master, 1'b1, 1'b0};
		end
		if(tx_done & clk_p1 & clk_i2c)
		begin
			clk_active <= 1'b0;
			tx_active <= 1'b0;
			ready <= 1'b1;
		end

		if(read_req_flag & clk_p1 & clk_i2c)
		begin
			clk_active <= 1'b1;
			rx_active <= 1'b1;
			read_req_flag <= 1'b0;
			tx_frame[9:0] <= {8'hff, ~master_ack, 1'b0};
		end
		if(rx_done & clk_p1 & clk_i2c)
		begin
			clk_active <= 1'b0;
			rx_active <= 1'b0;
			ready <= 1'b1;
		end
	end
end

endmodule
