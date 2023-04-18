module button_debounce(
		input wire clk,
		input wire[3:0] button_in,
		output reg rst,
		output reg[3:0] button_out
	);
	
	reg[14:0] clk_div;	//25MHz
	//reg[11:0] clk_div;	//4MHz
	reg rst_s;
	reg button_disable;
	reg[3:0] button_count[3:0];
	reg[3:0] button_s;
	
	wire sample_pulse;
	wire button_max[3:0];
	wire button_min[3:0];
	
	assign sample_pulse = &clk_div;
	
	assign button_max[0] = &button_count[0];
	assign button_max[1] = &button_count[1];
	assign button_max[2] = &button_count[2];
	assign button_max[3] = &button_count[3];
	
	assign button_min[0] = ~|button_count[0];
	assign button_min[1] = ~|button_count[1];
	assign button_min[2] = ~|button_count[2];
	assign button_min[3] = ~|button_count[3];
	
	initial
	begin
		rst_s = 1'b1;
		rst = 1'b0;	//have rising edge at power on
	end
	
	always @(posedge clk)
	begin
		button_s <= button_in;
		rst_s <= &button_s;
		rst <= rst_s;
	end
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			clk_div <= 15'h0000;
			//clk_div <= 12'h000;
			button_disable <= 1'b1;
			button_count[0] <= 4'h0;
			button_count[1] <= 4'h0;
			button_count[2] <= 4'h0;
			button_count[3] <= 4'h0;
			button_out <= 4'h0;
		end
		else
		begin
			clk_div <= clk_div + 15'h0001;
			//clk_div <= clk_div + 12'h001;
			button_disable <= button_disable & |button_s;
			
			if(sample_pulse & ~button_disable)
			begin
				if(button_s[0] & ~button_max[0])
				begin
					button_count[0] <= button_count[0] + 4'h1;
				end
				if(~button_s[0] & ~button_min[0])
				begin
					button_count[0] <= button_count[0] - 4'h1;
				end
				
				if(button_s[1] & ~button_max[1])
				begin
					button_count[1] <= button_count[1] + 4'h1;
				end
				if(~button_s[1] & ~button_min[1])
				begin
					button_count[1] <= button_count[1] - 4'h1;
				end
				
				if(button_s[2] & ~button_max[2])
				begin
					button_count[2] <= button_count[2] + 4'h1;
				end
				if(~button_s[2] & ~button_min[2])
				begin
					button_count[2] <= button_count[2] - 4'h1;
				end
				
				if(button_s[3] & ~button_max[3])
				begin
					button_count[3] <= button_count[3] + 4'h1;
				end
				if(~button_s[3] & ~button_min[3])
				begin
					button_count[3] <= button_count[3] - 4'h1;
				end
				
				if(button_max[0])
					button_out[0] <= 1'b1;
				if(button_min[0])
					button_out[0] <= 1'b0;
					
				if(button_max[1])
					button_out[1] <= 1'b1;
				if(button_min[1])
					button_out[1] <= 1'b0;
					
				if(button_max[2])
					button_out[2] <= 1'b1;
				if(button_min[2])
					button_out[2] <= 1'b0;
				
				if(button_max[3])
					button_out[3] <= 1'b1;
				if(button_min[3])
					button_out[3] <= 1'b0;
			end
		end
	end

endmodule
