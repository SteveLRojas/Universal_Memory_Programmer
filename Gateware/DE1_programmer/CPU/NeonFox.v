module NeonFox(
		input wire clk,
		input wire halt,
		input wire reset,
		input wire int_rq,	//interrupt request
		input wire[3:0] int_addr,	//interrupt address
		input wire p_cache_miss,	//program cache read miss
		input wire d_cache_read_miss,	//data cache read miss
		input wire d_cache_write_miss,	//data cache write miss
		input wire[15:0] prg_data,	//program data
		output wire[31:0] prg_address,	//program address
		output wire[31:0] data_address,	//NOT used for IO
		output wire[15:0] IO_address,
		output wire[15:0] data_out,	//data and IO out
		input wire[15:0] data_in,
		input wire[15:0] IO_in,
		output wire data_wren,	//data write enable
		output wire data_ren,	//data read enable
		output wire IO_wren,	//high during IO writes
		output wire IO_ren,		//IO read enable
		output wire H_en,	//high byte write enable for IO and data
		output wire L_en	//low byte write enable for IO and data
		);
reg prev_int_rq;
reg interrupt;
reg prev_interrupt;
reg[15:0] DIO_in;

wire data_hazard;
wire regf_wren;
reg regf_wren1, regf_wren2;
wire H_en0;
reg H_en1, H_en2;
wire L_en0;
reg L_en1, L_en2;
wire[4:0] src_raddr;
wire[4:0] dest_waddr;
reg[4:0] dest_waddr1, dest_waddr2;
wire[15:0] alu_out;
wire[15:0] a_data;
wire[15:0] b_data;
wire[31:0] last_callx_addr;
wire[31:0] next_callx_addr;
wire update_last_callx;

reg set_cc;
wire[9:0] I_field;
reg[7:0] I_field1;
wire[3:0] alu_op;
reg[3:0] alu_op1;
wire n, z, p, c;

wire pc_jmp;
wire pc_brx;
wire pc_brxt;
wire pc_call;
wire pc_ret;
reg pc_ret1, pc_ret_hold;
wire interrupt_inhibit;
wire hazard;
wire branch_hazard;
wire take_brx;
reg take_brx1, take_brx_hold;
wire take_jmp;
reg take_jmp1, take_jmp_hold;
wire decoder_flush_inhibit;	//indicates that the second instruction after a branch was not fetched

wire decoder_rst;
reg reset_hold;
wire decoder_input_flush;
wire decoder_output_flush;
reg extend_flush;	//causes flush to be treated like a full reset
wire data_wren0;
reg data_wren1, data_wren2;
wire data_ren0;
wire IO_wren0;
reg IO_wren1, IO_wren2;
wire IO_ren0;
wire status_ren;
wire address_select;
reg address_select1, address_select2;
wire data_select;
reg data_select1, data_select2;
wire IO_select;
reg IO_select1, IO_select2;

assign data_wren = data_wren2;
assign data_ren = data_ren0 & ~(data_select1 | data_select2);
assign IO_wren = IO_wren2;
assign IO_ren = IO_ren0 & ~(IO_select1 | IO_select2);
assign data_out = alu_out;
assign H_en = H_en2 | ~L_en2;	//both H_en and L_en low from the decoder indicate high and low bytes are swapped (both enabled).
assign L_en = L_en2 | ~H_en2;
assign data_hazard = d_cache_write_miss;
assign decoder_rst = reset | reset_hold | interrupt;

always @(posedge clk)
begin
	DIO_in <= ({16{data_ren}} & data_in) | ({16{IO_ren}} & IO_in);
	reset_hold <= reset;
	if(reset)
	begin
		interrupt <= 1'b0;
		prev_int_rq <= 1'b1;
		prev_interrupt <= 1'b0;
	end
	else
	begin
		prev_int_rq <= int_rq & (~interrupt_inhibit | prev_int_rq);	//set when int_rq & ~interrupt_inhibit, clear when ~int_rq
		interrupt <= int_rq & ~prev_int_rq & ~interrupt_inhibit;
		prev_interrupt <= interrupt;
	end
end

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		regf_wren1 <= 1'b0;
		regf_wren2 <= 1'b0;
		alu_op1 <= 4'b0111;
		data_wren1 <= 1'b0;
		data_wren2 <= 1'b0;
		IO_wren1 <= 1'b0;
		IO_wren2 <= 1'b0;
		address_select1 <= 1'b0;
		address_select2 <= 1'b0;
		data_select1 <= 1'b0;
		data_select2 <= 1'b0;
		IO_select1 <= 1'b0;
		IO_select2 <= 1'b0;
	end
	else if(~data_hazard)
	begin
		//take_brx1 <= take_brx;
		if(hazard | interrupt)
		begin
			regf_wren1 <= 1'b0;
			alu_op1 <= 4'b0111;
			data_wren1 <= 1'b0;
			IO_wren1 <= 1'b0;
			address_select1 <= 1'b0;
			data_select1 <= 1'b0;
			IO_select1 <= 1'b0;
		end
		else	//not hazard
		begin
			regf_wren1 <= regf_wren;
			alu_op1 <= alu_op;
			data_wren1 <= data_wren0;
			IO_wren1 <= IO_wren0;
			address_select1 <= address_select;
			data_select1 <= data_select;
			IO_select1 <= IO_select;
		end
		regf_wren2 <= regf_wren1;
		data_wren2 <= data_wren1;
		IO_wren2 <= IO_wren1;
		address_select2 <= address_select1;
		data_select2 <= data_select1;
		IO_select2 <= IO_select1;
	end
end

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		take_jmp1 <= 1'b0;
		take_jmp_hold <= 1'b0;
		pc_ret1 <= 1'b0;
		pc_ret_hold <= 1'b0;
		take_brx1 <= 1'b0;
		take_brx_hold <= 1'b0;
		extend_flush <= 1'b0;
	end
	else
	begin
		extend_flush <= ~(take_jmp_hold | pc_ret_hold | take_brx_hold);
		if(hazard)
		begin
			take_jmp_hold <= (take_jmp & ~decoder_flush_inhibit) | take_jmp_hold;
			take_jmp1 <= 1'b0;
			pc_ret_hold <= (pc_ret & ~decoder_flush_inhibit) | pc_ret_hold;
			pc_ret1 <= 1'b0;
			take_brx_hold <= (take_brx & ~decoder_flush_inhibit) | take_brx_hold;
			take_brx1 <= 1'b0;
		end
		else
		begin
			take_jmp_hold <= 1'b0;
			take_jmp1 <= take_jmp | take_jmp_hold;
			pc_ret_hold <= 1'b0;
			pc_ret1 <= pc_ret | pc_ret_hold;
			take_brx_hold <= 1'b0;
			take_brx1 <= take_brx | take_brx_hold;
		end
	end
end

always @(posedge clk)
begin
	if(~data_hazard)
	begin
		set_cc <= (dest_waddr == 5'h1E) & regf_wren;
		H_en1 <= H_en0;
		H_en2 <= H_en1;
		L_en1 <= L_en0;
		L_en2 <= L_en1;
		dest_waddr1 <= dest_waddr;
		dest_waddr2 <= dest_waddr1;
		I_field1 <= I_field[7:0];
	end
end

//##### REGISTER FILE #####
reg_file reg_file_inst(
		.clk(clk),
		.data_hazard(data_hazard),
		.wren(regf_wren2),
		.h_en(H_en2),
		.l_en(L_en2),
		.data_select(data_select2),
		.IO_select(IO_select2),
		.a_address(src_raddr),
		.w_address(dest_waddr2),
		.w_data(alu_out),
		.a_data(a_data),
		.b_data(b_data),
		.IO_ren(IO_ren0),
		.data_ren(data_ren0),
		.DIO_in(DIO_in),
		.last_callx_addr(last_callx_addr),
		.next_callx_addr(next_callx_addr),
		.update_last_callx(update_last_callx),
		.n(n), .z(z), .p(p), .c(c),
		.data_address(data_address),
		.IO_address(IO_address));

//##### ALU #####
ALU ALU_inst(
		.clk(clk),
		.data_hazard(data_hazard),
		.set_cc(set_cc), 
		.h_en(H_en1), .l_en(L_en1),
		.in_a(a_data), 
		.in_b(b_data),
		.I_field(I_field1),
		.alu_op(alu_op1),
		.alu_out(alu_out),
		.n(n), .z(z), .p(p), .c(c));

//##### PC #####
PC PC_inst(
		.clk(clk),
		.rst(reset),
		.pc_jmp(pc_jmp),
		.pc_brx(pc_brx),
		.pc_brxt(pc_brxt),
		.pc_call(pc_call),
		.pc_ret(pc_ret),
		.H_en(H_en0),
		.L_en(L_en0),
		.interrupt(interrupt),
		.int_addr(int_addr),
		.hazard(hazard),
		//.data_hazard(data_hazard),
		.branch_hazard(branch_hazard),
		.p_cache_miss(p_cache_miss),
		.next_callx_addr(next_callx_addr),
		.last_callx_addr(last_callx_addr),
		.update_last_callx(update_last_callx),
		.I_field(I_field),
		.n(n), .z(z), .p(p),
		.take_brx(take_brx),
		.take_jmp(take_jmp),
		.decoder_flush_inhibit(decoder_flush_inhibit),
		.interrupt_inhibit(interrupt_inhibit),
		.prg_address(prg_address));

//##### DECODER #####
decode_unit decoder_inst(
		.clk(clk),
		.rst(decoder_rst),
		.jmp_rst(take_jmp),
		.brx_rst(take_brx),
		.input_flush(decoder_input_flush),
		.output_flush(decoder_output_flush),
		.hazard(hazard),
		.p_cache_miss(p_cache_miss),
		.prg_data(prg_data),
		.data_wren(data_wren0),
		.data_ren(data_ren0),
		.IO_wren(IO_wren0),
		.IO_ren(IO_ren0),
		.status_ren(status_ren),
		.address_select(address_select),
		.data_select(data_select),
		.IO_select(IO_select),
		.H_en(H_en0),
		.L_en(L_en0),
		.alu_op(alu_op),
		.I_field(I_field),
		.src_raddr(src_raddr),
		.dest_waddr(dest_waddr),
		.regf_wren(regf_wren),
		.pc_jmp(pc_jmp),
		.pc_brx(pc_brx),
		.pc_brxt(pc_brxt),
		.pc_call(pc_call),
		.pc_ret(pc_ret));

//##### HAZARD UNIT #####
hazard_unit hazard_inst(
		.pc_jmp(pc_jmp),
		.pc_brx(pc_brx),
		.pc_call(pc_call),
		.pc_ret1(pc_ret1),
		.interrupt(prev_interrupt),
		.take_brx1(take_brx1),
		.take_jmp1(take_jmp1),
		.alu_op1(alu_op1),
		.halt(halt),
		.extend_flush(extend_flush),
		.IO_select1(IO_select1), .IO_select2(IO_select2),
		.address_select1(address_select1), .address_select2(address_select2),
		.data_select1(data_select1), .data_select2(data_select2), 
		.IO_ren(IO_ren0),
		.IO_wren1(IO_wren1), .IO_wren2(IO_wren2),
		.data_ren(data_ren0),
		.data_wren1(data_wren1), .data_wren2(data_wren2),
		.status_ren(status_ren),
		.d_cache_read_miss(d_cache_read_miss),
		.d_cache_write_miss(d_cache_write_miss),
		.hazard(hazard),
		.branch_hazard(branch_hazard),
		.decoder_input_flush(decoder_input_flush),
		.decoder_output_flush(decoder_output_flush));
endmodule	//NeonFox
