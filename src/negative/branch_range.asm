	.inesprg 1
	.ineschr 0
	.inesmir 1
	.inesmap 0

	.org $8000
	.bank 0

Start:
	beq FarTarget
	rts

	.org $8100
FarTarget:
	rts
