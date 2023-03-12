module I2C_ri(
		input wire clk,
		input wire reset,
		input wire a,
		input wire ce,
		input wire wren,
		input wire ren,
		output wire i2c_int,
		output reg[7:0] to_CPU,
		input wire[7:0] from_CPU,
		inout wire i2c_sda,
		inout wire i2c_scl);
//Note that the latency for this module is 2 clk cycles.
// Status bits:
// bit 0: START
// bit 1: STOP
// bit 2: READ_REQ
// bit 3: WRITE_REQ
// bit 4: MASTER_ACK
// bit 5: SLAVE_ACK
// bit 6: READY
reg start_req;
reg stop_req;
reg read_req;
reg write_req;
reg master_ack;
wire slave_ack;
reg ready_flag;
wire ready;
reg[7:0] data_from_master;
wire[7:0] data_from_slave;

assign i2c_int = ready;

always @(posedge clk)
begin
	if(reset)
	begin
		start_req <= 1'b0;
		stop_req <= 1'b0;
		read_req <= 1'b0;
		write_req <= 1'b0;
		ready_flag <= 1'b0;
		to_CPU <= 8'h00;
	end
	else
	begin
		to_CPU <= a ? {1'b0, ready_flag, slave_ack, master_ack, 4'h0} : data_from_slave;
		//default values
		start_req <= 1'b0;
		stop_req <= 1'b0;
		read_req <= 1'b0;
		write_req <= 1'b0;
		if(ce & wren & ~a)	//data write
		begin
			data_from_master <= from_CPU;
			ready_flag <= 1'b0;
		end
		if(ce & ren & ~a)	//read data
		begin
			ready_flag <= 1'b0;
		end
		if(ce & wren & a)	//write status
		begin
			start_req <= from_CPU[0];
			stop_req <= from_CPU[1];
			read_req <= from_CPU[2];
			write_req <= from_CPU[3];
			master_ack <= from_CPU[4];
			ready_flag <= 1'b0;
		end
//		if(ce && ren && a)	// read status
//		begin
//			ready_flag <= 1'b0;	//these are held for only one read cycle.
//		end
		if(ready)
		begin
			ready_flag <= 1'b1;
		end
	end
end

I2C_phy i2c_phy_inst(
		.clk(clk),
		.rst(reset),
		.start_req(start_req),
		.stop_req(stop_req),
		.write_req(write_req),
		.read_req(read_req),
		.ready(ready),
		.master_ack(master_ack),
		.slave_ack(slave_ack),
		.data_from_master(data_from_master),
		.data_from_slave(data_from_slave),
		.i2c_sda(i2c_sda),
		.i2c_scl(i2c_scl));

endmodule
