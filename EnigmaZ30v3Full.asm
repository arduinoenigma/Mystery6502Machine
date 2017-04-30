pass 2

0000 TODO:  


0000 REM_TO 

0000 REM_IS 

* = $0500
0500 ROLLTB = 004B
0500 GEARAM = 004C
0500 GEAR_W 
0500 ENIGV1 = 004F
0500 ONE_LE 
0500 ENIGVA = 0050
0500 RINGST = 0053
0500 REM_RO 
0500 ROTORS = 0057
0500 REM_RE 
0500 LROTOR = 0058
0500 MROTOR = 0059
0500 RROTOR = 005A
0500 KEYIN  = 005B
0500 KEYOUT = 005C

0500 TIMEO1 = 005D
0500 TMP01  = 005E
0500 TMP02  = 005F
0500 TMP03  = 0060
0500 TMP04  = 0061
0500 TMP05  = 0062
0500 TMP06  = 0063

0500 DISP3  = 00F9

0500 GETKEY = 1F6A
0500 SCANS  = 1F1F

0500        JMP INIT        4C 67 05

0503 GEARTX 
0503 .BYTE $00              00
0504 .BYTE $06              06
0505 .BYTE $0E              0E
0506 .BYTE $0A              0A

0507 DEFVAL 
0507 .BYTE $00              00
0508 .BYTE $01              01
0509 .BYTE $02              02
050A .BYTE $03              03
050B .BYTE $01              01
050C .BYTE $01              01
050D .BYTE $01              01
050E .BYTE $01              01
050F .BYTE $04              04
0510 .BYTE $03              03
0511 .BYTE $02              02
0512 .BYTE $01              01
0513 .BYTE $00              00
0514 .BYTE $00              00

0515 ROTIDX 
0515 .BYTE $1E              1E
0516 .BYTE $00              00
0517 .BYTE $0A              0A
0518 .BYTE $14              14

0519 FWRTR1 
0519 .BYTE $09              09
051A .BYTE $06              06
051B .BYTE $04              04
051C .BYTE $01              01
051D .BYTE $08              08
051E .BYTE $02              02
051F .BYTE $07              07
0520 .BYTE $00              00
0521 .BYTE $03              03
0522 .BYTE $05              05
0523 FWRTR2 
0523 .BYTE $02              02
0524 .BYTE $05              05
0525 .BYTE $08              08
0526 .BYTE $04              04
0527 .BYTE $01              01
0528 .BYTE $00              00
0529 .BYTE $09              09
052A .BYTE $07              07
052B .BYTE $06              06
052C .BYTE $03              03
052D FWRTR3 
052D .BYTE $04              04
052E .BYTE $03              03
052F .BYTE $05              05
0530 .BYTE $08              08
0531 .BYTE $01              01
0532 .BYTE $06              06
0533 .BYTE $02              02
0534 .BYTE $00              00
0535 .BYTE $07              07
0536 .BYTE $09              09
0537 REFLEC 
0537 .BYTE $02              02
0538 .BYTE $05              05
0539 .BYTE $00              00
053A .BYTE $07              07
053B .BYTE $09              09
053C .BYTE $01              01
053D .BYTE $08              08
053E .BYTE $03              03
053F .BYTE $06              06
0540 .BYTE $04              04
0541 BWRTR1 
0541 .BYTE $07              07
0542 .BYTE $03              03
0543 .BYTE $05              05
0544 .BYTE $08              08
0545 .BYTE $02              02
0546 .BYTE $09              09
0547 .BYTE $01              01
0548 .BYTE $06              06
0549 .BYTE $04              04
054A .BYTE $00              00
054B BWRTR2 
054B .BYTE $05              05
054C .BYTE $04              04
054D .BYTE $00              00
054E .BYTE $09              09
054F .BYTE $03              03
0550 .BYTE $01              01
0551 .BYTE $08              08
0552 .BYTE $07              07
0553 .BYTE $02              02
0554 .BYTE $06              06
0555 BWRTR3 
0555 .BYTE $07              07
0556 .BYTE $04              04
0557 .BYTE $06              06
0558 .BYTE $01              01
0559 .BYTE $00              00
055A .BYTE $02              02
055B .BYTE $05              05
055C .BYTE $08              08
055D .BYTE $03              03
055E .BYTE $09              09

055F KEYTBL 
055F .BYTE $10              10
0560 INC_V1 
0560 .BYTE $0C              0C
0561 DEC_V1 
0561 .BYTE $11              11
0562 INC_V2 
0562 .BYTE $0D              0D
0563 DEC_V2 
0563 .BYTE $14              14
0564 INC_V3 
0564 .BYTE $0E              0E
0565 DEC_V3 
0565 .BYTE $12              12
0566 INC_V4 
0566 .BYTE $0F              0F
0567 DEC_V4 

0567 INIT   

0567        CLD             D8
0568        LDA #$00        A9 00
056A REM_RO 
056A        CMP *ENIGVA     C5 50
056C        BNE INITOK      D0 10

056E ZEROIZ 
056E        LDA #$12        A9 12
0570 REM_14 
0570        STA *TMP01      85 5E
0572        LDX #$00        A2 00

0574 CPYINI 
0574        LDA GEARTX,X    BD 03 05
0577        STA *ROLLTB,X   95 4B
0579        INX             E8
057A        DEC *TMP01      C6 5E
057C        BNE CPYINI      D0 F6

057E INITOK 

057E START  

057E        JSR TIMEOU      20 B1 05

0581 MNURET 

0581        JSR SHOWEN      20 C0 05

0584        CMP #$15        C9 15
0586        BCS START       B0 F6
0588 REM_IF 

0588        CMP #$0A        C9 0A
058A        BCC SKIPMR      90 10
058C REM_IF 
058C        BEQ KPUSHA      F0 1A

058E        CMP #$0B        C9 0B
0590        BEQ KPUSHB      F0 19

0592        CMP #$13        C9 13
0594        BEQ KPUSHG      F0 18

0596        JSR MOVROT      20 DF 05
0599        JMP START       4C 7E 05

059C SKIPMR 
059C        STA *KEYIN      85 5B
059E        JSR STEPRT      20 20 06
05A1 REM_FA 

05A1        LDA #$50        A9 50
05A3        STA *TIMEO1     85 5D

05A5        JMP START       4C 7E 05

05A8 KPUSHA 
05A8        JMP START       4C 7E 05
05AB KPUSHB 
05AB        JMP SETUP       4C FC 06
05AE KPUSHG 
05AE        JMP ZEROIZ      4C 6E 05


05B1 REM_SU 
05B1 TIMEOU 

05B1        LDA #$00        A9 00
05B3        CMP *TIMEO1     C5 5D
05B5        BEQ TIMEOS      F0 08
05B7        DEC *TIMEO1     C6 5D
05B9        BNE TIMEOS      D0 04

05BB TIMEOC 
05BB        STA *KEYIN      85 5B
05BD        STA *KEYOUT     85 5C

05BF TIMEOS 
05BF        RTS             60


05C0 REM_SU 
05C0 SHOWEN 

05C0        LDY #$00        A0 00
05C2        LDX #$03        A2 03
05C4 SHOWND 
05C4        LDA ROTORS,Y    B9 57 00
05C7        ASL A           0A
05C8        ASL A           0A
05C9        ASL A           0A
05CA        ASL A           0A
05CB        STA *$F8,X      95 F8
05CD        INY             C8
05CE        LDA ROTORS,Y    B9 57 00
05D1        ORA *$F8,X      15 F8
05D3        STA *$F8,X      95 F8
05D5        INY             C8
05D6        DEX             CA
05D7        BNE SHOWND      D0 EB

05D9        JSR SCANS       20 1F 1F
05DC        JMP GETKEY      4C 6A 1F


05DF REM_SU 
05DF MOVROT 

05DF        LDX *$00        A6 00
05E1        LDY *$04        A4 04
05E3        STX *TMP01      86 5E

05E5 MOVRSC 
05E5        CMP KEYTBL,X    DD 5F 05
05E8        BEQ MOVRIN      F0 0D
05EA        CMP INC_V1,X    DD 60 05
05ED        BEQ MOVRDE      F0 0F
05EF        INC *TMP01      E6 5E
05F1        INX             E8
05F2        INX             E8
05F3        DEY             88
05F4        BNE MOVRSC      D0 EF
05F6        RTS             60

05F7 MOVRIN 
05F7        LDX *TMP01      A6 5E
05F9        INC *ROTORS,X   F6 57
05FB        JMP MOVRCK      4C 02 06

05FE MOVRDE 
05FE        LDX *TMP01      A6 5E
0600        DEC *ROTORS,X   D6 57

0602 MOVRCK 
0602        LDA #$00        A9 00
0604        JSR TIMEOC      20 BB 05


0607 REM_CO 

0607 AND_RE 


0607 REM_SU 

0607 REM_CA 

0607 REM_TO 

0607 REM_AF 

0607 ROLLOV 

0607        LDY #$02        A0 02
0609        STY *TMP02      84 5F
060B        LDY *ROLLTB     A4 4B

060D ROLLNX 

060D        LDA *ROTORS,X   B5 57
060F        CMP ROLLDF,Y    D9 C0 06
0612        BNE ROLL09      D0 03
0614        LDA ROLLSV,Y    B9 C1 06
0617 ROLL09 
0617        INY             C8
0618        INY             C8
0619        STA *ROTORS,X   95 57

061B        DEC *TMP02      C6 5F
061D        BNE ROLLNX      D0 EE

061F        RTS             60


0620 REM_SU 
0620 STEPRT 

0620        LDY #$01        A0 01
0622        STY *TMP01      84 5E

0624        LDX #$03        A2 03

0626 STEPDO 
0626        LDA #$00        A9 00
0628        LDA *ROTORS,X   B5 57
062A        NOP             EA

062B        PHA             48
062C        CMP #$09        C9 09
062E        BNE STEPSK      D0 10

0630        LDA *ENIGV1     A5 4F
0632        CMP #$00        C9 00
0634        BNE STEPGR      D0 06

0636        CPX #$00        E0 00
0638        BEQ STEPSK      F0 06

063A        STY *TMP01      84 5E

063C STEPGR 

063C        INC *TMP01      E6 5E
063E        INC *TMP01      E6 5E

0640 STEPSK 
0640        CLC             18
0641        ROR *TMP01      66 5E
0643        BCC STEPNI      90 07

0645        INC *ROTORS,X   F6 57
0647        JSR ROLLOV      20 07 06
064A        LDY #$01        A0 01
064C REM_RO 

064C STEPNI 

064C        PLA             68
064D        CMP #$09        C9 09
064F        BEQ STEPCN      F0 06

0651        LDA *ENIGV1     A5 4F
0653        CMP #$00        C9 00
0655        BNE STEPEX      D0 05

0657 STEPCN 

0657        DEX             CA
0658        CPX #$FF        E0 FF
065A        BNE STEPDO      D0 CA

065C STEPEX 


065C REM_FA 


065C REM_SU 
065C ENIGMA 

065C        LDX #$00        A2 00
065E        STX *TMP04      86 61
0660        DEX             CA
0661        STX *TMP03      86 60

0663        LDY #$07        A0 07
0665        LDX #$03        A2 03
0667        LDA *KEYIN      A5 5B

0669 ENIGM2 
0669        JSR ENRING      20 AE 06

066C        STX *TMP01      86 5E

066E        PHA             48
066F        TXA             8A
0670        CMP #$00        C9 00
0672        BEQ ENIGXO      F0 03

0674        LDA *ENIGV1,X   B5 4F
0676        TAX             AA

0677 ENIGXO 
0677        PLA             68

0678        CLC             18
0679        ADC *TMP04      65 61
067B        ADC ROTIDX,X    7D 15 05
067E        TAX             AA
067F        LDA FWRTR1,X    BD 19 05

0682        PHA             48
0683        LDA #$00        A9 00
0685        LDX *TMP01      A6 5E
0687        JSR ENRING      20 AE 06
068A        STA *TMP02      85 5F
068C        PLA             68

068D        SEC             38
068E        SBC *TMP02      E5 5F
0690        BCS ENIGM3      B0 02
0692        ADC #$0A        69 0A

0694 ENIGM3 

0694        STA *KEYOUT     85 5C

0696        TYA             98

0697        CMP #$04        C9 04
0699        BNE ENIGNB      D0 08


069B REM_SE 

069B        LDA #$01        A9 01
069D        STA *TMP03      85 60

069F        LDA #$28        A9 28
06A1        STA *TMP04      85 61

06A3 ENIGNB 

06A3        TXA             8A
06A4        CLC             18
06A5        ADC *TMP03      65 60
06A7        TAX             AA

06A8        LDA *KEYOUT     A5 5C

06AA        DEY             88
06AB        BNE ENIGM2      D0 BC

06AD        RTS             60


06AE REM_SU 

06AE CALL_W 

06AE CALL_W 
06AE ENRING 

06AE        SEC             38
06AF        ADC *ROTORS,X   75 57
06B1 REM_PL 
06B1        CMP #$0A        C9 0A
06B3        BCC ENRIK1      90 02
06B5 REM_AB 
06B5        SBC #$0A        E9 0A
06B7 REM_CA 

06B7 ENRIK1 
06B7        SEC             38
06B8        SBC *RINGST,X   F5 53
06BA        BCS ENRIK2      B0 02
06BC        ADC #$0A        69 0A

06BE ENRIK2 
06BE        CLC             18
06BF        RTS             60

06C0 ROLLDF 
06C0 REM_NO 
06C0 .BYTE $FF              FF
06C1 ROLLSV 
06C1 .BYTE $09              09
06C2 .BYTE $0A              0A
06C3 .BYTE $00              00


06C4 REM_ME 

06C4 ROLLRT 
06C4 REM_RO 
06C4 .BYTE $00              00
06C5 .BYTE $03              03
06C6 .BYTE $04              04
06C7 .BYTE $01              01
06C8 ROLLGR 
06C8 REM_GE 
06C8 .BYTE $FF              FF
06C9 .BYTE $01              01
06CA .BYTE $02              02
06CB .BYTE $00              00


06CC REM_SU 

06CC REM_A_ 

06CC REM_FR 

06CC REM_TO 
06CC COPY   
06CC        STA *TMP01      85 5E

06CE COPYDO 
06CE        LDA *$00,X      B5 00
06D0        STA $0000,Y     99 00 00
06D3        INX             E8
06D4        INY             C8
06D5        DEC *TMP01      C6 5E
06D7        BNE COPYDO      D0 F5
06D9        RTS             60


06DA REM_SU 
06DA READKY 

06DA        LDX #$0F        A2 0F
06DC        STX *KEYIN      86 5B

06DE        JSR SHOWEN      20 C0 05

06E1        CMP #$15        C9 15
06E3        BCS READKY      B0 F5
06E5 REM_IF 

06E5        CMP #$13        C9 13
06E7 REM_GO 
06E7        BNE READKG      D0 07
06E9        TSX             BA
06EA REM_BA 
06EA        INX             E8
06EB        INX             E8
06EC REM_DI 
06EC        TXS             9A
06ED REM_AN 
06ED        JMP ZEROIZ      4C 6E 05
06F0 REM_SE 
06F0 READKG 

06F0        CMP #$0B        C9 0B
06F2        BEQ READEX      F0 07
06F4 REM_IF 
06F4        BCC READKY      90 E4
06F6 REM_IF 

06F6 REM_IF 
06F6        PHA             48
06F7 REM_SA 
06F7        JSR MOVROT      20 DF 05
06FA CHANGE 
06FA        PLA             68
06FB REM_AF 
06FB READEX 

06FB        RTS             60


06FC REM_SU 
06FC SETUP  
06FC        LDA #$04        A9 04
06FE        STA *ROLLTB     85 4B
0700        LDX #ROTORS     A2 57
0702        LDY #TMP06      A0 63
0704        JSR COPY        20 CC 06

0707        LDA #$03        A9 03
0709        LDX #ENIGVA     A2 50
070B        LDY #LROTOR     A0 58
070D        JSR COPY        20 CC 06

0710 SETF1  

0710        LDX #$00        A2 00
0712        STX *ROTORS     86 57
0714        STX *TMP03      86 60
0716        STX *TMP04      86 61
0718        STX *TMP05      86 62
071A        INX             E8
071B        STX *KEYOUT     86 5C

071D SETF1E 

071D        JSR READKY      20 DA 06

0720        CMP #$0B        C9 0B
0722        BEQ SETCHK      F0 03

0724        JMP SETF1       4C 10 07

0727 SETCHK 

0727        LDA #$01        A9 01
0729        LDX *LROTOR     A6 58
072B        STA *TMP02,X    95 5F
072D        LDX *MROTOR     A6 59
072F        STA *TMP02,X    95 5F
0731        LDX *RROTOR     A6 5A
0733        STA *TMP02,X    95 5F
0735        LDA #$00        A9 00
0737        CLC             18
0738        ADC *TMP03      65 60
073A        ADC *TMP04      65 61
073C        ADC *TMP05      65 62

073E        CMP #$03        C9 03
0740        BEQ SETUOK      F0 08

0742        LDA #$0E        A9 0E
0744        JSR TIMEOC      20 BB 05
0747        JMP SETF1E      4C 1D 07

074A SETUOK 

074A        LDX #LROTOR     A2 58
074C        LDY #ENIGVA     A0 50
074E        JSR COPY        20 CC 06

0751        LDA #$04        A9 04
0753        LDX #RINGST     A2 53
0755        LDY #ROTORS     A0 57
0757        JSR COPY        20 CC 06

075A        LDA #$00        A9 00
075C        STA *ROLLTB     85 4B

075E SETF2  

075E        LDX #$02        A2 02
0760        STX *KEYOUT     86 5C

0762        JSR READKY      20 DA 06

0765        CMP #$0B        C9 0B
0767        BEQ RNGCHK      F0 03

0769        JMP SETF2       4C 5E 07

076C RNGCHK 

076C        LDA #$08        A9 08
076E        STA *ROLLTB     85 4B

0770        LDA #$04        A9 04
0772        LDX #ROTORS     A2 57
0774        LDY #RINGST     A0 53
0776        JSR COPY        20 CC 06

0779 SETF3  

0779        LDA #$04        A9 04
077B        LDX #GEARAM     A2 4C
077D        LDY #ROTORS     A0 57
077F        JSR COPY        20 CC 06

0782        LDX #$03        A2 03
0784        STX *KEYOUT     86 5C

0786        JSR READKY      20 DA 06

0789        CMP #$0B        C9 0B
078B        BEQ GEACHK      F0 07

078D        LDA *$5A        A5 5A
078F        STA *ENIGV1     85 4F

0791        JMP SETF3       4C 79 07

0794 GEACHK 

0794        LDA #$04        A9 04
0796        LDX #TMP06      A2 63
0798        LDY #ROTORS     A0 57
079A        JSR COPY        20 CC 06

079D        LDA #$00        A9 00
079F        STA *ROLLTB     85 4B
07A1 REM_SE 
07A1        JSR TIMEOC      20 BB 05

07A4        JMP MNURET      4C 81 05

done.
