module SPI_ri(
		input wire clk,
		input wire reset,
		input wire[1:0] a,
		input wire ce,
		input wire wren,
		output wire spi_int,
		output reg[7:0] to_cpu,
		input wire[7:0] from_cpu,
		output wire mosi,
		input wire miso,
		output wire sclk,
		output wire[7:0] ncs);

// Registers:
// 0x0:	data register
// 0x1:	status register
// 0x2:	clock speed register
// 0x3:	device select

// Status bits:
// bit 0: TRANSFER_REQ
// bit 1: CPOL
// bit 2: CPHA
// bit 3: reserved
// bit 4: reserved
// bit 5: CONFIG_EN
// bit 6: TRANSFER_ACTIVE
// bit 7: READY
	
	reg transfer_req;
	reg transfer_active;
	wire busy;
	
	reg[7:0] clk_div;
	reg cpol;
	reg cpha;
	reg[7:0] spi_ncs;
	
	wire transfer_ready;
	wire transfer_done;
	
	wire[7:0] from_agent;
	reg[7:0] data_from_master;
	reg[7:0] data_from_slave;

	assign spi_int = transfer_done;
	assign ncs = spi_ncs;
	assign busy = ce & wren;

	always @(posedge clk)
	begin
		if(reset)
		begin
			transfer_req <= 1'b0;
			transfer_active <= 1'b0;
			clk_div <= 8'h00;
			cpol <= 1'b0;
			cpha <= 1'b0;
			spi_ncs <= 8'hff;
			to_cpu <= 8'h00;
		end
		else
		begin
			//CPU reads
			case(a)
				2'b00: to_cpu <= data_from_slave;
				2'b01: to_cpu <= {~(transfer_active | busy), transfer_active, 3'b000, cpha, cpol, 1'b0};
				2'b10: to_cpu <= clk_div;
				2'b11: to_cpu <= spi_ncs;
			endcase
			
			//CPU writes
			if(ce & wren)
			begin
				case(a)
					2'b00:	//write data
					begin
						data_from_master <= from_cpu;
					end
					2'b01:	//write status
					begin
						transfer_req <= from_cpu[0];
						transfer_active <= from_cpu[0];
						if(from_cpu[5])
						begin
							cpol <= from_cpu[1];
							cpha <= from_cpu[2];
						end
					end
					2'b10:	//write clk_div
					begin
						clk_div <= from_cpu;
					end
					2'b11:	//write ncs
					begin
						spi_ncs <= from_cpu;
					end
				endcase
			end
			
			if(transfer_ready & transfer_req)
			begin
				transfer_req <= 1'b0;
			end
			
			if(transfer_done)
			begin
				transfer_active <= 1'b0;
			end
			
			if(transfer_done)
			begin
				data_from_slave <= from_agent;
			end
		end
	end
			
	spi_master spi_master_inst(
		.clk(clk),
		.rst(reset),

		.clk_div(clk_div),
		.cpol(cpol),
		.cpha(cpha),

		.sck(sclk),
		.mosi(mosi),
		.miso(miso),

		.transfer_req(transfer_req),
		.transfer_ready(transfer_ready),
		.transfer_done(transfer_done),
		
		.to_agent(data_from_master),
		.from_agent(from_agent) );

endmodule
