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
//***************************************************
//* Non Intel IP   SDRAM_SP8_I.sv memory controller *
//* Copyright (C) 2021 Esteban Looser-Rojas.        *
//* Single port SDRAM memory controller module with *
//* memory initialization interface.                *
//*  All rights reserved.                           *
//***************************************************
//Designed for TMS626812A-10 @ 100MHz
//Timing parameters (in cycles)
//	CAS latency: 3
//	tRAS: 5
//	tRC: 8
//	tRCD: 3
//	tRP: 3
// tRSA: 2
// refresh period: 1562
// burst length: 8
module SDRAM8_SP8_B8_I(
		input wire clk,
		input wire rst,
		output reg[7:0] from_mem,
		
		input wire[20:0] p1_address,
		input wire[7:0] p1_to_mem,
		input wire p1_req,
		input wire p1_wren,
		output wire p1_ready,
		output wire[2:0] p1_offset,
		
		output wire sdram_cke,
		output wire sdram_cs_n,
		output wire sdram_wre_n,
		output wire sdram_cas_n,
		output wire sdram_ras_n,
		output reg[10:0] sdram_a,
		output reg sdram_ba,
		output reg sdram_dqm,
		inout wire[7:0] sdram_dq,
		
		output wire init_req,
		input wire init_ready,
		input wire[20:0] init_stop,	//must be one less than a multiple of burst length
		output reg[20:0] init_address,
		input wire[7:0] init_data);
		
reg ready;
reg req_flag;
reg prev_req;
reg prev_init_ready;
reg init_pending;	//init data has been requested
reg init_flag;		//more init data needs to be fetched
reg init_done;		//all init data has been fetched and written
reg refresh_flag;
reg fifo_pop;

reg gate_out;
reg[2:0] sdram_cmd;
reg[2:0] init_refresh_count;	//initially set to 7. On refresh the number of refresh cycles performed will be this number plus one.
reg[10:0] refresh_timer;
reg[2:0] burst_count;
reg[20:0] address_hold;
reg[7:0] data_out;
reg wren;

wire init_comp;
wire fifo_full;
wire[7:0] fifo_data;

assign p1_ready = ready;
assign p1_offset = burst_count;
assign sdram_cke = 1'b1;
assign sdram_cs_n = 1'b0;
assign {sdram_ras_n, sdram_cas_n, sdram_wre_n} = sdram_cmd;
assign sdram_dq = gate_out ? data_out : 8'hZZ;
assign init_comp = |(init_stop ^ init_address);
assign init_req = init_pending;

queue_8_8 init_fifo_inst(
		.clk(clk),
		.reset(rst),
		.push(init_ready & ~prev_init_ready),
		.pop(fifo_pop),
		.full(fifo_full),
		.empty(),	//not used
		.din(init_data), 
		.dout(fifo_data)
		);

localparam [2:0] SDRAM_CMD_LOADMODE  = 3'b000;
localparam [2:0] SDRAM_CMD_REFRESH   = 3'b001;
localparam [2:0] SDRAM_CMD_PRECHARGE = 3'b010;
localparam [2:0] SDRAM_CMD_ACTIVE    = 3'b011;
localparam [2:0] SDRAM_CMD_WRITE     = 3'b100;
localparam [2:0] SDRAM_CMD_READ      = 3'b101;
localparam [2:0] SDRAM_CMD_NOP       = 3'b111;

enum logic[5:0] {
			S_INIT_DEVICE,
			S_INIT_DEVICE_NOP1,
			S_INIT_DEVICE_NOP2,
			S_MODE,
			S_MODE_NOP,
			S_IDLE,
			
			S_ACTIVATE,
			S_ACTIVATE_NOP1,
			S_ACTIVATE_NOP2,
			
			S_READ,
			S_READ_NOP1,
			S_READ_NOP2,
			S_READ_NOP3,
			S_READ_DATA,
			
			S_WRITE,
			S_WRITE_DATA,
			S_WRITE_NOP1,
			S_WRITE_NOP2,
			S_WRITE_NOP3,
			
			S_REFRESH,
			S_REFRESH_NOP,	//USE BURST COUNTER TO WAIT 7 CYCLES
			
			S_INIT_LOAD,
			S_INIT_ACTIVATE,
			S_INIT_ACTIVATE_NOP1,
			S_INIT_ACTIVATE_NOP2,
			S_INIT_WRITE,
			S_INIT_WRITE_DATA,
			S_INIT_NOP1,
			S_INIT_NOP2,
			S_INIT_INC} state;
			
always @(posedge clk)
begin
	if(rst)
	begin
		state <= S_INIT_DEVICE;
		req_flag <= 1'b0;
		prev_req <= 1'b0;
		sdram_cmd <= SDRAM_CMD_NOP;
		gate_out <= 1'b0;
		sdram_dqm <= 1'b1;
		address_hold <= 21'h000;
		init_address <= 21'h000;
		ready <= 1'b0;
		init_refresh_count <= 3'b111;
		refresh_timer <= 11'h00;
		refresh_flag <= 1'b1;
		init_pending <= 1'b0;
		init_flag <= 1'b1;
		init_done <= 1'b0;
		fifo_pop <= 1'b0;
		prev_init_ready <= 1'b0;
	end
	else
	begin
		//init control
		prev_init_ready <= init_ready;
		init_pending <= init_flag & ~fifo_full;
		if(init_ready & ~prev_init_ready)
		begin
			init_pending <= 1'b0;
			init_address <= init_address + 21'h001;
			init_flag <= init_comp;
		end
		
		//request logic
		prev_req <= p1_req;
		if(p1_req & ~prev_req)
			req_flag <= 1'b1;
		
		//refresh timer
		//if(refresh_timer == 11'd1562)	//100 MHz
		if(refresh_timer == 11'd1171)	//75 MHz
		begin
			refresh_timer <= 11'h00;
			refresh_flag <= 1'b1;
		end
		else
			refresh_timer <= refresh_timer + 11'h01;
			
		//state machine
		case(state)
			S_INIT_DEVICE:
			begin
				sdram_cmd <= SDRAM_CMD_PRECHARGE;
				sdram_a[10] <= 1'b1;	//precharge all
				gate_out <= 1'b0;
				sdram_dqm <= 1'b1;
				state <= S_INIT_DEVICE_NOP1;
			end
			S_INIT_DEVICE_NOP1:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				gate_out <= 1'b0;
				sdram_dqm <= 1'b1;
				state <= S_INIT_DEVICE_NOP2;
			end
			S_INIT_DEVICE_NOP2:
			begin
				sdram_dqm <= 1'b1;
				state <= S_MODE;
			end
			S_MODE:
			begin
				sdram_cmd <= SDRAM_CMD_LOADMODE;
				sdram_a <= 11'b0_0_00_011_1_011;	//burst length 8, interleave, CAS latency 3, burst read and write.
				sdram_ba <= 1'b0;
				gate_out <= 1'b0;
				sdram_dqm <= 1'b1;
				state <= S_MODE_NOP;
			end
			S_MODE_NOP:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				gate_out <= 1'b0;
				sdram_dqm <= 1'b1;
				state <= S_REFRESH;
			end
			S_IDLE:
			begin
				ready <= 1'b0;
				burst_count <= 3'h0;
				if(refresh_flag)
				begin
					state <= S_REFRESH;
				end
				else if(p1_req || req_flag)	//port 1 is read and write
				begin
					address_hold <= p1_address;
					req_flag <= 1'b0;
					wren <= p1_wren;
					state <= S_ACTIVATE;
				end
			end
			S_ACTIVATE:
			begin
				sdram_cmd <= SDRAM_CMD_ACTIVE;	//send activate command
				sdram_ba <= address_hold[3];	//set bank
				sdram_a[10:0] <= address_hold[20:10];	//set row
				sdram_dqm <= 1'b1;
				state <= S_ACTIVATE_NOP1;
			end
			S_ACTIVATE_NOP1:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				gate_out <= 1'b0;
				state <= S_ACTIVATE_NOP2;
				ready <= wren;
			end
			S_ACTIVATE_NOP2:
			begin
				burst_count <= ready ? (burst_count + 3'h1) : 3'h0;
				if(wren)
					state <= S_WRITE;
				else
					state <= S_READ;
			end
			S_READ:
			begin
				sdram_cmd <= SDRAM_CMD_READ;
				sdram_a[10] <= 1'b1;	//auto precharge
				sdram_a[9] <= 1'b0;
				sdram_a[8:0] <= {address_hold[9:4], address_hold[2:0]};	//set column
				sdram_dqm <= 1'b0;
				gate_out <= 1'b0;
				state <= S_READ_NOP1;
			end
			S_READ_NOP1:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				gate_out <= 1'b0;
				state <= S_READ_NOP2;
			end
			S_READ_NOP2:
			begin
				state <= S_READ_NOP3;
			end
			S_READ_NOP3:
			begin
				state <= S_READ_DATA;
			end
			S_READ_DATA:
			begin
				burst_count <= ready ? (burst_count + 3'h1) : 3'h0;
				from_mem <= sdram_dq;
				ready <= 1'b1;
				if(&burst_count[2:1])
				begin
					if(refresh_flag)
						state <= S_REFRESH;
					else
						state <= S_IDLE;
				end
			end
			S_WRITE:
			begin
				sdram_cmd <= SDRAM_CMD_WRITE;
				sdram_a[10] <= 1'b1;	//automatic precharge
				sdram_a[9] <= 1'b0;
				sdram_a[8:0] <= {address_hold[9:4], address_hold[2:0]};	//set col
				sdram_dqm <= 1'b0;
				gate_out <= 1'b1;
				data_out <= p1_to_mem;
				burst_count <= ready ? (burst_count + 3'h1) : 3'h0;
				state <= S_WRITE_DATA;
			end
			S_WRITE_DATA:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				data_out <= p1_to_mem;
				burst_count <= ready ? (burst_count + 3'h1) : 3'h0;
				if(&burst_count)
					ready <= 1'b0;
				if(~ready)
					state <= S_WRITE_NOP1;
			end
			S_WRITE_NOP1:
			begin
				sdram_dqm <= 1'b1;
				gate_out <= 1'b0;
				state <= S_WRITE_NOP2;
			end
			S_WRITE_NOP2:
			begin
				state <= S_WRITE_NOP3;
			end
			S_WRITE_NOP3:
			begin
				state <= S_IDLE;
			end
			S_REFRESH:
			begin
				ready <= 1'b0;
				sdram_cmd <= SDRAM_CMD_REFRESH;
				sdram_dqm <= 1'b1;
				state <= S_REFRESH_NOP;
				burst_count <= 3'h0;
			end
			S_REFRESH_NOP:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				burst_count <= burst_count + 3'h1;
				if(&burst_count[2:1])
				begin
					if(init_refresh_count == 3'h0)
						refresh_flag <= 1'b0;
					else
						init_refresh_count <= init_refresh_count - 3'b001;
					if(~init_done)
						state <= S_INIT_LOAD;
					else
						state <= S_IDLE;
				end
			end

			S_INIT_LOAD:
			begin
				if(refresh_flag)
				begin
					state <= S_REFRESH;
				end
				else if(fifo_full)
				begin
					state <= S_INIT_ACTIVATE;
				end
			end
			S_INIT_ACTIVATE:
			begin
				sdram_cmd <= SDRAM_CMD_ACTIVE;	//send activate command
				sdram_ba <= address_hold[3];	//set bank
				sdram_a[10:0] <= address_hold[20:10];	//set row
				sdram_dqm <= 1'b1;
				state <= S_INIT_ACTIVATE_NOP1;
			end
			S_INIT_ACTIVATE_NOP1:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				gate_out <= 1'b0;
				state <= S_INIT_ACTIVATE_NOP2;
			end
			S_INIT_ACTIVATE_NOP2:
			begin
				state <= S_INIT_WRITE;
				burst_count <= 3'h0;
				fifo_pop <= 1'b1;
			end
			S_INIT_WRITE:
			begin
				sdram_cmd <= SDRAM_CMD_WRITE;
				sdram_a[10] <= 1'b1;	//automatic precharge
				sdram_a[9] <= 1'b0;
				sdram_a[8:0] <= {address_hold[9:4], address_hold[2:0]};	//set col
				sdram_dqm <= 1'b0;
				gate_out <= 1'b1;
				data_out <= fifo_data;
				burst_count <= burst_count + 3'h1;
				state <= S_INIT_WRITE_DATA;
			end
			S_INIT_WRITE_DATA:
			begin
				sdram_cmd <= SDRAM_CMD_NOP;
				data_out <= fifo_data;
				burst_count <= burst_count + 3'h1;
				if(&burst_count)
				begin
					fifo_pop <= 1'b0;
					state <= S_INIT_NOP1;
				end
			end
			S_INIT_NOP1:
			begin
				sdram_dqm <= 1'b1;
				gate_out <= 1'b0;
				state <= S_INIT_NOP2;
			end
			S_INIT_NOP2:
			begin
				state <= S_INIT_INC;
			end
			S_INIT_INC:
			begin
				address_hold[20:3] <= address_hold[20:3] + 18'h001;
				if(~init_flag)
				begin
					init_done <= 1'b1;
					state <= S_IDLE;
				end
				else
				begin
					state <= S_INIT_LOAD;
				end
			end
			default: ;
		endcase
	end
end
		
endmodule: SDRAM8_SP8_B8_I
