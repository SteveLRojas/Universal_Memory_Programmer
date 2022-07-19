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
;* DRAGONBOARD_SDRAM64.INC          LIBRARY FILE  *
;* Copyright (C) 2022 Esteban Looser-Rojas.       *
;* Contains SDRAM driver for the DragonBoard      *
;* programmer project based on NeonFox CPU.       *
;**************************************************

;#############################################################################
SDRAM_NULL
	LIM H, AUX0, $E0
	LIM L, AUX0, $00
	RET
	MOVE W, AUX0, R11
;#############################################################################

;#############################################################################
SDRAM_INIT
	; CLEAR WRITE ADDRESS
	LIM H, AUX1, `LH IOMM64_WRITE_ADDR_HIGH
	LIM L, AUX1, `LL IOMM64_WRITE_ADDR_HIGH
	MOVE W, AUX1, IAL
	MOVE W, ZERO, ID

	LIM H, AUX1, `LH IOMM64_WRITE_ADDR_LOW
	LIM L, AUX1, `LL IOMM64_WRITE_ADDR_LOW
	MOVE W, AUX1, IAL
	MOVE W, ZERO, ID

	LIM H, AUX0, `LH IOMM64_WRITE_ADDR_INC
	LIM L, AUX0, `LL IOMM64_WRITE_ADDR_INC
	MOVE W, AUX0, IAL
	MOVE W, ZERO, ID	;DISABLE AUTO INCREMENT

	LIM H, AUX0, `LH IOMM64_READ_ADDR_INC
	LIM L, AUX0, `LL IOMM64_READ_ADDR_INC
	MOVE W, AUX0, IAL
	MOVE W, ZERO, ID	;DISABLE AUTO INCREMENT

	LIM H, AUX0, `LH SDRAM_WORD_OFFSET
	LIM L, AUX0, `LL SDRAM_WORD_OFFSET
	MOVE W, AUX0, DAL
	MOVE W, ZERO, DD	;CLEAR WORD OFFSET

	RET
	NOP
;#############################################################################

;#############################################################################
SDRAM_SET_ADDRESS_WRITE
	LIM H, AUX0, `LH SDRAM_ADDRESS_H		
	LIM L, AUX0, `LL SDRAM_ADDRESS_H
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX1

	LIM H, AUX0, `LH SDRAM_ADDRESS_L
	LIM L, AUX0, `LL SDRAM_ADDRESS_L
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX2

	; DIVIDE 4-BYTE NUMBER BY 4
	ROR W, AUX2, AUX2
	ROR W, AUX2, AUX2	;ROTATE LOW REG (BIT 0 BECOMES BIT 14)
	LIM H, AUX0, $3F
	LIM L, AUX0, $FF
	AND W, AUX2, AUX2	;CLEAR BIT 15 AND 14 OF LOW REG

	ROR W, AUX1, AUX1
	ROR W, AUX1, AUX1	;ROTATE HIGH REG
	NOT W, AUX0, AUX0
	AND W, AUX1, AUX0	;GOT BITS WE SHIFTED OUT FROM HIGH REG - STORE IN AUX0[15:14]
	OR W, AUX2, AUX2	;PUT BIT IN LOW REG[15:14]

	LIM H, AUX0, $3F
	LIM L, AUX0, $FF
	AND W, AUX1, AUX1 	;CLEAR BITS [15:14] OF HIGH REG

	LIM H, AUX0, `LH IOMM64_WRITE_ADDR_HIGH
	LIM L, AUX0, `LL IOMM64_WRITE_ADDR_HIGH
	MOVE W, AUX0, IAL
	MOVE W, AUX1, ID

	LIM H, AUX0, `LH IOMM64_WRITE_ADDR_LOW
	LIM L, AUX0, `LL IOMM64_WRITE_ADDR_LOW
	MOVE W, AUX0, IAL
	MOVE W, AUX2, ID

	RET
	NOP
;#############################################################################

;#############################################################################
SDRAM_SET_ADDRESS_READ
	;SET AUTO INCREMENT FOR READ
	LIM H, AUX0, `LH IOMM64_READ_ADDR_INC
	LIM L, AUX0, `LL IOMM64_READ_ADDR_INC
	MOVE W, AUX0, IAL
	LIM W, AUX0, $00
	MOVE W, AUX0, ID	;DISABLE AUTO INCREMENT

	LIM H, AUX0, `LH SDRAM_ADDRESS_H		
	LIM L, AUX0, `LL SDRAM_ADDRESS_H
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX1

	LIM H, AUX0, `LH SDRAM_ADDRESS_L
	LIM L, AUX0, `LL SDRAM_ADDRESS_L
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX2

	; DIVIDE 4-BYTE NUMBER BY 4
	ROR W, AUX2, AUX2
	ROR W, AUX2, AUX2	;ROTATE LOW REG (BIT 0 BECOMES BIT 14)
	LIM H, AUX0, $3F
	LIM L, AUX0, $FF
	AND W, AUX2, AUX2	;CLEAR BIT 15 AND 14 OF LOW REG

	ROR W, AUX1, AUX1
	ROR W, AUX1, AUX1	;ROTATE HIGH REG
	NOT W, AUX0, AUX0
	AND W, AUX1, AUX0	;GOT BITS WE SHIFTED OUT FROM HIGH REG - STORE IN AUX0[15:14]
	OR W, AUX2, AUX2	;PUT BIT IN LOW REG[15:14]

	LIM H, AUX0, $3F
	LIM L, AUX0, $FF
	AND W, AUX1, AUX1 	;CLEAR BITS [15:14] OF HIGH REG

	LIM H, AUX0, `LH IOMM64_READ_ADDR_HIGH
	LIM L, AUX0, `LL IOMM64_READ_ADDR_HIGH
	MOVE W, AUX0, IAL
	MOVE W, AUX1, ID

	LIM H, AUX0, `LH IOMM64_READ_ADDR_LOW
	LIM L, AUX0, `LL IOMM64_READ_ADDR_LOW
	MOVE W, AUX0, IAL
	MOVE W, AUX2, ID		;WRITING TO IOMM64_READ_ADDR_LOW TRIGGERS A READ

	LIM H, AUX0, `LH IOMM64_STATUS
	LIM L, AUX0, `LL IOMM64_STATUS
	MOVE W, AUX0, IAL
SDSAR_WAIT
	BITT W, ID, 1		;CHECK READ READY FLAG
	BRZ SDSAR_WAIT		;IF NOT SET KEEP WAITING
	NOP

	RET
	NOP
;#############################################################################

;#############################################################################
SDRAM_GET_WORD
	LIM H, AUX0, `LH SDRAM_WORD_OFFSET
	LIM L, AUX0, `LL SDRAM_WORD_OFFSET
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX1

	LIM W, AUX0, $01
	SUB W, AUX1, AUX1

	BRNN SDGW_UPDATE
	LIM H, AUX0, `LH IOMM64_STATUS
	LIM L, AUX0, `LL IOMM64_STATUS
	MOVE W, AUX0, IAL
	MOVE W, ZERO, ID	;WRITE TO STATUS REGISTER TO INITIATE READ
SDGW_WAIT
	BITT W, ID, 1		;CHECK READ READY FLAG
	BRZ SDGW_WAIT		;IF NOT SET KEEP WAITING
	LIM W, AUX1, $03	;SET WORD OFFSET TO 3

SDGW_UPDATE
	MOVE W, AUX1, DD	;UPDATE WORD OFFSET

	LIM H, AUX0, `LH IOMM64_MEM_DATA0
	LIM L, AUX0, `LL IOMM64_MEM_DATA0
	ADD W, AUX1, AUX0
	MOVE W, AUX0, IAL
	RET
	MOVE W, ID, R11
;#############################################################################

;#############################################################################
SDRAM_SEND_WORD
	LIM H, AUX0, `LH SDRAM_WORD_OFFSET
	LIM L, AUX0, `LL SDRAM_WORD_OFFSET
	MOVE W, AUX0, DAL
	MOVE W, DD, AUX1

	LIM W, AUX0, $01
	SUB W, AUX1, AUX1

	BRNN SDSW_UPDATE
	NOP
	LIM W, AUX1, $03	;SET WORD OFFSET TO 3

SDSW_UPDATE
	MOVE W, AUX1, DD	;UPDATE WORD OFFSET

	LIM H, AUX0, `LH IOMM64_MEM_DATA0
	LIM L, AUX0, `LL IOMM64_MEM_DATA0
	ADD W, AUX1, AUX0
	MOVE W, AUX0, IAL
	TEST W, AUX1
	BRZ SDSW_STATUS
	MOVE L, R0, ID
	RET

SDSW_STATUS
	LIM H, AUX0, `LH IOMM64_STATUS
	LIM L, AUX0, `LL IOMM64_STATUS
	MOVE W, AUX0, IAL
	MOVE W, ZERO, ID	;WRITE TO STATUS REGISTER TO INITIATE READ
SDSW_WAIT
	BITT W, ID, 1		;CHECK READ READY FLAG
	BRZ SDSW_WAIT		;IF NOT SET KEEP WAITING
	NOP

	RET
	NOP
;#############################################################################

;#############################################################################
SDRAM_GET_N_WORDS
	;SET AUTO INCREMENT FOR READ
	LIM H, AUX0, `LH IOMM64_READ_ADDR_INC
	LIM L, AUX0, `LL IOMM64_READ_ADDR_INC
	MOVE W, AUX0, IAL
	LIM W, AUX0, $01
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
	LIM H, AUX1, `HH SDRAM_GET_WORD
	LIM L, AUX1, `HL SDRAM_GET_WORD
	LIM H, AUX0, `LH SDRAM_GET_WORD
	LIM L, AUX0, `LL SDRAM_GET_WORD
	MOVE W, AUX1, CAH
	MOVE W, AUX0, CAL
	CALL
	NOP

	;WRITE WORD 
	LIM W, AUX0, $03 	; Fix order [0,1,2,3] -> [3,2,1,0]
	XOR W, R5, DAL
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
	LIM H, AUX0, `LH IOMM64_WRITE_ADDR_INC
	LIM L, AUX0, `LL IOMM64_WRITE_ADDR_INC
	MOVE W, AUX0, IAL
	LIM W, AUX0, $01
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
	LIM W, AUX0, $03
	XOR W, R5, DAL
	MOVE W, DD, R0

	;WRITE WORD
	LIM H, AUX1, `HH SDRAM_SEND_WORD
	LIM L, AUX1, `HL SDRAM_SEND_WORD
	LIM H, AUX0, `LH SDRAM_SEND_WORD
	LIM L, AUX0, `LL SDRAM_SEND_WORD
	MOVE W, AUX1, CAH
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
