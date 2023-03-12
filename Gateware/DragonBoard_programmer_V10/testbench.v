`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:44:11 06/15/2022
// Design Name:   Nexys2_programmer
// Module Name:   /home/ise/VM_share/Nexys2_programmer/testbench.v
// Project Name:  Nexys2_programmer
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Nexys2_programmer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

	//External signals
	reg clk;
	reg n_reset;
	reg [3:0] button;
	wire [3:0] led;
	wire rxd;
	wire txd;
	wire i2c_sda;
	wire i2c_scl;
	wire sdram_clk;
	wire sdram_cke;
	wire sdram_cs_n;
	wire sdram_wre_n;
	wire sdram_cas_n;
	wire sdram_ras_n;
	wire[10:0] sdram_a;
	wire sdram_ba;
	wire sdram_dqm;
	wire[7:0] sdram_dq;
	
	pullup(i2c_scl);
	pullup(i2c_sda);
	
	//internal signals
	wire[15:0] prg_data;
	wire[31:0] prg_address;
	wire[31:0] data_address;
	wire[15:0] data_to_cpu;
	wire data_wren;
	
	wire[15:0] IO_address;
	wire[15:0] from_cpu;
	wire[15:0] IO_to_cpu;
	wire IO_wren;
	wire IO_ren;
	//wire L_en;
	//wire H_en;

	// Instantiate the Unit Under Test (UUT)
	DragonBoard_programmer uut (
		.clk(clk), 
		.reset(n_reset),
		.button(button),
		.led(led),
		
		.rxd0(rxd), 
		.txd0(txd),
		.rxd1(1'b1),
		.txd1(),
		
		.i2c_sda(i2c_sda),
		.i2c_scl(i2c_scl),
		
		.ps2_clk_d(1'b1),
		.ps2_data_d(1'b1),
		.ps2_clk_q(),
		.ps2_data_q(),
		
		.sdram_clk(sdram_clk),
		.sdram_cke(sdram_cke),
		.sdram_cs_n(sdram_cs_n),
		.sdram_wre_n(sdram_wre_n),
		.sdram_cas_n(sdram_cas_n),
		.sdram_ras_n(sdram_ras_n),
		.sdram_a(sdram_a),
		.sdram_ba(sdram_ba),
		.sdram_dqm(sdram_dqm),
		.sdram_dq(sdram_dq)
	);
	
	sdr sdram0(
		.Dq(sdram_dq),
		.Addr(sdram_a),
		.Ba(sdram_ba),
		.Clk(sdram_clk),
		.Cke(sdram_cke),
		.Cs_n(sdram_cs_n),
		.Ras_n(sdram_ras_n),
		.Cas_n(sdram_cas_n),
		.We_n(sdram_wre_n),
		.Dqm(sdram_dqm));
	
	assign prg_data = uut.prg_data;
	assign prg_address = uut.prg_address;
	assign data_address = uut.data_address;
	assign data_to_cpu = uut.data_to_cpu;
	assign data_wren = uut.data_wren;
	
	assign IO_address = uut.IO_address;
	assign from_cpu = uut.from_cpu;
	assign IO_to_cpu = uut.IO_to_cpu;
	assign IO_wren = uut.IO_wren;
	assign IO_ren = uut.IO_ren;
	//assign L_en = uut.L_en;
	//assign H_en = uut.H_en;
	
	//test inputs from PC
	reg[7:0] test_inputs[0:31];
	reg[4:0] test_index;
	reg test_tx_req;
	wire test_tx_ready;
	wire test_rx_ready;
	reg test_tx_busy;
	wire[7:0] test_tx_data;
	wire[7:0] test_rx_data;

	assign test_tx_data = test_inputs[test_index];

	UART test_UART(
				.clk(clk),
				.reset(~button[0]),
				.tx_req(test_tx_req),
				.tx_data(test_tx_data),
				.rx(txd),
				.tx(rxd),
				.rx_data(test_rx_data),
				.tx_ready(test_tx_ready),
				.rx_ready(test_rx_ready));

	always @(posedge clk)
	begin
		test_tx_req <= 1'b0;
		if(~button[0])
		begin
			test_tx_busy <= 1'b0;
			test_index <= 5'h0;
		end
		else
		begin
			if(test_tx_req)
				test_tx_busy <= 1'b1;
			if(test_tx_ready)
				test_tx_busy <= 1'b0;
			if(~test_tx_busy & (test_index != 5'h1f))
				test_tx_req <= 1'b1;
			if(test_tx_ready & (test_index != 5'h1f))
				test_index <= test_index + 5'h01;
		end
	end
	
	always
	begin
		#10 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		test_inputs[0] = 8'hde;
		test_inputs[1] = 8'had;
		test_inputs[2] = 8'hbe;
		test_inputs[3] = 8'hef;
		
		test_inputs[4] = 8'h01;
		
		test_inputs[5] = 8'h00;
		test_inputs[6] = 8'h00;
		test_inputs[7] = 8'h00;
		test_inputs[8] = 8'h10;
		
		test_inputs[9] = 8'h64;
		test_inputs[10] = 8'h65;
		test_inputs[11] = 8'h72;
		test_inputs[12] = 8'h67;
		test_inputs[13] = 8'h20;
		test_inputs[14] = 8'h77;
		test_inputs[15] = 8'h61;
		test_inputs[16] = 8'h73;
		test_inputs[17] = 8'h20;
		test_inputs[18] = 8'h68;
		test_inputs[19] = 8'h65;
		test_inputs[20] = 8'h72;
		test_inputs[21] = 8'h65;
		test_inputs[22] = 8'h2e;
		test_inputs[23] = 8'hde;
		test_inputs[24] = 8'had;
		test_inputs[25] = 8'hbe;
		test_inputs[26] = 8'hef;
		test_inputs[27] = 8'hde;
		test_inputs[28] = 8'had;
		test_inputs[29] = 8'hbe;
		test_inputs[30] = 8'hef;
		test_inputs[31] = 8'hde;
		
		clk = 0;
		n_reset = 1'b1;
		button = 4'he;

		// Wait 100 ns for global reset to finish
		#200 button = 4'hf;
        
		// Add stimulus here

	end
      
endmodule

