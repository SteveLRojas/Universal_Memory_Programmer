module interrupt_controller(
		input wire clk,
		input wire rst,
		input wire ce,
		input wire wren,
		input wire in0, in1, in2, in3, in4, in5, in6, in7,
		input wire in8, in9, in10, in11, in12, in13, in14, in15,
		input wire ri_addr,
		input wire[15:0] from_cpu,
		output reg[15:0] to_cpu,
		output reg[3:0] int_addr,
		output reg int_rq);
		
	reg[3:0] timer;
	reg[15:0] status;
	reg[15:0] control;
	reg[15:0] prev_in;
	
	wire[15:0] in;		//requests in
	wire[15:0] trig;	//interrupt trigger pulses
	wire[15:0] interrupt;
	wire suspend;

	assign in = {in15, in14, in13, in12, in11, in10, in9, in8, in7, in6, in5, in4, in3, in2, in1, in0};
	assign trig = in & ~prev_in;
	assign interrupt = control & status;
	assign suspend = |timer;

always @(posedge clk)
begin
	if(rst)
	begin
		status <= 16'h0000;
		control <= 16'h0000;
		prev_in <= 16'hffff;
		timer <= 4'h0;
	end
	else
	begin
		prev_in <= in;
		
		if(suspend)
			timer <= timer - 4'h1;
			
		if(ce & wren & ri_addr)
			control <= from_cpu;
		if(ce & wren & ~ri_addr)
		begin
			status <= status & from_cpu;
			timer <= 4'hf;
		end
		else
			status <= status | trig;
			
		if(ce)
		begin
			if(ri_addr)
				to_cpu <= control;
			else
				to_cpu <= status;
		end
		
		int_rq <= ~suspend & (|interrupt);
		if(|interrupt[7:0])
		begin
			if(|interrupt[3:0])
			begin
				if(interrupt[0])
					int_addr <= 4'h0;
				else if(interrupt[1])
					int_addr <= 4'h1;
				else if(interrupt[2])
					int_addr <= 4'h2;
				else
					int_addr <= 4'h3;
			end
			else	// |interrupt[7:4]
			begin
				if(interrupt[4])
					int_addr <= 4'h4;
				else if(interrupt[5])
					int_addr <= 4'h5;
				else if(interrupt[6])
					int_addr <= 4'h6;
				else
					int_addr <= 4'h7;
			end
		end
		else	// |interrupt[15:8]
		begin
			if(|interrupt[11:8])
			begin
				if(interrupt[8])
					int_addr <= 4'h8;
				else if(interrupt[9])
					int_addr <= 4'h9;
				else if(interrupt[10])
					int_addr <= 4'hA;
				else
					int_addr <= 4'hB;
			end
			else	// |interrupt[15:12]
			begin
				if(interrupt[12])
					int_addr <= 4'hC;
				else if(interrupt[13])
					int_addr <= 4'hD;
				else if(interrupt[14])
					int_addr <= 4'hE;
				else
					int_addr <= 4'hF;
			end
		end
	end
end

endmodule
