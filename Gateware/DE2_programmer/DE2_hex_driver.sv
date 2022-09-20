module DE2_hex_driver(
		input logic clk,
		input logic[31:0] hex_data,
		output logic[6:0] hex_out0,
		output logic[6:0] hex_out1,
		output logic[6:0] hex_out2,
		output logic[6:0] hex_out3,
		output logic[6:0] hex_out4,
		output logic[6:0] hex_out5,
		output logic[6:0] hex_out6,
		output logic[6:0] hex_out7);
	
	wire[6:0] hex0_d;
	wire[6:0] hex1_d;
	wire[6:0] hex2_d;
	wire[6:0] hex3_d;
	wire[6:0] hex4_d;
	wire[6:0] hex5_d;
	wire[6:0] hex6_d;
	wire[6:0] hex7_d;
	
	reg[6:0] hex0_q;
	reg[6:0] hex1_q;
	reg[6:0] hex2_q;
	reg[6:0] hex3_q;
	reg[6:0] hex4_q;
	reg[6:0] hex5_q;
	reg[6:0] hex6_q;
	reg[6:0] hex7_q;
	
	assign hex_out0 = hex0_q;
	assign hex_out1 = hex1_q;
	assign hex_out2 = hex2_q;
	assign hex_out3 = hex3_q;
	assign hex_out4 = hex4_q;
	assign hex_out5 = hex5_q;
	assign hex_out6 = hex6_q;
	assign hex_out7 = hex7_q;
	
	hexdriver driver_inst0(.In(hex_data[3:0]), .Out(hex0_d));
	hexdriver driver_inst1(.In(hex_data[7:4]), .Out(hex1_d));
	hexdriver driver_inst2(.In(hex_data[11:8]), .Out(hex2_d));
	hexdriver driver_inst3(.In(hex_data[15:12]), .Out(hex3_d));
	hexdriver driver_inst4(.In(hex_data[19:16]), .Out(hex4_d));
	hexdriver driver_inst5(.In(hex_data[23:20]), .Out(hex5_d));
	hexdriver driver_inst6(.In(hex_data[27:24]), .Out(hex6_d));
	hexdriver driver_inst7(.In(hex_data[31:28]), .Out(hex7_d));
	
	always_ff @(posedge clk)
	begin
		hex0_q <= hex0_d;
		hex1_q <= hex1_d;
		hex2_q <= hex2_d;
		hex3_q <= hex3_d;
		hex4_q <= hex4_d;
		hex5_q <= hex5_d;
		hex6_q <= hex6_d;
		hex7_q <= hex7_d;
	end
endmodule

module hexdriver(input logic[3:0] In, output logic[6:0] Out);
	always_comb begin
		unique case (In)
			4'b0000   : Out = 7'b1000000; // '0'
			4'b0001   : Out = 7'b1111001; // '1'
			4'b0010   : Out = 7'b0100100; // '2'
			4'b0011   : Out = 7'b0110000; // '3'
			4'b0100   : Out = 7'b0011001; // '4'
			4'b0101   : Out = 7'b0010010; // '5'
			4'b0110   : Out = 7'b0000010; // '6'
			4'b0111   : Out = 7'b1111000; // '7'
			4'b1000   : Out = 7'b0000000; // '8'
			4'b1001   : Out = 7'b0010000; // '9'
			4'b1010   : Out = 7'b0001000; // 'A'
			4'b1011   : Out = 7'b0000011; // 'b'
			4'b1100   : Out = 7'b1000110; // 'C'
			4'b1101   : Out = 7'b0100001; // 'd'
			4'b1110   : Out = 7'b0000110; // 'E'
			4'b1111   : Out = 7'b0001110; // 'F'
		endcase
	end
endmodule
