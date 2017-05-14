TODO:

;REM_TO_BE_1024KB_MAX
;REM_IS_128_ROWS_OF_CODES

* = $0500
ROLLTB = $4B
GEARAM = $4C   ;GEAR_WORD_RAM
ENIGV1 = $4F   ;ONE_LESS
ENIGVA = $50
RINGST = $53   ;REM_ROTOR  
ROTORS = $57   ;REM_REFLECTOR
LROTOR = $58
MROTOR = $59
RROTOR = $5A   
KEYIN  = $5B
KEYOUT = $5C

TIMEO1 = $5D
TMP01  = $5E
TMP02  = $5F
TMP03  = $60
TMP04  = $61
TMP05  = $62
TMP06  = $63

DISP3  = $F9

GETKEY = $1F6A
SCANS  = $1F1F

JMP INIT

GEARTX
.BYTE $00
.BYTE $06
.BYTE $0E
.BYTE $0A

DEFVAL
.BYTE $00
.BYTE $01
.BYTE $02
.BYTE $03
.BYTE $01
.BYTE $01
.BYTE $01
.BYTE $01
.BYTE $04
.BYTE $03
.BYTE $02
.BYTE $01
.BYTE $00
.BYTE $00

ROTIDX
.BYTE $1E
.BYTE $00
.BYTE $0A
.BYTE $14

FWRTR1
.BYTE $9
.BYTE $6
.BYTE $4
.BYTE $1
.BYTE $8
.BYTE $2
.BYTE $7
.BYTE $0
.BYTE $3
.BYTE $5
FWRTR2
.BYTE $2
.BYTE $5
.BYTE $8
.BYTE $4
.BYTE $1
.BYTE $0
.BYTE $9
.BYTE $7
.BYTE $6
.BYTE $3
FWRTR3
.BYTE $4
.BYTE $3
.BYTE $5
.BYTE $8
.BYTE $1
.BYTE $6
.BYTE $2
.BYTE $0
.BYTE $7
.BYTE $9
REFLEC
.BYTE $2
.BYTE $5
.BYTE $0
.BYTE $7
.BYTE $9
.BYTE $1
.BYTE $8
.BYTE $3
.BYTE $6
.BYTE $4
BWRTR1
.BYTE $7
.BYTE $3
.BYTE $5
.BYTE $8
.BYTE $2
.BYTE $9
.BYTE $1
.BYTE $6
.BYTE $4
.BYTE $0
BWRTR2
.BYTE $5
.BYTE $4
.BYTE $0
.BYTE $9
.BYTE $3
.BYTE $1
.BYTE $8
.BYTE $7
.BYTE $2
.BYTE $6
BWRTR3
.BYTE $7
.BYTE $4
.BYTE $6
.BYTE $1
.BYTE $0
.BYTE $2
.BYTE $5
.BYTE $8
.BYTE $3
.BYTE $9

KEYTBL
.BYTE $10 ;INC_V1
.BYTE $0C ;DEC_V1
.BYTE $11 ;INC_V2
.BYTE $0D ;DEC_V2
.BYTE $14 ;INC_V3
.BYTE $0E ;DEC_V3
.BYTE $12 ;INC_V4
.BYTE $0F ;DEC_V4

INIT

CLD
LDA #$00     ;REM_ROTOR_CONFIG
CMP *ENIGVA
BNE INITOK

ZEROIZ
LDA #$12   ;REM_14_PARAMS
STA *TMP01
LDX #$00

CPYINI
LDA GEARTX,X
STA *ROLLTB,X
INX
DEC *TMP01
BNE CPYINI

INITOK

START

JSR TIMEOU

MNURET

JSR SHOWEN

CMP #$15   
BCS START  ;REM_IF_ABOVE_15

CMP #$0A
BCC SKIPMR ;REM_IF_9_OR_LESS
BEQ KPUSHA

CMP #$0B
BEQ KPUSHB

CMP #$13
BEQ KPUSHG

JSR MOVROT
JMP START

SKIPMR
STA *KEYIN
JSR STEPRT ;REM_FALLSTOENIGMA

LDA #$50
STA *TIMEO1

JMP START

KPUSHA
JMP START
KPUSHB
JMP SETUP
KPUSHG
JMP ZEROIZ

;REM_SUB_TIMEOUT
TIMEOU

LDA #$0
CMP *TIMEO1
BEQ TIMEOS
DEC *TIMEO1
BNE TIMEOS

TIMEOC
STA *KEYIN
STA *KEYOUT

TIMEOS
RTS

;REM_SUB_SHOWENIGMA
SHOWEN

LDY #$00
LDX #$03
SHOWND
LDA ROTORS,Y
ASL A
ASL A
ASL A
ASL A
STA *$F8,X
INY
LDA ROTORS,Y
ORA *$F8,X
STA *$F8,X
INY
DEX
BNE SHOWND

JSR SCANS
JMP GETKEY

;REM_SUB_MOVROT
MOVROT

LDX *$00
LDY *$04
STX *TMP01

MOVRSC
CMP KEYTBL,X
BEQ MOVRIN
CMP INC_V1,X
BEQ MOVRDE
INC *TMP01
INX
INX
DEY
BNE MOVRSC
RTS

MOVRIN
LDX *TMP01
INC *ROTORS,X
JMP MOVRCK

MOVRDE
LDX *TMP01
DEC *ROTORS,X

MOVRCK
LDA #$0         
JSR TIMEOC

;REM_CONTINUE_TO_ROLLOV
;AND_RETURN_FROM_THERE

;REM_SUB_ROLLOV
;REM_CALL_THIS_WITH_X
;REM_TO_CHECK_0-9_ROLLOVER
;REM_AFTER_MOVE_WHEELS

ROLLOV

LDY #$02
STY *TMP02
LDY *ROLLTB

ROLLNX

LDA *ROTORS,X
CMP ROLLDF,Y
BNE ROLL09
LDA ROLLSV,Y
ROLL09
INY
INY
STA *ROTORS,X

DEC *TMP02
BNE ROLLNX

RTS

;REM_SUB_STEPRT
STEPRT

LDY #$01
STY *TMP01

LDX #$03

STEPDO
LDA #$00
LDA *ROTORS,X
NOP

PHA
CMP #$09
BNE STEPSK

LDA *ENIGV1
CMP #$00
BNE STEPGR

CPX #$00
BEQ STEPSK

STY *TMP01

STEPGR

INC *TMP01
INC *TMP01

STEPSK
CLC
ROR *TMP01
BCC STEPNI

INC *ROTORS,X
JSR ROLLOV
LDY #$01 ;REM_ROLLOV_AFFECTS_Y

STEPNI

PLA
CMP #$09
BEQ STEPCN

LDA *ENIGV1
CMP #$00
BNE STEPEX

STEPCN

DEX
CPX #$FF
BNE STEPDO

STEPEX

;REM_FALLSTHROUGH

;REM_SUB_ENIGMA
ENIGMA

LDX #$00
STX *TMP04
DEX
STX *TMP03

LDY #$07
LDX #$03
LDA *KEYIN

ENIGM2
JSR ENRING

STX *TMP01

PHA
TXA
CMP #$00
BEQ ENIGXO

LDA *ENIGV1,X
TAX

ENIGXO
PLA

CLC
ADC *TMP04
ADC ROTIDX,X
TAX
LDA FWRTR1,X

PHA
LDA #$00
LDX *TMP01
JSR ENRING
STA *TMP02
PLA

SEC
SBC *TMP02
BCS ENIGM3
ADC #$0A

ENIGM3
 
STA *KEYOUT

TYA

CMP #$04
BNE ENIGNB

;REM_SETUP_TO_GO_BACK

LDA #$01
STA *TMP03

LDA #$28
STA *TMP04

ENIGNB

TXA
CLC
ADC *TMP03
TAX

LDA *KEYOUT

DEY
BNE ENIGM2

RTS

;REM_SUB_ENRING
;CALL_WITH_A_KEY_TO_ENCODE
;CALL_WITH_X_OFFSET_TO_ROTOR
ENRING

SEC
ADC *ROTORS,X ;REM_PLUS_1
CMP #$0A
BCC ENRIK1  ;REM_ABOVE_9
SBC #$0A    ;REM_CARRY_IS_SET

ENRIK1
SEC
SBC *RINGST,X
BCS ENRIK2
ADC #$0A

ENRIK2
CLC
RTS

ROLLDF   ;REM_NORMAL_F2_ROLLOV
.BYTE $FF
ROLLSV
.BYTE $09
.BYTE $0A
.BYTE $00

;REM_MENUSTARTS

ROLLRT    ;REM_ROTOR_F1_ROLLOV
.BYTE $00
.BYTE $03
.BYTE $04
.BYTE $01
ROLLGR    ;REM_GEAR_F3_ROLLOV
.BYTE $FF
.BYTE $01
.BYTE $02
.BYTE $00 

;REM_SUB_COPY
;REM_A_BYTES
;REM_FROM_ZP_X
;REM_TO_ZP_Y
COPY
STA *TMP01

COPYDO
LDA *$00,X
STA $00,Y
INX
INY
DEC *TMP01
BNE COPYDO
RTS

;REM_SUB_READKY
READKY

LDX #$0F
STX *KEYIN

JSR SHOWEN

CMP #$15   
BCS READKY  ;REM_IF_ABOVE_$15

CMP #$13    ;REM_GO_BUTTON
BNE READKG
TSX         ;REM_BALANCE_STACK
INX
INX         ;REM_DISCARD_CALL
TXS         ;REM_AND_BAIL_OUT
JMP ZEROIZ  ;REM_SETWHL_ZEROIZ
READKG

CMP #$0B
BEQ READEX  ;REM_IF_$0B_EXIT
BCC READKY  ;REM_IF_BELOW_$0B
            ;REM_IF_$0B-$15
PHA         ;REM_SAVE_KEY
JSR MOVROT  ;CHANGES_IT
PLA         ;REM_AFFECTS_F3
READEX

RTS

;REM_SUB_SETUP
SETUP
LDA #$04
STA *ROLLTB
LDX #ROTORS
LDY #TMP06
JSR COPY

LDA #$03
LDX #ENIGVA
LDY #LROTOR
JSR COPY

SETF1

LDX #$00
STX *ROTORS
STX *TMP03
STX *TMP04
STX *TMP05
INX
STX *KEYOUT

SETF1E

JSR READKY

CMP #$0B
BEQ SETCHK
           
JMP SETF1

SETCHK

LDA #$01
LDX *LROTOR
STA *TMP02,X
LDX *MROTOR
STA *TMP02,X
LDX *RROTOR
STA *TMP02,X
LDA #$00
CLC
ADC *TMP03
ADC *TMP04
ADC *TMP05

CMP #$03
BEQ SETUOK

LDA #$0E
JSR TIMEOC
JMP SETF1E

SETUOK

LDX #LROTOR
LDY #ENIGVA
JSR COPY

LDA #$04
LDX #RINGST
LDY #ROTORS
JSR COPY

LDA #$00
STA *ROLLTB

SETF2

LDX #$02
STX *KEYOUT

JSR READKY

CMP #$0B
BEQ RNGCHK

JMP SETF2

RNGCHK

LDA #$08
STA *ROLLTB

LDA #$04
LDX #ROTORS
LDY #RINGST
JSR COPY

SETF3

LDA #$04
LDX #GEARAM
LDY #ROTORS
JSR COPY

LDX #$03
STX *KEYOUT

JSR READKY

CMP #$0B
BEQ GEACHK

LDA *$5A
STA *ENIGV1

JMP SETF3

GEACHK

LDA #$04
LDX #TMP06
LDY #ROTORS
JSR COPY

LDA #$00
STA *ROLLTB ;REM_SELECT_TABLE
JSR TIMEOC

JMP MNURET
