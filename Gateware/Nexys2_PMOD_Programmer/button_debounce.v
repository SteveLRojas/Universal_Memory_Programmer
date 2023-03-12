module button_debounce(input wire clk, rst, input wire[3:0] button_in, output reg[3:0] button_out);
	reg[15:0] clk_div;
	reg[3:0] button_0_count;
	reg[3:0] button_1_count;
	reg[3:0] button_2_count;
	reg[3:0] button_3_count;
	reg[3:0] button_s;
	
	wire sample_pulse;
	
	wire button_0_max;
	wire button_1_max;
	wire button_2_max;
	wire button_3_max;
	
	wire button_0_min;
	wire button_1_min;
	wire button_2_min;
	wire button_3_min;
	
	assign sample_pulse = &clk_div;
	
	assign button_0_max = &button_0_count;
	assign button_1_max = &button_1_count;
	assign button_2_max = &button_2_count;
	assign button_3_max = &button_3_count;
	
	assign button_0_min = ~|button_0_count;
	assign button_1_min = ~|button_1_count;
	assign button_2_min = ~|button_2_count;
	assign button_3_min = ~|button_3_count;
	
	always @(posedge clk)
	begin
		button_s <= button_in;
	end
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			clk_div <= 16'h00;
			button_0_count <= 4'h0;
			button_1_count <= 4'h0;
			button_2_count <= 4'h0;
			button_3_count <= 4'h0;
			button_out <= 4'h0;
		end
		else
		begin
			clk_div <= clk_div + 16'h01;
			
			if(sample_pulse)
			begin
				if(button_s[0] & ~button_0_max)
				begin
					button_0_count <= button_0_count + 4'h1;
				end
				if(~button_s[0] & ~button_0_min)
				begin
					button_0_count <= button_0_count - 4'h1;
				end
				
				if(button_s[1] & ~button_1_max)
				begin
					button_1_count <= button_1_count + 4'h1;
				end
				if(~button_s[1] & ~button_1_min)
				begin
					button_1_count <= button_1_count - 4'h1;
				end
				
				if(button_s[2] & ~button_2_max)
				begin
					button_2_count <= button_2_count + 4'h1;
				end
				if(~button_s[2] & ~button_2_min)
				begin
					button_2_count <= button_2_count - 4'h1;
				end
				
				if(button_s[3] & ~button_3_max)
				begin
					button_3_count <= button_3_count + 4'h1;
				end
				if(~button_s[3] & ~button_3_min)
				begin
					button_3_count <= button_3_count - 4'h1;
				end
				
				if(button_0_max)
					button_out[0] <= 1'b1;
				if(button_0_min)
					button_out[0] <= 1'b0;
					
				if(button_1_max)
					button_out[1] <= 1'b1;
				if(button_1_min)
					button_out[1] <= 1'b0;
					
				if(button_2_max)
					button_out[2] <= 1'b1;
				if(button_2_min)
					button_out[2] <= 1'b0;
				
				if(button_3_max)
					button_out[3] <= 1'b1;
				if(button_3_min)
					button_out[3] <= 1'b0;
			end
		end
	end

endmodule
