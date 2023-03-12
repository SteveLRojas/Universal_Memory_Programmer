module hazard_unit(
		input wire pc_jmp,
		input wire pc_brx,
		input wire pc_call,
		input wire pc_ret1,
		input wire interrupt,
		input wire take_brx1,
		input wire take_jmp1,
		input wire[3:0] alu_op1,
		input wire halt,
		input wire extend_flush,
		input wire IO_select1, IO_select2,
		input wire address_select1, address_select2,
		input wire data_select1, data_select2, 
		input wire IO_ren,
		input wire IO_wren1, IO_wren2,
		input wire data_ren,
		input wire data_wren1, data_wren2,
		input wire status_ren,
		input wire d_cache_read_miss,
		input wire d_cache_write_miss,
		output wire hazard,
		output wire branch_hazard,
		output wire decoder_input_flush,
		output wire decoder_output_flush);
		
wire status_hazard;
wire IO_hazard, IO_hazard1, IO_hazard2;
wire data_hazard_read1, data_hazard_read2;
wire data_hazard_read;
wire branch_hazard_ca;
wire branch_hazard_nzp;

assign status_hazard = (alu_op1 != 4'b0111) & status_ren;
assign branch_hazard_nzp = (alu_op1 != 4'b0111) & pc_brx;	//recent write to nzp and brx
assign branch_hazard_ca = (address_select1 | address_select2) & (pc_call | pc_jmp);	//call or jump after writing call address
assign branch_hazard = branch_hazard_ca | branch_hazard_nzp;
assign decoder_output_flush = take_brx1 | take_jmp1 | pc_ret1 | interrupt;
assign decoder_input_flush = (decoder_output_flush & extend_flush) | interrupt;
assign IO_hazard1 = IO_ren & (IO_select1 | IO_wren1);
assign IO_hazard2 = IO_ren & (IO_select2 | IO_wren2);
assign IO_hazard = IO_hazard1 | IO_hazard2;
assign data_hazard_read1 = data_ren & (data_select1 | data_wren1);
assign data_hazard_read2 = data_ren & (data_select2 | data_wren2);
assign data_hazard_read = data_hazard_read1 | data_hazard_read2;
assign hazard = IO_hazard | data_hazard_read | d_cache_read_miss | d_cache_write_miss | halt | branch_hazard | status_hazard;
endmodule	//hazard_unit
