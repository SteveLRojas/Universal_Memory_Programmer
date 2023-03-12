module timer(
		input wire clk,
		input wire rst,
		input wire ce,
		input wire wren,
		input wire hsync,
		input wire vsync,
		output wire timer_int,
		input wire[1:0] addr,
		input wire[7:0] from_cpu,
		output reg[7:0] to_cpu);
//NOTE: the hsync and vsync inputs are active low.
reg[23:0] counter;
wire[5:0] status;
wire[2:0] count_nz;
reg count_active;

assign count_nz = {|counter[23:16], |counter[15:8], |counter[7:0]};
assign status = {~hsync, ~vsync, |count_nz, count_nz};
assign timer_int = count_active & ~(|count_nz);

always @(posedge clk)
begin
	if(rst)
	begin
		counter <= 24'h00;
		count_active <= 1'b0;
	end
	else
	begin
		if(count_active & (|count_nz))
		begin
			counter <= counter - 24'h01;
		end
		if(~(|count_nz))
		begin
			count_active <= 1'b0;
		end
		if(ce)
		begin
			if(wren)
			begin
				case(addr)
				2'h0:
				begin
					counter[7:0] <= from_cpu;	//start counting when byte 0 is written
					count_active <= 1'b1;
				end
				2'h1: counter[15:8] <= from_cpu;
				2'h2: counter[23:16] <= from_cpu;
				2'h3: count_active <= 1'b0;	//stop counting if address 3 is written
				endcase
			end
			//if(ren)
			//begin
				case(addr)
				2'h0: to_cpu <= counter[7:0];
				2'h1: to_cpu <= counter[15:8];
				2'h2: to_cpu <= counter[23:16];
				2'h3: to_cpu <= {2'b00, status};
				endcase
			//end
		end
	end
end
endmodule
