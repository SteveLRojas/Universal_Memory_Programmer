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
;* I2C_PROGRAMMER.INC            HEADER FILE      *
;* Copyright (C) 2021 Esteban Looser-Rojas.       *
;* Contains register defines for the NeonFox CPU  *
;* and address defines for platform peripherals.  *
;* Addresses are for the I2C_programmer project.  *
;**************************************************

; Address map for IO space:
; 0x0000 to 0xFFCF	unused
; 0xFFD0 to 0xFFDF	unused
; 0xFFE0 to 0xFFEB	unused
; 0xFFEC to 0xFFED	I2C module (read write)
; 0xFFEE to 0xFFEF	interrupt controller (read write)
; 0xFFF0 to 0xFFF3	timer module (read write)
; 0xFFF4 to 0xFFF5	unused
; 0xFFF6 to 0xFFF7	unused
; 0xFFF8 to 0xFFF9	unused
; 0xFFFA to 0xFFFB	led indicators (write only)
; 0xFFFC to 0xFFFD	unused
; 0xFFFE to 0xFFFF	RS-232 module 0	(read write)

; RS-232 module address map
; 0 data register
; 1 status register
;		bit 0: TX overwrite (LSB)
;		bit 1: RX overwrite
;		bit 2: TX ready
;		bit 3: RX ready
;		bit 4: TX queue empty
;		bit 5: RX queue full
;		bit 6: reserved
;		bit 7: busy flag

; Timer module address map
; 0 counter bits 7:0
; 1 counter bits 15:8
; 2 counter bits 23:16
; 3 status
;		bit 0: counter 7:0 not zero
;		bit 1: counter 15:8 not zero
;		bit 2: counter 23:16 not zero
;		bit 3: counter 23:0 not zero
;		bit 4: VSYNC
;		bit 5: HSYNC

; Interrupt controller address map
; 0 status register
; 1 control register

; I2C module address map
; 0 data register
; 1 status and control register
;		bit 0: START
;		bit 1: STOP
;		bit 2: READ_REQ
;		bit 3: WRITE_REQ
;		bit 4: MASTER_ACK
;		bit 5: SLAVE_ACK
;		bit 6: READY

; Address map for data and program space:
; 0x00000000 to 0x00001FFF	16KB main memory
; 0x00002000 to 0xFFFFFFFF	Not implemented

; REMEMBER: PROGRAM AND DATA MEMORIES ARE BOTH WORD ADDRESSABLE!

AUX0	EQU R16
AUX1 	EQU R17
AUX2 	EQU R18
AUX3	EQU R19
DAL		EQU R20
DAH		EQU R21
IAL		EQU R22
IAH		EQU R23
DD		EQU R24
ID		EQU R25
CAL		EQU R26
CAH 	EQU R27
RAL 	EQU R28
RAH 	EQU R29
STATUS 	EQU R30
ZERO	EQU R31

TIMER_COUNT_0 EQU $FFF0
TIMER_COUNT_1 EQU $FFF1
TIMER_COUNT_2 EQU $FFF2
TIMER_STATUS EQU $FFF3

HEX_INDICATORS EQU $FFFA
LED_INDICATORS EQU $FFFB

UART_DATA EQU $FFFE
UART_STATUS EQU $FFFF

INTERRUPT_STATUS EQU $FFEE
INTERRUPT_CONTROL EQU $FFEF

I2C_DATA EQU $FFEC
I2C_STATUS EQU $FFED

ROM_END		EQU $1FFF		;PAD FILE TO 8K WORDS
BUFFER_SIZE	EQU $1000		;BUFFER SIZE IN WORDS
NUM_TARGETS	EQU $01

;VARIABLES
SERIAL_NUM_WORDS	EQU $1FFF

I2C_NUM_WORDS	EQU $1FFE

I2C_ADDRESS_H	EQU $1FFD
I2C_ADDRESS_L	EQU $1FFC

I2C_BYTE_ADDR_H	EQU $1FFB
I2C_BYTE_ADDR_L	EQU $1FFA

WORDS_REMAINING_H	EQU $1FF9
WORDS_REMAINING_L	EQU $1FF8

BUFFER_END			EQU $1FF7
BUFFER_START		EQU $0FF8

FPTR_MEM_SET_ADDR_WRITE		EQU $0FF7

FPTR_MEM_SET_ADDR_READ		EQU $0FF6

FPTR_MEM_GET_N_WORDS	EQU $0FF5

FPTR_MEM_SEND_N_WORDS	EQU $0FF4

FPTR_MEM_ERASE_ALL		EQU $0FF3

FPTR_MEM_UNLOCK_ALL		EQU $0FF2

FPTR_MEM_LOCK_ALL		EQU $0FF1

FPTR_MEM_GET_STATUS		EQU $0FF0

FPTR_MEM_LOCK_BLOCK		EQU $0FEF

FPTR_MEM_ERASE_BLOCK	EQU $0FEE

DPTR_MEM_NUM_WORDS		EQU $0FED

DPTR_MEM_ADDRESS		EQU $0FEC

DPTR_MEMORY_SIZE		EQU $0FEB

DPTR_TARGET_DESCRIPTOR	EQU $0FEA


;MACROS

MACRO PLATFORM_STRINGS
PLATFORM_DESCRIPTOR
	DATA 'G'
	DATA 'e'
	DATA 'n'
	DATA 'e'
	DATA 'r'
	DATA 'i'
	DATA 'c'
	DATA ' '
	DATA 'I'
	DATA '2'
	DATA 'C'
	DATA '\0'

TARGET_DESCRIPTORS
	DATA `LW EEPROM_DESCRIPTOR

EEPROM_DESCRIPTOR
	DATA 'E'
	DATA 'E'
	DATA 'P'
	DATA 'R'
	DATA 'O'
	DATA 'M'
	DATA '\0'

TARGET_SIZE
	DATA $0000	;EEPROM SIZE
	DATA $0002
ENDMACRO PLATFORM_STRINGS

MACRO INIT_PLATFORM
	LIM H, AUX0, `LH CAT_INIT
	LIM L, AUX0, `LL CAT_INIT
	MOVE W, AUX0, CAL
	CALL
	NOP

	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_WRITE
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_WRITE
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH CAT_NULL
	LIM L, AUX0, `LL CAT_NULL
	MOVE W, AUX0, DD		;SET POINTER TO CAT_SET_ADDRESS_WRITE

	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_READ
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_READ
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH CAT_NULL
	LIM L, AUX0, `LL CAT_NULL
	MOVE W, AUX0, DD		;SET POINTER TO CAT_NULL

	LIM H, AUX0, `LH FPTR_MEM_GET_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_GET_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH CAT_GET_N_WORDS
	LIM L, AUX0, `LL CAT_GET_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO CAT_GET_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_SEND_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_SEND_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH CAT_SEND_N_WORDS
	LIM L, AUX0, `LL CAT_SEND_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO CAT_SEND_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_ERASE_ALL
	LIM L, AUX0, `LL FPTR_MEM_ERASE_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH CAT_NULL
	LIM L, AUX0, `LL CAT_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_UNLOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_UNLOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH CAT_NULL
	LIM L, AUX0, `LL CAT_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_LOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH CAT_NULL
	LIM L, AUX0, `LL CAT_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_GET_STATUS
	LIM L, AUX0, `LL FPTR_MEM_GET_STATUS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH CAT_NULL
	LIM L, AUX0, `LL CAT_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_LOCK_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH CAT_NULL
	LIM L, AUX0, `LL CAT_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_ERASE_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_ERASE_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH CAT_NULL
	LIM L, AUX0, `LL CAT_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH DPTR_MEM_NUM_WORDS
	LIM L, AUX0, `LL DPTR_MEM_NUM_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH I2C_NUM_WORDS
	LIM L, AUX0, `LL I2C_NUM_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO CAT_NUM_WORDS

	LIM H, AUX0, `LH DPTR_MEM_ADDRESS
	LIM L, AUX0, `LL DPTR_MEM_ADDRESS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH I2C_ADDRESS_L
	LIM L, AUX0, `LL I2C_ADDRESS_L
	MOVE W, AUX0, DD		;SET POINTER TO CAT_ADDRESS_L

	LIM H, AUX0, `LH DPTR_MEMORY_SIZE
	LIM L, AUX0, `LL DPTR_MEMORY_SIZE
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH TARGET_SIZE
	LIM L, AUX0, `LL TARGET_SIZE
	MOVE W, AUX0, DD		;SET POINTER TO TARGET_SIZE

	LIM H, AUX0, `LH DPTR_TARGET_DESCRIPTOR
	LIM L, AUX0, `LL DPTR_TARGET_DESCRIPTOR
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH TARGET_DESCRIPTORS
	LIM L, AUX0, `LL TARGET_DESCRIPTORS			
	MOVE W, AUX0, DD		;SET POINTER CURRENT TARGET DESCRIPTOR
ENDMACRO INIT_PLATFORM

MACRO SET_TARGET
	NOP	;NOTHING TO DO HERE
ENDMACRO SET_TARGET