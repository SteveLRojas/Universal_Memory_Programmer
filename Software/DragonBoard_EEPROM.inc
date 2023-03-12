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
;* DragonBoard_EEPROM.inc          LIBRARY FILE   *
;* Copyright (C) 2022 Esteban Looser-Rojas.       *
;* Contains EEPROM driver for the NeonFox         *
;* ROM programmer project.                        *
;**************************************************

;#############################################################################
CAT_NULL
	LIM H, AUX0, $E0
	LIM L, AUX0, $00
	RET
	MOVE W, AUX0, R11
;#############################################################################

;#############################################################################
CAT_INIT
	;START I2C
	LIM H, AUX0, `LH I2C_START
	LIM L, AUX0, `LL I2C_START
	MOVE W, AUX0, CAL
	CALL
	NOP

	;DUMMY READ WITH NAK
	LIM H, AUX0, `LH I2C_GET_BYTE_NAK
	LIM L, AUX0, `LL I2C_GET_BYTE_NAK
	MOVE W, AUX0, CAL
	CALL
	NOP

	;STOP I2C
	LIM H, AUX0, `LH I2C_STOP
	LIM L, AUX0, `LL I2C_STOP
	MOVE W, AUX0, CAL
	CALL
	NOP

	RET
	NOP
;#############################################################################

;#############################################################################
CAT_SET_ADDRESS_READ
	LIM H, AUX0, `LH CAT_SET_ADDRESS_WRITE
	LIM L, AUX0, `LL CAT_SET_ADDRESS_WRITE
	MOVE W, AUX0, CAL
	CALL
	NOP

	LIM H, AUX0, `LH I2C_START
	LIM L, AUX0, `LL I2C_START
	MOVE W, AUX0, CAL
	CALL
	NOP

	LIM H, AUX0, `LH I2C_BYTE_ADDR_H
	LIM L, AUX0, `LL I2C_BYTE_ADDR_H
	MOVE W, AUX0, DAL
	MOVE W, ZERO, AUX0
	LIM L, AUX0, %1010 1001
	ROL W, DD, AUX1
	LIM H, AUX2, `LH I2C_SEND_BYTE
	LIM L, AUX2, `LL I2C_SEND_BYTE
	MOVE W, AUX2, CAL
	CALL
	OR W, AUX1, R0
	RET
	NOP
;#############################################################################

;#############################################################################
CAT_SET_ADDRESS_WRITE
	LIM H, AUX0, `LH I2C_ADDRESS_H		
	LIM L, AUX0, `LL I2C_ADDRESS_H
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX1

	LIM H, AUX0, `LH I2C_ADDRESS_L
	LIM L, AUX0, `LL I2C_ADDRESS_L
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX2	

	MOVE W, AUX2, AUX0 ;CALCULATE ADDRESS IN BYTES
	ADD W, AUX2, AUX2
	MOVE W, AUX1, AUX0
	ADDC W, AUX1, AUX1			;MULTIPLY BY 2

	LIM H, AUX0, `LH I2C_BYTE_ADDR_H		
	LIM L, AUX0, `LL I2C_BYTE_ADDR_H
	MOVE W, AUX0, DAL
	MOVE W, AUX1, DD

	LIM H, AUX0, `LH I2C_BYTE_ADDR_L
	LIM L, AUX0, `LL I2C_BYTE_ADDR_L
	MOVE W, AUX0, DAL
	MOVE W, AUX2, DD

	;START I2C
	LIM H, AUX0, `LH I2C_START
	LIM L, AUX0, `LL I2C_START
	MOVE W, AUX0, CAL
	CALL
	NOP

	LIM H, AUX0, `LH I2C_BYTE_ADDR_H
	LIM L, AUX0, `LL I2C_BYTE_ADDR_H
	MOVE W, AUX0, DAL
	MOVE W, ZERO, AUX0
	LIM L, AUX0, %1010 1000
	ROL W, DD, AUX1

	LIM H, AUX2, `LH I2C_SEND_BYTE
	LIM L, AUX2, `LL I2C_SEND_BYTE
	MOVE W, AUX2, CAL
	CALL
	OR W, AUX1, R0

	LIM H, AUX0, `LH I2C_BYTE_ADDR_L
	LIM L, AUX0, `LL I2C_BYTE_ADDR_L
	MOVE W, AUX0, DAL
	CALL
	MOVE S, DD, R0

	CALL
	MOVE L, DD, R0

	RET
	NOP
;#############################################################################

;#############################################################################
CAT_GET_N_WORDS
	;SET READ ADDRESS
	LIM H, AUX0, `LH CAT_SET_ADDRESS_READ
	LIM L, AUX0, `LL CAT_SET_ADDRESS_READ
	MOVE W, AUX0, CAL
	CALL
	NOP

	;GET THE DATA
	LIM H, AUX0, `LH I2C_GET_N_WORDS
	LIM L, AUX0, `LL I2C_GET_N_WORDS
	MOVE W, AUX0, CAL
	CALL
	NOP

	;DUMMY READ WITH NAK
	LIM H, AUX0, `LH I2C_GET_BYTE_NAK
	LIM L, AUX0, `LL I2C_GET_BYTE_NAK
	MOVE W, AUX0, CAL
	CALL
	NOP

	;STOP I2C
	LIM H, AUX0, `LH I2C_STOP
	LIM L, AUX0, `LL I2C_STOP
	MOVE W, AUX0, CAL
	CALL
	NOP

	;GET THE NUMBER OF WORDS
	LIM H, AUX0, `LH I2C_NUM_WORDS
	LIM L, AUX0, `LL I2C_NUM_WORDS
	MOVE W, AUX0, DAL
	MOVE W, DD, R3		;NUMBER OF WORDS GOES IN R3

	;GET I2C ADDRESS
	LIM H, AUX0, `LH I2C_ADDRESS_H
	LIM L, AUX0, `LL I2C_ADDRESS_H
	MOVE W, AUX0, DAL
	MOVE W, DD, R5		;I2C ADDRESS HIGH GOES IN R5

	LIM H, AUX0, `LH I2C_ADDRESS_L
	LIM L, AUX0, `LL I2C_ADDRESS_L
	MOVE W, AUX0, DAL
	MOVE W, DD, R4		;I2C ADDRESS LOW GOES IN R4

	;ADD NUMBER OF WORDS READ TO THE I2C ADDRESS
	MOVE W, R3, AUX0
	ADD W, R4, R4
	MOVE W, ZERO, AUX0
	ADDC W, R5, R5

	;UPDATE I2C ADDRESS
	LIM H, AUX0, `LH I2C_ADDRESS_H
	LIM L, AUX0, `LL I2C_ADDRESS_H
	MOVE W, AUX0, DAL
	MOVE W, R5, DD
	LIM H, AUX0, `LH I2C_ADDRESS_L
	LIM L, AUX0, `LL I2C_ADDRESS_L
	MOVE W, AUX0, DAL
	MOVE W, R4, DD

	RET
	NOP
;#############################################################################

;#############################################################################
CAT_SEND_N_WORDS
	;GET THE NUMBER OF WORDS
	LIM H, AUX0, `LH I2C_NUM_WORDS
	LIM L, AUX0, `LL I2C_NUM_WORDS
	MOVE W, AUX0, DAL
	;GET I2C ADDRESS
	LIM H, AUX0, `LH I2C_ADDRESS_H
	LIM L, AUX0, `LL I2C_ADDRESS_H
	MOVE W, DD, R3		;NUMBER OF WORDS GOES IN R3
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH I2C_ADDRESS_L
	LIM L, AUX0, `LL I2C_ADDRESS_L
	MOVE W, DD, R5		;I2C ADDRESS HIGH GOES IN R5
	MOVE W, AUX0, DAL
	;SET STARTING ADDRESS IN MEMORY
	LIM H, AUX0, `LH BUFFER_START
	LIM L, AUX0, `LL BUFFER_START
	MOVE W, AUX0, R6	;ADDRESS IN MEMORY GOES IN R6
	MOVE W, DD, R4		;I2C ADDRESS LOW GOES IN R4

	;LOOP N TIMES
	TEST W, R3
	BRNZ CWNB_WAIT
	NOP
	RET

CWNB_LOOP
	;GET WORD
	MOVE W, R6, DAL
	MOVE W, DD, R7

	;WRITE WORD
	LIM H, AUX0, `LH I2C_SEND_BYTE
	LIM L, AUX0, `LL I2C_SEND_BYTE
	MOVE W, AUX0, CAL

	CALL
	MOVE L, R7, R0

	CALL
	MOVE S, R7, R0

	;INCREMENT DATA ADDRESS
	LIM W, AUX0, $01
	ADD W, R6, R6

	;INCREMENT I2C ADDRESS
	LIM W, AUX0, $01
	ADD W, R4, R4
	LIM W, AUX0, $00
	ADDC W, R5, R5

	;DECREMENT COUNTER
	LIM W, AUX0, $01
	SUB W, R3, R3

	;CHECK IF ZERO
	BRNZ CWNB_ND
	NOP

	;UPDATE I2C ADDRESS
	LIM H, AUX0, `LH I2C_ADDRESS_H
	LIM L, AUX0, `LL I2C_ADDRESS_H
	MOVE W, AUX0, DAL
	MOVE W, R5, DD
	LIM H, AUX0, `LH I2C_ADDRESS_L
	LIM L, AUX0, `LL I2C_ADDRESS_L
	MOVE W, AUX0, DAL
	MOVE W, R4, DD

	;STOP I2C
	LIM H, AUX0, `LH I2C_STOP
	LIM L, AUX0, `LL I2C_STOP
	MOVE W, AUX0, CAL
	CALL
	NOP

	RET
	NOP

CWNB_ND
	LIM W, AUX0, $7F	;CHECK FOR 256 BYTE PAGE BOUNDARY
	AND W, R4, AUX0
	BRNZ CWNB_LOOP

	;UPDATE I2C ADDRESS
	LIM H, AUX0, `LH I2C_ADDRESS_H
	LIM L, AUX0, `LL I2C_ADDRESS_H
	MOVE W, AUX0, DAL
	MOVE W, R5, DD
	LIM H, AUX0, `LH I2C_ADDRESS_L
	LIM L, AUX0, `LL I2C_ADDRESS_L
	MOVE W, AUX0, DAL
	MOVE W, R4, DD

	;STOP I2C
	LIM H, AUX0, `LH I2C_STOP
	LIM L, AUX0, `LL I2C_STOP
	MOVE W, AUX0, CAL
	CALL
	NOP

CWNB_WAIT
	;SET WRITE ADDRESS
	LIM H, AUX0, `LH CAT_SET_ADDRESS_WRITE
	LIM L, AUX0, `LL CAT_SET_ADDRESS_WRITE
	MOVE W, AUX0, CAL
	CALL
	NOP

	;CHECK FOR ACK
	LIM H, AUX0, `LH I2C_STATUS
	LIM L, AUX0, `LL I2C_STATUS
	MOVE W, AUX0, IAL
	BITT W, ID, 5
	BRNZ CWNB_LOOP
	NOP
	BRA CWNB_WAIT
	NOP
;#############################################################################
