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
;* NeonFox_BY25Q16.inc             LIBRARY FILE   *
;* Copyright (C) 2022 Esteban Looser-Rojas.       *
;* Contains SPI flash driver for the NeonFox      *
;* ROM programmer project.                        *
;**************************************************

;#############################################################################
by_null
	lim h, aux0, $E0
	lim l, aux0, $00
	ret
	move w, aux0, r11
;#############################################################################

;#############################################################################
by_init
	lim h, aux0, `lh spi_configure
	lim l, aux0, `ll spi_configure
	move w, aux0, cal

	;lim l, aux0, $00	;set clock divider to 0 (spi clock = sys clock / 2)
	lim l, aux0, $01	;set clock divider to 1 (spi clock = sys clock / 2)
	lim h, aux0, $00	;cpol = 0, cpha = 0

	call
	move w, aux0, r0

	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	move w, zero, r0
	call
	not w, r0, r0

	ret
	nop
;#############################################################################

;#############################################################################
by_read_command
	lim h, aux0, `lh spi_transfer
	lim l, aux0, `ll spi_transfer
	move w, aux0, cal

	lim w, aux0, $03	;read command
	call
	move w, aux0, r0

	lim h, aux0, `lh spi_address_h
	lim l, aux0, `ll spi_address_h
	move w, aux0, dal
	move w, dd, aux1

	lim h, aux0, `lh spi_address_l
	lim l, aux0, `ll spi_address_l
	move w, aux0, dal
	move w, dd, aux2

	move w, aux2, aux0	;calculate address in bytes
	add w, aux2, aux2
	move w, aux1, aux0
	addc w, aux1, aux1	;multiply by 2

	call
	move l, aux1, r0	;send address

	call
	move s, aux2, r0

	call
	move l, aux2, r0

	ret
	nop
;#############################################################################

;#############################################################################
by_write_command
	lim h, aux0, `lh spi_transfer
	lim l, aux0, `ll spi_transfer
	move w, aux0, cal

	lim w, aux0, $02	;write command
	call
	move w, aux0, r0

	lim h, aux0, `lh spi_address_h
	lim l, aux0, `ll spi_address_h
	move w, aux0, dal
	move w, dd, aux1

	lim h, aux0, `lh spi_address_l
	lim l, aux0, `ll spi_address_l
	move w, aux0, dal
	move w, dd, aux2

	move w, aux2, aux0	;calculate address in bytes
	add w, aux2, aux2
	move w, aux1, aux0
	addc w, aux1, aux1	;multiply by 2

	call
	move l, aux1, r0	;send address

	call
	move s, aux2, r0

	call
	move l, aux2, r0

	ret
	nop
;#############################################################################

;#############################################################################
by_get_n_words
	;get the number of words
	lim h, aux0, `lh spi_num_words
	lim l, aux0, `ll spi_num_words
	move w, aux0, dal
	move w, dd, r3	;number of words goes in r3

	;get spi address
	lim h, aux0, `lh spi_address_h
	lim l, aux0, `ll spi_address_h
	move w, aux0, dal
	move w, dd, r5	;spi address high goes in r5

	lim h, aux0, `lh spi_address_l
	lim l, aux0, `ll spi_address_l
	move w, aux0, dal
	move w, dd, r4	;spi address low goes in r4

	;set starting address in memory
	lim h, aux0, `lh buffer_start
	lim l, aux0, `ll buffer_start
	move w, aux0, r6	;address in memory goes in r6

	;loop n times
	test w, r3
	brz bygnw_done

	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	lim w, aux0, $FE	;enable device
	call
	move w, aux0, r0

	lim h, aux0, `lh by_read_command
	lim l, aux0, `ll by_read_command
	move w, aux0, cal
	call
	nop

bygnw_loop
	;get word
	lim h, aux0, `lh spi_transfer
	lim l, aux0, `ll spi_transfer
	move w, aux0, cal

	call
	move w, zero, r0
	move l, r11, r7

	call
	move w, zero, r0
	move s, r11, r11
	move h, r11, r7

	;write word
	move w, r6, dal
	move w, r7, dd

	;increment data address
	lim w, aux0, $01
	add w, r6, r6

	;increment spi address
	lim w, aux0, $01
	add w, r4, r4
	lim w, aux0, $00
	addc w, r5, r5

	;decrement counter
	lim w, aux0, $01
	sub w, r3, r3

	;check if zero
	brnz bygnw_loop

	;update spi address
	lim h, aux0, `lh spi_address_h
	lim l, aux0, `ll spi_address_h
	move w, aux0, dal
	move w, r5, dd
	lim h, aux0, `lh spi_address_l
	lim l, aux0, `ll spi_address_l
	move w, aux0, dal
	move w, r4, dd

	;disable device
	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	lim w, aux0, $FF	;disable device
	call
	move w, aux0, r0

bygnw_done
	ret
	nop
;#############################################################################

;#############################################################################
by_send_n_words
	;get the number of words
	lim h, aux0, `lh spi_num_words
	lim l, aux0, `ll spi_num_words
	move w, aux0, dal
	move w, dd, r3	;number of words goes in r3

	;get spi address
	lim h, aux0, `lh spi_address_h
	lim l, aux0, `ll spi_address_h
	move w, aux0, dal
	move w, dd, r5	;spi address high goes in r5

	lim h, aux0, `lh spi_address_l
	lim l, aux0, `ll spi_address_l
	move w, aux0, dal
	move w, dd, r4	;spi address low goes in r4

	;set starting address in memory
	lim h, aux0, `lh buffer_start
	lim l, aux0, `ll buffer_start
	move w, aux0, r6	;address in memory goes in r6

	;loop n times
	test w, r3
	brnz bywnb_start
	nop
	ret

bywnb_loop
	;get word
	move w, r6, dal
	move w, dd, r7

	;write word
	lim h, aux0, `lh spi_transfer
	lim l, aux0, `ll spi_transfer
	move w, aux0, cal

	call
	move l, r7, r0

	call
	move s, r7, r0

	;increment data address
	lim w, aux0, $01
	add w, r6, r6

	;increment spi address
	lim w, aux0, $01
	add w, r4, r4
	lim w, aux0, $00
	addc w, r5, r5

	;decrement counter
	lim w, aux0, $01
	sub w, r3, r3

	;check if zero
	brnz bywnb_nd
	nop

	;update spi address
	lim h, aux0, `lh spi_address_h
	lim l, aux0, `ll spi_address_h
	move w, aux0, dal
	move w, r5, dd
	lim h, aux0, `lh spi_address_l
	lim l, aux0, `ll spi_address_l
	move w, aux0, dal
	move w, r4, dd

	;disable device
	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	lim w, aux0, $FF	;disable device
	call
	move w, aux0, r0

	ret
	nop

bywnb_nd
	lim w, aux0, $7F	;check for 256 byte page boundary
	and w, r4, aux0
	brnz bywnb_loop

	;update spi address
	lim h, aux0, `lh spi_address_h
	lim l, aux0, `ll spi_address_h
	move w, aux0, dal
	move w, r5, dd
	lim h, aux0, `lh spi_address_l
	lim l, aux0, `ll spi_address_l
	move w, aux0, dal
	move w, r4, dd

	;disable device
	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	lim w, aux0, $FF	;disable device
	call
	move w, aux0, r0

bywnb_start
	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	lim w, aux0, $FE	;enable device
	call
	move w, aux0, r0

	lim h, aux0, `lh spi_transfer
	lim l, aux0, `ll spi_transfer
	move w, aux0, cal

	lim w, aux0, $05	;read status command
	call
	move w, aux0, r0

bywnb_wait
	call
	move w, zero, r0
	bitt w, r11, 0	;check WIP bit
	brnz bywnb_wait

	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	lim w, aux0, $FF	;disable device
	call
	move w, aux0, r0

	lim w, aux0, $FE	;enable device
	call
	move w, aux0, r0

	lim h, aux0, `lh spi_transfer
	lim l, aux0, `ll spi_transfer
	move w, aux0, cal

	lim w, aux0, $06	;write enable command
	call
	move w, aux0, r0

	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	lim w, aux0, $FF	;disable device
	call
	move w, aux0, r0

	lim w, aux0, $FE	;enable device
	call
	move w, aux0, r0

	lim h, aux0, `lh by_write_command
	lim l, aux0, `ll by_write_command
	move w, aux0, cal
	call
	nop

	bra bywnb_loop
	nop
;#############################################################################

;#############################################################################
by_sector_erase_command
	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	lim w, aux0, $FE	;enable device
	call
	move w, aux0, r0

	lim h, aux0, `lh spi_transfer
	lim l, aux0, `ll spi_transfer
	move w, aux0, cal

	lim w, aux0, $05	;read status command
	call
	move w, aux0, r0

bysec_wait
	call
	move w, zero, r0
	bitt w, r11, 0	;check WIP bit
	brnz bysec_wait

	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	lim w, aux0, $FF	;disable device
	call
	move w, aux0, r0

	lim w, aux0, $FE	;enable device
	call
	move w, aux0, r0

	lim h, aux0, `lh spi_transfer
	lim l, aux0, `ll spi_transfer
	move w, aux0, cal

	lim w, aux0, $06	;write enable command
	call
	move w, aux0, r0

	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	lim w, aux0, $FF	;disable device
	call
	move w, aux0, r0

	lim w, aux0, $FE	;enable device
	call
	move w, aux0, r0

	lim h, aux0, `lh spi_transfer
	lim l, aux0, `ll spi_transfer
	move w, aux0, cal

	lim w, aux0, $20	;sector erase command
	call
	move w, aux0, r0

	lim h, aux0, `lh spi_address_h
	lim l, aux0, `ll spi_address_h
	move w, aux0, dal
	move w, dd, aux1

	lim h, aux0, `lh spi_address_l
	lim l, aux0, `ll spi_address_l
	move w, aux0, dal
	move w, dd, aux2

	move w, aux2, aux0	;calculate address in bytes
	add w, aux2, aux2
	move w, aux1, aux0
	addc w, aux1, aux1	;multiply by 2

	call
	move l, aux1, r0	;send address

	call
	move s, aux2, r0

	call
	move l, aux2, r0

	lim h, aux0, `lh spi_select
	lim l, aux0, `ll spi_select
	move w, aux0, cal

	lim w, aux0, $FF	;disable device
	call
	move w, aux0, r0

	ret
	nop
;#############################################################################

;#############################################################################
by_erase_all_blocks
	lim h, aux0, `lh spi_address_h
	lim l, aux0, `ll spi_address_h
	move w, aux0, dal
	move w, zero, dd

	lim h, aux0, `lh spi_address_l
	lim l, aux0, `ll spi_address_l
	move w, aux0, dal
	move w, zero, dd

byeab_loop
	lim h, aux0, `lh by_sector_erase_command
	lim l, aux0, `ll by_sector_erase_command
	move w, aux0, cal
	call
	nop

	lim h, aux0, `lh spi_address_h
	lim l, aux0, `ll spi_address_h
	move w, aux0, dal
	move w, dd, r3

	lim h, aux0, `lh spi_address_l
	lim l, aux0, `ll spi_address_l
	move w, aux0, dal
	move w, dd, r4

	move s, r3, aux1
	move s, r4, aux0
	move l, aux0, aux1

	lim h, aux0, `lh hex_indicators
	lim l, aux0, `ll hex_indicators
	move w, aux0, ial
	move w, aux1, id

	lim h, aux0, $08
	lim l, aux0, $00
	add w, r4, r4
	move w, zero, aux0
	addc w, r3, r3

	lim h, aux0, `lh spi_address_h
	lim l, aux0, `ll spi_address_h
	move w, aux0, dal
	move w, r3, dd

	lim h, aux0, `lh spi_address_l
	lim l, aux0, `ll spi_address_l
	move w, aux0, dal
	move w, r4, dd

	bitt w, r3, 4
	brz byeab_loop
	nop

	ret
	nop
;#############################################################################