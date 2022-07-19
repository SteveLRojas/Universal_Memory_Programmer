`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:37:16 06/10/2022 
// Design Name: 
// Module Name:    Nexys2_PS2_driver 
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
module Nexys2_PS2_driver(
		input wire clk,
		output reg ps2_data_d,
		output reg ps2_clk_d,
		input wire ps2_data_q,
		input wire ps2_clk_q,
		inout wire ps2_data,
		inout wire ps2_clk);
		
	reg ps2_data_q_s;
	reg ps2_clk_q_s;
	
	assign ps2_data = ps2_data_q_s ? 1'b0 : 1'bz;
	assign ps2_clk = ps2_clk_q_s ? 1'b0 : 1'bz;
	
	always @(posedge clk)
	begin
		ps2_data_q_s <= ps2_data_q;
		ps2_clk_q_s <= ps2_clk_q;
		ps2_data_d <= ps2_data;
		ps2_clk_d <= ps2_clk;
	end

endmodule
