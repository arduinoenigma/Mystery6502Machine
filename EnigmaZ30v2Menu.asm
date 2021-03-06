* = $06C3

SHOWEN = $05CA 
ZEROIZ = $056D 
MOVROT = $05E5
TIMEOC = $05C5
MNURET = $0580  

ENIGV1 = $4F   ;ONE_LESS
ENIGVA = $50
RINGST = $53   ;REM_ROTOR  
ROTORS = $57   ;REM_REFLECTOR
LROTOR = $58   
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
JSR SCANS
JSR GETKEY

CMP #$15   
BCS READKY  ;REM_IF_ABOVE_15

CMP #$13    ;REM_GO_BUTTON
BNE READKG
TSX         ;REM_BALANCE_STACK
INX
INX         ;REM_DISCARD_CALL
TXS         ;REM_AND_BAIL_OUT
JMP ZEROIZ  ;REM_SETWHL_ZEROIZ
READKG

CMP #$0B  
BCC READKY  ;REM_IF_BELOW_11

RTS

;REM_SUB_SETUP
SETUP
LDA #$04
LDX #ROTORS
LDY #TMP06
JSR COPY

LDA #$03
LDX #ENIGVA
LDY #LROTOR
JSR COPY

SETF1

LDX #$0
STX *ROTORS
INX
STX *KEYOUT

SETF1E

JSR READKY

CMP #$0B
BEQ SETCHK

JSR MOVROT
           
LDX #$03   ;REM_OVERFLOW
SETOVF     ;REM_TURN_0_INTO_3_AND_4_INTO_1
LDA *ROTORS,X
CMP #$00
BNE SETNZ
LDA #$03
SETNZ
CMP #$04
BNE SETNF
LDA #$01
SETNF
STA *ROTORS,X
DEX
BNE SETOVF

JMP SETF1

SETCHK

LDX #$03
STX *TMP02 

LDX #$00
STX *TMP03
STX *TMP04
STX *TMP05

SETCHL
LDX *TMP02
LDA *ROTORS,X
TAX
LDA #$01
STA *TMP02,X
DEC *TMP02
BNE SETCHL

LDX #$3
LDA #$00
TAY
SETCHD
CLC
ADC *TMP02,X
STY *TMP02,X
DEX
BNE SETCHD

CMP #$03
BEQ SETUOK

LDA #$0E
JSR TIMEOC
JMP SETF1E

SETUOK

LDA #$03 ;REM_A_IS_ALREADY3_CAN_DELETE
LDX #LROTOR
LDY #ENIGVA
JSR COPY

LDA #$04
LDX #RINGST
LDY #ROTORS
JSR COPY

SETF2

LDX #$02
STX *KEYOUT

JSR READKY

CMP #$0B
BEQ RNGCHK

JSR MOVROT

JMP SETF2

RNGCHK

LDA #$04
LDX #ROTORS
LDY #RINGST
JSR COPY

SETF3

LDA #$03
LDX #$4C
LDY #ROTORS
JSR COPY

LDX #$03
STX *KEYOUT

LDA *ENIGV1
STA *$5A

JSR READKY

CMP #$0B
BEQ GEACHK

JSR MOVROT

LDA *$5A
CMP #$09
BNE F3NOOV
LDA #$01
F3NOOV
CMP #$02
BNE F3NOUF
LDA #$00
F3NOUF
STA *ENIGV1

JMP SETF3

GEACHK

LDA #$04
LDX #TMP06
LDY #ROTORS
JSR COPY

LDA #$00
JSR TIMEOC

JMP MNURET
