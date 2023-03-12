//                     /\         /\__
//                   // \       (  0 )_____/\            __
//                  // \ \     (vv          o|          /^v\
//                //    \ \   (vvvv  ___-----^        /^^/\vv\
//              //  /     \ \ |vvvvv/               /^^/    \v\
//             //  /       (\\/vvvv/              /^^/       \v\
//            //  /  /  \ (  /vvvv/              /^^/---(     \v\
//           //  /  /    \( /vvvv/----(O        /^^/           \v\
//          //  /  /  \  (/vvvv/               /^^/             \v|
//        //  /  /    \( vvvv/                /^^/               ||
//       //  /  /    (  vvvv/                 |^^|              //
//      //  / /    (  |vvvv|                  /^^/            //
//     //  / /   (    \vvvvv\          )-----/^^/           //
//    // / / (          \vvvvv\            /^^^/          //
//   /// /(               \vvvvv\        /^^^^/          //
//  ///(              )-----\vvvvv\    /^^^^/-----(      \\
// //(                        \vvvvv\/^^^^/               \\
///(                            \vvvv^^^/                 //
//                                \vv^/         /        //
//                                             /<______//
//                                            <<<------/
//                                             \<
//                                              \
//****************************************************
//* DE2 flash memory programmer.                     *
//* Copyright (C) 2022 Esteban Looser-Rojas.         *
//* Instantiates the NeonFox CPU core along with     *
//* a timer, interrupt controller, flash controller, *
//* PS2 controller, RS-232 controller, and memory.   *
//****************************************************
module DE2_programmer(
		input wire clk,
		input wire[3:0] button,
		input wire[1:0] switch,
		output wire[15:0] ledr,
		output wire[7:0] ledg,
		
		//RS-232
		input wire rxd,
		output wire txd,
		
		//PS2
		inout wire ps2_data,
		inout wire ps2_clk,
		
		//Flash interface
		output wire[21:0] flash_a,
		inout wire[7:0] flash_d,
		output wire flash_we_n,
		output wire flash_reset_n,
		output wire flash_ce_n,
		output wire flash_oe_n,
		
		//SRAM interface
		output wire[17:0] sram_a,
		inout wire[15:0] sram_d,
		output wire sram_we_n,
		output wire sram_ce_n,
		output wire sram_oe_n,
		output wire sram_lb_n,
		output wire sram_ub_n,
		
		//SDRAM interface
		output wire sdram_clk,
		output wire sdram_cke,
		output wire sdram_cs_n,
		output wire sdram_wre_n,
		output wire sdram_cas_n,
		output wire sdram_ras_n,
		output wire[11:0] sdram_a,
		output wire[1:0] sdram_ba,
		output wire[1:0] sdram_dqm,
		inout wire[15:0] sdram_dq,
		
		//Hex display
		output wire[6:0] hex0_d,
		output wire[6:0] hex1_d,
		output wire[6:0] hex2_d,
		output wire[6:0] hex3_d,
		output wire[6:0] hex4_d,
		output wire[6:0] hex5_d,
		output wire[6:0] hex6_d,
		output wire[6:0] hex7_d
		);

//Address map for IO space:
// 0x0000 to 0xFFBF	unused
// 0xFFC0 to 0xFFCF	unused
// 0xFFD0 to 0xFFD7	IOMM2 (read write)
// 0xFFD8 to 0xFFDF	IOMM0 (read write)
// 0xFFE0 to 0xFFE7	IOMM1 (read write)
// 0xFFE8 to 0xFFEB	RS-232 module
// 0xFFEC to 0xFFED	unused
// 0xFFEE to 0xFFEF	interrupt controller (read write)
// 0xFFF0 to 0xFFF3	timer module (read write)
// 0xFFF4 to 0xFFF5	keyboard module (read write)
// 0xFFF6 to 0xFFF9	unused
// 0xFFFA to 0xFFFB	led indicators (write only)
// 0xFFFC to 0xFFFD	hex display (write only)
// 0xFFFE to 0xFFFF	unused

//Address map for data and program space:
// 0x00000000 to 0x00003FFF	32KB main memory
// 0x00004000 to 0xFFFFFFFF	Not implemented

// RS-232 module address map
// 0 data register
// 1 status register
//		bit 0: TX overwrite
//		bit 1: RX overwrite
//		bit 2: TX ready
//		bit 3: RX ready
//		bit 4: TX queue empty
//		bit 5: RX queue full
// 2 clk_div_l
// 3 clk_div_h

// Keyboard module memory map
// 0 data register
// 1 status register
//		bit 0: TX overwrite
//		bit 1: RX overwrite
//		bit 2: TX ready
//		bit 3: RX ready
//		bit 4: TX queue empty
//		bit 5: RX queue full

// Timer module address map
// 0 counter bits 7:0
// 1 counter bits 15:8
// 2 counter bits 23:16
// 3 status
//		bit 0: counter 7:0 not zero
//		bit 1: counter 15:8 not zero
//		bit 2: counter 23:16 not zero
//		bit 3: counter 23:0 not zero
//		bit 4: VSYNC
//		bit 5: HSYNC
	
//####### PLL #################################################################
	wire clk_25;
	wire clk_sys;
	PLL0 PLL_inst(.inclk0(clk), .c0(clk_25), .c1(clk_sys), .c2(sdram_clk));
//#############################################################################

//####### IO Control #########################################################
	wire[15:0] IO_address;
	wire[15:0] from_cpu;
	wire[15:0] IO_to_cpu;
	wire IO_wren;
	wire IO_ren;
	wire L_en;
	wire H_en;
	wire hex_en;
	wire led_en;

	wire[3:0] button_d;
	reg[1:0] switch_s;
	reg rst_s;
	reg rst;
	reg[15:0] hex_indicators_h;
	reg[15:0] hex_indicators_l;
	reg[15:0] led_indicators_r;
	reg[7:0] led_indicators_g;

	assign hex_en = (&IO_address[15:2]) & ~IO_address[1];
	assign led_en = (&IO_address[15:3]) & ~IO_address[2] & IO_address[1];

	initial
	begin
		rst_s = 1'b1;
		rst = 1'b1;
		hex_indicators_h = 16'h0000;
		hex_indicators_l = 16'h0000;
		led_indicators_r = 16'h0000;
		led_indicators_g = 8'h00;
	end

	always @(posedge clk_25)
	begin
		switch_s <= switch;
		rst_s <= switch_s[0];
		rst <= rst_s;
	end

	always @(posedge clk_sys)
	begin
		if(IO_wren & H_en & hex_en & IO_address[0])
			hex_indicators_h[15:8] <= from_cpu[15:8];
		if(IO_wren & L_en & hex_en & IO_address[0])
			hex_indicators_h[7:0] <= from_cpu[7:0];
		if(IO_wren & H_en & hex_en & ~IO_address[0])
			hex_indicators_l[15:8] <= from_cpu[15:8];
		if(IO_wren & L_en & hex_en & ~IO_address[0])
			hex_indicators_l[7:0] <= from_cpu[7:0];
		
		if(IO_wren & H_en & led_en & IO_address[0])
			led_indicators_r[15:8] <= from_cpu[15:8];
		if(IO_wren & L_en & led_en & IO_address[0])
			led_indicators_r[7:0] <= from_cpu[7:0];
		if(IO_wren & L_en & led_en & ~IO_address[0])
			led_indicators_g[7:0] <= from_cpu[7:0];
	end
			
	assign ledr[15:0] = led_indicators_r;
	assign ledg[7:0] = led_indicators_g;
			
	DE2_hex_driver hex_inst(
			.clk(clk_25),
			.hex_data({hex_indicators_h, hex_indicators_l}),
			.hex_out0(hex0_d),
			.hex_out1(hex1_d),
			.hex_out2(hex2_d),
			.hex_out3(hex3_d),
			.hex_out4(hex4_d),
			.hex_out5(hex5_d),
			.hex_out6(hex6_d),
			.hex_out7(hex7_d));
			
	button_debounce debounce_inst(.clk(clk_25), .rst(rst), .button_in(~button), .button_out(button_d));
//#############################################################################

//####### Main Memory #########################################################
	wire[15:0] prg_data;
	wire[31:0] prg_address;
	wire[31:0] data_address;
	wire[15:0] data_to_cpu;
	wire data_wren;
	BRAM_16K main_mem(
		.clock(clk_sys),
		.wren_a(1'b0),	//program data is read only
		.address_a(prg_address[13:0]),
		.data_a(16'h0000),
		.q_a(prg_data),
		.wren_b(data_wren),
		.address_b(data_address[13:0]),
		.data_b(from_cpu),
		.q_b(data_to_cpu)
	);
//#############################################################################

//####### Serial Module #######################################################
	wire serial_en;
	wire[7:0] from_serial;
	wire uart_rx_int;
	wire uart_tx_int;
	assign serial_en = &IO_address[15:5] & ~IO_address[4] & IO_address[3] & ~IO_address[2];	//0xFFE8 to 0xFFEB
			
	serial_gen2 serial_inst(
		.clk(clk_sys), 
		.reset(rst),
		.addr(IO_address[1:0]),
		.en(serial_en),
		.wren(IO_wren),
		.ren(IO_ren),
		.rx(rxd),
		.tx(txd),
		.rx_int(uart_rx_int),
		.tx_int(uart_tx_int),
		.to_cpu(from_serial),
		.from_cpu(from_cpu[7:0]));
//#############################################################################

//####### keyboard Module #####################################################
	wire keyboard_en;
	wire[7:0] from_keyboard;
	wire kb_rx_int;
	assign keyboard_en = (&IO_address[15:4]) & ~IO_address[3] & IO_address[2] & ~IO_address[1];	//0xFFF4 - 0xFFF5

	wire ps2_data_d;
	wire ps2_clk_d;
	wire ps2_data_q;
	wire ps2_clk_q;
	
	keyboard keyboard_inst(
			.clk(clk_sys),
			.reset(rst),
			.A(IO_address[0]),
			.CE(keyboard_en),
			.WREN(IO_wren),
			.REN(IO_ren),
			.ps2_data_d(ps2_data_d),
			.ps2_clk_d(ps2_clk_d),
			.ps2_data_q(ps2_data_q),
			.ps2_clk_q(ps2_clk_q),
			.rx_int(kb_rx_int),
			.to_CPU(from_keyboard),
			.from_CPU(from_cpu[7:0]));
			
	DE1_PS2_driver PS2_driver_inst(
			.clk(clk_sys),
			.ps2_data_d(ps2_data_d),
			.ps2_clk_d(ps2_clk_d),
			.ps2_data_q(ps2_data_q),
			.ps2_clk_q(ps2_clk_q),
			.ps2_data(ps2_data),
			.ps2_clk(ps2_clk));
//#############################################################################

//####### Timer Module ########################################################
	wire timer_en;
	wire[7:0] from_timer;
	wire timer_int;
	wire vsync;
	wire hsync; 
	assign vsync = 1'b1;
	assign hsync = 1'b1;
	assign timer_en = (&IO_address[15:4]) & ~IO_address[3] & ~IO_address[2];

	timer timer_inst(
			.clk(clk_sys),
			.rst(rst),
			.ce(timer_en),
			.wren(IO_wren),
			.hsync(hsync),
			.vsync(vsync),
			.timer_int(timer_int),
			.addr(IO_address[1:0]),
			.from_cpu(from_cpu[7:0]),
			.to_cpu(from_timer));
//#############################################################################

//####### Interrupt Controller ################################################
	wire intcon_en;
	wire[15:0] from_intcon;
	wire int_rq;
	wire[3:0] int_addr;
	assign intcon_en = (&IO_address[15:5]) & ~IO_address[4] & (&IO_address[3:1]);

	interrupt_controller intcon_inst(
			.clk(clk_sys),
			.rst(rst),
			.ce(intcon_en),
			.wren(IO_wren),
			.in0(button_d[2]),
			.in1(~hsync),
			.in2(~vsync),
			.in3(timer_int),
			.in4(1'b0),
			.in5(1'b0),
			.in6(uart_rx_int),
			.in7(uart_tx_int),
			.in8(1'b0),
			.in9(1'b0),
			.in10(kb_rx_int),
			.in11(1'b0),
			.in12(1'b0),
			.in13(1'b0),
			.in14(button_d[1]),
			.in15(button_d[0]),
			.ri_addr(IO_address[0]),
			.from_cpu(from_cpu),
			.to_cpu(from_intcon),
			.int_addr(int_addr),
			.int_rq(int_rq));
//#############################################################################

//####### IOMM0 ###############################################################
	wire iomm0_en;
	wire[15:0] from_iomm0;
	wire[31:0] p1_address;
	wire[15:0] p1_to_mem;
	wire[15:0] p1_from_mem;
	wire p1_req;
	wire p1_wren;
	wire p1_ready;
	
	assign iomm0_en = (&IO_address[15:6]) & ~IO_address[5] & (&IO_address[4:3]);	//FFD8 to FFDF
	
	IOMM IOMM_inst0(
		.clk(clk_sys),
		.reset(rst),
		//CPU IO interface
		.addr(IO_address[2:0]),
		.en(iomm0_en),
		.wren(IO_wren),
		.H_en(H_en),
		.L_en(L_en), 
		.from_CPU(from_cpu),
		.to_CPU(from_iomm0),
		//Memory interface
		.mem_address(p1_address),
		.to_mem(p1_to_mem),
		.from_mem(p1_from_mem),
		.mem_req(p1_req),
		.mem_wren(p1_wren),
		.mem_ready(p1_ready)
	);
//#############################################################################

//####### IOMM1 ###############################################################
	wire iomm1_en;
	wire[15:0] from_iomm1;
	wire[31:0] p2_address;
	wire[15:0] p2_to_mem;
	wire[15:0] p2_from_mem;
	wire p2_req;
	wire p2_wren;
	wire p2_ready;
	
	assign iomm1_en = (&IO_address[15:5]) & ~IO_address[4] & ~IO_address[3];	//FFE0 to FFE7
	
	IOMM IOMM_inst1(
		.clk(clk_sys),
		.reset(rst),
		//CPU IO interface
		.addr(IO_address[2:0]),
		.en(iomm1_en),
		.wren(IO_wren),
		.H_en(H_en),
		.L_en(L_en), 
		.from_CPU(from_cpu),
		.to_CPU(from_iomm1),
		//Memory interface
		.mem_address(p2_address),
		.to_mem(p2_to_mem),
		.from_mem(p2_from_mem),
		.mem_req(p2_req),
		.mem_wren(p2_wren),
		.mem_ready(p2_ready)
	);
//#############################################################################

//####### IOMM2 ###############################################################
	wire iomm2_en;
	wire[15:0] from_iomm2;
	wire[31:0] p3_address;
	wire[15:0] p3_to_mem;
	wire[15:0] p3_from_mem;
	wire p3_req;
	wire p3_wren;
	wire p3_ready;
	wire p3_valid;
	wire[2:0] p3_offset;
	
	assign iomm2_en = (&IO_address[15:6]) & ~IO_address[5] & IO_address[4] & ~IO_address[3];	//0xFFD0 to 0xFFD7
	
	iomm16_gen2 #(.BURST_LENGTH(4)) IOMM_inst2
	(
		.clk(clk_sys),
		.reset(rst),
		//CPU IO interface
		.addr(IO_address[2:0]),
		.en(iomm2_en),
		.wren(IO_wren),
		.from_cpu(from_cpu),
		.to_cpu(from_iomm2),
		//Memory interface
		.mem_address(p3_address),
		.to_mem(p3_to_mem),
		.from_mem(p3_from_mem),
		.mem_req(p3_req),
		.mem_wren(p3_wren),
		.mem_ready(p3_ready),
		.mem_valid(p3_valid),
		.mem_offset(p3_offset)
	);
//#############################################################################

//####### Flash Controller ####################################################
	assign p1_from_mem[15:8] = 8'h00;
	DE2_flash_controller flash_controller_inst(
		.clk(clk_sys),
		.rst(rst),
		//Port 1
		.p1_address(p1_address[21:0]),
		.p1_to_mem(p1_to_mem[7:0]),
		.p1_from_mem(p1_from_mem[7:0]),
		.p1_req(p1_req),
		.p1_wren(p1_wren & switch_s[1]),
		.p1_ready(p1_ready),
		//Flash interface
		.flash_a(flash_a),
		.flash_d(flash_d),
		.flash_we_n(flash_we_n),
		.flash_reset_n(flash_reset_n),
		.flash_ce_n(flash_ce_n),
		.flash_oe_n(flash_oe_n)
	);
//#############################################################################

//####### SRAM Controller #####################################################
	DE2_SRAM_controller SRAM_inst(
		.clk(clk_sys),
		.rst(rst),
		//Port 1
		.p1_address(p2_address[17:0]),
		.p1_to_mem(p2_to_mem),
		.p1_from_mem(p2_from_mem),
		.p1_req(p2_req),
		.p1_wren(p2_wren),
		.p1_ready(p2_ready),
		//SRAM interface
		.sram_a(sram_a),
		.sram_d(sram_d),
		.sram_we_n(sram_we_n),
		.sram_ce_n(sram_ce_n),
		.sram_oe_n(sram_oe_n),
		.sram_lb_n(sram_lb_n),
		.sram_ub_n(sram_ub_n));
//#############################################################################

//####### SDRAM Controller ####################################################
	sdram_controller_gen2
	#(
		.BUS_WIDTH(16),
		.PORT_ADDRESS_BITS(22),
		.SDRAM_ADDRESS_BITS(12),
		.DQM_BITS(2),
		.NUM_BANKS(4),
		.BANK_NUM_ROWS(4096),
		.BANK_NUM_COLUMNS(256),
		.BURST_LENGTH(4),
		.MEM_CLK_KHZ(50000),
		.REFRESH_CYCLES(4096),
		.REFRESH_INTERVAL_MS(64),
		.CAS_LATENCY(3),
		.TRP(18),
		.TRSA(40),
		.TRCD(18),
		.TRC(60),
		.TRAS_MIN(42)
	) SDRAM_controller_inst
	(
		.clk(clk_sys),
		.rst(rst),

		.from_mem(p3_from_mem),
		.p1_address(p3_address[21:0]),
		.p1_to_mem(p3_to_mem),
		.p1_req(p3_req),
		.p1_wren(p3_wren),
		.p1_ready(p3_ready),
		.p1_valid(p3_valid),
		.p1_offset(p3_offset),
		
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
//#############################################################################

//####### IO Multiplexer ######################################################
	reg prev_keyboard_en;
	reg prev_serial_en;
	reg prev_timer_en;
	reg prev_intcon_en;
	reg prev_iomm0_en;
	reg prev_iomm1_en;
	reg prev_iomm2_en;

	always @(posedge clk_sys)
	begin
		prev_keyboard_en <= keyboard_en;
		prev_serial_en <= serial_en;
		prev_timer_en <= timer_en;
		prev_intcon_en <= intcon_en;
		prev_iomm0_en <= iomm0_en;
		prev_iomm1_en <= iomm1_en;
		prev_iomm2_en <= iomm2_en;
	end

	wire[15:0] m_from_keyboard;
	wire[15:0] m_from_serial;
	wire[15:0] m_from_timer;
	wire[15:0] m_from_intcon;
	wire[15:0] m_from_iomm0;
	wire[15:0] m_from_iomm1;
	wire[15:0] m_from_iomm2;

	assign m_from_keyboard = {8'h00, from_keyboard & {8{prev_keyboard_en}}};
	assign m_from_serial = {8'h00, from_serial & {8{prev_serial_en}}};
	assign m_from_timer = {8'h00, from_timer & {8{prev_timer_en}}};
	assign m_from_intcon = {from_intcon & {16{prev_intcon_en}}};
	assign m_from_iomm0 = from_iomm0 & {16{prev_iomm0_en}};
	assign m_from_iomm1 = from_iomm1 & {16{prev_iomm1_en}};
	assign m_from_iomm2 = from_iomm2 & {16{prev_iomm2_en}};
	
	assign IO_to_cpu = m_from_keyboard | m_from_serial | m_from_timer | m_from_intcon | m_from_iomm0 | m_from_iomm1 | m_from_iomm2;
//#############################################################################

//####### CPU Core ############################################################
	NeonFox CPU_inst(
			.clk(clk_sys),
			.halt(1'b0),
			.reset(rst | button_d[3]),
			.int_rq(int_rq),					//interrupt request
			.int_addr(int_addr),				//interrupt address
			.p_cache_miss(1'b0),				//program cache read miss
			.d_cache_read_miss(1'b0),		//data cache read miss
			.d_cache_write_miss(1'b0),		//data cache write miss
			.prg_data(prg_data),				//program data
			.prg_address(prg_address),		//program address
			.data_address(data_address),	//NOT used for IO
			.IO_address(IO_address),
			.data_out(from_cpu),				//data and IO out
			.data_in(data_to_cpu),
			.IO_in(IO_to_cpu),
			.data_wren(data_wren),			//data write enable
			.data_ren(),			//data read enable
			.IO_wren(IO_wren),	//high during IO writes
			.IO_ren(IO_ren),		//IO read enable
			.H_en(H_en),			//high byte write enable for IO and data
			.L_en(L_en)				//low byte write enable for IO and data
			);
//#############################################################################
endmodule
