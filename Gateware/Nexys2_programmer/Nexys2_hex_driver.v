`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:28:33 06/09/2022 
// Design Name: 
// Module Name:    Nexys2_hex_driver 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Nexys2_hex_driver(
		input wire clk, 
		input wire[3:0] seg0,
		input wire[3:0] seg1,
		input wire[3:0] seg2,
		input wire[3:0] seg3,
		input wire[3:0] dp,
		output reg[3:0] seg_sel,
		output reg[7:0] hex_out
	);

	wire[1:0] count;
	wire[6:0] hex0, hex1, hex2, hex3;
	reg[3:0] seg0_s, seg1_s, seg2_s, seg3_s;
	reg[3:0] dp_s;

	always @(posedge clk)
	begin
		seg0_s <= seg0;
		seg1_s <= seg1;
		seg2_s <= seg2;
		seg3_s <= seg3;
		dp_s <= dp;
	end

	hexdriver hex_inst_0(.clk(clk), .In(seg0_s), .Out(hex0));
	hexdriver hex_inst_1(.clk(clk), .In(seg1_s), .Out(hex1));
	hexdriver hex_inst_2(.clk(clk), .In(seg2_s), .Out(hex2));
	hexdriver hex_inst_3(.clk(clk), .In(seg3_s), .Out(hex3));
	frame_clk frame_clk_inst(.clk(clk), .seg_count(count));

	always @(posedge clk)
	begin
		case(count)
		2'b00: seg_sel <= ~4'b0001;
		2'b01: seg_sel <= ~4'b0010;
		2'b10: seg_sel <= ~4'b0100;
		2'b11: seg_sel <= ~4'b1000;
		endcase
		
		case(count)
		2'b00: hex_out <= {~dp_s[3], hex3};
		2'b01: hex_out <= {~dp_s[2], hex2};
		2'b10: hex_out <= {~dp_s[1], hex1};
		2'b11: hex_out <= {~dp_s[0], hex0};
		endcase
	end
endmodule	//Nexys2_hex_driver
		
module hexdriver(
		input wire clk,
		input wire[3:0] In,
		output reg[6:0] Out);
		
	always @(posedge clk)
	begin
		case (In)
			4'b0000: Out <= 7'b1000000; // '0'
			4'b0001: Out <= 7'b1111001; // '1'
			4'b0010: Out <= 7'b0100100; // '2'
			4'b0011: Out <= 7'b0110000; // '3'
			4'b0100: Out <= 7'b0011001; // '4'
			4'b0101: Out <= 7'b0010010; // '5'
			4'b0110: Out <= 7'b0000010; // '6'
			4'b0111: Out <= 7'b1111000; // '7'
			4'b1000: Out <= 7'b0000000; // '8'
			4'b1001: Out <= 7'b0010000; // '9'
			4'b1010: Out <= 7'b0001000; // 'A'
			4'b1011: Out <= 7'b0000011; // 'b'
			4'b1100: Out <= 7'b1000110; // 'C'
			4'b1101: Out <= 7'b0100001; // 'd'
			4'b1110: Out <= 7'b0000110; // 'E'
			4'b1111: Out <= 7'b0001110; // 'F'
		endcase
	end
endmodule	//hexdriver

module frame_clk(
		input wire clk,
		output wire[1:0] seg_count);
		
	reg [17:0] count;
	always @(posedge clk)
	begin
		count <= count + 18'h01;
	end
	assign seg_count = count[17:16];
	
endmodule	//frame_clk
