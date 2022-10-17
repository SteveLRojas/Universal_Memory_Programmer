;                     /\         /\__
;                   // \       (  0 )_____/\            __
;                  // \ \     (vv          o|          /^v\
;                //    \ \   (vvvv  ___-----^        /^^/\vv\
;              //  /     \ \ |vvvvv/               /^^/    \v\
;             //  /       (\\/vvvv/              /^^/       \v\
;            //  /  /  \ (  /vvvv/              /^^/---(     \v\
;           //  /  /    \( /vvvv/----(O        /^^/           \v\
;          //  /  /  \  (/vvvv/               /^^/             \v|
;        //  /  /    \( vvvv/                /^^/               ||
;       //  /  /    (  vvvv/                 |^^|              //
;      //  / /    (  |vvvv|                  /^^/            //
;     //  / /   (    \vvvvv\          )-----/^^/           //
;    // / / (          \vvvvv\            /^^^/          //
;   /// /(               \vvvvv\        /^^^^/          //
;  ///(              )-----\vvvvv\    /^^^^/-----(      \\
; //(                        \vvvvv\/^^^^/               \\
;/(                            \vvvv^^^/                 //
;                                \vv^/         /        //
;                                             /<______//
;                                            <<<------/
;                                             \<
;                                              \
;**************************************************
;* NEONFOX_SERIAL_SIM.INC       SIMULATION FILE   *
;* Copyright (C) 2022 Esteban Looser-Rojas.       *
;* Contains serial driver for the NeonFox         *
;* ROM programmer project.                        *
;**************************************************

;#############################################################################
; NAME:	SERIAL_GET_BYTE
; INPUTS:	NONE
; MODIFIES: AUX0, R11, IAL
; RETURNS:	RECEIVED BYTE IN R11
;#############################################################################
SERIAL_GET_BYTE
	;CHECK THAT UART IS READY
	LIM H, AUX0, `LH UART_STATUS
	LIM L, AUX0, `LL UART_STATUS
	MOVE W, AUX0, IAL
SGB_WAIT
	BITT W, ID, 7	;CHECK BUSY FLAG
	BRNZ SGB_WAIT
	BITT W, ID, 3	;CHECK RX READY FLAG
	BRZ SGB_WAIT	;IF NOT SET KEEP WAITING
	LIM L, AUX0, `LL UART_DATA
	MOVE W, AUX0, IAL
	RET
	MOVE L, ID, R11
;#############################################################################

;#############################################################################
; NAME:	SERIAL_SEND_BYTE
; DESCRIPTION: MODIFIES THE REGISTERS THAT THE REAL FUNCTION NORMALLY MODIFIES BUT DOES NOT ACTUALLY SEND ANY DATA
; INPUTS:	BYTE TO TRANSMIT IN R0
; MODIFIES: AUX0, IAL
; RETURNS:	NONE
;#############################################################################
SERIAL_SEND_BYTE
	LIM W, AUX0, $55
	RET
	MOVE W, AUX0, IAL

	NOP	;PAD TO THE SAME SIZE AS THE REAL FUNCTION
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
;#############################################################################

;#############################################################################
SERIAL_GET_N_WORDS
	;GET THE NUMBER OF WORDS
	LIM H, AUX1, `LH SERIAL_NUM_WORDS
	LIM L, AUX1, `LL SERIAL_NUM_WORDS
	MOVE W, AUX1, DAL
	MOVE W, DD, R3

	;SET STARTING ADDRESS IN MEMORY
	LIM H, AUX0, `LH BUFFER_START
	LIM L, AUX0, `LL BUFFER_START
	MOVE W, AUX0, R5

	;LOOP N TIMES
	TEST W, R3
	BRNZ SGNB_LOOP
	NOP
	RET

SGNB_LOOP
	;GET WORD
	LIM H, AUX1, `HH SERIAL_GET_BYTE
	LIM L, AUX1, `HL SERIAL_GET_BYTE
	LIM H, AUX0, `LH SERIAL_GET_BYTE
	LIM L, AUX0, `LL SERIAL_GET_BYTE
	MOVE W, AUX1, CAH
	MOVE W, AUX0, CAL

	CALL
	NOP
	MOVE L, R11, R6

	CALL
	NOP
	MOVE S, R11, R11
	MOVE H, R11, R6

	;WRITE WORD
	MOVE W, R5, DAL
	MOVE W, R6, DD

	;INCREMENT DATA ADDRESS
	LIM W, AUX0, $01
	ADD W, R5, R5

	;DECREMENT COUNTER
	LIM W, AUX0, $01
	SUB W, R3, R3

	;CHECK IF ZERO
	BRNZ SGNB_LOOP
	NOP

	RET
	NOP
;#############################################################################

;#############################################################################
SERIAL_SEND_N_WORDS
	;GET THE NUMBER OF WORDS
	LIM H, AUX1, `LH SERIAL_NUM_WORDS
	LIM L, AUX1, `LL SERIAL_NUM_WORDS
	MOVE W, AUX1, DAL
	MOVE W, DD, R3

	;SET STARTING ADDRESS IN MEMORY
	LIM H, AUX0, `LH BUFFER_START
	LIM L, AUX0, `LL BUFFER_START
	MOVE W, AUX0, R5

	;LOOP N TIMES
	TEST W, R3
	BRNZ SSNB_LOOP
	NOP
	RET

SSNB_LOOP
	;GET WORD
	MOVE W, R5, DAL
	MOVE W, DD, R6

	;WRITE WORD
	LIM H, AUX1, `HH SERIAL_SEND_BYTE
	LIM L, AUX1, `HL SERIAL_SEND_BYTE
	LIM H, AUX0, `LH SERIAL_SEND_BYTE
	LIM L, AUX0, `LL SERIAL_SEND_BYTE
	MOVE W, AUX1, CAH
	MOVE W, AUX0, CAL

	MOVE L, R6, R0
	CALL
	NOP

	MOVE S, R6, R0
	CALL
	NOP

	;INCREMENT DATA ADDRESS
	LIM W, AUX0, $01
	ADD W, R5, R5

	;DECREMENT COUNTER
	LIM W, AUX0, $01
	SUB W, R3, R3

	;CHECK IF ZERO
	BRNZ SSNB_LOOP
	NOP

	RET
	NOP
;#############################################################################
