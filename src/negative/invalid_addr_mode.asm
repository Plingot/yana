	.inesprg 1
	.ineschr 0
	.inesmir 1
	.inesmap 0

	.org $8000
	.bank 0

Start:
	ldx $1000,Y
	rts
