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
;****************************************************
;* Nexys2_PMOD_Programmer.inc       HEADER FILE     *
;* Copyright (C) 2022 Esteban Looser-Rojas.         *
;* Contains register defines for the NeonFox CPU    *
;* and address defines for platform peripherals.    *
;* Addresses are for the Nexys2 programmer platform.*
;****************************************************

;Address map for IO space:
; 0x0000 to 0xFFD7	unused
; 0xFFD8 to 0xFFDF	IOMM0 (read write)
; 0xFFE0 to 0xFFE7	IOMM1 (read write)
; 0xFFE8 to 0xFFEB	SPI module
; 0xFFEC to 0xFFED	I2C module
; 0xFFEE to 0xFFEF	interrupt controller (read write)
; 0xFFF0 to 0xFFF3	timer module (read write)
; 0xFFF4 to 0xFFF5	keyboard module (read write)
; 0xFFF6 to 0xFFF7	unused
; 0xFFF8 to 0xFFFB	unused
; 0xFFFC to 0xFFFD	hex display (write only)
; 0xFFFE to 0xFFFF	RS-232 module	(read write)

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

; keyboard module address map
; 0 data register
; 1 status register
;		bit 0: TX overwrite (LSB)
;		bit 1: RX overwrite
;		bit 2: TX ready
;		bit 3: RX ready
;		bit 4: TX queue empty
;		bit 5: RX queue full

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

; I2C module address map
; 0 data register
; 1 status register
;		bit 0: START
;		bit 1: STOP
;		bit 2: READ_REQ
;		bit 3: WRITE_REQ
;		bit 4: MASTER_ACK
;		bit 5: SLAVE_ACK
;		bit 6: READY

; SPI module address map
; 0 data register
; 1 status register
;		bit 0: TRANSFER_REQ
;		bit 1: CPOL
;		bit 2: CPHA
;		bit 3: RESERVED
;		bit 4: RESERVED
;		bit 5: CONFIG_EN
;		bit 6: TRANSFER_ACTIVE
;		bit 7: READY
; 2 clock speed register
; 3 device select

; Interrupt controller address map
; 0 status register
; 1 control register

;Address map for data and program space:
; 0x00000000 to 0x00003FFF	32KB main memory
; 0x00004000 to 0xFFFFFFFF	Not implemented

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

KB_DATA EQU $FFF4
KB_STATUS EQU $FFF5

HEX_INDICATORS EQU $FFFC
LED_INDICATORS EQU $FFFD

UART_DATA EQU $FFFE
UART_STATUS EQU $FFFF

INTERRUPT_STATUS EQU $FFEE
INTERRUPT_CONTROL EQU $FFEF

I2C_DATA EQU $FFEC
I2C_STATUS EQU $FFED

SPI_DATA	EQU $FFE8
SPI_STATUS	EQU $FFE9
SPI_CLK_DIV	EQU $FFEA
SPI_NCS		EQU $FFEB

IOMM0_WRITE_ADDR_HIGH 	EQU $FFD8
IOMM0_WRITE_ADDR_LOW 	EQU $FFD9
IOMM0_WRITE_ADDR_INC 	EQU $FFDA
IOMM0_MEM_DATA 			EQU $FFDB
IOMM0_READ_ADDR_HIGH 	EQU $FFDC
IOMM0_READ_ADDR_LOW 	EQU $FFDD
IOMM0_READ_ADDR_INC	 	EQU $FFDE
IOMM0_STATUS 			EQU $FFDF

IOMM1_WRITE_ADDR_HIGH 	EQU $FFE0
IOMM1_WRITE_ADDR_LOW 	EQU $FFE1
IOMM1_WRITE_ADDR_INC 	EQU $FFE2
IOMM1_MEM_DATA 			EQU $FFE3
IOMM1_READ_ADDR_HIGH 	EQU $FFE4
IOMM1_READ_ADDR_LOW 	EQU $FFE5
IOMM1_READ_ADDR_INC	 	EQU $FFE6
IOMM1_STATUS 			EQU $FFE7

ROM_END		EQU $3FFF		;PAD FILE TO 16K WORDS
BUFFER_SIZE	EQU $2000		;BUFFER SIZE IN WORDS
NUM_TARGETS	EQU $04

;VARIABLES
SERIAL_NUM_WORDS	EQU $3FFF

FLASH_NUM_WORDS		EQU $3FFE

PSRAM_ADDRESS_H		EQU $3FFD
PSRAM_ADDRESS_L		EQU $3FFC

FLASH_ADDRESS_H	EQU $3FFB
FLASH_ADDRESS_L	EQU $3FFA

WORDS_REMAINING_H	EQU $3FF9
WORDS_REMAINING_L	EQU $3FF8

BUFFER_END		EQU $3FF7
BUFFER_START	EQU $1FF8

PSRAM_NUM_WORDS		EQU $1FF7

FPTR_MEM_SET_ADDR_WRITE		EQU $1FF6

FPTR_MEM_SET_ADDR_READ		EQU $1FF5

FPTR_MEM_GET_N_WORDS	EQU $1FF4

FPTR_MEM_SEND_N_WORDS	EQU $1FF3

FPTR_MEM_ERASE_ALL		EQU $1FF2

FPTR_MEM_UNLOCK_ALL		EQU $1FF1

FPTR_MEM_LOCK_ALL		EQU $1FF0

FPTR_MEM_GET_STATUS		EQU $1FEF

FPTR_MEM_LOCK_BLOCK		EQU $1FEE

FPTR_MEM_ERASE_BLOCK	EQU $1FED

DPTR_MEM_NUM_WORDS		EQU $1FEC

DPTR_MEM_ADDRESS		EQU $1FEB

DPTR_MEMORY_SIZE		EQU $1FEA

DPTR_TARGET_DESCRIPTOR	EQU $1FE9

I2C_NUM_WORDS	EQU $1FE8

I2C_ADDRESS_H	EQU $1FE7
I2C_ADDRESS_L	EQU $1FE6

I2C_BYTE_ADDR_H	EQU $1FE5
I2C_BYTE_ADDR_L	EQU $1FE4

SPI_NUM_WORDS	EQU $1FE3

SPI_ADDRESS_H	EQU $1FE2
SPI_ADDRESS_L	EQU $1FE1


;MACROS

MACRO PLATFORM_STRINGS
PLATFORM_DESCRIPTOR
	DATA 'D'
	DATA 'I'
	DATA 'G'
	DATA 'I'
	DATA 'L'
	DATA 'E'
	DATA 'N'
	DATA 'T'
	DATA ' '
	DATA 'N'
	DATA 'E'
	DATA 'X'
	DATA 'Y'
	DATA 'S'
	DATA ' '
	DATA '2'
	DATA ' '
	DATA '('
	DATA 'e'
	DATA 'x'
	DATA 't'
	DATA 'e'
	DATA 'n'
	DATA 'd'
	DATA 'e'
	DATA 'd'
	DATA ')'
	DATA '\0'

TARGET_DESCRIPTORS
	DATA `LW FLASH_DESCRIPTOR
	DATA `LW PSRAM_DESCRIPTOR
	DATA `LW I2C_EEPROM_DESCRIPTOR
	DATA `LW SPI_FLASH_DESCRIPTOR

FLASH_DESCRIPTOR
	DATA 'F'
	DATA 'l'
	DATA 'a'
	DATA 's'
	DATA 'h'
	DATA '\0'

PSRAM_DESCRIPTOR
	DATA 'P'
	DATA 'S'
	DATA 'R'
	DATA 'A'
	DATA 'M'
	DATA '\0'

i2c_eeprom_descriptor
	data 'I'
	data '2'
	data 'C'
	data ' '
	data 'E'
	data 'E'
	data 'P'
	data 'R'
	data 'O'
	data 'M'
	data '\0'

spi_flash_descriptor
	data 'S'
	data 'P'
	data 'I'
	data ' '
	data 'F'
	data 'l'
	data 'a'
	data 's'
	data 'h'
	data '\0'

TARGET_SIZE
	DATA $0000	;FLASH SIZE
	DATA $0100
	DATA $0000	;PSRAM SIZE
	DATA $0100
	DATA $0080	;I2C EEPROM
	DATA $0000
	DATA $0000	;SPI FLASH
	DATA $0020

ENDMACRO PLATFORM_STRINGS

MACRO INIT_PLATFORM
	LIM H, AUX0, `LH FLASH_INIT
	LIM L, AUX0, `LL FLASH_INIT
	MOVE W, AUX0, CAL
	CALL
	NOP

	LIM H, AUX0, `LH PSRAM_INIT
	LIM L, AUX0, `LL PSRAM_INIT
	MOVE W, AUX0, CAL
	CALL
	NOP

	LIM H, AUX0, `LH AT_INIT
	LIM L, AUX0, `LL AT_INIT
	MOVE W, AUX0, CAL
	CALL
	NOP

	LIM H, AUX0, `LH BY_INIT
	LIM L, AUX0, `LL BY_INIT
	MOVE W, AUX0, CAL
	CALL
	NOP

	LIM H, AUX0, `LH DPTR_TARGET_DESCRIPTOR
	LIM L, AUX0, `LL DPTR_TARGET_DESCRIPTOR
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH TARGET_DESCRIPTORS
	LIM L, AUX0, `LL TARGET_DESCRIPTORS			
	MOVE W, AUX0, DD		;SET POINTER CURRENT TARGET DESCRIPTOR

	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_WRITE
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_WRITE
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_SET_ADDRESS_WRITE
	LIM L, AUX0, `LL FLASH_SET_ADDRESS_WRITE
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_SET_ADDRESS_WRITE

	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_READ
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_READ
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_SET_ADDRESS_READ
	LIM L, AUX0, `LL FLASH_SET_ADDRESS_READ
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_SET_ADDRESS_READ

	LIM H, AUX0, `LH FPTR_MEM_GET_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_GET_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_GET_N_WORDS
	LIM L, AUX0, `LL FLASH_GET_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_GET_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_SEND_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_SEND_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_SEND_N_WORDS
	LIM L, AUX0, `LL FLASH_SEND_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_SEND_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_ERASE_ALL
	LIM L, AUX0, `LL FPTR_MEM_ERASE_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_ERASE_ALL_BLOCKS
	LIM L, AUX0, `LL FLASH_ERASE_ALL_BLOCKS
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_UNLOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_UNLOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_UNLOCK_ALL_BLOCKS
	LIM L, AUX0, `LL FLASH_UNLOCK_ALL_BLOCKS
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_LOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_LOCK_ALL_BLOCKS
	LIM L, AUX0, `LL FLASH_LOCK_ALL_BLOCKS
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_GET_STATUS
	LIM L, AUX0, `LL FPTR_MEM_GET_STATUS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_NULL
	LIM L, AUX0, `LL FLASH_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_LOCK_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_LOCK_BLOCK
	LIM L, AUX0, `LL FLASH_LOCK_BLOCK
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_ERASE_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_ERASE_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_ERASE_BLOCK
	LIM L, AUX0, `LL FLASH_ERASE_BLOCK
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH DPTR_MEM_NUM_WORDS
	LIM L, AUX0, `LL DPTR_MEM_NUM_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_NUM_WORDS
	LIM L, AUX0, `LL FLASH_NUM_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_NUM_WORDS

	LIM H, AUX0, `LH DPTR_MEM_ADDRESS
	LIM L, AUX0, `LL DPTR_MEM_ADDRESS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_ADDRESS_L
	LIM L, AUX0, `LL FLASH_ADDRESS_L
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_ADDRESS_L

	LIM H, AUX0, `LH DPTR_MEMORY_SIZE
	LIM L, AUX0, `LL DPTR_MEMORY_SIZE
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH TARGET_SIZE
	LIM L, AUX0, `LL TARGET_SIZE
	MOVE W, AUX0, DD		;SET POINTER TO TARGET_SIZE
ENDMACRO INIT_PLATFORM

MACRO SET_TARGET
	LIM W, AUX0, $03
	XOR L, R11, AUX0
	BRZ M_ST_SPI_FLASH

	LIM W, AUX0, $02
	XOR L, R11, AUX0
	BRZ M_ST_I2C_EEPROM

	LIM W, AUX0, $01
	XOR L, R11, AUX0
	BRZ M_ST_PSRAM

M_ST_FLASH
	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_WRITE
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_WRITE
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_SET_ADDRESS_WRITE
	LIM L, AUX0, `LL FLASH_SET_ADDRESS_WRITE
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_SET_ADDRESS_WRITE

	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_READ
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_READ
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_SET_ADDRESS_READ
	LIM L, AUX0, `LL FLASH_SET_ADDRESS_READ
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_SET_ADDRESS_READ

	LIM H, AUX0, `LH FPTR_MEM_GET_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_GET_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_GET_N_WORDS
	LIM L, AUX0, `LL FLASH_GET_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_GET_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_SEND_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_SEND_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_SEND_N_WORDS
	LIM L, AUX0, `LL FLASH_SEND_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_SEND_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_ERASE_ALL
	LIM L, AUX0, `LL FPTR_MEM_ERASE_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_ERASE_ALL_BLOCKS
	LIM L, AUX0, `LL FLASH_ERASE_ALL_BLOCKS
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_UNLOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_UNLOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_UNLOCK_ALL_BLOCKS
	LIM L, AUX0, `LL FLASH_UNLOCK_ALL_BLOCKS
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_LOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_LOCK_ALL_BLOCKS
	LIM L, AUX0, `LL FLASH_LOCK_ALL_BLOCKS
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_GET_STATUS
	LIM L, AUX0, `LL FPTR_MEM_GET_STATUS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_NULL
	LIM L, AUX0, `LL FLASH_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_LOCK_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_LOCK_BLOCK
	LIM L, AUX0, `LL FLASH_LOCK_BLOCK
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_ERASE_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_ERASE_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_ERASE_BLOCK
	LIM L, AUX0, `LL FLASH_ERASE_BLOCK
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH DPTR_MEM_NUM_WORDS
	LIM L, AUX0, `LL DPTR_MEM_NUM_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_NUM_WORDS
	LIM L, AUX0, `LL FLASH_NUM_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_NUM_WORDS

	LIM H, AUX0, `LH DPTR_MEM_ADDRESS
	LIM L, AUX0, `LL DPTR_MEM_ADDRESS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH FLASH_ADDRESS_L
	LIM L, AUX0, `LL FLASH_ADDRESS_L
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_ADDRESS_L
	BRA M_ST_END

M_ST_PSRAM
	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_WRITE
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_WRITE
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_SET_ADDRESS_WRITE
	LIM L, AUX0, `LL PSRAM_SET_ADDRESS_WRITE
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_SET_ADDRESS_WRITE

	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_READ
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_READ
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_SET_ADDRESS_READ
	LIM L, AUX0, `LL PSRAM_SET_ADDRESS_READ
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_SET_ADDRESS_READ

	LIM H, AUX0, `LH FPTR_MEM_GET_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_GET_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_GET_N_WORDS
	LIM L, AUX0, `LL PSRAM_GET_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_GET_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_SEND_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_SEND_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_SEND_N_WORDS
	LIM L, AUX0, `LL PSRAM_SEND_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_SEND_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_ERASE_ALL
	LIM L, AUX0, `LL FPTR_MEM_ERASE_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_NULL
	LIM L, AUX0, `LL PSRAM_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_UNLOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_UNLOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_NULL
	LIM L, AUX0, `LL PSRAM_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_LOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_NULL
	LIM L, AUX0, `LL PSRAM_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_GET_STATUS
	LIM L, AUX0, `LL FPTR_MEM_GET_STATUS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_NULL
	LIM L, AUX0, `LL PSRAM_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_LOCK_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_NULL
	LIM L, AUX0, `LL PSRAM_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_ERASE_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_ERASE_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_NULL
	LIM L, AUX0, `LL PSRAM_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH DPTR_MEM_NUM_WORDS
	LIM L, AUX0, `LL DPTR_MEM_NUM_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_NUM_WORDS
	LIM L, AUX0, `LL PSRAM_NUM_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_NUM_WORDS

	LIM H, AUX0, `LH DPTR_MEM_ADDRESS
	LIM L, AUX0, `LL DPTR_MEM_ADDRESS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH PSRAM_ADDRESS_L
	LIM L, AUX0, `LL PSRAM_ADDRESS_L
	MOVE W, AUX0, DD		;SET POINTER TO SDRAM_ADDRESS_L
	BRA M_ST_END

M_ST_I2C_EEPROM
	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_WRITE
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_WRITE
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH AT_NULL
	LIM L, AUX0, `LL AT_NULL
	MOVE W, AUX0, DD		;SET POINTER TO CAT_SET_ADDRESS_WRITE

	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_READ
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_READ
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH AT_NULL
	LIM L, AUX0, `LL AT_NULL
	MOVE W, AUX0, DD		;SET POINTER TO CAT_NULL

	LIM H, AUX0, `LH FPTR_MEM_GET_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_GET_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH AT_GET_N_WORDS
	LIM L, AUX0, `LL AT_GET_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO CAT_GET_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_SEND_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_SEND_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH AT_SEND_N_WORDS
	LIM L, AUX0, `LL AT_SEND_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO CAT_SEND_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_ERASE_ALL
	LIM L, AUX0, `LL FPTR_MEM_ERASE_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH AT_NULL
	LIM L, AUX0, `LL AT_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_UNLOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_UNLOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH AT_NULL
	LIM L, AUX0, `LL AT_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_LOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH AT_NULL
	LIM L, AUX0, `LL AT_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_GET_STATUS
	LIM L, AUX0, `LL FPTR_MEM_GET_STATUS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH AT_NULL
	LIM L, AUX0, `LL AT_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_LOCK_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH AT_NULL
	LIM L, AUX0, `LL AT_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_ERASE_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_ERASE_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH AT_NULL
	LIM L, AUX0, `LL AT_NULL
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
	BRA M_ST_END

M_ST_SPI_FLASH
	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_WRITE
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_WRITE
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH BY_NULL
	LIM L, AUX0, `LL BY_NULL
	MOVE W, AUX0, DD		;SET POINTER TO CAT_SET_ADDRESS_WRITE

	LIM H, AUX0, `LH FPTR_MEM_SET_ADDR_READ
	LIM L, AUX0, `LL FPTR_MEM_SET_ADDR_READ
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH BY_NULL
	LIM L, AUX0, `LL BY_NULL
	MOVE W, AUX0, DD		;SET POINTER TO CAT_NULL

	LIM H, AUX0, `LH FPTR_MEM_GET_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_GET_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH BY_GET_N_WORDS
	LIM L, AUX0, `LL BY_GET_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO CAT_GET_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_SEND_N_WORDS
	LIM L, AUX0, `LL FPTR_MEM_SEND_N_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH BY_SEND_N_WORDS
	LIM L, AUX0, `LL BY_SEND_N_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO CAT_SEND_N_WORDS

	LIM H, AUX0, `LH FPTR_MEM_ERASE_ALL
	LIM L, AUX0, `LL FPTR_MEM_ERASE_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH BY_ERASE_ALL_BLOCKS
	LIM L, AUX0, `LL BY_ERASE_ALL_BLOCKS
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_UNLOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_UNLOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH BY_NULL
	LIM L, AUX0, `LL BY_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_ALL
	LIM L, AUX0, `LL FPTR_MEM_LOCK_ALL
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH BY_NULL
	LIM L, AUX0, `LL BY_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_GET_STATUS
	LIM L, AUX0, `LL FPTR_MEM_GET_STATUS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH BY_NULL
	LIM L, AUX0, `LL BY_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_LOCK_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_LOCK_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH BY_NULL
	LIM L, AUX0, `LL BY_NULL
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH FPTR_MEM_ERASE_BLOCK
	LIM L, AUX0, `LL FPTR_MEM_ERASE_BLOCK
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH BY_SECTOR_ERASE_COMMAND
	LIM L, AUX0, `LL BY_SECTOR_ERASE_COMMAND
	MOVE W, AUX0, DD

	LIM H, AUX0, `LH DPTR_MEM_NUM_WORDS
	LIM L, AUX0, `LL DPTR_MEM_NUM_WORDS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH SPI_NUM_WORDS
	LIM L, AUX0, `LL SPI_NUM_WORDS
	MOVE W, AUX0, DD		;SET POINTER TO CAT_NUM_WORDS

	LIM H, AUX0, `LH DPTR_MEM_ADDRESS
	LIM L, AUX0, `LL DPTR_MEM_ADDRESS
	MOVE W, AUX0, DAL
	LIM H, AUX0, `LH SPI_ADDRESS_L
	LIM L, AUX0, `LL SPI_ADDRESS_L
	MOVE W, AUX0, DD		;SET POINTER TO CAT_ADDRESS_L

M_ST_END
	LIM H, AUX0, `LH DPTR_MEMORY_SIZE
	LIM L, AUX0, `LL DPTR_MEMORY_SIZE
	MOVE W, AUX0, DAL
	MOVE L, R11, AUX0
	ADD L, R11, AUX0
	LIM H, AUX1, `LH TARGET_SIZE
	LIM L, AUX1, `LL TARGET_SIZE
	MOVE H, ZERO, AUX0
	ADD W, AUX1, DD

	LIM H, AUX0, `LH DPTR_TARGET_DESCRIPTOR
	LIM L, AUX0, `LL DPTR_TARGET_DESCRIPTOR
	MOVE W, AUX0, DAL
	MOVE L, R11, AUX0
	LIM H, AUX1, `LH TARGET_DESCRIPTORS
	LIM L, AUX1, `LL TARGET_DESCRIPTORS
	MOVE H, ZERO, AUX0
	ADD W, AUX1, DD	
ENDMACRO SET_TARGET