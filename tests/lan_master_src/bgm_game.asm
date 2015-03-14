bgm_game_module
	.dw .chn0,.chn1,.chn2,.chn3,.chn4,.ins
	.db $06
.env_default
	.db $c0,$7f,$00
.env_vol0
	.db $cf,$04,$c0,$7f,$02
.env_vol1
	.db $c1,$c0,$c1,$03,$c0,$c1,$c0,$c1,$c0,$c1,$03,$c0,$c1,$04,$c0,$c1
	.db $04,$c0,$c1,$08,$c0,$c2,$c1,$c2,$03,$c1,$c2,$03,$c1,$c2,$c2,$c1
	.db $c2,$06,$c1,$c2,$06,$c3,$04,$c2,$c3,$05,$c2,$c3,$07,$c2,$c3,$0a
	.db $c2,$c3,$09,$c2,$05,$c1,$c2,$09,$c1,$c2,$06,$c1,$c2,$c2,$c1,$13
	.db $c0,$c1,$05,$c0,$c1,$c1,$c0,$c1,$c1,$c0,$c1,$c1,$c0,$c1,$c0,$7f
	.db $4e
.env_vol2
	.db $c3,$03,$c0,$c1,$c0,$03,$c2,$03,$c0,$c2,$c0,$03,$c2,$c2,$c0,$c0
	.db $c2,$c0,$03,$c2,$c2,$c0,$c0,$c2,$c0,$7f,$18
.env_vol3
	.db $c1,$c2,$c3,$c2,$c1,$7f,$04
.env_vol4
	.db $c2,$03,$c0,$7f,$02
.env_vol5
	.db $cf,$03,$c0,$7f,$02
.env_vol6
	.db $c3,$c4,$c3,$c2,$7f,$03
.env_vol7
	.db $c2,$04,$c1,$0b,$c0,$7f,$04
.env_vol8
	.db $c2,$c2,$c3,$03,$c4,$25,$c3,$c4,$c3,$c4,$c3,$c4,$c3,$c4,$c3,$c4
	.db $c3,$c4,$c3,$c4,$c3,$18,$c2,$c3,$c2,$c3,$c2,$c3,$c2,$c3,$c2,$c3
	.db $c2,$c3,$c2,$c3,$c2,$c3,$c2,$c3,$c2,$17,$c1,$c2,$c1,$c2,$c1,$c2
	.db $c1,$c2,$c1,$c2,$c1,$c2,$c1,$c2,$c1,$c2,$c1,$c2,$c1,$0b,$c0,$c1
	.db $07,$c0,$c1,$c1,$c0,$c1,$c1,$c0,$c1,$c0,$c1,$c0,$c1,$c0,$c1,$c0
	.db $03,$c1,$c0,$03,$c1,$c0,$04,$c1,$c0,$7f,$58
.env_vol9
	.db $c4,$c2,$c1,$05,$c0,$7f,$04
.env_vol10
	.db $cf,$06,$c0,$7f,$02
.env_vol11
	.db $cf,$7f,$00
.env_vol12
	.db $c2,$c3,$c2,$c2,$7f,$03
.env_vol13
	.db $cf,$cf,$c0,$7f,$02
.env_vol14
	.db $c3,$c4,$c5,$c5,$c4,$c3,$c1,$0e,$c0,$7f,$08
.env_vol15
	.db $c1,$c2,$c2,$c1,$04,$c0,$7f,$05
.env_vol16
	.db $c2,$30,$c1,$4f,$c0,$7f,$04
.env_vol17
	.db $c2,$7f,$00
.env_vol18
	.db $c3,$7f,$00
.env_vol19
	.db $c1,$03,$c0,$7f,$02
.env_arp0
	.db $c0,$bd,$ba,$7f,$02
.env_arp1
	.db $bd,$be,$bf,$c0,$7f,$03
.env_arp2
	.db $bc,$bc,$bd,$bd,$be,$be,$bf,$bf,$c0,$7f,$08
.env_arp3
	.db $cc,$c0,$7f,$01
.env_pitch0
	.db $ca,$7f,$00
.env_pitch1
	.db $c1,$c1,$c2,$c2,$c3,$c3,$c4,$c4,$c5,$c5,$c6,$c6,$c5,$c5,$c4,$c4
	.db $c3,$c3,$c2,$c2,$c1,$c1,$c0,$c0,$7f,$00
.env_pitch2
	.db $c2,$7f,$00
.env_pitch3
	.db $c0,$12,$c1,$04,$c2,$04,$c1,$04,$c0,$04,$7f,$02
.env_pitch4
	.db $c1,$c2,$c3,$c2,$c1,$c0,$7f,$00
.env_pitch5
	.db $ac,$a2,$9d,$9d,$7f,$03
.ins
	.dw .env_default,.env_default,.env_default
	.db $30,$00
	.dw .env_vol0,.env_default,.env_default
	.db $30,$00
	.dw .env_vol1,.env_default,.env_pitch1
	.db $30,$00
	.dw .env_vol1,.env_default,.env_pitch0
	.db $30,$00
	.dw .env_vol2,.env_default,.env_default
	.db $70,$00
	.dw .env_vol3,.env_default,.env_default
	.db $70,$00
	.dw .env_vol4,.env_default,.env_default
	.db $70,$00
	.dw .env_vol6,.env_default,.env_default
	.db $70,$00
	.dw .env_vol7,.env_default,.env_default
	.db $30,$00
	.dw .env_vol12,.env_default,.env_pitch2
	.db $70,$00
	.dw .env_vol7,.env_default,.env_pitch2
	.db $30,$00
	.dw .env_vol8,.env_default,.env_pitch3
	.db $70,$00
	.dw .env_vol9,.env_default,.env_default
	.db $30,$00
	.dw .env_vol10,.env_default,.env_pitch4
	.db $30,$00
	.dw .env_vol11,.env_default,.env_default
	.db $30,$00
	.dw .env_vol13,.env_default,.env_default
	.db $30,$00
	.dw .env_vol11,.env_arp1,.env_default
	.db $30,$00
	.dw .env_vol8,.env_arp2,.env_pitch3
	.db $70,$00
	.dw .env_vol16,.env_default,.env_pitch3
	.db $70,$00
	.dw .env_vol17,.env_default,.env_pitch4
	.db $70,$00
	.dw .env_vol18,.env_default,.env_pitch4
	.db $70,$00
	.dw .env_vol19,.env_default,.env_default
	.db $70,$00

.chn0
.chn0_0
	.db $42,$09,$9e,$05,$9e
.chn0_loop
.chn0_1
	.db $42,$09,$9e,$0e,$9e
.chn0_2
	.db $09,$9e,$05,$9e
.chn0_3
	.db $09,$9e,$0e,$9e
.chn0_4
	.db $4b,$09,$8e,$42,$09,$8e,$4b,$05,$8e,$42,$05,$8e
.chn0_5
	.db $4b,$09,$8e,$42,$09,$8e,$4b,$02,$8e,$42,$0e,$8e
.chn0_6
	.db $ff,$40
	.dw .chn0_4
.chn0_7
	.db $4b,$09,$8e,$42,$09,$8e,$4b,$02,$96,$3f,$86
.chn0_8
	.db $13,$15,$89,$13,$80,$15,$88,$13,$82,$10,$96,$47,$18,$80,$48,$18
	.db $80,$47,$15,$80,$48,$15,$80,$3f,$82
.chn0_9
	.db $4b,$15,$8a,$10,$80,$13,$88,$15,$82,$18,$86,$17,$8a,$51,$1a,$82
	.db $4b,$1c,$86,$15,$82
.chn0_10
	.db $8b,$10,$80,$11,$88,$13,$82,$0e,$96,$49,$15,$80,$4a,$15,$80,$49
	.db $18,$80,$4a,$18,$80,$3f,$82
.chn0_11
	.db $4b,$13,$8a,$10,$80,$11,$88,$13,$82,$17,$86,$18,$8a,$47,$18,$48
	.db $18,$47,$17,$48,$18,$47,$13,$48,$17,$47,$18,$48,$13,$80,$18,$47
	.db $18,$48,$13,$47,$17,$48,$18,$47,$13,$48,$17
.chn0_12
	.db $4b,$13,$15,$89,$13,$80,$15,$88,$13,$82,$10,$96,$47,$18,$80,$48
	.db $18,$80,$47,$15,$80,$48,$15,$80,$3f,$82
.chn0_13
	.db $ff,$40
	.dw .chn0_9
.chn0_14
	.db $ff,$40
	.dw .chn0_10
.chn0_15
	.db $ff,$40
	.dw .chn0_11
.chn0_16
	.db $47,$15,$86,$48,$15,$9a,$42,$05,$9a
.chn0_17
	.db $ff,$40
	.dw .chn0_3
.chn0_18
	.db $ff,$40
	.dw .chn0_2
.chn0_19
	.db $ff,$40
	.dw .chn0_3
.chn0_20
	.db $ff,$40
	.dw .chn0_4
.chn0_21
	.db $ff,$40
	.dw .chn0_5
.chn0_22
	.db $ff,$40
	.dw .chn0_4
.chn0_23
	.db $ff,$40
	.dw .chn0_7
.chn0_24
	.db $47,$15,$48,$15,$47,$18,$48,$15,$47,$1c,$48,$18,$47,$21,$48,$1c
	.db $47,$24,$48,$21,$47,$21,$48,$24,$47,$1c,$48,$21,$47,$18,$48,$1c
	.db $47,$15,$48,$18,$47,$18,$48,$15,$47,$1c,$48,$18,$47,$21,$48,$1c
	.db $47,$24,$48,$21,$47,$21,$48,$24,$47,$1c,$48,$21,$47,$18,$48,$1c
	.db $47,$15,$48,$18,$47,$18,$48,$15,$47,$1c,$48,$18,$47,$21,$48,$1c
	.db $47,$23,$48,$21,$47,$21,$48,$23,$47,$1c,$48,$21,$47,$18,$48,$1c
	.db $47,$15,$48,$18,$47,$18,$48,$15,$47,$1c,$48,$18,$47,$21,$48,$1c
	.db $47,$23,$48,$21,$47,$21,$48,$23,$47,$1c,$48,$21,$47,$18,$48,$1c
.chn0_25
	.db $47,$11,$48,$11,$47,$15,$48,$11,$47,$18,$48,$15,$47,$1d,$48,$18
	.db $47,$21,$48,$1d,$47,$1d,$48,$21,$47,$18,$48,$1d,$47,$15,$48,$18
	.db $47,$11,$48,$15,$47,$15,$48,$11,$47,$18,$48,$15,$47,$1d,$48,$18
	.db $47,$21,$48,$1d,$47,$1d,$48,$21,$47,$18,$48,$1d,$47,$15,$48,$18
	.db $47,$11,$48,$15,$47,$15,$48,$11,$47,$1a,$48,$15,$47,$1d,$48,$1a
	.db $47,$21,$48,$1d,$47,$1d,$48,$21,$47,$1a,$48,$1d,$47,$15,$48,$1a
	.db $47,$11,$48,$15,$47,$15,$48,$11,$47,$1a,$48,$15,$47,$1d,$48,$1a
	.db $47,$21,$48,$1d,$47,$1d,$48,$21,$47,$1a,$48,$1d,$47,$15,$48,$1a
.chn0_26
	.db $ff,$40
	.dw .chn0_24
.chn0_27
	.db $47,$0e,$48,$0e,$47,$11,$48,$0e,$47,$15,$48,$11,$47,$1a,$48,$15
	.db $47,$1d,$48,$1a,$47,$1a,$48,$1d,$47,$15,$48,$1a,$47,$11,$48,$15
	.db $47,$0e,$48,$11,$47,$11,$48,$0e,$47,$15,$48,$11,$47,$1a,$48,$15
	.db $47,$1d,$48,$1a,$47,$1a,$48,$1d,$47,$15,$48,$1a,$47,$11,$48,$15
	.db $47,$10,$48,$11,$47,$13,$48,$10,$47,$17,$48,$13,$47,$1c,$48,$17
	.db $47,$1f,$48,$1c,$47,$1c,$48,$1f,$47,$17,$48,$1c,$47,$13,$48,$17
	.db $47,$10,$48,$13,$47,$13,$48,$10,$47,$17,$48,$13,$47,$1c,$48,$17
	.db $1f,$3f,$1c,$3f,$17,$3f,$10,$3f
.chn0_28
	.db $4b,$18,$80,$17,$80,$13,$80,$18,$82,$17,$80,$13,$80,$15,$a6,$18
	.db $80,$17,$80,$18,$80,$1a,$80,$18,$80
.chn0_29
	.db $8b,$1a,$a2,$47,$24,$80,$23,$80,$1f,$80,$24,$80,$48,$1f,$80,$47
	.db $23,$80,$1f,$80,$48,$23,$80
.chn0_30
	.db $4b,$18,$80,$17,$80,$13,$80,$18,$82,$17,$80,$13,$80,$15,$a6,$18
	.db $80,$17,$80,$18,$80,$1a,$80,$51,$17,$80
.chn0_31
	.db $9b,$4b,$18,$80,$1a,$90,$1c,$8e
.chn0_32
	.db $18,$80,$17,$80,$13,$80,$18,$82,$17,$80,$13,$80,$15,$a6,$18,$80
	.db $17,$80,$18,$80,$1a,$80,$18,$80
.chn0_33
	.db $ff,$40
	.dw .chn0_29
.chn0_34
	.db $ff,$40
	.dw .chn0_30
.chn0_35
	.db $ff,$40
	.dw .chn0_31
.chn0_36
	.db $15,$9e,$42,$05,$9e
	.db $fe
	.dw .chn0_loop

.chn1
.chn1_0
	.db $87,$43,$09,$9e,$05,$96
.chn1_loop
.chn1_1
	.db $87,$43,$09,$9e,$0e,$96
.chn1_2
	.db $87,$09,$9e,$05,$96
.chn1_3
	.db $87,$09,$9e,$0e,$96
.chn1_4
	.db $47,$09,$48,$09,$47,$0c,$48,$09,$47,$10,$48,$0c,$47,$09,$48,$10
	.db $47,$0c,$48,$09,$47,$10,$48,$0c,$47,$09,$48,$10,$47,$0c,$48,$09
	.db $47,$09,$48,$0c,$47,$0c,$48,$09,$47,$10,$48,$0c,$47,$09,$48,$10
	.db $54,$13,$80,$15,$80,$53,$13,$80,$54,$15,$80,$53,$15,$83,$48,$09
	.db $47,$05,$48,$0c,$47,$09,$48,$05,$47,$0c,$48,$09,$47,$05,$48,$0c
	.db $47,$09,$48,$05,$47,$05,$48,$09,$47,$09,$48,$05,$47,$0c,$48,$09
	.db $47,$05,$48,$0c,$47,$09,$48,$05,$47,$0c,$48,$09,$53,$15,$80,$47
	.db $09,$48,$05
.chn1_5
	.db $47,$09,$48,$09,$47,$0c,$48,$09,$47,$10,$48,$0c,$47,$09,$48,$10
	.db $47,$0c,$48,$09,$47,$10,$48,$0c,$47,$09,$48,$10,$47,$0c,$48,$09
	.db $47,$09,$48,$0c,$47,$0c,$48,$09,$47,$10,$48,$0c,$47,$09,$48,$10
	.db $54,$13,$80,$15,$80,$53,$13,$80,$54,$11,$80,$53,$11,$83,$48,$05
	.db $47,$02,$48,$09,$47,$05,$48,$02,$47,$09,$48,$05,$47,$02,$48,$09
	.db $47,$05,$48,$02,$54,$13,$80,$53,$13,$81,$48,$05,$47,$02,$48,$09
	.db $54,$15,$80,$53,$15,$80,$0e,$82
.chn1_6
	.db $ff,$40
	.dw .chn1_4
.chn1_7
	.db $47,$09,$48,$09,$47,$0c,$48,$09,$47,$10,$48,$0c,$47,$09,$48,$10
	.db $47,$0c,$48,$09,$47,$10,$48,$0c,$47,$09,$48,$10,$47,$0c,$48,$09
	.db $47,$09,$48,$0c,$47,$0c,$48,$09,$47,$10,$48,$0c,$47,$09,$48,$10
	.db $54,$13,$80,$15,$80,$53,$13,$80,$54,$11,$80,$53,$11,$83,$48,$05
	.db $47,$02,$48,$09,$47,$05,$48,$02,$47,$09,$48,$05,$47,$02,$48,$09
	.db $47,$05,$48,$02,$54,$0e,$80,$53,$0e,$82,$47,$02,$48,$09,$47,$05
	.db $48,$02,$47,$09,$48,$05,$47,$02,$48,$09,$47,$05,$48,$02
.chn1_8
	.db $47,$09,$80,$48,$09,$47,$09,$52,$15,$80,$47,$15,$52,$15,$48,$09
	.db $52,$15,$81,$47,$07,$80,$48,$15,$52,$13,$47,$09,$52,$15,$48,$09
	.db $47,$09,$52,$15,$80,$47,$15,$80,$48,$09,$80,$47,$07,$52,$13,$48
	.db $15,$13,$07,$52,$10,$47,$09,$52,$10,$48,$09,$47,$09,$18,$52,$10
	.db $48,$18,$52,$10,$47,$15,$80,$48,$15,$80,$47,$07,$80,$48,$15,$80
	.db $47,$09,$80,$48,$09,$47,$09,$49,$18,$80,$4a,$18,$80,$49,$15,$80
	.db $4a,$15,$80,$47,$13,$80,$48,$09,$80
.chn1_9
	.db $47,$09,$80,$48,$09,$47,$09,$52,$15,$80,$47,$15,$52,$15,$48,$09
	.db $52,$15,$81,$47,$07,$80,$48,$15,$52,$10,$47,$09,$52,$13,$48,$09
	.db $47,$09,$52,$13,$80,$47,$15,$80,$48,$09,$80,$47,$07,$52,$15,$48
	.db $15,$15,$07,$52,$18,$47,$09,$52,$18,$48,$09,$47,$09,$52,$18,$80
	.db $47,$15,$52,$17,$48,$09,$52,$17,$81,$47,$07,$80,$48,$15,$80,$47
	.db $09,$80,$48,$09,$47,$09,$52,$1a,$80,$47,$15,$52,$1c,$48,$09,$52
	.db $1c,$81,$47,$13,$80,$48,$09,$80
.chn1_10
	.db $47,$05,$52,$15,$48,$05,$47,$05,$18,$52,$15,$48,$18,$52,$15,$47
	.db $15,$80,$48,$15,$80,$47,$02,$80,$48,$11,$52,$10,$47,$05,$52,$11
	.db $48,$05,$47,$05,$52,$11,$80,$47,$11,$80,$48,$05,$80,$47,$02,$52
	.db $13,$48,$11,$0e,$02,$52,$0e,$47,$05,$52,$0e,$48,$05,$47,$05,$18
	.db $52,$0e,$48,$18,$52,$0e,$47,$15,$52,$0e,$48,$15,$80,$47,$02,$80
	.db $48,$11,$80,$47,$05,$80,$48,$05,$47,$05,$15,$80,$48,$15,$80,$47
	.db $18,$80,$48,$18,$80,$47,$02,$80,$48,$05,$80
.chn1_11
	.db $47,$07,$80,$48,$07,$47,$07,$52,$13,$80,$47,$13,$52,$13,$48,$07
	.db $52,$13,$81,$47,$04,$80,$48,$13,$52,$10,$47,$07,$52,$11,$48,$07
	.db $47,$07,$52,$11,$80,$47,$13,$80,$48,$07,$80,$47,$04,$52,$13,$48
	.db $13,$13,$04,$52,$17,$47,$07,$52,$17,$48,$07,$47,$07,$81,$13,$52
	.db $18,$48,$07,$52,$18,$81,$47,$04,$80,$48,$13,$80,$49,$24,$4a,$24
	.db $49,$23,$4a,$24,$49,$1f,$4a,$23,$49,$24,$4a,$1f,$80,$24,$49,$24
	.db $4a,$1f,$49,$23,$4a,$24,$49,$1f,$4a,$23
.chn1_12
	.db $ff,$40
	.dw .chn1_8
.chn1_13
	.db $ff,$40
	.dw .chn1_9
.chn1_14
	.db $ff,$40
	.dw .chn1_10
.chn1_15
	.db $ff,$40
	.dw .chn1_11
.chn1_16
	.db $49,$21,$82,$4a,$21,$82,$43,$09,$9e,$05,$96
.chn1_17
	.db $ff,$40
	.dw .chn1_3
.chn1_18
	.db $ff,$40
	.dw .chn1_2
.chn1_19
	.db $ff,$40
	.dw .chn1_3
.chn1_20
	.db $ff,$40
	.dw .chn1_4
.chn1_21
	.db $ff,$40
	.dw .chn1_5
.chn1_22
	.db $ff,$40
	.dw .chn1_4
.chn1_23
	.db $ff,$40
	.dw .chn1_7
.chn1_24
	.db $3f,$4a,$15,$3f,$15,$3f,$18,$3f,$1c,$3f,$21,$3f,$24,$3f,$21,$3f
	.db $1c,$3f,$18,$18,$15,$1c,$18,$21,$1c,$24,$21,$21,$24,$1c,$21,$18
	.db $1c,$49,$15,$4a,$18,$18,$15,$49,$1c,$4a,$18,$21,$1c,$49,$23,$4a
	.db $21,$21,$23,$49,$1c,$4a,$21,$18,$1c,$49,$15,$4a,$18,$49,$18,$4a
	.db $15,$49,$1c,$4a,$18,$49,$21,$4a,$1c,$49,$23,$4a,$21,$49,$21,$4a
	.db $23,$49,$1c,$4a,$21,$49,$18,$4a,$1c
.chn1_25
	.db $49,$11,$4a,$11,$49,$15,$4a,$11,$49,$18,$4a,$15,$49,$1d,$4a,$18
	.db $49,$21,$4a,$1d,$49,$1d,$4a,$21,$49,$18,$4a,$1d,$49,$15,$4a,$18
	.db $49,$11,$4a,$15,$49,$15,$4a,$11,$49,$18,$4a,$15,$49,$1d,$4a,$18
	.db $49,$21,$4a,$1d,$49,$1d,$4a,$21,$49,$18,$4a,$1d,$49,$15,$4a,$18
	.db $49,$11,$4a,$15,$49,$15,$4a,$11,$49,$1a,$4a,$15,$49,$1d,$4a,$1a
	.db $49,$21,$4a,$1d,$49,$1d,$4a,$21,$49,$1a,$4a,$1d,$49,$15,$4a,$1a
	.db $49,$11,$4a,$15,$49,$15,$4a,$11,$49,$1a,$4a,$15,$49,$1d,$4a,$1a
	.db $49,$21,$4a,$1d,$49,$1d,$4a,$21,$49,$1a,$4a,$1d,$49,$15,$4a,$1a
.chn1_26
	.db $49,$21,$4a,$21,$49,$24,$4a,$21,$49,$28,$4a,$24,$49,$2d,$4a,$28
	.db $49,$30,$4a,$2d,$49,$2d,$4a,$30,$49,$28,$4a,$2d,$49,$24,$4a,$28
	.db $49,$21,$4a,$24,$49,$24,$4a,$21,$49,$28,$4a,$24,$49,$2d,$4a,$28
	.db $49,$30,$4a,$2d,$49,$2d,$4a,$30,$49,$28,$4a,$2d,$49,$24,$4a,$28
	.db $49,$21,$4a,$24,$49,$24,$4a,$21,$49,$28,$4a,$24,$49,$2d,$4a,$28
	.db $49,$2f,$4a,$2d,$49,$2d,$4a,$2f,$49,$28,$4a,$2d,$49,$24,$4a,$28
	.db $49,$21,$4a,$24,$49,$24,$4a,$21,$49,$28,$4a,$24,$49,$2d,$4a,$28
	.db $49,$2f,$4a,$2d,$49,$2d,$4a,$2f,$49,$28,$4a,$2d,$49,$24,$4a,$28
.chn1_27
	.db $49,$0e,$4a,$0e,$49,$11,$4a,$0e,$49,$15,$4a,$11,$49,$1a,$4a,$15
	.db $49,$1d,$4a,$1a,$49,$1a,$4a,$1d,$49,$15,$4a,$1a,$49,$11,$4a,$15
	.db $49,$0e,$4a,$11,$49,$11,$4a,$0e,$49,$15,$4a,$11,$49,$1a,$4a,$15
	.db $49,$1d,$4a,$1a,$49,$1a,$4a,$1d,$49,$15,$4a,$1a,$49,$11,$4a,$15
	.db $10,$11,$13,$10,$17,$13,$1c,$17,$1f,$1c,$1c,$1f,$17,$1c,$13,$17
	.db $3f,$13,$3f,$10,$3f,$13,$3f,$17,$3f,$1c,$3f,$1f,$3f,$1c,$3f,$17
.chn1_28
	.db $42,$09,$86,$52,$18,$80,$17,$80,$13,$80,$18,$80,$48,$13,$80,$52
	.db $17,$80,$13,$80,$15,$80,$48,$17,$80,$13,$80,$15,$80,$17,$80,$42
	.db $09,$9e
.chn1_29
	.db $09,$82,$47,$18,$80,$1a,$80,$18,$80,$48,$18,$80,$1a,$80,$18,$84
	.db $47,$1a,$82,$48,$1a,$86,$49,$18,$80,$17,$80,$13,$80,$18,$80,$4a
	.db $13,$80,$47,$17,$80,$13,$80,$17,$80,$49,$18,$80,$17,$80,$13,$80
	.db $18,$80,$4a,$13,$80,$49,$17,$80,$13,$80,$4a,$17,$80
.chn1_30
	.db $42,$11,$86,$52,$18,$80,$17,$80,$13,$80,$18,$80,$48,$13,$80,$52
	.db $17,$80,$13,$80,$15,$80,$48,$17,$80,$13,$80,$15,$80,$17,$80,$42
	.db $05,$9e
.chn1_31
	.db $02,$82,$47,$18,$80,$1a,$80,$18,$80,$48,$18,$80,$1a,$80,$18,$80
	.db $42,$02,$8e,$04,$8e,$47,$1c,$48,$1c,$47,$18,$48,$1c,$47,$17,$48
	.db $18,$47,$1c,$48,$17,$47,$18,$48,$1c,$47,$17,$48,$18,$47,$1c,$48
	.db $17,$47,$18,$48,$1c
.chn1_32
	.db $ff,$40
	.dw .chn1_28
.chn1_33
	.db $ff,$40
	.dw .chn1_29
.chn1_34
	.db $ff,$40
	.dw .chn1_30
.chn1_35
	.db $ff,$40
	.dw .chn1_31
.chn1_36
	.db $3f,$86,$43,$09,$9e,$05,$96
	.db $fe
	.dw .chn1_loop

.chn2
.chn2_0
	.db $bf
.chn2_loop
.chn2_1
	.db $bf
.chn2_2
	.db $82,$41,$09,$81,$15,$82,$15,$80,$09,$82,$09,$81,$09,$83,$07,$80
	.db $09,$87,$09,$81,$15,$82,$15,$80,$09,$82,$09,$81,$09,$83,$07,$80
	.db $09,$80,$13,$80,$15,$80
.chn2_3
	.db $82,$09,$81,$15,$82,$15,$80,$09,$82,$09,$81,$09,$83,$07,$80,$09
	.db $87,$0e,$81,$1a,$82,$1a,$80,$0e,$82,$0e,$8e
.chn2_4
	.db $4e,$09,$80,$3f,$41,$09,$81,$21,$82,$15,$80,$09,$82,$09,$81,$09
	.db $83,$4d,$1f,$80,$21,$80,$4e,$07,$80,$50,$21,$82,$4e,$3f,$41,$09
	.db $81,$21,$82,$15,$80,$09,$82,$09,$81,$09,$83,$21,$80,$4d,$15,$80
	.db $07,$80,$13,$80
.chn2_5
	.db $4e,$09,$80,$3f,$41,$09,$81,$21,$82,$15,$80,$09,$82,$09,$81,$09
	.db $83,$4d,$1f,$80,$21,$80,$13,$80,$4e,$1d,$82,$3f,$41,$0e,$81,$26
	.db $82,$1a,$80,$0e,$82,$50,$1f,$81,$41,$0e,$83,$50,$21,$80,$4d,$1a
	.db $80,$0c,$80,$18,$80
.chn2_6
	.db $ff,$40
	.dw .chn2_4
.chn2_7
	.db $4e,$09,$80,$3f,$41,$09,$81,$21,$82,$15,$80,$09,$82,$09,$81,$09
	.db $83,$4d,$1f,$80,$21,$80,$13,$80,$4e,$1d,$82,$3f,$41,$0e,$81,$26
	.db $82,$1a,$80,$0e,$82,$4e,$1a,$81,$41,$0e,$83,$26,$80,$4d,$1a,$80
	.db $0c,$80,$18,$80
.chn2_8
	.db $4e,$09,$80,$3f,$41,$09,$81,$15,$84,$4e,$07,$82,$09,$80,$3f,$41
	.db $09,$81,$15,$82,$4e,$07,$82,$4d,$3f,$80,$4e,$09,$80,$3f,$41,$09
	.db $81,$15,$84,$4e,$07,$82,$09,$80,$3f,$41,$09,$81,$15,$84,$4e,$13
	.db $82
.chn2_9
	.db $09,$80,$3f,$41,$09,$81,$15,$84,$4e,$07,$82,$09,$80,$3f,$41,$09
	.db $81,$15,$82,$4e,$07,$82,$4d,$3f,$80,$4e,$09,$80,$3f,$41,$09,$81
	.db $15,$84,$4e,$07,$82,$09,$80,$3f,$41,$09,$81,$15,$84,$4e,$13,$82
.chn2_10
	.db $11,$80,$3f,$41,$11,$81,$1d,$84,$4e,$0e,$82,$11,$80,$3f,$41,$11
	.db $81,$1d,$82,$4e,$0e,$82,$4d,$3f,$80,$4e,$11,$80,$3f,$41,$11,$81
	.db $1d,$84,$4e,$0e,$82,$11,$80,$3f,$41,$11,$81,$1d,$84,$4e,$0e,$82
.chn2_11
	.db $13,$80,$3f,$41,$13,$81,$1f,$84,$4e,$10,$82,$13,$80,$3f,$41,$13
	.db $81,$1f,$82,$4e,$10,$82,$4d,$3f,$80,$4e,$13,$80,$3f,$41,$13,$81
	.db $1f,$84,$4e,$10,$82,$13,$80,$3f,$41,$13,$81,$1f,$82,$18,$80,$13
	.db $80,$4e,$10,$80
.chn2_12
	.db $ff,$40
	.dw .chn2_9
.chn2_13
	.db $ff,$40
	.dw .chn2_9
.chn2_14
	.db $ff,$40
	.dw .chn2_10
.chn2_15
	.db $ff,$40
	.dw .chn2_11
.chn2_16
	.db $15,$80,$3f,$41,$09,$81,$09,$80,$4f,$15,$8e,$15,$8e,$15,$8e,$15
	.db $86
.chn2_17
	.db $87,$15,$8e,$15,$8e,$15,$96
.chn2_18
	.db $ff,$40
	.dw .chn2_2
.chn2_19
	.db $ff,$40
	.dw .chn2_3
.chn2_20
	.db $ff,$40
	.dw .chn2_4
.chn2_21
	.db $ff,$40
	.dw .chn2_5
.chn2_22
	.db $ff,$40
	.dw .chn2_4
.chn2_23
	.db $ff,$40
	.dw .chn2_7
.chn2_24
	.db $41,$09,$81,$09,$81,$09,$96,$07,$80,$09,$81,$09,$81,$09,$96,$07
	.db $80
.chn2_25
	.db $05,$81,$05,$81,$05,$96,$04,$80,$05,$81,$05,$81,$05,$96,$04,$80
.chn2_26
	.db $09,$81,$09,$81,$15,$82,$15,$80,$09,$82,$09,$81,$09,$83,$07,$80
	.db $09,$84,$09,$81,$09,$81,$15,$82,$15,$80,$09,$82,$09,$81,$09,$83
	.db $07,$80,$09,$80,$13,$80,$15,$80
.chn2_27
	.db $02,$81,$02,$81,$0e,$82,$0e,$80,$02,$82,$02,$81,$02,$83,$00,$80
	.db $02,$82,$02,$80,$04,$81,$04,$81,$10,$82,$10,$80,$04,$82,$50,$10
	.db $82,$4e,$0c,$09,$04,$00,$41,$1c,$80,$1c,$80,$1c,$80,$1c,$80
.chn2_28
	.db $ff,$40
	.dw .chn2_8
.chn2_29
	.db $09,$80,$3f,$41,$09,$81,$15,$84,$4e,$07,$82,$09,$80,$3f,$41,$09
	.db $81,$15,$82,$4e,$07,$82,$4d,$3f,$80,$4e,$09,$80,$3f,$41,$09,$81
	.db $15,$84,$4e,$07,$82,$09,$80,$3f,$41,$09,$81,$4e,$15,$82,$3f,$84
.chn2_30
	.db $ff,$40
	.dw .chn2_10
.chn2_31
	.db $0e,$80,$3f,$41,$0e,$81,$1a,$84,$4e,$0c,$82,$0e,$80,$3f,$41,$0e
	.db $81,$1a,$82,$4e,$0c,$82,$4d,$3f,$80,$4e,$10,$80,$3f,$41,$10,$81
	.db $1c,$84,$4e,$0e,$82,$10,$82,$3f,$80,$41,$1c,$80,$10,$80,$10,$80
	.db $1c,$80,$10,$80
.chn2_32
	.db $ff,$40
	.dw .chn2_8
.chn2_33
	.db $ff,$40
	.dw .chn2_29
.chn2_34
	.db $ff,$40
	.dw .chn2_10
.chn2_35
	.db $ff,$40
	.dw .chn2_31
.chn2_36
	.db $4e,$15,$80,$3f,$bc
	.db $fe
	.dw .chn2_loop

.chn3
.chn3_0
	.db $45,$05,$82,$03,$80,$05,$80,$3f,$86,$44,$0c,$81,$0b,$85,$42,$06
	.db $84,$05,$82,$03,$80,$05,$80,$3f,$86,$46,$0c,$0c,$42,$0a,$82,$3f
	.db $88
.chn3_loop
.chn3_1
	.db $45,$09,$82,$03,$80,$0c,$80,$46,$0c,$0c,$0c,$84,$44,$0d,$81,$08
	.db $83,$46,$09,$81,$07,$80,$05,$04,$80,$42,$09,$86,$3f,$86,$46,$0e
	.db $80,$07,$0d,$80,$0a,$81,$0c,$80,$07,$05,$83
.chn3_2
	.db $45,$05,$82,$03,$80,$07,$80,$3f,$86,$44,$0c,$81,$0b,$85,$42,$06
	.db $84,$05,$82,$03,$80,$05,$80,$3f,$86,$46,$0c,$0c,$42,$0a,$82,$3f
	.db $88
.chn3_3
	.db $45,$0c,$82,$0b,$80,$05,$80,$3f,$86,$44,$0d,$81,$08,$85,$42,$06
	.db $84,$09,$86,$3f,$86,$46,$0d,$80,$0c,$80,$0b,$80,$0e,$0c,$0b,$0e
	.db $0c,$0b,$05,$82
.chn3_4
	.db $4c,$0e,$80,$0f,$80,$44,$0d,$80,$4c,$0f,$80,$44,$0e,$80,$4c,$0f
	.db $80,$0e,$80,$0f,$80,$0e,$80,$0f,$80,$44,$0d,$80,$0c,$80,$4c,$0e
	.db $80,$0f,$80,$0e,$80,$0f,$80,$0e,$80,$0f,$80,$44,$0d,$80,$4c,$0f
	.db $80,$44,$0e,$80,$4c,$0f,$80,$0e,$80,$0f,$80,$0e,$80,$0f,$80,$44
	.db $0d,$80,$0c,$80,$4c,$0e,$80,$44,$0b,$80,$4c,$0e,$80,$0f,$80
.chn3_5
	.db $0e,$80,$0f,$80,$44,$0d,$80,$4c,$0f,$80,$44,$0e,$80,$4c,$0f,$80
	.db $0e,$80,$0f,$80,$0e,$80,$0f,$80,$44,$0d,$80,$0c,$80,$4c,$0e,$80
	.db $0f,$80,$0e,$80,$0f,$80,$0e,$80,$0f,$80,$44,$0d,$80,$4c,$0f,$80
	.db $44,$0e,$80,$4c,$0f,$80,$0e,$80,$0f,$80,$0e,$80,$0f,$80,$44,$0d
	.db $80,$0c,$80,$4c,$0e,$86
.chn3_6
	.db $0e,$80,$0f,$80,$44,$0d,$80,$4c,$0f,$80,$44,$0e,$80,$4c,$0f,$80
	.db $0e,$80,$0f,$80,$0e,$80,$0f,$80,$44,$0d,$80,$0c,$80,$4c,$0e,$80
	.db $0f,$80,$0e,$80,$0f,$80,$0e,$80,$0f,$80,$44,$0d,$80,$4c,$0f,$80
	.db $44,$0e,$80,$4c,$0f,$80,$0e,$80,$0f,$80,$0e,$80,$0f,$80,$44,$0d
	.db $80,$0c,$80,$4c,$0e,$80,$44,$0b,$80,$4c,$0e,$80,$0f,$80
.chn3_7
	.db $0e,$80,$0f,$80,$44,$0d,$80,$4c,$0f,$80,$44,$0e,$80,$4c,$0f,$80
	.db $0e,$80,$0f,$80,$0e,$80,$0f,$80,$44,$0d,$80,$0c,$80,$4c,$0e,$80
	.db $0f,$80,$0e,$80,$0f,$80,$0e,$80,$0f,$80,$44,$0d,$80,$4c,$0f,$80
	.db $44,$0e,$80,$4c,$0f,$80,$0e,$80,$0f,$80,$42,$08,$86,$3f,$86
.chn3_8
	.db $81,$4c,$0f,$80,$0e,$80,$0f,$82,$0f,$80,$0e,$80,$0f,$82,$0f,$80
	.db $0e,$80,$0f,$82,$0f,$80,$0e,$80,$0f,$82,$0f,$80,$0e,$80,$0f,$82
	.db $0f,$80,$0e,$80,$0f,$82,$0f,$80,$0e,$80,$0f,$82,$0f,$80,$0e,$80
	.db $0f,$80
.chn3_9
	.db $81,$0f,$80,$0e,$80,$0f,$82,$0f,$80,$0e,$80,$0f,$82,$0f,$80,$0e
	.db $80,$0f,$82,$0f,$80,$0e,$80,$0f,$82,$0f,$80,$0e,$80,$0f,$82,$0f
	.db $80,$0e,$80,$0f,$82,$0f,$80,$0e,$80,$0f,$82,$0f,$80,$0e,$80,$0f
	.db $80
.chn3_10
	.db $ff,$40
	.dw .chn3_9
.chn3_11
	.db $81,$0f,$80,$0e,$80,$0f,$82,$0f,$80,$0e,$80,$0f,$82,$0f,$80,$0e
	.db $80,$0f,$82,$0f,$80,$0e,$80,$0f,$82,$0f,$80,$0e,$80,$0f,$82,$0f
	.db $80,$0e,$80,$0f,$80,$0e,$80,$0f,$80,$0e,$80,$0f,$80,$0e,$80,$0f
	.db $80,$0f,$80,$0f,$80
.chn3_12
	.db $ff,$40
	.dw .chn3_9
.chn3_13
	.db $ff,$40
	.dw .chn3_9
.chn3_14
	.db $ff,$40
	.dw .chn3_9
.chn3_15
	.db $ff,$40
	.dw .chn3_11
.chn3_16
	.db $ff,$40
	.dw .chn3_0
.chn3_17
	.db $ff,$40
	.dw .chn3_1
.chn3_18
	.db $ff,$40
	.dw .chn3_2
.chn3_19
	.db $ff,$40
	.dw .chn3_3
.chn3_20
	.db $ff,$40
	.dw .chn3_4
.chn3_21
	.db $ff,$40
	.dw .chn3_5
.chn3_22
	.db $ff,$40
	.dw .chn3_6
.chn3_23
	.db $ff,$40
	.dw .chn3_7
.chn3_24
	.db $46,$08,$81,$08,$81,$06,$88,$0d,$80,$0d,$0d,$80,$0d,$81,$0d,$84
	.db $08,$80,$09,$81,$09,$81,$08,$88,$0d,$80,$0d,$0d,$80,$0d,$81,$0b
	.db $81,$0b,$83
.chn3_25
	.db $08,$81,$08,$81,$06,$88,$0d,$80,$0d,$0d,$80,$0d,$81,$0d,$84,$08
	.db $80,$09,$81,$09,$81,$08,$88,$0d,$80,$0d,$0d,$80,$0d,$81,$0b,$81
	.db $0b,$83
.chn3_26
	.db $ff,$40
	.dw .chn3_0
.chn3_27
	.db $45,$09,$81,$46,$08,$45,$03,$80,$0c,$80,$46,$0c,$0c,$0c,$84,$44
	.db $0d,$80,$46,$0d,$44,$08,$80,$46,$0d,$80,$0d,$09,$81,$07,$80,$05
	.db $04,$80,$42,$09,$81,$46,$09,$81,$08,$80,$3f,$86,$44,$0e,$86,$4c
	.db $0f,$80,$0e,$80,$0d,$80,$0c,$80
.chn3_28
	.db $0e,$80,$0f,$80,$46,$0a,$80,$4c,$0f,$80,$0e,$80,$0f,$80,$46,$0c
	.db $80,$0d,$80,$4c,$0e,$80,$0f,$80,$46,$0a,$80,$4c,$0f,$80,$0e,$80
	.db $0f,$80,$46,$09,$80,$4c,$0f,$80,$0e,$80,$0f,$80,$46,$0a,$80,$4c
	.db $0f,$80,$0e,$80,$0f,$80,$46,$0c,$80,$0d,$80,$4c,$0e,$80,$0f,$80
	.db $46,$0a,$80,$4c,$0f,$80,$0e,$80,$0f,$80,$44,$04,$82
.chn3_29
	.db $4c,$0e,$80,$0f,$80,$46,$0a,$80,$4c,$0f,$80,$0e,$80,$0f,$80,$46
	.db $0c,$80,$0d,$80,$4c,$0e,$80,$0f,$80,$46,$0a,$80,$4c,$0f,$80,$0e
	.db $80,$0f,$80,$46,$09,$80,$4c,$0f,$80,$0e,$80,$0f,$80,$46,$0a,$80
	.db $4c,$0f,$80,$0e,$80,$0f,$80,$46,$0c,$80,$0d,$80,$4c,$0e,$80,$0f
	.db $80,$46,$0a,$80,$4c,$0f,$80,$0e,$80,$0f,$80,$44,$04,$82
.chn3_30
	.db $ff,$40
	.dw .chn3_29
.chn3_31
	.db $ff,$40
	.dw .chn3_29
.chn3_32
	.db $ff,$40
	.dw .chn3_29
.chn3_33
	.db $ff,$40
	.dw .chn3_29
.chn3_34
	.db $ff,$40
	.dw .chn3_29
.chn3_35
	.db $ff,$40
	.dw .chn3_29
.chn3_36
	.db $ff,$40
	.dw .chn3_0
	.db $fe
	.dw .chn3_loop

.chn4
.chn4_0
	.db $bf
.chn4_loop
.chn4_1
	.db $bf
.chn4_2
	.db $87,$02,$8e,$02,$8e,$02,$88,$02,$84,$02,$86
.chn4_3
	.db $87,$02,$8e,$02,$8c,$00,$80,$02,$80,$00,$84,$00,$8e
.chn4_4
	.db $00,$84,$00,$80,$02,$82,$00,$86,$00,$82,$02,$85,$00,$00,$84,$00
	.db $80,$02,$82,$00,$84,$02,$80,$00,$82,$02,$82,$00,$82
.chn4_5
	.db $00,$84,$00,$80,$02,$82,$00,$86,$00,$82,$02,$85,$00,$00,$84,$00
	.db $80,$02,$82,$00,$84,$02,$80,$00,$82,$02,$82,$02,$80,$02,$80
.chn4_6
	.db $ff,$40
	.dw .chn4_4
.chn4_7
	.db $00,$84,$00,$80,$02,$82,$00,$86,$00,$82,$02,$85,$00,$00,$84,$00
	.db $80,$02,$82,$00,$82,$02,$8e
.chn4_8
	.db $00,$86,$02,$8a,$00,$82,$02,$86,$00,$86,$02,$8a,$00,$82,$02,$82
	.db $00,$82
.chn4_9
	.db $00,$86,$02,$8a,$00,$82,$02,$86,$00,$86,$02,$8a,$00,$82,$02,$82
	.db $02,$80,$02,$80
.chn4_10
	.db $ff,$40
	.dw .chn4_8
.chn4_11
	.db $00,$86,$02,$8a,$00,$82,$02,$86,$00,$86,$02,$84,$02,$80,$00,$82
	.db $00,$82,$02,$80,$00,$80,$02,$80,$02,$80
.chn4_12
	.db $ff,$40
	.dw .chn4_8
.chn4_13
	.db $ff,$40
	.dw .chn4_9
.chn4_14
	.db $ff,$40
	.dw .chn4_8
.chn4_15
	.db $ff,$40
	.dw .chn4_11
.chn4_16
	.db $00,$be
.chn4_17
	.db $bf
.chn4_18
	.db $ff,$40
	.dw .chn4_2
.chn4_19
	.db $ff,$40
	.dw .chn4_3
.chn4_20
	.db $ff,$40
	.dw .chn4_4
.chn4_21
	.db $ff,$40
	.dw .chn4_5
.chn4_22
	.db $ff,$40
	.dw .chn4_4
.chn4_23
	.db $ff,$40
	.dw .chn4_7
.chn4_24
	.db $00,$9c,$00,$80,$00,$9c,$00,$80
.chn4_25
	.db $ff,$40
	.dw .chn4_24
.chn4_26
	.db $00,$84,$00,$80,$02,$82,$00,$86,$00,$82,$02,$86,$00,$84,$00,$80
	.db $02,$82,$00,$84,$02,$80,$00,$82,$02,$82,$02,$80,$02,$80
.chn4_27
	.db $00,$84,$00,$80,$02,$82,$00,$86,$00,$82,$02,$84,$00,$80,$00,$84
	.db $00,$80,$02,$82,$00,$84,$04,$80,$00,$82,$04,$80,$04,$80,$04,$80
	.db $04,$80
.chn4_28
	.db $00,$84,$00,$80,$04,$82,$00,$82,$00,$84,$00,$80,$04,$86,$00,$84
	.db $00,$80,$04,$82,$00,$82,$00,$84,$00,$80,$04,$86
.chn4_29
	.db $00,$84,$00,$80,$04,$82,$00,$82,$00,$84,$00,$80,$04,$86,$00,$84
	.db $00,$80,$04,$82,$00,$82,$00,$82,$02,$80,$00,$80,$04,$82,$04,$80
	.db $04,$80
.chn4_30
	.db $ff,$40
	.dw .chn4_28
.chn4_31
	.db $00,$84,$00,$80,$04,$82,$00,$82,$00,$84,$00,$80,$04,$86,$00,$82
	.db $02,$80,$00,$80,$04,$82,$00,$82,$00,$80,$00,$82,$02,$80,$04,$82
	.db $04,$80,$04,$80
.chn4_32
	.db $ff,$40
	.dw .chn4_28
.chn4_33
	.db $ff,$40
	.dw .chn4_29
.chn4_34
	.db $ff,$40
	.dw .chn4_28
.chn4_35
	.db $ff,$40
	.dw .chn4_31
.chn4_36
	.db $ff,$40
	.dw .chn4_16
	.db $fe
	.dw .chn4_loop
