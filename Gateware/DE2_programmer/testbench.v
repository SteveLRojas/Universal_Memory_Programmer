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

	// Inputs
	reg clk;
	reg [3:0] button;
	wire rxd;

	// Outputs
	wire [7:0] ledr;
	wire [7:0] ledg;
	wire txd;
	wire [21:0] flash_a;
	wire flash_we_n;
	wire flash_reset_n;
	wire flash_ce_n;
	wire flash_oe_n;
	wire[6:0] hex0_d;
	wire[6:0] hex1_d;
	wire[6:0] hex2_d;
	wire[6:0] hex3_d;

	// Bidirs
	wire ps2_data;
	wire ps2_clk;
	wire [7:0] flash_d;
	
	wire sdram_clk;
	wire sdram_cke;
	wire sdram_cs_n;
	wire sdram_wre_n;
	wire sdram_cas_n;
	wire sdram_ras_n;
	wire[11:0] sdram_a;
	wire[1:0] sdram_ba;
	wire[1:0] sdram_dqm;
	wire[15:0] sdram_dq;
	
	pullup(ps2_data);
	pullup(ps2_clk);
	pullup(flash_d[0]);
	pullup(flash_d[1]);
	pullup(flash_d[2]);
	pullup(flash_d[3]);
	pullup(flash_d[4]);
	pullup(flash_d[5]);
	pullup(flash_d[6]);
	pullup(flash_d[7]);
	
	//internal signals
	wire[15:0] hex_indicators_h;
	wire[15:0] hex_indicators_l;
	wire[7:0] led_indicators_g;
	
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
	wire L_en;
	wire H_en;
	
	wire[7:0] clk_div_l;
	wire[7:0] clk_div_h;

	// Instantiate the Unit Under Test (UUT)
	DE2_programmer uut (
		.clk(clk), 
		.button(button),
		.switch(2'b10),
		.ledr(ledr),
		.ledg(ledg),
		
		.rxd(rxd), 
		.txd(txd),
		
		.ps2_data(ps2_data), 
		.ps2_clk(ps2_clk),
		
		.flash_a(flash_a), 
		.flash_d(flash_d), 
		.flash_we_n(flash_we_n), 
		.flash_reset_n(flash_reset_n), 
		.flash_ce_n(flash_ce_n), 
		.flash_oe_n(flash_oe_n),
	
		.sram_a(),
		.sram_d(),
		.sram_we_n(),
		.sram_ce_n(),
		.sram_oe_n(),
		.sram_lb_n(),
		.sram_ub_n(),
		
		.sdram_clk(sdram_clk),
		.sdram_cke(sdram_cke),
		.sdram_cs_n(sdram_cs_n),
		.sdram_wre_n(sdram_wre_n),
		.sdram_cas_n(sdram_cas_n),
		.sdram_ras_n(sdram_ras_n),
		.sdram_a(sdram_a),
		.sdram_ba(sdram_ba),
		.sdram_dqm(sdram_dqm),
		.sdram_dq(sdram_dq),
	
		.hex0_d(hex0_d),
		.hex1_d(hex1_d),
		.hex2_d(hex2_d),
		.hex3_d(hex3_d)
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
	
	assign hex_indicators_h = uut.hex_indicators_h;
	assign hex_indicators_l = uut.hex_indicators_l;
	assign led_indicators_g = uut.led_indicators_g;
	
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
	assign L_en = uut.L_en;
	assign H_en = uut.H_en;
	
	assign clk_div_l = uut.serial_inst.clk_div_l;
	assign clk_div_h = uut.serial_inst.clk_div_h;
	
	//test inputs from PC
	reg uart_rst;
	reg[31:0] timestep_count;
	reg[31:0] cycle_count;
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
				.reset(uart_rst),
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
		if(uart_rst)
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

	initial begin
		// Initialize Inputs
		// Handshake
		test_inputs[0] = 8'hde;
		test_inputs[1] = 8'had;
		test_inputs[2] = 8'hbe;
		test_inputs[3] = 8'hef;
		
		// Set target
		test_inputs[4] = 8'h0E;
		test_inputs[5] = 8'h02;
		
//		//	READ command
//		test_inputs[6] = 8'h01;
//		// Size to READ
//		test_inputs[7] = 8'h00;
//		test_inputs[8] = 8'h01;
//		test_inputs[9] = 8'h00;
//		test_inputs[10] = 8'h00;

		test_inputs[6] = 8'h02;
		
		test_inputs[7] = 8'h00;
		test_inputs[8] = 8'h00;
		test_inputs[9] = 8'h00;
		test_inputs[10] = 8'h10;
		
		// Data
		test_inputs[11] = 8'h00;
		test_inputs[12] = 8'h01;
		test_inputs[13] = 8'h02;
		test_inputs[14] = 8'h03;
		test_inputs[15] = 8'h04;
		test_inputs[16] = 8'h05;
		test_inputs[17] = 8'h06;
		test_inputs[18] = 8'h07;
		test_inputs[19] = 8'h08;
		test_inputs[20] = 8'h09;
		test_inputs[21] = 8'h0A;
		test_inputs[22] = 8'h0B;
		test_inputs[23] = 8'h0C;
		test_inputs[24] = 8'h0D;
		test_inputs[25] = 8'h0E;
		test_inputs[26] = 8'h0F;
		test_inputs[27] = 8'h10;
		test_inputs[28] = 8'had;
		test_inputs[29] = 8'hbe;
		test_inputs[30] = 8'hef;
		test_inputs[31] = 8'hde;
		
		clk = 0;
		cycle_count = 0;
		timestep_count = 0;
		uart_rst = 1'b1;
		button = 4'hf;

		// Wait 100 ns for global reset to finish
		#1300 uart_rst = 1'b0;
        
		// Add stimulus here

	end
	
	always
	begin
		#1 timestep_count = timestep_count + 1;
	end
	
	always
	begin
		#20 cycle_count = cycle_count + 1;
	end
	
	always
	begin
		#10 clk = ~clk;
	end
      
endmodule

