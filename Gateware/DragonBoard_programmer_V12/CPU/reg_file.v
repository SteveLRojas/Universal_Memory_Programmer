module reg_file(
		input wire clk,
		input wire data_hazard,
		input wire wren,
		input wire h_en,
		input wire l_en,
		input wire data_select,
		input wire IO_select,
		input wire[4:0] a_address,
		input wire[4:0] w_address,
		input wire[15:0] w_data,
		output reg[15:0] a_data,
		output reg[15:0] b_data,
		input wire IO_ren,
		input wire data_ren,
		//output logic[15:0] DIO_out,
		input wire[15:0] DIO_in,
		input wire[31:0] last_callx_addr,
		output reg[31:0] next_callx_addr,
		input wire update_last_callx,
		input wire n, z, p, c,
		output reg[31:0] data_address,
		output reg[15:0] IO_address);
reg[4:0] prev_w_address;
reg[4:0] prev_a_address;
reg[15:0] prev_w_data;
reg prev_wren;
reg prev_h_en;
reg prev_l_en;
reg[15:0] a_reg;

reg[15:0] r0, r1, r2, r3;
reg[15:0] r4, r5, r6, r7;
reg[15:0] r8, r9, r10, r11;
reg[15:0] r12, r13, r14, r15;
reg[15:0] aux0, aux1, aux2, aux3;
reg[15:0] dal, dah, ial;
reg[15:0] cal, cah;
reg[15:0] ral, rah;
//reg[15:0] status;
//reg[15:0] control;

wire high_enable;
wire low_enable;

wire bh_forward;
wire bl_forward;
wire ah_forward0;
wire al_forward0;
wire ah_forward1;
wire al_forward1;

reg dio_read;
wire data_select_high;
wire data_select_low;

assign high_enable = (h_en | ~l_en);
assign low_enable = (~h_en | l_en);

assign bh_forward = (w_address == 5'h10) & wren & high_enable;
assign bl_forward = (w_address == 5'h10) & wren & low_enable;

assign ah_forward0 = (w_address == prev_a_address) & wren & high_enable;
assign al_forward0 = (w_address == prev_a_address) & wren & low_enable;
assign ah_forward1 = (prev_w_address == prev_a_address) & prev_wren & (prev_h_en | ~prev_l_en);
assign al_forward1 = (prev_w_address == prev_a_address) & prev_wren & (~prev_h_en | prev_l_en);

//assign dio_read = (a_address == 5'h18) | (a_address == 5'h19);
assign data_select_high = data_select & w_address[0];
assign data_select_low = data_select & ~w_address[0];

initial
begin
	dah = 16'h0000;
	dal = 16'h0000;
end

always @(posedge clk)
begin
	//write logic
	if(~data_hazard)
	begin
		prev_w_address <= w_address;
		prev_a_address <= a_address;
		prev_w_data <= w_data;
		prev_wren <= wren;
		prev_h_en <= h_en;
		prev_l_en <= l_en;
		dio_read <= IO_ren | data_ren;
		if(wren & high_enable)
		begin
			case(w_address)
				5'h00: r0[15:8] <= w_data[15:8];
				5'h01: r1[15:8] <= w_data[15:8];
				5'h02: r2[15:8] <= w_data[15:8];
				5'h03: r3[15:8] <= w_data[15:8];
				5'h04: r4[15:8] <= w_data[15:8];
				5'h05: r5[15:8] <= w_data[15:8];
				5'h06: r6[15:8] <= w_data[15:8];
				5'h07: r7[15:8] <= w_data[15:8];
				5'h08: r8[15:8] <= w_data[15:8];
				5'h09: r9[15:8] <= w_data[15:8];
				5'h0A: r10[15:8] <= w_data[15:8];
				5'h0B: r11[15:8] <= w_data[15:8];
				5'h0C: r12[15:8] <= w_data[15:8];
				5'h0D: r13[15:8] <= w_data[15:8];
				5'h0E: r14[15:8] <= w_data[15:8];
				5'h0F: r15[15:8] <= w_data[15:8];
				5'h10: aux0[15:8] <= w_data[15:8];
				5'h11: aux1[15:8] <= w_data[15:8];
				5'h12: aux2[15:8] <= w_data[15:8];
				5'h13: aux3[15:8] <= w_data[15:8];
				5'h14: dal[15:8] <= w_data[15:8];
				5'h15: dah[15:8] <= w_data[15:8];
				5'h16: ial[15:8] <= w_data[15:8];
				5'h17: ;	//reserved
				5'h18: ;	//dd
				5'h19: ;	//id
				5'h1A: cal[15:8] <= w_data[15:8];	//cal
				5'h1B: cah[15:8] <= w_data[15:8];	//cah
				5'h1C: ral[15:8] <= w_data[15:8];
				5'h1D: rah[15:8] <= w_data[15:8];
				5'h1E: ;	//status
				5'h1F: ;	//control
			endcase
		end
		if(wren & low_enable)
		begin
			case(w_address)
				5'h00: r0[7:0] <= w_data[7:0];
				5'h01: r1[7:0] <= w_data[7:0];
				5'h02: r2[7:0] <= w_data[7:0];
				5'h03: r3[7:0] <= w_data[7:0];
				5'h04: r4[7:0] <= w_data[7:0];
				5'h05: r5[7:0] <= w_data[7:0];
				5'h06: r6[7:0] <= w_data[7:0];
				5'h07: r7[7:0] <= w_data[7:0];
				5'h08: r8[7:0] <= w_data[7:0];
				5'h09: r9[7:0] <= w_data[7:0];
				5'h0A: r10[7:0] <= w_data[7:0];
				5'h0B: r11[7:0] <= w_data[7:0];
				5'h0C: r12[7:0] <= w_data[7:0];
				5'h0D: r13[7:0] <= w_data[7:0];
				5'h0E: r14[7:0] <= w_data[7:0];
				5'h0F: r15[7:0] <= w_data[7:0];
				5'h10: aux0[7:0] <= w_data[7:0];
				5'h11: aux1[7:0] <= w_data[7:0];
				5'h12: aux2[7:0] <= w_data[7:0];
				5'h13: aux3[7:0] <= w_data[7:0];
				5'h14: dal[7:0] <= w_data[7:0];
				5'h15: dah[7:0] <= w_data[7:0];
				5'h16: ial[7:0] <= w_data[7:0];
				5'h17: ;	//reserved
				5'h18: ; //dd
				5'h19: ; //id
				5'h1A: cal[7:0] <= w_data[7:0];
				5'h1B: cah[7:0] <= w_data[7:0];
				5'h1C: ral[7:0] <= w_data[7:0];
				5'h1D: rah[7:0] <= w_data[7:0];
				5'h1E: ;	//status
				5'h1F: ;	//control
			endcase
		end
		//read logic
		case(a_address)
			5'h00: a_reg <= r0;
			5'h01: a_reg <= r1;
			5'h02: a_reg <= r2;
			5'h03: a_reg <= r3;
			5'h04: a_reg <= r4;
			5'h05: a_reg <= r5;
			5'h06: a_reg <= r6;
			5'h07: a_reg <= r7;
			5'h08: a_reg <= r8;
			5'h09: a_reg <= r9;
			5'h0A: a_reg <= r10;
			5'h0B: a_reg <= r11;
			5'h0C: a_reg <= r12;
			5'h0D: a_reg <= r13;
			5'h0E: a_reg <= r14;
			5'h0F: a_reg <= r15;
			5'h10: a_reg <= aux0;
			5'h11: a_reg <= aux1;
			5'h12: a_reg <= aux2;
			5'h13: a_reg <= aux3;
			5'h14: a_reg <= dal;
			5'h15: a_reg <= dah;
			5'h16: a_reg <= ial;
			5'h17: a_reg <= 16'hxxxx;	//reserved
			5'h18: a_reg <= 16'hxxxx;	//dd
			5'h19: a_reg <= 16'hxxxx;	//id
			5'h1A: a_reg <= cal;
			5'h1B: a_reg <= cah;
			5'h1C: a_reg <= ral;
			5'h1D: a_reg <= rah;
			5'h1E: a_reg <= {12'h000, c, p, z, n};
			5'h1F: a_reg <= 16'h0000;	//zero
		endcase
	end
	if(update_last_callx)
	begin
		ral <= last_callx_addr[15:0];
		rah <= last_callx_addr[31:16];
	end
end

always @(*)
begin
	if(~dio_read & (ah_forward0 | ah_forward1))
	begin
		if(ah_forward0)
		begin
			a_data[15:8] = w_data[15:8];
		end
		else
		begin
			a_data[15:8] = prev_w_data[15:8];
		end
	end
	else
	begin
		if(dio_read)
		begin
			a_data[15:8] = DIO_in[15:8];
		end
		else
		begin
			a_data[15:8] = a_reg[15:8];
		end
	end
	if(~dio_read & (al_forward0 | al_forward1))
	begin
		if(al_forward0)
		begin
			a_data[7:0] = w_data[7:0];
		end
		else
		begin
			a_data[7:0] = prev_w_data[7:0];
		end
	end
	else
	begin
		if(dio_read)
		begin
			a_data[7:0] = DIO_in[7:0];
		end
		else
		begin
			a_data[7:0] = a_reg[7:0];
		end
	end
	
	if(bh_forward)
		b_data[15:8] = w_data[15:8];
	else
		b_data[15:8] = aux0[15:8];
	if(bl_forward)
		b_data[7:0] = w_data[7:0];
	else
		b_data[7:0] = aux0[7:0];
	
	
	if(data_select_high & high_enable)
		data_address[31:24] = w_data[15:8];
	else
		data_address[31:24] = dah[15:8];
		
	if(data_select_high & low_enable)
		data_address[23:16] = w_data[7:0];
	else
		data_address[23:16] = dah[7:0];
		
	if(data_select_low & high_enable)
		data_address[15:8] = w_data[15:8];
	else
		data_address[15:8] = dal[15:8];
		
	if(data_select_low & low_enable)
		data_address[7:0] = w_data[7:0];
	else
		data_address[7:0] = dal[7:0];
		
		
	if(IO_select & high_enable)
		IO_address[15:8] = w_data[15:8];
	else
		IO_address[15:8] = ial[15:8];
	if(IO_select & low_enable)
		IO_address[7:0] = w_data[7:0];
	else
		IO_address[7:0] = ial[7:0];
	
	next_callx_addr = {cah, cal};
end
endmodule	//reg_file