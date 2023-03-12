module PC(
		input wire clk,
		input wire rst,
		input wire pc_jmp,
		input wire pc_brx,
		input wire pc_brxt,
		input wire pc_call,
		input wire pc_ret,
		input wire H_en,
		input wire L_en,
		input wire interrupt,
		input wire[3:0] int_addr,
		input wire hazard,
		input wire branch_hazard,
		input wire p_cache_miss,
		input wire[31:0] next_callx_addr,
		output wire[31:0] last_callx_addr,
		output wire update_last_callx,
		input wire[9:0] I_field,
		input wire n, z, p,
		output wire take_brx,
		output wire take_jmp,
		output wire decoder_flush_inhibit,
		output wire interrupt_inhibit,
		output wire[31:0] prg_address);
// PC sources:
	//PC + 1
	//brx
	//jmp, ret
	//int, A_miss_next
reg decoder_prev_hazard;
reg pc_hazard1;
reg pc_hazard2;
reg p_miss_override;	//during P miss, forces PC increment when hazard is cleared
reg p_miss;
reg prev_p_miss;
reg prev_branch_taken;
reg[31:0] A_miss, A_miss_next;
reg[31:0] A_next_I;
reg[31:0] PC_reg;
reg[31:0] A_current_I, A_current_I_alternate, A_pipe0;//, A_pipe1;
reg[31:0] A_return;
wire[31:0] stack_out;
wire[31:0] stack_in;
wire stack_en;
wire stack_push;
wire stack_pop;
reg delay_p_miss;	//used to determine if the instruction in the branch delay slot resulted in a miss
reg prev_delay_p_miss;
wire single_hazard;	//indicates that prev hazard was a single cycle hazard
wire branch_taken;
reg backtrack_enable;	//causes PC to be restored to A_miss_next on first cycle of p_miss
reg prev_interrupt;

assign take_brx = pc_brx & (pc_brxt ^ |({p, z, n, 1'b0} & (1 << {H_en, L_en}))) & ~branch_hazard;
assign take_jmp = (pc_jmp | pc_call) & ~branch_hazard;
assign stack_in = interrupt ? A_pipe0 : A_return;
assign stack_en = 1'b1;
assign stack_push = (pc_call & ~branch_hazard) | interrupt;
assign stack_pop = pc_ret & ~interrupt;
assign decoder_flush_inhibit = p_miss;
assign single_hazard = ~hazard & pc_hazard1 & ~pc_hazard2;
assign branch_taken = ((pc_jmp | pc_call) & ~branch_hazard) | take_brx | pc_ret;
assign interrupt_inhibit = prev_delay_p_miss | pc_jmp | pc_brx | pc_call | pc_ret;

assign last_callx_addr = stack_in;
assign update_last_callx = pc_jmp & (~branch_hazard) & (~interrupt);

call_stack cstack0(.rst(rst), .clk(clk), .en(stack_en), .push(stack_push), .pop(stack_pop), .data_in(stack_in), .data_out(stack_out));

always @(posedge clk)
begin
	if(~hazard)
		A_return <= PC_reg;
	A_next_I <= prg_address;
	if(~pc_hazard1)
	begin
		delay_p_miss <= p_miss;
		prev_delay_p_miss <= delay_p_miss;
	end
	prev_branch_taken <= branch_taken;
	backtrack_enable <= ~branch_taken & ~single_hazard & ~interrupt;	//p_miss_override will not trigger on single cycle hazards, so we don't want to backtrack in that case
	prev_interrupt <= interrupt;
end

always @(posedge clk or posedge rst)	//reset needs not be asynchronous, but doing this eliminates a mux and improves timing.
begin
	if(rst)
	begin
		decoder_prev_hazard <= 1'b0;
		pc_hazard1 <= 1'b0;
		pc_hazard2 <= 1'b0;
		p_miss_override <= 1'b0;
		p_miss <= 1'b0;
		prev_p_miss <= 1'b0;
		A_miss <= 32'h0000;
		A_miss_next <= 32'h0000;
		A_current_I_alternate <= 32'h0000;
		A_current_I <= 32'h0000;
		A_pipe0 <= 32'h0000;
	end
	else
	begin
		pc_hazard1 <= hazard;
		pc_hazard2 <= pc_hazard1;
		//p_miss override will not trigger on single cycle hazards because that would prevent backtracking and effectively do a double increment
		p_miss_override <= (hazard & pc_hazard1 & ~p_miss) | (p_miss_override & hazard);	//set if pc_hazard1 before p_miss, cleared when no hazard
		p_miss <= p_cache_miss;
		prev_p_miss <= p_miss;
		if(~p_miss | prev_branch_taken)
		begin
			A_miss_next <= PC_reg;
		end

		if(~p_miss | (prev_branch_taken & ~delay_p_miss) | prev_interrupt)	//check delay_p_miss to make sure the instruction after the branch has been fetched before changing address
		begin
			if((prev_branch_taken & ~delay_p_miss) | prev_interrupt)
				A_miss <= PC_reg;
			else
				A_miss <= A_miss_next;
		end

		if(~p_cache_miss)
		begin
			decoder_prev_hazard <= hazard;
		end
		if(hazard && ~decoder_prev_hazard)
			A_current_I_alternate <= A_next_I;
		if(~hazard)
		begin
			if(decoder_prev_hazard)
				A_current_I <= A_current_I_alternate;
			else
				A_current_I <= A_next_I;
			A_pipe0 <= A_current_I;
		end
		
		if(prev_branch_taken)	//assign new address to flushed instructions in case of interrupt.
		begin
			A_current_I_alternate <= PC_reg;
			A_current_I <= PC_reg;
			A_pipe0 <= PC_reg;	//TODO: does this change for delayed branches?
		end
	end
end

//mux priority:
// 0: interrupt
// 1: ((pc_jmp | pc_call) & ~branch_hazard)
// 2: pc_ret
// 3: take_brx
// 4: (~hazard & ~(p_miss & ~p_miss_override))
// 5: (p_miss & ~prev_p_miss & backtrack_enable)
//Note that mutual exclusivity between 4 and 5 is sacrificed to obtain a simpler expression for 5
always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
		PC_reg <= 16'h0000;
	end
	else if(interrupt | (p_miss & ~prev_p_miss & backtrack_enable) | ((pc_jmp | pc_call) & ~branch_hazard) | pc_ret | take_brx | (~hazard & ~(p_miss & ~p_miss_override)))
	begin
		if(interrupt | ((pc_jmp | pc_call) & ~branch_hazard) | pc_ret | ~(take_brx | (~hazard & ~(p_miss & ~p_miss_override))))
		begin
			if(interrupt | ~(((pc_jmp | pc_call) & ~branch_hazard) | pc_ret))
			begin
				if(interrupt)
				begin
					PC_reg <= {27'h0000000, int_addr, 1'b0};
				end
				else	//p_miss & ~prev_p_miss & backtrack_enable
				begin
					PC_reg <= A_miss_next;
				end
			end
			else	//((pc_jmp | pc_call) & ~branch_hazard) | pc_ret
			begin
				if((pc_jmp | pc_call) & ~branch_hazard)
				begin
					PC_reg <= next_callx_addr;
				end
				else	//pc_ret
				begin
					PC_reg <= stack_out;
				end
			end
		end
		else	//(take_brx) | (~hazard & ~(p_miss & ~p_miss_override))
		begin
			if(take_brx)
			begin
				PC_reg <= A_pipe0 + {{22{I_field[9]}}, I_field};
			end
			else	//(~hazard & ~(p_miss & ~p_miss_override))
			begin
				PC_reg <= PC_reg + 32'h01;
			end
		end
	end
end

assign prg_address = p_miss ? A_miss : PC_reg;
endmodule	//PC

module call_stack(input wire rst, clk, en, push, pop, input wire[31:0] data_in, output wire[31:0] data_out);
reg[3:0] address;
reg[31:0] input_buf;
reg[31:0] output_buf;
reg prev_push;
(* ramstyle = "logic" *) reg[31:0] stack_mem[15:0];

always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
		address <= 4'b0000;
	end
	else if(en & (push | pop))
	begin
		address <= address + {{3{pop}}, 1'b1};
	end
end

always @(posedge clk)
begin
	if(en)
	begin
		input_buf <= data_in;
		prev_push <= push;
		output_buf <= stack_mem[address];
		if(prev_push)
			stack_mem[address] <= input_buf;
	end
end
assign data_out = output_buf;
endmodule	//call_stack
