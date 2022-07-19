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
//* Nexys2 flash memory programmer.                  *
//* Copyright (C) 2022 Esteban Looser-Rojas.         *
//* Instantiates the NeonFox CPU core along with     *
//* a timer, interrupt controller, flash controller, *
//* PS2 controller, RS-232 controller, and memory.   *
//****************************************************
module Nexys2_programmer(
		input wire clk,
		input wire[3:0] button,
		input wire[1:0] switch,
		output wire[7:0] led,
		
		//RS-232
		input wire rxd,
		output wire txd,
		
		//PS2
		inout wire ps2_data,
		inout wire ps2_clk,
		
		//Flash and PSRAM interface
		output wire[22:0] shared_a,
		inout wire[15:0] shared_d,
		output wire shared_oe_n,
		output wire shared_we_n,
		output wire flash_ce_n,
		output wire flash_reset_n,
		input wire flash_sts,
		output wire psram_ce_n,
		output wire psram_adv_n,
		output wire psram_cre,
		output wire psram_clk,
		output wire psram_lb_n,
		output wire psram_ub_n,

		//Hex display
		output wire[3:0] seg_sel,
		output wire[7:0] hex_out
		);

//Address map for IO space:
// 0x0000 to 0xFFD7	unused
// 0xFFD8 to 0xFFDF	IOMM0 (read write)
// 0xFFE0 to 0xFFE7	IOMM1 (read write)
// 0xFFE8 to 0xFFED	unused
// 0xFFEE to 0xFFEF	interrupt controller (read write)
// 0xFFF0 to 0xFFF3	timer module (read write)
// 0xFFF4 to 0xFFF5	keyboard module (read write)
// 0xFFF6 to 0xFFF7	unused
// 0xFFF8 to 0xFFFB	unused
// 0xFFFC to 0xFFFD	hex display (write only)
// 0xFFFE to 0xFFFF	RS-232 module	(read write)

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
	PLL0 PLL_inst(.CLKIN_IN(clk), .CLKDV_OUT(clk_25), .CLKIN_IBUFG_OUT(), .CLK0_OUT(clk_sys));
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
	reg[15:0] hex_indicators;
	reg[11:0] led_indicators;

	assign hex_en = (&IO_address[15:2]) & ~IO_address[1] & ~IO_address[0];
	assign led_en = (&IO_address[15:2]) & ~IO_address[1] & IO_address[0];

	initial
	begin
		rst_s = 1'b1;
		rst = 1'b1;
		hex_indicators = 16'h0000;
		led_indicators = 12'h000;
	end

	always @(posedge clk_25)
	begin
		switch_s <= switch;
		rst_s <= switch_s[0];
		rst <= rst_s;
	end

	always @(posedge clk_sys)
	begin
		if(IO_wren & H_en & hex_en)
			hex_indicators[15:8] <= from_cpu[15:8];
		if(IO_wren & L_en & hex_en)
			hex_indicators[7:0] <= from_cpu[7:0];
		
		if(IO_wren & H_en & led_en)
			led_indicators[11:8] <= from_cpu[11:8];
		if(IO_wren & L_en & led_en)
			led_indicators[7:0] <= from_cpu[7:0];
	end
			
	assign led[7:0] = led_indicators[7:0];
			
	Nexys2_hex_driver hex_inst(
			.clk(clk_25),
			.seg0(hex_indicators[3:0]),
			.seg1(hex_indicators[7:4]),
			.seg2(hex_indicators[11:8]),
			.seg3(hex_indicators[15:12]),
			.dp(led_indicators[11:8]),
			.seg_sel(seg_sel),
			.hex_out(hex_out));

	button_debounce debounce_inst(.clk(clk_25), .rst(rst), .button_in(button), .button_out(button_d));
//#############################################################################

//####### Main Memory #########################################################
	wire[15:0] prg_data;
	wire[31:0] prg_address;
	wire[31:0] data_address;
	wire[15:0] data_to_cpu;
	wire data_wren;
	BRAM_16K main_mem(
		.clka(clk_sys),
		.wea(1'b0),	//program data is read only
		.addra(prg_address[13:0]),
		.dina(16'h0000),
		.douta(prg_data),
		.clkb(clk_sys),
		.web(data_wren),
		.addrb(data_address[13:0]),
		.dinb(from_cpu),
		.doutb(data_to_cpu)
	);
//#############################################################################

//####### Serial Module #######################################################
	wire serial_en;
	wire[7:0] from_serial;
	wire uart_rx_int;
	wire uart_tx_int;
	assign serial_en = &IO_address[15:1];	//0xFFFE - 0xFFFF

	serial serial_inst(
			.clk(clk_sys),
			.reset(rst),
			.A(IO_address[0]),
			.CE(serial_en),
			.WREN(IO_wren),
			.REN(IO_ren),
			.rx(rxd),
			.tx(txd),
			.rx_int(uart_rx_int),
			.tx_int(uart_tx_int),
			.to_CPU(from_serial),
			.from_CPU(from_cpu[7:0]));
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
			
	Nexys2_PS2_driver PS2_driver_inst(
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

//####### Memory Controller ###################################################
	Nexys2_memory_controller memory_controller_inst(
		.clk(clk_sys),
		.rst(rst),
		//Port 1 (Flash)
		.p1_address(p1_address[22:0]),
		.p1_to_mem(p1_to_mem),
		.p1_from_mem(p1_from_mem),
		.p1_req(p1_req),
		.p1_wren(p1_wren & switch_s[1]),
		.p1_ready(p1_ready),
		//Port 2 (PSRAM)
		.p2_address(p2_address[22:0]),
		.p2_to_mem(p2_to_mem),
		.p2_from_mem(p2_from_mem),
		.p2_req(p2_req),
		.p2_wren(p2_wren),
		.p2_ready(p2_ready),
		//Flash and PSRAM interface
		.shared_a(shared_a),
		.shared_d(shared_d),
		.shared_oe_n(shared_oe_n),
		.shared_we_n(shared_we_n),
		.flash_ce_n(flash_ce_n),
		.flash_reset_n(flash_reset_n),
		.flash_sts(flash_sts),
		.psram_ce_n(psram_ce_n),
		.psram_adv_n(psram_adv_n),
		.psram_cre(psram_cre),
		.psram_clk(psram_clk),
		.psram_lb_n(psram_lb_n),
		.psram_ub_n(psram_ub_n)
	);
//#############################################################################

//####### IO Multiplexer ######################################################
	reg prev_keyboard_en;
	reg prev_serial_en;
	reg prev_timer_en;
	reg prev_intcon_en;
	reg prev_iomm0_en;
	reg prev_iomm1_en;

	always @(posedge clk_sys)
	begin
		prev_keyboard_en <= keyboard_en;
		prev_serial_en <= serial_en;
		prev_timer_en <= timer_en;
		prev_intcon_en <= intcon_en;
		prev_iomm0_en <= iomm0_en;
		prev_iomm1_en <= iomm1_en;
	end

	wire[15:0] m_from_keyboard;
	wire[15:0] m_from_serial;
	wire[15:0] m_from_timer;
	wire[15:0] m_from_intcon;
	wire[15:0] m_from_iomm0;
	wire[15:0] m_from_iomm1;

	assign m_from_keyboard = {8'h00, from_keyboard & {8{prev_keyboard_en}}};
	assign m_from_serial = {8'h00, from_serial & {8{prev_serial_en}}};
	assign m_from_timer = {8'h00, from_timer & {8{prev_timer_en}}};
	assign m_from_intcon = {from_intcon & {16{prev_intcon_en}}};
	assign m_from_iomm0 = from_iomm0 & {16{prev_iomm0_en}};
	assign m_from_iomm1 = from_iomm1 & {16{prev_iomm1_en}};
	
	assign IO_to_cpu = m_from_keyboard | m_from_serial | m_from_timer | m_from_intcon | m_from_iomm0 | m_from_iomm1;
//#############################################################################

//####### CPU Core ############################################################
	NeonFox CPU_inst(
			.clk(clk_sys),
			.halt(1'b0),
			.reset(rst | button_d[3]),
			.int_rq(int_rq),			//interrupt request
			.int_addr(int_addr),		//interrupt address
			.p_cache_miss(1'b0),		//program cache read miss
			.d_cache_read_miss(1'b0),	//data cache read miss
			.d_cache_write_miss(1'b0),	//data cache write miss
			.prg_data(prg_data),		//program data
			.prg_address(prg_address),		//program address
			.data_address(data_address),	//NOT used for IO
			.IO_address(IO_address),
			.data_out(from_cpu),		//data and IO out
			.data_in(data_to_cpu),
			.IO_in(IO_to_cpu),
			.data_wren(data_wren),	//data write enable
			.data_ren(),			//data read enable
			.IO_wren(IO_wren),	//high during IO writes
			.IO_ren(IO_ren),		//IO read enable
			.H_en(H_en),			//high byte write enable for IO and data
			.L_en(L_en)				//low byte write enable for IO and data
		);
//#############################################################################
endmodule
