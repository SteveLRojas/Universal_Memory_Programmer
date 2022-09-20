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
// bit 2: write buffer empty
// bit 3: read buffer full
//	bits 4 to 6: reserved
//	bit 7: busy flag
//	bits 8 to 15: unused

//Memory reads are triggered automatically when the read buffer is empty.
//Writes to the status register pop the read buffer, writes to the read address registers flush the read buffer.
//Memory writes are triggered automatically when the write buffer is full.
//Writes to the data register push the write buffer, writes to the write address registers flush the write buffer.
module iomm16_gen2
	#(parameter BURST_LENGTH = 8)
	(
		input wire clk,
		input wire reset,
		//CPU IO interface
		input wire[2:0] addr,
		input wire en,
		input wire wren,
		input wire[15:0] from_cpu,
		output reg[15:0] to_cpu,
		//Memory interface
		output wire[31:0] mem_address,
		output wire[15:0] to_mem,
		input wire[15:0] from_mem,
		output wire mem_req,
		output wire mem_wren,
		input wire mem_ready,
		input wire mem_valid,
		input wire[2:0] mem_offset
	);

	reg[15:0] write_address_high;
	reg[15:0] write_address_low;
	reg[15:0] write_increment;

	reg[15:0] read_address_high;
	reg[15:0] read_address_low;
	reg[15:0] read_increment;

	reg read_pending;
	reg write_pending;
	reg read_active;
	reg write_active;
	
	wire read_ready;
	wire write_ready;

	wire write_enable;
	wire[7:0] status;
	
	wire write_buf_flush;
	wire write_buf_push;
	wire write_buf_pop;
	wire write_buf_full;
	wire write_buf_empty;

	wire read_buf_flush;
	wire read_buf_push;
	wire read_buf_pop;
	wire read_buf_full;
	wire read_buf_empty;
	wire[15:0] read_buf_dout;

	assign write_enable = en & wren;

	assign mem_address = write_pending ? {write_address_high, write_address_low} : {read_address_high, read_address_low};
	assign mem_req = write_pending | read_pending;
	assign mem_wren = write_pending;
	
	assign read_ready = ~read_buf_empty;
	assign write_ready = ~write_buf_full;
	
	assign status = {write_enable | read_pending | write_pending, 3'h0, read_buf_full, write_buf_empty, (read_ready & ~write_enable), (write_ready & ~write_enable)};

	always @(posedge clk or posedge reset)
	begin
		if(reset)
		begin
			to_cpu <= 16'h0000;
			write_address_high <= 16'h0000;
			write_address_low <= 16'h0000;
			write_increment <= 16'h0000;
			read_address_high <= 16'h0000;
			read_address_low <= 16'h0000;
			read_increment <= 16'h0000;
			read_pending <= 1'b0;
			write_pending <= 1'b0;
			read_active <= 1'b0;
			write_active <= 1'b0;
		end
		else
		begin
			to_cpu <= addr[2] ? {8'h00, status} : read_buf_dout;
			if(write_enable)
			begin
				case(addr)
					3'h0:	//write address high
					begin
						write_address_high <= from_cpu;
					end
					3'h1:	//write address low
					begin
						write_address_low <= from_cpu;
					end
					3'h2:	//write address increment
					begin
						write_increment <= from_cpu;
					end
					3'h3:	;//write data
					//begin
						//write_active <= 1'b1;
					//end
					3'h4:	//read address high
					begin
						read_address_high <= from_cpu;
					end
					3'h5:	//read address low
					begin
						read_address_low <= from_cpu;
						//read_pending <= 1'b1;
					end
					3'h6:	//read address increment
					begin
						read_increment <= from_cpu;
					end
					3'h7:	;//status
					//begin
						//read_pending <= read_buf_empty;
					//end
				endcase // addr
			end
			
			if(read_buf_empty & ~(read_pending | read_active))
				read_pending <= 1'b1;
			if(write_buf_full & ~(write_pending | write_active))
				write_pending <= 1'b1;

			if(mem_ready & read_pending)
			begin
				read_pending <= 1'b0;
				read_active <= 1'b1;
			end
			if(mem_ready & write_pending)
			begin
				write_pending <= 1'b0;
				write_active <= 1'b1;
			end
				
			if(mem_valid & read_active & (mem_offset == (BURST_LENGTH - 1)))
			begin
				{read_address_high, read_address_low} <= {read_address_high, read_address_low} + {16'h0000, read_increment};
				read_active <= 1'b0;
			end
			if(mem_valid & write_active & (mem_offset == 3'(BURST_LENGTH)))
			begin
				{write_address_high, write_address_low} <= {write_address_high, write_address_low} + {16'h0000, write_increment};
				write_active <= 1'b0;
			end
		end
	end
	
	assign write_buf_flush = reset | (write_enable & (addr == 3'h0 || addr == 3'h1));	//reset or write to write address registers
	assign write_buf_push = write_enable & (addr == 3'h3);	//write to data register
	assign write_buf_pop = write_active & mem_valid;
	
	assign read_buf_flush = reset | (write_enable & (addr == 3'h4 || addr == 3'h5));		//reset or write to read address registers
	assign read_buf_push = read_active & mem_valid;
	assign read_buf_pop = write_enable & (addr == 3'h7);		//write to status
	
	fifo #(
		.BUS_WIDTH(16),
		.NUM_WORDS(BURST_LENGTH)
	) write_buffer(
		.clk(clk),
		.reset(write_buf_flush),
		.push(write_buf_push),
		.pop(write_buf_pop),
		.full(write_buf_full),
		.empty(write_buf_empty),
		.din(from_cpu),
		.dout(to_mem)
	);
			
	fifo #(
		.BUS_WIDTH(16),
		.NUM_WORDS(BURST_LENGTH)
	) read_buffer(
		.clk(clk),
		.reset(read_buf_flush),
		.push(read_buf_push),
		.pop(read_buf_pop),
		.full(read_buf_full),
		.empty(read_buf_empty),
		.din(from_mem),
		.dout(read_buf_dout)
	);

endmodule	//IOMM
