module I2C_ri_gen2(
		input wire clk,
		input wire reset,
		input wire[1:0] addr,
		input wire ce,
		input wire wren,
		input wire ren,
		output wire i2c_int,
		output reg[7:0] to_cpu,
		input wire[7:0] from_cpu,
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
	reg[7:0] clk_div_l;
	reg[7:0] clk_div_h;

	assign i2c_int = ready;

	always @(posedge clk)
	begin
		if(reset)
		begin
			start_req	<= 1'b0;
			stop_req		<= 1'b0;
			read_req		<= 1'b0;
			write_req	<= 1'b0;
			ready_flag	<= 1'b0;
			to_cpu		<= 8'h00;
		end
		else
		begin
			case(addr)
				2'b00: to_cpu <= data_from_slave;
				2'b01: to_cpu <= {1'b0, ready_flag, slave_ack, master_ack, 4'h0};
				2'b10: to_cpu <= clk_div_l;
				2'b11: to_cpu <= clk_div_h;
			endcase 
			//to_CPU <= a ? {1'b0, ready_flag, slave_ack, master_ack, 4'h0} : data_from_slave;
			
			//default values
			start_req	<= 1'b0;
			stop_req		<= 1'b0;
			read_req		<= 1'b0;
			write_req	<= 1'b0;
			
			if(ce & wren) 
			begin
				case(addr)
					2'b00: // write data
					begin
						data_from_master <= from_cpu;
						ready_flag <= 1'b0;
					end
					2'b01: // write status
					begin
						start_req	<= from_cpu[0];
						stop_req		<= from_cpu[1];
						read_req		<= from_cpu[2];
						write_req	<= from_cpu[3];
						master_ack	<= from_cpu[4];
						ready_flag	<= 1'b0;
					end
					2'b10: // write clk_div_l
						clk_div_l <= from_cpu;
					2'b11: // write clk_div_h
						clk_div_h <= from_cpu;
				endcase
			end
			
			if(ce & ren & (addr == 2'b00))	//read data
			begin
				ready_flag <= 1'b0;
			end

			if(ready)
			begin
				ready_flag <= 1'b1;
			end
		end
	end

	I2C_phy_gen2 i2c_phy_inst(
			.clk(clk),
			.rst(reset),
			.clk_div({clk_div_h, clk_div_l}),
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
