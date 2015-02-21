	.inesprg	2
	.ineschr	1
	.inesmir	1
	.inesmap	0

	.org $8000
	.bank 0


Start:
	; this setups the PPU
	lda #%00001000
	sta $2000
	lda #%00011110
	sta $2001

	; set to start of palette
	lda #$3f
	sta $2006
	lda #$00
	sta $2006

	; these are the write that setup the palette
	lda #$01
	sta $2007
	lda #$02
	sta $2007
	lda #$03
	sta $2007
	lda #$04
	sta $2007
	lda #$05
	sta $2007
	lda #$06
	sta $2007
	lda #$07
	sta $2007
	lda #$08
	sta $2007
	lda #$01	; stop here
	sta $2007
	lda #$08
	sta $2007
	lda #$09
	sta $2007
	lda #$0a
	sta $2007
	lda #$01
	sta $2007
	lda #$0b
	sta $2007
	lda #$0c
	sta $2007
	lda #$0d
	sta $2007
	lda #$01	; Start sprite colors
	sta $2007
	lda #$0d
	lda #$08
	sta $2007
	lda #$2b
	sta $2007
	lda #$01
	sta $2007
	lda #$05
	sta $2007
	lda #$06
	sta $2007
	lda #$07
	sta $2007
	lda #$01
	sta $2007
	lda #$08
	sta $2007
	lda #$09
	sta $2007
	lda #$0a
	sta $2007
	lda #$01
	sta $2007
	lda #$0b
	sta $2007
	lda #$0c
	sta $2007
	lda #$0d
	sta $2007

vwait:
	lda $2002	;wait
	bpl vwait

	lda #$20	;set ppu to start of VRAM
	sta $2006
	lda #$20
	sta $2006

	lda #$48	;write pattern table tile numbers to the name table
	sta $2007
	lda #$65
	sta $2007
	lda #$6c
	sta $2007
	lda #$6c
	sta $2007
	lda #$6f
	sta $2007

	lda #$00	;set $2004 to the start of SPR-RAM
	stx $2003
	;stx $2003

	lda #$7f	;y-1
	sta $2004
	lda #$02	;sprite pattern number
	sta $2004
	lda #%00000011	;color bit
	sta $2004
	lda #$08	;x
	sta $2004


Loop:
	jmp Loop


		; Vector table
	.bank	1
	.org	$fffa
	.dw		0			; (NMI_Routine)
	.dw		Start		; (Reset_Routine)
	.dw		0			; (IRQ_Routine)


	.bank 2
	.org	$0000
	.incbin	"test.chr"		; gotta be 8192 bytes long
