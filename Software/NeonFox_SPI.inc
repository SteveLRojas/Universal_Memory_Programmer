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
;* NeonFox_SPI.inc                 LIBRARY FILE   *
;* Copyright (C) 2022 Esteban Looser-Rojas.       *
;* Contains SPI driver for the NeonFox ROM        *
;* programmer project.                            *
;**************************************************

;#############################################################################
; NAME:	spi_configure
; INPUTS:	{6'h00, cpha, cpol, clk_div[7:0]} in R0
; MODIFIES: AUX0, AUX1, IAL
; RETURNS:	NONE
;#############################################################################
;#############################################################################
spi_configure
	lim h, aux0, `lh spi_clk_div
	lim l, aux0, `ll spi_clk_div
	move w, aux0, ial
	move l, r0, id

	lim h, aux0, `lh spi_status
	lim l, aux0, `ll spi_status
	move w, aux0, ial

	lim w, aux0, $06
	rol s, r0, aux1
	and w, aux1, aux1
	lim w, aux0, %00100000
	or w, aux1, aux1
	ret
	move l, aux1, id
;#############################################################################

;#############################################################################
spi_select
	lim h, aux0, `lh spi_ncs
	lim l, aux0, `ll spi_ncs
	move w, aux0, ial
	ret
	move l, r0, id
;#############################################################################

;#############################################################################
spi_transfer
	lim h, aux0, `lh spi_data
	lim l, aux0, `ll spi_data
	move w, aux0, ial
	move l, r0, id

	lim h, aux0, `lh spi_status
	lim l, aux0, `ll spi_status
	move w, aux0, ial
	
	lim w, aux0, $01
	move l, aux0, id

sptr_wait
	bitt w, id, 7
	brz sptr_wait
	lim h, aux0, `lh spi_data
	lim l, aux0, `ll spi_data
	move w, aux0, ial
	ret
	move w, id, r11
;#############################################################################