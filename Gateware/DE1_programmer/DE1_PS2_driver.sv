module DE1_PS2_driver(
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
