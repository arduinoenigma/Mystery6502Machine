* = $0500
ENIGVA = $50
TIMEO1 = $58
DISP3 = $F9

START

LDA #$0
CMP *TIMEO1
BEQ NOTOUT
DEC *TIMEO1
BNE NOTOUT

STA *DISP3

NOTOUT:

JSR $1F1F
JSR $1F6A

CMP #$15   ;IS_14_OR_LESS
BCS START

STA *DISP3
LDA #$50
STA *TIMEO1

JMP START

DEFVAL
.BYTE $01
.BYTE $02
.BYTE $03
.BYTE $01
.BYTE $02
.BYTE $03
.BYTE $04

STEPS
.BYTE $03
.BYTE $05
.BYTE $07

ROTORS
.BYTE $4
.BYTE $7
.BYTE $6
.BYTE $9
.BYTE $0
.BYTE $8
.BYTE $2
.BYTE $1
.BYTE $5
.BYTE $3
.BYTE $8
.BYTE $4
.BYTE $7
.BYTE $5
.BYTE $1
.BYTE $3
.BYTE $9
.BYTE $2
.BYTE $0
.BYTE $6
.BYTE $3
.BYTE $6
.BYTE $5
.BYTE $0
.BYTE $8
.BYTE $2
.BYTE $1
.BYTE $9
.BYTE $4
.BYTE $7
.BYTE $5
.BYTE $3
.BYTE $9
.BYTE $1
.BYTE $7
.BYTE $0
.BYTE $8
.BYTE $4
.BYTE $6
.BYTE $1