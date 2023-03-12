module decode_unit(
		input wire clk,
		input wire rst,
		input wire jmp_rst,
		input wire brx_rst,
		input wire input_flush,
		input wire output_flush,
		input wire hazard,
		input wire p_cache_miss,
		input wire[15:0] prg_data,
		output reg data_wren,
		output reg data_ren,
		output reg IO_wren,
		output reg IO_ren,
		output reg status_ren,
		output reg address_select,
		output reg data_select,
		output reg IO_select,
		output reg H_en,
		output reg L_en,
		output reg[3:0] alu_op,
		output reg[9:0] I_field,
		output reg[4:0] src_raddr,
		output reg[4:0] dest_waddr,
		output reg regf_wren,
		output reg pc_jmp,
		output reg pc_brx,
		output reg pc_brxt,
		output reg pc_call,
		output reg pc_ret);
		
	localparam ALU_ADD = 4'b0000;
	localparam ALU_ADDC = 4'b1000;
	localparam ALU_SUB = 4'b0001;
	localparam ALU_SUBC = 4'b1001;
	localparam ALU_MOVE = 4'b0010;
	localparam ALU_NOT = 4'b1010;
	localparam ALU_ROR = 4'b0011;
	localparam ALU_ROL = 4'b1011;
	localparam ALU_AND = 4'b0100;
	localparam ALU_XOR = 4'b0101;
	localparam ALU_OR = 4'b0110;
	//localparam ALU_LIM = 4'b1110;
	localparam ALU_NOP = 4'b0111;
	localparam ALU_BITT = 4'b1111;

	reg[15:0] I_reg;
	reg[15:0] I_alternate;
	reg prev_hazard;
	reg prev_p_cache_miss;

	always @(posedge clk)
	begin
		if(rst)
		begin
			prev_hazard <= 1'b0;
			prev_p_cache_miss <= 1'b0;
		end
		else
		begin
			prev_p_cache_miss <= p_cache_miss;
			if(~(p_cache_miss | prev_p_cache_miss) | (~hazard & prev_hazard))
				prev_hazard <= hazard;
		end
	
		if(rst | input_flush)
		begin
			I_reg <= 16'hC000;
			I_alternate <= 16'hC000;
		end
		else 
		begin
			if(hazard & (~prev_hazard))
				I_alternate <= prg_data;
			if(~hazard)
			begin
				if(prev_hazard)	//loads last valid instruction after hazard.
					I_reg <= I_alternate;
				else if(p_cache_miss | prev_p_cache_miss)
					I_reg <= 16'hC000;	//NOP
				else
					I_reg <= prg_data;
			end
		end
	end
	
	always @(posedge clk)
	begin
		if(~hazard | rst)
		begin
			if(rst)
			begin
				data_wren <= 1'b0;
				data_ren <= 1'b0;
				IO_wren <= 1'b0;
				IO_ren <= 1'b0;
				status_ren <= 1'b0;
				address_select <= 1'b0;
				data_select <= 1'b0;
				IO_select <= 1'b0;
				alu_op <= ALU_NOP;
				regf_wren <= 1'b0;
			end
			else
			begin
				if(output_flush)
				begin
					data_wren <= 1'b0;
					data_ren <= 1'b0;
					IO_wren <= 1'b0;
					IO_ren <= 1'b0;
					status_ren <= 1'b0;
					address_select <= 1'b0;
					data_select <= 1'b0;
					IO_select <= 1'b0;
					alu_op <= ALU_NOP;
					regf_wren <= 1'b0;
				end
				else
				begin
					I_field <= I_reg[9:0];
					H_en <= I_reg[11];
					L_en <= I_reg[10];
					src_raddr <= I_reg[9:5];
					pc_brxt <= I_reg[12];
					case(I_reg[15:12])
						4'h0:	//add
						begin
							data_wren <= (I_reg[4:0] == 5'h18);
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= (I_reg[4:0] == 5'h19);
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= (I_reg[4:0] == 5'h1A) | (I_reg[4:0] == 5'h1B);
							data_select <= (I_reg[4:0] == 5'h14) | (I_reg[4:0] == 5'h15);
							IO_select <= (I_reg[4:0] == 5'h16);
							alu_op <= ALU_ADD;
							dest_waddr <= I_reg[4:0];
							regf_wren <= 1'b1;
						end
						4'h1:	//addc
						begin
							data_wren <= (I_reg[4:0] == 5'h18);
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= (I_reg[4:0] == 5'h19);
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= (I_reg[4:0] == 5'h1A) | (I_reg[4:0] == 5'h1B);
							data_select <= (I_reg[4:0] == 5'h14) | (I_reg[4:0] == 5'h15);
							IO_select <= (I_reg[4:0] == 5'h16);
							alu_op <= ALU_ADDC;
							dest_waddr <= I_reg[4:0];
							regf_wren <= 1'b1;
						end
						4'h2:	//sub
						begin
							data_wren <= (I_reg[4:0] == 5'h18);
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= (I_reg[4:0] == 5'h19);
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= (I_reg[4:0] == 5'h1A) | (I_reg[4:0] == 5'h1B);
							data_select <= (I_reg[4:0] == 5'h14) | (I_reg[4:0] == 5'h15);
							IO_select <= (I_reg[4:0] == 5'h16);
							alu_op <= ALU_SUB;
							dest_waddr <= I_reg[4:0];
							regf_wren <= 1'b1;
						end
						4'h3:	//subc
						begin
							data_wren <= (I_reg[4:0] == 5'h18);
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= (I_reg[4:0] == 5'h19);
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= (I_reg[4:0] == 5'h1A) | (I_reg[4:0] == 5'h1B);
							data_select <= (I_reg[4:0] == 5'h14) | (I_reg[4:0] == 5'h15);
							IO_select <= (I_reg[4:0] == 5'h16);
							alu_op <= ALU_SUBC;
							dest_waddr <= I_reg[4:0];
							regf_wren <= 1'b1;
						end
						4'h4:	//move, test
						begin
							data_wren <= (I_reg[4:0] == 5'h18);
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= (I_reg[4:0] == 5'h19);
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= (I_reg[4:0] == 5'h1A) | (I_reg[4:0] == 5'h1B);
							data_select <= (I_reg[4:0] == 5'h14) | (I_reg[4:0] == 5'h15);
							IO_select <= (I_reg[4:0] == 5'h16);
							alu_op <= ALU_MOVE;
							dest_waddr <= I_reg[4:0];
							regf_wren <= 1'b1;
						end
						4'h5:	//not
						begin
							data_wren <= (I_reg[4:0] == 5'h18);
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= (I_reg[4:0] == 5'h19);
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= (I_reg[4:0] == 5'h1A) | (I_reg[4:0] == 5'h1B);
							data_select <= (I_reg[4:0] == 5'h14) | (I_reg[4:0] == 5'h15);
							IO_select <= (I_reg[4:0] == 5'h16);
							alu_op <= ALU_NOT;
							dest_waddr <= I_reg[4:0];
							regf_wren <= 1'b1;
						end
						4'h6:	//ror
						begin
							data_wren <= (I_reg[4:0] == 5'h18);
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= (I_reg[4:0] == 5'h19);
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= (I_reg[4:0] == 5'h1A) | (I_reg[4:0] == 5'h1B);
							data_select <= (I_reg[4:0] == 5'h14) | (I_reg[4:0] == 5'h15);
							IO_select <= (I_reg[4:0] == 5'h16);
							alu_op <= ALU_ROR;
							dest_waddr <= I_reg[4:0];
							regf_wren <= 1'b1;
						end
						4'h7:	//rol
						begin
							data_wren <= (I_reg[4:0] == 5'h18);
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= (I_reg[4:0] == 5'h19);
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= (I_reg[4:0] == 5'h1A) | (I_reg[4:0] == 5'h1B);
							data_select <= (I_reg[4:0] == 5'h14) | (I_reg[4:0] == 5'h15);
							IO_select <= (I_reg[4:0] == 5'h16);
							alu_op <= ALU_ROL;
							dest_waddr <= I_reg[4:0];
							regf_wren <= 1'b1;
						end
						4'h8:	//and
						begin
							data_wren <= (I_reg[4:0] == 5'h18);
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= (I_reg[4:0] == 5'h19);
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= (I_reg[4:0] == 5'h1A) | (I_reg[4:0] == 5'h1B);
							data_select <= (I_reg[4:0] == 5'h14) | (I_reg[4:0] == 5'h15);
							IO_select <= (I_reg[4:0] == 5'h16);
							alu_op <= ALU_AND;
							dest_waddr <= I_reg[4:0];
							regf_wren <= 1'b1;
						end
						4'h9:	//xor
						begin
							data_wren <= (I_reg[4:0] == 5'h18);
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= (I_reg[4:0] == 5'h19);
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= (I_reg[4:0] == 5'h1A) | (I_reg[4:0] == 5'h1B);
							data_select <= (I_reg[4:0] == 5'h14) | (I_reg[4:0] == 5'h15);
							IO_select <= (I_reg[4:0] == 5'h16);
							alu_op <= ALU_XOR;
							dest_waddr <= I_reg[4:0];
							regf_wren <= 1'b1;
						end
						4'ha:	//or
						begin
							data_wren <= (I_reg[4:0] == 5'h18);
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= (I_reg[4:0] == 5'h19);
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= (I_reg[4:0] == 5'h1A) | (I_reg[4:0] == 5'h1B);
							data_select <= (I_reg[4:0] == 5'h14) | (I_reg[4:0] == 5'h15);
							IO_select <= (I_reg[4:0] == 5'h16);
							alu_op <= ALU_OR;
							dest_waddr <= I_reg[4:0];
							regf_wren <= 1'b1;
						end
						4'hb:	//call, callx, calll, calllx, ret, retx, retl, retlx, jmp, jmpl
						begin
							data_wren <= 1'b0;
							data_ren <= 1'b0;
							IO_wren <= 1'b0;
							IO_ren <= 1'b0;
							status_ren <= 1'b0;
							address_select <= 1'b0;
							data_select <= 1'b0;
							IO_select <= 1'b0;
							alu_op <= ALU_NOP;
							dest_waddr <= 5'h11;	//AUX1
							regf_wren <= |I_reg[11:10];
						end
						4'hc:	//nop, brn, brz, brp
						begin
							data_wren <= 1'b0;
							data_ren <= 1'b0;
							IO_wren <= 1'b0;
							IO_ren <= 1'b0;
							status_ren <= 1'b0;
							address_select <= 1'b0;
							data_select <= 1'b0;
							IO_select <= 1'b0;
							alu_op <= ALU_NOP;
							dest_waddr <= 5'hxx;
							regf_wren <= 1'b0;
						end
						4'hd:	//bra, brnn, brnz, brnp
						begin
							data_wren <= 1'b0;
							data_ren <= 1'b0;
							IO_wren <= 1'b0;
							IO_ren <= 1'b0;
							status_ren <= 1'b0;
							address_select <= 1'b0;
							data_select <= 1'b0;
							IO_select <= 1'b0;
							alu_op <= ALU_NOP;
							dest_waddr <= 5'hxx;
							regf_wren <= 1'b0;
						end
						4'he:	//lim
						begin
							data_wren <= 1'b0;
							data_ren <= 1'b0;
							IO_wren <= 1'b0;
							IO_ren <= 1'b0;
							status_ren <= 1'b0;
							address_select <= 1'b0;
							data_select <= 1'b0;
							IO_select <= 1'b0;
							alu_op <= ALU_NOP;
							dest_waddr <= {3'b100, I_reg[9:8]};
							regf_wren <= 1'b1;
						end
						4'hf:	//bitt
						begin
							data_wren <= 1'b0;
							data_ren <= (I_reg[9:5] == 5'h18);
							IO_wren <= 1'b0;
							IO_ren <= (I_reg[9:5] == 5'h19);
							status_ren <= (I_reg[9:5] == 5'h1E);
							address_select <= 1'b0;
							data_select <= 1'b0;
							IO_select <= 1'b0;
							alu_op <= ALU_BITT;
							dest_waddr <= 5'hxx;
							regf_wren <= 1'b0;
						end
					endcase
				end
			end
		end
	end
	
	always @(posedge clk)
	begin
		if(~hazard | rst | jmp_rst)
		begin
			if(rst | jmp_rst)
			begin
				pc_jmp <= 1'b0;
				pc_call <= 1'b0;
			end
			else
			begin
				if(output_flush)
				begin
					pc_jmp <= 1'b0;
					pc_call <= 1'b0;
				end
				else
				begin
					case(I_reg[15:12])
						4'h0:	//add
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'h1:	//addc
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'h2:	//sub
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'h3:	//subc
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'h4:	//move, test
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'h5:	//not
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'h6:	//ror
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'h7:	//rol
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'h8:	//and
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'h9:	//xor
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'ha:	//or
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'hb:	//call, callx, calll, calllx, ret, retx, retl, retlx, jmp, jmpl
						begin
							pc_jmp <= I_reg[8];
							pc_call <= ~I_reg[8] & ~I_reg[9];
						end
						4'hc:	//nop, brn, brz, brp
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'hd:	//bra, brnn, brnz, brnp
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'he:	//lim
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
						4'hf:	//bitt
						begin
							pc_jmp <= 1'b0;
							pc_call <= 1'b0;
						end
					endcase
				end
			end
		end
	end
	
	always @(posedge clk)
	begin
		if(~hazard | rst | brx_rst)
		begin
			if(rst | brx_rst)
			begin
				pc_brx <= 1'b0;
			end
			else
			begin
				if(output_flush)
				begin
					pc_brx <= 1'b0;
				end
				else
				begin
					case(I_reg[15:12])
						4'h0:	//add
						begin
							pc_brx <= 1'b0;
						end
						4'h1:	//addc
						begin
							pc_brx <= 1'b0;
						end
						4'h2:	//sub
						begin
							pc_brx <= 1'b0;
						end
						4'h3:	//subc
						begin
							pc_brx <= 1'b0;
						end
						4'h4:	//move, test
						begin
							pc_brx <= 1'b0;
						end
						4'h5:	//not
						begin
							pc_brx <= 1'b0;
						end
						4'h6:	//ror
						begin
							pc_brx <= 1'b0;
						end
						4'h7:	//rol
						begin
							pc_brx <= 1'b0;
						end
						4'h8:	//and
						begin
							pc_brx <= 1'b0;
						end
						4'h9:	//xor
						begin
							pc_brx <= 1'b0;
						end
						4'ha:	//or
						begin
							pc_brx <= 1'b0;
						end
						4'hb:	//call, callx, calll, calllx, ret, retx, retl, retlx, jmp, jmpl
						begin
							pc_brx <= 1'b0;
						end
						4'hc:	//nop, brn, brz, brp
						begin
							pc_brx <= |I_reg[11:10];	//no brx for nop
						end
						4'hd:	//bra, brnn, brnz, brnp
						begin
							pc_brx <= 1'b1;
						end
						4'he:	//lim
						begin
							pc_brx <= 1'b0;
						end
						4'hf:	//bitt
						begin
							pc_brx <= 1'b0;
						end
					endcase
				end
			end
		end
	end
	
	always @(posedge clk)
	begin
		if(~hazard | rst | pc_ret)
		begin
			if(rst | pc_ret)
			begin
				pc_ret <= 1'b0;
			end
			else
			begin
				if(output_flush)
				begin
					pc_ret <= 1'b0;
				end
				else
				begin
					case(I_reg[15:12])
						4'h0:	//add
						begin
							pc_ret <= 1'b0;
						end
						4'h1:	//addc
						begin
							pc_ret <= 1'b0;
						end
						4'h2:	//sub
						begin
							pc_ret <= 1'b0;
						end
						4'h3:	//subc
						begin
							pc_ret <= 1'b0;
						end
						4'h4:	//move, test
						begin
							pc_ret <= 1'b0;
						end
						4'h5:	//not
						begin
							pc_ret <= 1'b0;
						end
						4'h6:	//ror
						begin
							pc_ret <= 1'b0;
						end
						4'h7:	//rol
						begin
							pc_ret <= 1'b0;
						end
						4'h8:	//and
						begin
							pc_ret <= 1'b0;
						end
						4'h9:	//xor
						begin
							pc_ret <= 1'b0;
						end
						4'ha:	//or
						begin
							pc_ret <= 1'b0;
						end
						4'hb:	//call, callx, calll, calllx, ret, retx, retl, retlx, jmp, jmpl
						begin
							pc_ret <= ~I_reg[8] & I_reg[9];
						end
						4'hc:	//nop, brn, brz, brp
						begin
							pc_ret <= 1'b0;
						end
						4'hd:	//bra, brnn, brnz, brnp
						begin
							pc_ret <= 1'b0;
						end
						4'he:	//lim
						begin
							pc_ret <= 1'b0;
						end
						4'hf:	//bitt
						begin
							pc_ret <= 1'b0;
						end
					endcase
				end
			end
		end
	end

endmodule	//decode_unit
