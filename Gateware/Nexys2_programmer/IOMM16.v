//Address map:
//	0x0: write address high
//	0x1: write address low
//	0x2: write address increment
//	0x3: mem data (read and write)
//	0x4: read address high
//	0x5: read address low
//	0x6: read address increment
//	0x7: status
//Status bits:
//	bit 0: write ready
//	bit 1: read ready
//	bits 2 to 6: reserved
//	bit 7: busy flag
//	bits 8 to 15: unused

//Write is triggered by writing to the mem data register
//Read is triggered by writing to the status register or the read address low register
//Write ready flag is cleared by writing to the write address or data registers.
//Read ready flag is cleared by writing to the read address or status registers.
module IOMM(
		input wire clk,
		input wire reset,
		//CPU IO interface
		input wire[2:0] addr,
		input wire en,
		input wire wren,
		input wire H_en,
		input wire L_en, 
		input wire[15:0] from_CPU,
		output reg[15:0] to_CPU,
		//Memory interface
		output wire[31:0] mem_address,
		output wire[15:0] to_mem,
		input wire[15:0] from_mem,
		output wire mem_req,
		output wire mem_wren,
		input wire mem_ready
	);

	reg[15:0] write_address_high;
	reg[15:0] write_address_low;
	reg[15:0] write_increment;
	reg[15:0] write_data;

	reg[15:0] read_address_high;
	reg[15:0] read_address_low;
	reg[15:0] read_increment;
	reg[15:0] read_data;

	reg read_active;
	reg write_active;
	reg read_ready;
	reg write_ready;

	wire high_enable;
	wire low_enable;
	wire write_enable;
	
	wire[7:0] status;

	assign high_enable = (H_en | ~L_en);
	assign low_enable = (~H_en | L_en);
	assign write_enable = en & wren;

	assign mem_address = write_active ? {write_address_high, write_address_low} : {read_address_high, read_address_low};
	assign to_mem = write_data;
	assign mem_req = write_active | read_active;
	assign mem_wren = write_active;
	
	assign status = {(read_active | write_active | write_enable), 5'h00, (read_ready & ~write_enable), (write_ready & ~write_enable)};

	always @(posedge clk or posedge reset)
	begin
		if(reset)
		begin
			write_address_high <= 16'h0000;
			write_address_low <= 16'h0000;
			write_increment <= 16'h0000;
			write_data <= 16'h0000;
			read_address_high <= 16'h0000;
			read_address_low <= 16'h0000;
			read_increment <= 16'h0000;
			read_data <= 16'h0000;
			read_active <= 1'b0;
			write_active <= 1'b0;
			read_ready <= 1'b0;
			write_ready <= 1'b0;
		end
		else
		begin
			to_CPU <= addr[2] ? {8'h00, status} : read_data;
			if(write_enable)
			begin
				case(addr)
					3'h0:	//write address high
					begin
						if(high_enable)
							write_address_high[15:8] <= from_CPU[15:8];
						if(low_enable)
							write_address_high[7:0] <= from_CPU[7:0];
						write_ready <= 1'b0;
					end
					3'h1:	//write address low
					begin
						if(high_enable)
							write_address_low[15:8] <= from_CPU[15:8];
						if(low_enable)
							write_address_low[7:0] <= from_CPU[7:0];
						write_ready <= 1'b0;
					end
					3'h2:	//write address increment
					begin
						if(high_enable)
							write_increment[15:8] <= from_CPU[15:8];
						if(low_enable)
							write_increment[7:0] <= from_CPU[7:0];
					end
					3'h3:	//write data
					begin
						if(high_enable)
							write_data[15:8] <= from_CPU[15:8];
						if(low_enable)
							write_data[7:0] <= from_CPU[7:0];
						write_active <= 1'b1;
						write_ready <= 1'b0;
					end
					3'h4:	//read address high
					begin
						if(high_enable)
							read_address_high[15:8] <= from_CPU[15:8];
						if(low_enable)
							read_address_high[7:0] <= from_CPU[7:0];
						read_ready <= 1'b0;
					end
					3'h5:	//read address low
					begin
						if(high_enable)
							read_address_low[15:8] <= from_CPU[15:8];
						if(low_enable)
							read_address_low[7:0] <= from_CPU[7:0];
						read_active <= 1'b1;
						read_ready <= 1'b0;
					end
					3'h6:	//read address increment
					begin
						if(high_enable)
							read_increment[15:8] <= from_CPU[15:8];
						if(low_enable)
							read_increment[7:0] <= from_CPU[7:0];
					end
					3'h7:	//status
					begin
						read_active <= 1'b1;
						read_ready <= 1'b0;
					end
				endcase // addr
			end

			if(mem_ready)
			begin
				read_active <= 1'b0;
				write_active <= 1'b0;
				read_ready <= read_active;
				write_ready <= write_active;
				if(read_active)
				begin
					{read_address_high, read_address_low} <= {read_address_high, read_address_low} + {16'h0000, read_increment};
					read_data <= from_mem;
				end
				if(write_active)
				begin
					{write_address_high, write_address_low} <= {write_address_high, write_address_low} + {16'h0000, write_increment};
				end
			end
		end
	end

endmodule	//IOMM
