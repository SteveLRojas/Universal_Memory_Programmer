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
;* neonfox_i2c_gen2.inc            LIBRARY FILE   *
;* Copyright (C) 2022 Esteban Looser-Rojas.       *
;* Contains I2C driver for the NeonFox ROM        *
;* programmer project.                            *
;**************************************************

;#############################################################################
; NAME:	I2C_INIT
; INPUTS:	CLOCK DIVIDER VALUE IN R0
; MODIFIES: AUX0, IAL
; RETURNS:	NONE
;#############################################################################
I2C_INIT
	LIM H, AUX0, `LH I2C_CLK_DIV_L
	LIM L, AUX0, `LL I2C_CLK_DIV_L
	MOVE W, AUX0, IAL
	MOVE L, R0, ID
	LIM H, AUX0, `LH I2C_CLK_DIV_H
	LIM L, AUX0, `LL I2C_CLK_DIV_H
	MOVE W, AUX0, IAL
	RET
	MOVE S, R0, ID
;#############################################################################

;#############################################################################
I2C_START
	LIM H, AUX0, `LH I2C_STATUS
	LIM L, AUX0, `LL I2C_STATUS
	MOVE W, AUX0, IAL
	LIM W, AUX0, $01	;BIT 0 IS START REQ
	MOVE W, AUX0, ID	;WRITE TO STATUS CLEARS READY FLAG
	MOVE W, ID, ZERO	;DUMMY READ BECAUSE I2C MODULE HAS 2 CYCLE LATENCY
ISTART_LOOP
	BITT W, ID, 6	;CHECK READY FLAG
	BRZ ISTART_LOOP
	NOP
	RET
	NOP
;#############################################################################

;#############################################################################
I2C_STOP
	LIM H, AUX0, `LH I2C_STATUS
	LIM L, AUX0, `LL I2C_STATUS
	MOVE W, AUX0, IAL
	LIM W, AUX0, $02	;BIT 1 IS STOP BIT
	MOVE W, AUX0, ID	;WRITE TO STATUS CLEARS READY FLAG
	MOVE W, ID, ZERO	;DUMMY READ BECAUSE I2C MODULE HAS 2 CYCLE LATENCY
ISTOP_LOOP
	BITT W, ID, 6	;CHECK READY FLAG
	BRZ ISTOP_LOOP
	NOP
	RET
	NOP
;#############################################################################

;#############################################################################
I2C_GET_BYTE
	LIM H, AUX0, `LH I2C_STATUS
	LIM L, AUX0, `LL I2C_STATUS
	MOVE W, AUX0, IAL
	LIM W, AUX0, $14	;READ REQ + ACK
	MOVE W, AUX0, ID	;WRITE TO STATUS CLEARS READY FLAG
	MOVE W, ID, ZERO	;DUMMY READ BECAUSE I2C MODULE HAS 2 CYCLE LATENCY
IGET_LOOP
	BITT W, ID, 6	;CHECK READY FLAG
	BRZ IGET_LOOP
	LIM H, AUX0, `LH I2C_DATA
	LIM L, AUX0, `LL I2C_DATA
	MOVE W, AUX0, IAL
	RET
	MOVE L, ID, R11
;#############################################################################

;#############################################################################
I2C_GET_BYTE_NAK
	LIM H, AUX0, `LH I2C_STATUS
	LIM L, AUX0, `LL I2C_STATUS
	MOVE W, AUX0, IAL
	LIM W, AUX0, $04	;READ REQ
	MOVE W, AUX0, ID	;WRITE TO STATUS CLEARS READY FLAG
	MOVE W, ID, ZERO	;DUMMY READ BECAUSE I2C MODULE HAS 2 CYCLE LATENCY
IGETBN_LOOP
	BITT W, ID, 6	;CHECK READY FLAG
	BRZ IGETBN_LOOP
	LIM H, AUX0, `LH I2C_DATA
	LIM L, AUX0, `LL I2C_DATA
	MOVE W, AUX0, IAL
	RET
	MOVE L, ID, R11
;#############################################################################

;#############################################################################
I2C_SEND_BYTE
	LIM H, AUX0, `LH I2C_DATA
	LIM L, AUX0, `LL I2C_DATA
	MOVE W, AUX0, IAL
	LIM H, AUX0, `LH I2C_STATUS
	LIM L, AUX0, `LL I2C_STATUS
	MOVE W, R0, ID	;WRITE TO I2C_DATA CLEARS READY FLAG
	MOVE W, AUX0, IAL
	LIM W, AUX0, $08
	MOVE W, AUX0, ID
ISENDB_LOOP
	BITT W, ID, 6
	BRZ ISENDB_LOOP
	NOP
	RET
	NOP
;#############################################################################

;#############################################################################
I2C_GET_N_WORDS
	;GET THE NUMBER OF BYTES
	LIM H, AUX0, `LH I2C_NUM_WORDS
	LIM L, AUX0, `LL I2C_NUM_WORDS
	MOVE W, AUX0, DAL
	;SET STARTING ADDRESS IN MEMORY
	LIM H, AUX0, `LH BUFFER_START
	LIM L, AUX0, `LL BUFFER_START
	MOVE W, AUX0, R4
	MOVE W, DD, R3

	;LOOP N TIMES
	;TEST W, R3
	BRNZ IGNB_LOOP
	NOP
	RET

IGNB_LOOP
	;GET WORD
	LIM H, AUX0, `LH I2C_GET_BYTE
	LIM L, AUX0, `LL I2C_GET_BYTE
	MOVE W, AUX0, CAL

	CALL
	NOP
	MOVE L, R11, R5

	CALL
	NOP
	MOVE S, R11, R11
	MOVE H, R11, R5
	
	;WRITE WORD
	MOVE W, R4, DAL
	MOVE W, R5, DD

	;INCREMENT DATA ADDRESS
	LIM W, AUX0, $01
	ADD W, R4, R4

	;DECREMENT COUNTER
	LIM W, AUX0, $01
	SUB W, R3, R3

	;CHECK IF ZERO
	BRNZ IGNB_LOOP
	NOP

	RET
	NOP
;#############################################################################

;#############################################################################
I2C_SEND_N_WORDS
	;GET THE NUMBER OF WORDS
	LIM H, AUX0, `LH I2C_NUM_WORDS
	LIM L, AUX0, `LL I2C_NUM_WORDS
	MOVE W, AUX0, DAL
	;SET STARTING ADDRESS IN MEMORY
	LIM H, AUX0, `LH BUFFER_START
	LIM L, AUX0, `LL BUFFER_START
	MOVE W, AUX0, R4
	MOVE W, DD, R3

	;LOOP N TIMES
	;TEST W, R3
	BRNZ ISNB_LOOP
	NOP
	RET

ISNB_LOOP
	;GET WORD
	MOVE W, R4, DAL
	MOVE W, DD, R5

	;WRITE WORD
	LIM H, AUX0, `LH I2C_SEND_BYTE
	LIM L, AUX0, `LL I2C_SEND_BYTE
	MOVE W, AUX0, CAL

	CALL
	MOVE L, R5, R0

	CALL
	MOVE S, R5, R0

	;INCREMENT DATA ADDRESS
	LIM W, AUX0, $01
	ADD W, R4, R4

	;DECREMENT COUNTER
	LIM W, AUX0, $01
	SUB W, R3, R3

	;CHECK IF ZERO
	BRNZ ISNB_LOOP
	NOP

	RET
	NOP
;#############################################################################
