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
;* DE2_SDRAM.INC                    LIBRARY FILE  *
;* Copyright (C) 2022 Esteban Looser-Rojas.       *
;* Contains SDRAM driver for the DE2 programmer   *
;* project based on NeonFox CPU.                  *
;**************************************************

;Memory reads are triggered automatically when the read buffer is empty.
;Writes to the status register pop the read buffer, writes to the read address registers flush the read buffer.
;Memory writes are triggered automatically when the write buffer is full.
;Writes to the data register push the write buffer, writes to the write address registers flush the write buffer.

;Status bits:
;	bit 0: write ready
;	bit 1: read ready
;	bit 2: write buffer empty
;	bit 3: read buffer full
;	bits 4 to 6: reserved
;	bit 7: busy flag
;	bits 8 to 15: unused

;#############################################################################
SDRAM_NULL
	LIM H, AUX0, $E0
	LIM L, AUX0, $00
	RET
	MOVE W, AUX0, R11
;#############################################################################

;#############################################################################
SDRAM_INIT
	LIM H, AUX0, `LH IOMM2_WRITE_ADDR_INC
	LIM L, AUX0, `LL IOMM2_WRITE_ADDR_INC
	MOVE W, AUX0, IAL
	MOVE W, ZERO, ID	;DISABLE AUTO INCREMENT

	LIM H, AUX0, `LH IOMM2_READ_ADDR_INC
	LIM L, AUX0, `LL IOMM2_READ_ADDR_INC
	MOVE W, AUX0, IAL
	MOVE W, ZERO, ID	;DISABLE AUTO INCREMENT

	; CLEAR WRITE ADDRESS
	LIM H, AUX1, `LH IOMM2_WRITE_ADDR_HIGH
	LIM L, AUX1, `LL IOMM2_WRITE_ADDR_HIGH
	MOVE W, AUX1, IAL
	MOVE W, ZERO, ID

	LIM H, AUX1, `LH IOMM2_WRITE_ADDR_LOW
	LIM L, AUX1, `LL IOMM2_WRITE_ADDR_LOW
	MOVE W, AUX1, IAL
	RET
	MOVE W, ZERO, ID
;#############################################################################

;#############################################################################
SDRAM_SET_ADDRESS_WRITE
	;SET AUTO INCREMENT FOR WRITE
	LIM H, AUX0, `LH IOMM2_WRITE_ADDR_INC
	LIM L, AUX0, `LL IOMM2_WRITE_ADDR_INC
	MOVE W, AUX0, IAL
	LIM W, AUX0, $04
	MOVE W, AUX0, ID	;ENABLE AUTO INCREMENT

	LIM H, AUX0, `LH SDRAM_ADDRESS_H		
	LIM L, AUX0, `LL SDRAM_ADDRESS_H
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX1

	LIM H, AUX0, `LH SDRAM_ADDRESS_L
	LIM L, AUX0, `LL SDRAM_ADDRESS_L
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX2

	LIM H, AUX0, `LH IOMM2_WRITE_ADDR_HIGH
	LIM L, AUX0, `LL IOMM2_WRITE_ADDR_HIGH
	MOVE W, AUX0, IAL
	MOVE W, AUX1, ID

	LIM H, AUX0, `LH IOMM2_WRITE_ADDR_LOW
	LIM L, AUX0, `LL IOMM2_WRITE_ADDR_LOW
	MOVE W, AUX0, IAL
	RET
	MOVE W, AUX2, ID
;#############################################################################

;#############################################################################
SDRAM_SET_ADDRESS_READ
	;SET AUTO INCREMENT FOR READ
	LIM H, AUX0, `LH IOMM2_READ_ADDR_INC
	LIM L, AUX0, `LL IOMM2_READ_ADDR_INC
	MOVE W, AUX0, IAL
	LIM W, AUX0, $04
	MOVE W, AUX0, ID	;ENABLE AUTO INCREMENT

	LIM H, AUX0, `LH SDRAM_ADDRESS_H		
	LIM L, AUX0, `LL SDRAM_ADDRESS_H
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX1

	LIM H, AUX0, `LH SDRAM_ADDRESS_L
	LIM L, AUX0, `LL SDRAM_ADDRESS_L
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX2

	LIM H, AUX0, `LH IOMM2_READ_ADDR_HIGH
	LIM L, AUX0, `LL IOMM2_READ_ADDR_HIGH
	MOVE W, AUX0, IAL
	MOVE W, AUX1, ID

	LIM H, AUX0, `LH IOMM2_READ_ADDR_LOW
	LIM L, AUX0, `LL IOMM2_READ_ADDR_LOW
	MOVE W, AUX0, IAL
	RET
	MOVE W, AUX2, ID		;WRITING TO IOMM2_READ_ADDR_LOW TRIGGERS A READ
;#############################################################################

;#############################################################################
SDRAM_GET_WORD
	LIM H, AUX0, `LH IOMM2_STATUS
	LIM L, AUX0, `LL IOMM2_STATUS
	MOVE W, AUX0, IAL
SDGW_WAIT
	BITT W, ID, 1		;CHECK READ READY FLAG
	BRZ SDGW_WAIT		;IF NOT SET KEEP WAITING

	LIM H, AUX0, `LH IOMM2_MEM_DATA
	LIM L, AUX0, `LL IOMM2_MEM_DATA
	MOVE W, AUX0, IAL
	MOVE W, ID, R11

	LIM H, AUX0, `LH IOMM2_STATUS
	LIM L, AUX0, `LL IOMM2_STATUS
	MOVE W, AUX0, IAL
	RET
	MOVE W, ZERO, ID	;WRITE TO STATUS REGISTER TO POP BUFFER
;#############################################################################

;#############################################################################
SDRAM_SEND_WORD
	LIM H, AUX0, `LH IOMM2_STATUS
	LIM L, AUX0, `LL IOMM2_STATUS
	MOVE W, AUX0, IAL
SDSW_WAIT
	BITT W, ID, 0		;CHECK WRITE READY FLAG
	BRZ SDSW_WAIT		;IF NOT SET KEEP WAITING

	LIM H, AUX0, `LH IOMM2_MEM_DATA
	LIM L, AUX0, `LL IOMM2_MEM_DATA
	MOVE W, AUX0, IAL
	RET
	MOVE W, R0, ID
;#############################################################################

;#############################################################################
SDRAM_GET_N_WORDS
	;SET AUTO INCREMENT FOR READ
	LIM H, AUX0, `LH IOMM2_READ_ADDR_INC
	LIM L, AUX0, `LL IOMM2_READ_ADDR_INC
	MOVE W, AUX0, IAL
	LIM W, AUX0, $04
	MOVE W, AUX0, ID	;ENABLE AUTO INCREMENT

	;GET THE NUMBER OF WORDS
	LIM H, AUX1, `LH SDRAM_NUM_WORDS
	LIM L, AUX1, `LL SDRAM_NUM_WORDS
	MOVE W, AUX1, DAL
	MOVE W, DD, R3

	;SET STARTING ADDRESS IN MEMORY
	LIM H, AUX0, `LH BUFFER_START
	LIM L, AUX0, `LL BUFFER_START
	MOVE W, AUX0, R5

	;LOOP N TIMES
	TEST W, R3
	BRNZ SDGNW_LOOP
	NOP
	RET

SDGNW_LOOP
	;GET WORD
	LIM H, AUX0, `LH SDRAM_GET_WORD
	LIM L, AUX0, `LL SDRAM_GET_WORD
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
	BRNZ SDGNW_LOOP
	NOP

	RET
	NOP
;#############################################################################

;#############################################################################
SDRAM_SEND_N_WORDS
	;SET AUTO INCREMENT FOR WRITE
	LIM H, AUX0, `LH IOMM2_WRITE_ADDR_INC
	LIM L, AUX0, `LL IOMM2_WRITE_ADDR_INC
	MOVE W, AUX0, IAL
	LIM W, AUX0, $04
	MOVE W, AUX0, ID	;ENABLE AUTO INCREMENT

	;GET THE NUMBER OF WORDS
	LIM H, AUX1, `LH SDRAM_NUM_WORDS
	LIM L, AUX1, `LL SDRAM_NUM_WORDS
	MOVE W, AUX1, DAL
	MOVE W, DD, R3

	;SET STARTING ADDRESS IN MEMORY
	LIM H, AUX0, `LH BUFFER_START
	LIM L, AUX0, `LL BUFFER_START
	MOVE W, AUX0, R5

	;LOOP N TIMES
	TEST W, R3
	BRNZ SDSNW_LOOP
	NOP
	RET

SDSNW_LOOP
	;GET WORD
	MOVE W, R5, DAL
	MOVE W, DD, R0

	;WRITE WORD
	LIM H, AUX0, `LH SDRAM_SEND_WORD
	LIM L, AUX0, `LL SDRAM_SEND_WORD
	MOVE W, AUX0, CAL
	CALL
	NOP

	;INCREMENT DATA ADDRESS
	LIM W, AUX0, $01
	ADD W, R5, R5

	;DECREMENT COUNTER
	LIM W, AUX0, $01
	SUB W, R3, R3

	;CHECK IF ZERO
	BRNZ SDSNW_LOOP
	NOP

	RET
	NOP
;#############################################################################
