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
;* NEXYS2_PSRAM.INC         LIBRARY FILE          *
;* Copyright (C) 2022 Esteban Looser-Rojas.       *
;* Contains PSRAM driver for the Nexys2 flash     *
;* programmer project based on NeonFox CPU.       *
;**************************************************

;#############################################################################
PSRAM_NULL
	LIM H, AUX0, $E0
	LIM L, AUX0, $00
	RET
	MOVE W, AUX0, R11
;#############################################################################

;#############################################################################
PSRAM_INIT

	RET
	NOP
;#############################################################################

;#############################################################################
PSRAM_SET_ADDRESS_WRITE
	LIM H, AUX1, `LH PSRAM_ADDRESS_H		
	LIM L, AUX1, `LL PSRAM_ADDRESS_H
	MOVE W, AUX1, DAL
	MOVE W, DD, R4

	LIM H, AUX1, `LH PSRAM_ADDRESS_L
	LIM L, AUX1, `LL PSRAM_ADDRESS_L
	MOVE W, AUX1, DAL
	MOVE W, DD, R3

	LIM H, AUX1, `LH IOMM1_WRITE_ADDR_HIGH
	LIM L, AUX1, `LL IOMM1_WRITE_ADDR_HIGH
	MOVE W, AUX1, IAL
	MOVE W, R4, ID

	LIM H, AUX1, `LH IOMM1_WRITE_ADDR_LOW
	LIM L, AUX1, `LL IOMM1_WRITE_ADDR_LOW
	MOVE W, AUX1, IAL
	MOVE W, R3, ID

	RET
	NOP
;#############################################################################

;#############################################################################
PSRAM_SET_ADDRESS_READ
	;SET AUTO INCREMENT FOR READ
	LIM H, AUX0, `LH IOMM1_READ_ADDR_INC
	LIM L, AUX0, `LL IOMM1_READ_ADDR_INC
	MOVE W, AUX0, IAL
	LIM W, AUX0, $00
	MOVE W, AUX0, ID	;DISABLE AUTO INCREMENT

	LIM H, AUX1, `LH PSRAM_ADDRESS_H		
	LIM L, AUX1, `LL PSRAM_ADDRESS_H
	MOVE W, AUX1, DAL
	MOVE W, DD, R4

	LIM H, AUX1, `LH PSRAM_ADDRESS_L
	LIM L, AUX1, `LL PSRAM_ADDRESS_L
	MOVE W, AUX1, DAL
	MOVE W, DD, R3

	LIM H, AUX1, `LH IOMM1_READ_ADDR_HIGH
	LIM L, AUX1, `LL IOMM1_READ_ADDR_HIGH
	MOVE W, AUX1, IAL
	MOVE W, R4, ID

	LIM H, AUX1, `LH IOMM1_READ_ADDR_LOW
	LIM L, AUX1, `LL IOMM1_READ_ADDR_LOW
	MOVE W, AUX1, IAL
	MOVE W, R3, ID	;THIS TRIGGERS A READ

	LIM H, AUX0, `LH IOMM1_STATUS
	LIM L, AUX0, `LL IOMM1_STATUS
	MOVE W, AUX0, IAL
PSAR_WAIT
	BITT W, ID, 1	;CHECK READ READY FLAG
	BRZ PSAR_WAIT	;IF NOT SET KEEP WAITING
	NOP

	RET
	NOP
;#############################################################################

;#############################################################################
PSRAM_GET_WORD
	LIM H, AUX0, `LH IOMM1_STATUS
	LIM L, AUX0, `LL IOMM1_STATUS
	MOVE W, AUX0, IAL
	MOVE W, ZERO, ID	;WRITE TO STATUS REGISTER TO INITIATE READ
PGW_WAIT
	BITT W, ID, 1	;CHECK READ READY FLAG
	BRZ PGW_WAIT	;IF NOT SET KEEP WAITING
	LIM L, AUX0, `LL IOMM1_MEM_DATA
	MOVE W, AUX0, IAL
	RET
	MOVE W, ID, R11
;#############################################################################

;#############################################################################
PSRAM_SEND_WORD
	LIM H, AUX0, `LH IOMM1_MEM_DATA
	LIM L, AUX0, `LL IOMM1_MEM_DATA
	MOVE W, AUX0, IAL
	MOVE W, R0, ID		;WRITE WORD

	LIM H, AUX0, `LH IOMM1_STATUS
	LIM L, AUX0, `LL IOMM1_STATUS
	MOVE W, AUX0, IAL
PWW_WAIT_DATA
	BITT W, ID, 0		;CHECK WRITE READY FLAG
	BRZ PWW_WAIT_DATA	;IF NOT SET KEEP WAITING
	NOP

	RET
	NOP
;#############################################################################

;#############################################################################
PSRAM_GET_N_WORDS
	;SET AUTO INCREMENT FOR READ
	LIM H, AUX0, `LH IOMM1_READ_ADDR_INC
	LIM L, AUX0, `LL IOMM1_READ_ADDR_INC
	MOVE W, AUX0, IAL
	LIM W, AUX0, $01
	MOVE W, AUX0, ID	;ENABLE AUTO INCREMENT

	;GET THE NUMBER OF WORDS
	LIM H, AUX1, `LH PSRAM_NUM_WORDS
	LIM L, AUX1, `LL PSRAM_NUM_WORDS
	MOVE W, AUX1, DAL
	MOVE W, DD, R3

	;SET STARTING ADDRESS IN MEMORY
	LIM H, AUX0, `LH BUFFER_START
	LIM L, AUX0, `LL BUFFER_START
	MOVE W, AUX0, R5

	;LOOP N TIMES
	TEST W, R3
	BRNZ PGNB_LOOP
	NOP
	RET

PGNB_LOOP
	;GET WORD
	LIM H, AUX0, `LH PSRAM_GET_WORD
	LIM L, AUX0, `LL PSRAM_GET_WORD
	MOVE W, AUX0, CAL
	CALL
	NOP

	;WRITE WORD
	MOVE W, R5, DAL
	MOVE W, R11, DD

	;INCREMENT DATA ADDRESS
	LIM W, AUX0, $01
	ADD W, R5, R5

	;DECREMENT COUNTER
	LIM W, AUX0, $01
	SUB W, R3, R3

	;CHECK IF ZERO
	BRNZ PGNB_LOOP
	NOP

	RET
	NOP
;#############################################################################

;#############################################################################
PSRAM_SEND_N_WORDS
	;SET AUTO INCREMENT FOR READ
	LIM H, AUX0, `LH IOMM1_WRITE_ADDR_INC
	LIM L, AUX0, `LL IOMM1_WRITE_ADDR_INC
	MOVE W, AUX0, IAL
	LIM W, AUX0, $01
	MOVE W, AUX0, ID	;ENABLE AUTO INCREMENT

	;GET THE NUMBER OF WORDS
	LIM H, AUX1, `LH PSRAM_NUM_WORDS
	LIM L, AUX1, `LL PSRAM_NUM_WORDS
	MOVE W, AUX1, DAL
	MOVE W, DD, R3

	;SET STARTING ADDRESS IN MEMORY
	LIM H, AUX0, `LH BUFFER_START
	LIM L, AUX0, `LL BUFFER_START
	MOVE W, AUX0, R5

	;LOOP N TIMES
	TEST W, R3
	BRNZ PSNB_LOOP
	NOP
	RET

PSNB_LOOP
	;GET WORD
	MOVE W, R5, DAL
	MOVE W, DD, R6

	;WRITE WORD
	LIM H, AUX0, `LH PSRAM_SEND_WORD
	LIM L, AUX0, `LL PSRAM_SEND_WORD
	MOVE W, AUX0, CAL

	MOVE W, R6, R0
	CALL
	NOP

	;INCREMENT DATA ADDRESS
	LIM W, AUX0, $01
	ADD W, R5, R5

	;DECREMENT COUNTER
	LIM W, AUX0, $01
	SUB W, R3, R3

	;CHECK IF ZERO
	BRNZ PSNB_LOOP
	NOP

	RET
	NOP
;#############################################################################
