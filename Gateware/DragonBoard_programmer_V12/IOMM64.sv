//Address map:
//	0x0: write address high
//	0x1: write address low
//	0x2: write address increment
//	0x3: unused
//	0x4: read address high
//	0x5: read address low
//	0x6: read address increment
//	0x7: status
// 0x8: mem data 0 (read and write)
// 0x9: mem data 1 (read and write)
// 0xA: mem data 2 (read and write)
// 0xB: mem data 3 (read and write)
// 0xC: unused
// 0xD: unused
// 0xE: unused
// 0xF: unused

//Status bits:
//	bit 0: write ready
//	bit 1: read ready
//	bits 2 to 6: reserved
//	bit 7: busy flag
//	bits 8 to 15: unused

//Write is triggered by writing to the mem data 0 register
//Read is triggered by writing to the status register or the read address low register
//Write ready flag is cleared by writing to the write address or data registers.
//Read ready flag is cleared by writing to the read address or status registers.
module IOMM64(
		input wire clk,
		input wire reset,
		//CPU IO interface
		input wire[3:0] addr,
		input wire en,
		input wire wren,
		input wire[15:0] from_CPU,
		output reg[15:0] to_CPU,
		//Memory interface
		output wire[31:0] mem_address,
		output wire[63:0] to_mem,
		input wire[63:0] from_mem,
		output wire mem_req,
		output wire mem_wren,
		input wire mem_ready
	);

	reg[15:0] write_address_high;
	reg[15:0] write_address_low;
	reg[15:0] write_increment;
	reg[63:0] write_data;

	reg[15:0] read_address_high;
	reg[15:0] read_address_low;
	reg[15:0] read_increment;
	reg[63:0] read_data;

	reg read_active;
	reg write_active;
	reg read_ready;
	reg write_ready;

	wire write_enable;
	wire[7:0] status;

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
			write_data <= 64'h0000;
			read_address_high <= 16'h0000;
			read_address_low <= 16'h0000;
			read_increment <= 16'h0000;
			read_data <= 64'h0000;
			read_active <= 1'b0;
			write_active <= 1'b0;
			read_ready <= 1'b0;
			write_ready <= 1'b0;
		end
		else
		begin
			case(addr)
				4'h7: to_CPU <= {8'h00, status};
				4'h8: to_CPU <= read_data[15:0];
				4'h9: to_CPU <= read_data[31:16];
				4'hA: to_CPU <= read_data[47:32];
				4'hB: to_CPU <= read_data[63:48];
				default: to_CPU <= 16'hxxxx;
			endcase
			
			if(write_enable)
			begin
				case(addr)
					4'h0:	//write address high
					begin
						write_address_high <= from_CPU;
						write_ready <= 1'b0;
					end
					4'h1:	//write address low
					begin
						write_address_low <= from_CPU;
						write_ready <= 1'b0;
					end
					4'h2:	//write address increment
					begin
						write_increment <= from_CPU;
					end
					4'h4:	//read address high
					begin
						read_address_high <= from_CPU;
						read_ready <= 1'b0;
					end
					4'h5:	//read address low
					begin
						read_address_low <= from_CPU;
						read_active <= 1'b1;
						read_ready <= 1'b0;
					end
					4'h6:	//read address increment
					begin
						read_increment <= from_CPU;
					end
					4'h7:	//status
					begin
						read_active <= 1'b1;
						read_ready <= 1'b0;
					end
					4'h8:
					begin
						write_data[15:0] <= from_CPU;
						write_active <= 1'b1;
						write_ready <= 1'b0;
					end
					4'h9:
					begin
						write_data[31:16] <= from_CPU;
						write_ready <= 1'b0;
					end
					4'hA:
					begin
						write_data[47:32] <= from_CPU;
						write_ready <= 1'b0;
					end
					4'hB:
					begin
						write_data[63:48] <= from_CPU;
						write_ready <= 1'b0;
					end
					default: ;
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

endmodule	//IOMM64
