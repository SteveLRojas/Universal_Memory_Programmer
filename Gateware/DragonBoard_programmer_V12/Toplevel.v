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
//* DE1 flash memory programmer.                     *
//* Copyright (C) 2022 Esteban Looser-Rojas.         *
//* Instantiates the NeonFox CPU core along with     *
//* a timer, interrupt controller, flash controller, *
//* PS2 controller, RS-232 controller, and memory.   *
//****************************************************
module DragonBoard_programmer(
		input wire reset,
		input wire clk,
		input wire[3:0] button,
		output wire[3:0] led,
		
		//RS-232
		input wire rxd0,
		output wire txd0,
		input wire rxd1,
		output wire txd1,
		
		//EEPROM
		inout wire i2c_sda,
		inout wire i2c_scl,
		
		//PS2
		input wire ps2_clk_d,
		input wire ps2_data_d,
		output wire ps2_clk_q,
		output wire ps2_data_q,
		
		//SDRAM interface
		output wire sdram_clk,
		output wire sdram_cke,
		output wire sdram_cs_n,
		output wire sdram_wre_n,
		output wire sdram_cas_n,
		output wire sdram_ras_n,
		output wire[10:0] sdram_a,
		output wire sdram_ba,
		output wire sdram_dqm,
		inout wire[7:0] sdram_dq
	);

//Address map for IO space:
// 0x0000 to 0xFFCF	unused
// 0xFFD0 to 0xFFDF	IOMM64 (read write)
// 0xFFE0 to 0xFFEB	unused
// 0xFFEC to 0xFFED	I2C module (read write)
// 0xFFEE to 0xFFEF	interrupt controller (read write)
// 0xFFF0 to 0xFFF3	timer module (read write)
// 0xFFF4 to 0xFFF5	keyboard module (read write)
// 0xFFF6 to 0xFFF7	unused
// 0xFFF8 to 0xFFF9	unused
// 0xFFFA to 0xFFFB	hex and led indicators (write only)
// 0xFFFC to 0xFFFD	RS-232 module 1
// 0xFFFE to 0xFFFF	RS-232 module 0	(read write)

//Address map for data and program space:
// 0x00000000 to 0x00001FFF	16KB main memory
// 0x00002000 to 0xFFFFFFFF	Not implemented

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

// Interrupt controller address map
//		bit 0: status register
//		bit 1: control register
	
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
	wire hex_en;
	wire led_en;

	wire[3:0] button_d;
	reg rst_s;
	reg rst;
	reg[2:0] indicator_select;
	reg prev_select;
	reg[15:0] hex_indicators;
	reg[15:0] led_indicators;
	reg[3:0] led_reg;
	
	assign hex_en = (IO_address == 16'hFFFA);
	assign led_en = (IO_address == 16'hFFFB);
	assign led[3:0] = led_reg;

	initial
	begin
		rst_s = 1'b1;
		rst = 1'b1;
		indicator_select = 3'b000;
	end

	always @(posedge clk_25)
	begin
		rst_s <= ~reset;
		rst <= rst_s;
		
		prev_select <= button_d[0];
		if(button_d[0] & ~prev_select)
			indicator_select <= indicator_select + 3'b01;
		
		case(indicator_select)
			3'b000: led_reg <= ~led_indicators[3:0];
			3'b001: led_reg <= ~led_indicators[7:4];
			3'b010: led_reg <= ~led_indicators[11:8];
			3'b011: led_reg <= ~led_indicators[15:12];
			3'b100: led_reg <= ~hex_indicators[3:0];
			3'b101: led_reg <= ~hex_indicators[7:4];
			3'b110: led_reg <= ~hex_indicators[11:8];
			3'b111: led_reg <= ~hex_indicators[15:12];
		endcase
		if(button_d[0])
			led_reg <= ~{1'b0, indicator_select};
	end

	always @(posedge clk_sys)
	begin
		if(IO_wren & led_en)
			led_indicators <= from_cpu;
		if(IO_wren & hex_en)
			hex_indicators <= from_cpu;
	end
			
	button_debounce debounce_inst(.clk(clk_25), .rst(rst), .button_in(~button), .button_out(button_d));
//#############################################################################

//####### Main Memory #########################################################
	wire[15:0] prg_data;
	wire[31:0] prg_address;
	wire[31:0] data_address;
	wire[15:0] data_to_cpu;
	wire data_wren;
	BRAM_8K main_mem(
			.clock(clk_sys),
			.wren_a(1'b0),		//program data is read only
			.address_a(prg_address[12:0]),
			.data_a(16'h0000),
			.q_a(prg_data),
			.wren_b(data_wren),
			.address_b(data_address[12:0]),
			.data_b(from_cpu),
			.q_b(data_to_cpu)
	);
//#############################################################################

//####### Serial Module 0 #####################################################
	wire serial_en0;
	wire[7:0] from_serial0;
	wire uart_rx_int0;
	wire uart_tx_int0;
	assign serial_en0 = &IO_address[15:1];	//0xFFFE - 0xFFFF

	serial serial_inst0(
			.clk(clk_sys),
			.reset(rst),
			.A(IO_address[0]),
			.CE(serial_en0),
			.WREN(IO_wren),
			.REN(IO_ren),
			.rx(rxd0),
			.tx(txd0),
			.rx_int(uart_rx_int0),
			.tx_int(uart_tx_int0),
			.to_CPU(from_serial0),
			.from_CPU(from_cpu[7:0]));
//#############################################################################

//####### Serial Module 1 #####################################################
	wire serial_en1;
	wire[7:0] from_serial1;
	wire uart_rx_int1;
	wire uart_tx_int1;
	assign serial_en1 = &IO_address[15:2] & ~IO_address[1];	//0xFFFC to 0xFFFD

	serial serial_inst1(
			.clk(clk_sys),
			.reset(rst),
			.A(IO_address[0]),
			.CE(serial_en1),
			.WREN(IO_wren),
			.REN(IO_ren),
			.rx(rxd1),
			.tx(txd1),
			.rx_int(uart_rx_int1),
			.tx_int(uart_tx_int1),
			.to_CPU(from_serial1),
			.from_CPU(from_cpu[7:0]));
//#############################################################################

//####### keyboard Module #####################################################
	wire keyboard_en;
	wire[7:0] from_keyboard;
	wire kb_rx_int;
	assign keyboard_en = (&IO_address[15:4]) & ~IO_address[3] & IO_address[2] & ~IO_address[1];	//0xFFF4 - 0xFFF5
	
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

//####### I2C Module ##########################################################
	wire i2c_en;
	wire[7:0] from_i2c;
	wire i2c_int;
	assign i2c_en = (&IO_address[15:5] & ~IO_address[4] & (&IO_address[3:2]) & ~IO_address[1]);	//0xFFEC - 0xFFED

	I2C_ri i2c_ri_inst(
			.clk(clk_sys),
			.reset(rst),
			.a(IO_address[0]),
			.ce(i2c_en),
			.wren(IO_wren),
			.ren(IO_ren),
			.i2c_int(i2c_int),
			.to_CPU(from_i2c),
			.from_CPU(from_cpu[7:0]),
			.i2c_sda(i2c_sda),
			.i2c_scl(i2c_scl));
//#############################################################################

//####### IOMM ################################################################
	wire iomm_en;
	wire[15:0] from_iomm;
	wire[31:0] arbiter_address;
	wire[63:0] to_arbiter;
	wire[63:0] from_arbiter;
	wire arbiter_req;
	wire arbiter_wren;
	wire arbiter_ready;
	
	assign iomm_en = (&IO_address[15:6]) & ~IO_address[5] & IO_address[4];	//0xFFD0 to 0xFFDF
	
	IOMM64 IOMM_inst(
			.clk(clk_sys),
			.reset(rst),
			//CPU IO interface
			.addr(IO_address[3:0]),
			.en(iomm_en),
			.wren(IO_wren), 
			.from_CPU(from_cpu),
			.to_CPU(from_iomm),
			//Memory interface
			.mem_address(arbiter_address),
			.to_mem(to_arbiter),
			.from_mem(from_arbiter),
			.mem_req(arbiter_req),
			.mem_wren(arbiter_wren),
			.mem_ready(arbiter_ready)
	);
//#############################################################################

//####### Main Memory #########################################################
	wire init_req;
	wire init_ready;
	wire[7:0] init_data;
	wire[20:0] init_address;

	wire[7:0] memory_from_mem;
	wire[20:0] memory_p1_address;
	wire[7:0] memory_p1_to_mem;
	wire memory_p1_req;
	wire memory_p1_wren;
	wire memory_p1_ready;
	wire[2:0] memory_p1_offset;

	memory_arbiter arbiter_inst(
			.clk(clk_sys),
			.rst(rst),
			
			.arbiter_p1_address(18'h00),
			.arbiter_p1_to_mem(64'h00),
			.arbiter_p1_from_mem(),
			.arbiter_p1_req(1'b0),
			.arbiter_p1_wren(1'b0),
			.arbiter_p1_ready(),
			
			.arbiter_p2_address(arbiter_address[17:0]),
			.arbiter_p2_to_mem(to_arbiter),
			.arbiter_p2_from_mem(from_arbiter),
			.arbiter_p2_req(arbiter_req),
			.arbiter_p2_wren(arbiter_wren),
			.arbiter_p2_ready(arbiter_ready),
			
			.memory_from_mem(memory_from_mem),
			.memory_p1_address(memory_p1_address),
			.memory_p1_to_mem(memory_p1_to_mem),
			.memory_p1_req(memory_p1_req),
			.memory_p1_wren(memory_p1_wren),
			.memory_p1_ready(memory_p1_ready),
			.memory_p1_offset(memory_p1_offset)
		);

	SDRAM8_SP8_B8_I SDRAM_controller(
			.clk(clk_sys),
			.rst(rst),
			
			.from_mem(memory_from_mem),
			.p1_address(memory_p1_address),
			.p1_to_mem(memory_p1_to_mem),
			.p1_req(memory_p1_req),
			.p1_wren(memory_p1_wren),
			.p1_ready(memory_p1_ready),
			.p1_offset(memory_p1_offset),
			
			.sdram_cke(sdram_cke),
			.sdram_cs_n(sdram_cs_n),
			.sdram_wre_n(sdram_wre_n),
			.sdram_cas_n(sdram_cas_n),
			.sdram_ras_n(sdram_ras_n),
			.sdram_a(sdram_a),
			.sdram_ba(sdram_ba),
			.sdram_dqm(sdram_dqm),
			.sdram_dq(sdram_dq),
			
			.init_req(init_req),
			.init_ready(init_ready),
			.init_stop(21'h1fff),
			.init_address(init_address),
			.init_data(init_data));
//#############################################################################

//####### ROM #################################################################
	reg ROM_ready;
	always @(posedge clk_sys)
	begin
		ROM_ready <= init_req;
	end
	assign init_ready = ROM_ready;
		PRG_ROM PRG_inst(.address(init_address[12:0]), .clock(clk_sys), .q(init_data));
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
			.in6(uart_rx_int0),
			.in7(uart_tx_int0),
			.in8(uart_rx_int1),
			.in9(uart_tx_int1),
			.in10(kb_rx_int),
			.in11(i2c_int),
			.in12(1'b0),
			.in13(1'b0),
			.in14(1'b0),
			.in15(button_d[1]),
			.ri_addr(IO_address[0]),
			.from_cpu(from_cpu),
			.to_cpu(from_intcon),
			.int_addr(int_addr),
			.int_rq(int_rq));
//#############################################################################

//####### IO Multiplexer ######################################################
	reg prev_serial_en0;
	reg prev_serial_en1;
	reg prev_keyboard_en;
	reg prev_timer_en;
	reg prev_intcon_en;
	reg prev_i2c_en;
	reg prev_iomm_en;

	always @(posedge clk_sys)
	begin
		prev_serial_en0 <= serial_en0;
		prev_serial_en1 <= serial_en1;
		prev_keyboard_en <= keyboard_en;
		prev_timer_en <= timer_en;
		prev_intcon_en <= intcon_en;
		prev_i2c_en <= i2c_en;
		prev_iomm_en <= iomm_en;
	end

	wire[15:0] m_from_serial0;
	wire[15:0] m_from_serial1;
	wire[15:0] m_from_keyboard;
	wire[15:0] m_from_timer;
	wire[15:0] m_from_intcon;
	wire[15:0] m_from_i2c;
	wire[15:0] m_from_iomm;

	assign m_from_serial0 = {8'h00, from_serial0 & {8{prev_serial_en0}}};
	assign m_from_serial1 = {8'h00, from_serial1 & {8{prev_serial_en1}}};
	assign m_from_keyboard = {8'h00, from_keyboard & {8{prev_keyboard_en}}};
	assign m_from_timer = {8'h00, from_timer & {8{prev_timer_en}}};
	assign m_from_intcon = from_intcon & {16{prev_intcon_en}};
	assign m_from_i2c = {8'h00, from_i2c & {8{prev_i2c_en}}};
	assign m_from_iomm = from_iomm & {16{prev_iomm_en}};
	
	assign IO_to_cpu = m_from_serial0 | m_from_serial1 | m_from_keyboard | m_from_timer | m_from_intcon | m_from_i2c | m_from_iomm;
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
			.data_out(from_cpu),		//data and IO out
			.data_in(data_to_cpu),
			.IO_in(IO_to_cpu),
			.data_wren(data_wren),	//data write enable
			.data_ren(),				//data read enable
			.IO_wren(IO_wren),		//high during IO writes
			.IO_ren(IO_ren),			//IO read enable
			.H_en(),					//high byte write enable for IO and data
			.L_en()					//low byte write enable for IO and data
		);
//#############################################################################
endmodule
