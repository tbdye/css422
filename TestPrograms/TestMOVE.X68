*-----------------------------------------------------------
* Title      : Test MOVE
* Written by : Thomas Dye
* Date       : 2/16/2016
* Description: Test basic functionality of MOVE opcode.
*-----------------------------------------------------------
        ORG     $7000
START:

* Test Size (also tests Dn as dest and Dn as src)
        MOVE.B  D7,D0           ;test01 size byte
        MOVE.W  D6,D1           ;test02 size word
        MOVE.L  D5,D2           ;test03 size long 
    
* Test Destination EA
        MOVE.B  D1,(A0)         ;test04 dest (An)
        MOVE.B  D1,(A0)+        ;test05 dest (An)+
        MOVE.B  D1,-(A0)        ;test06 dest -(An)
        MOVE.B  D1,$42A6        ;test07 dest (xxx).W
        MOVE.B  D1,$0000A000    ;test08 dest (xxx).L

* Test Source EA
        MOVE.W  A1,D1           ;test09 src An
        MOVE.B  (A1),D1         ;test10 src (An)
        MOVE.B  (A1)+,D1        ;test11 src (An)+
        MOVE.B  -(A1),D1        ;test12 src -(An)
        MOVE.W  $42A6,D1        ;test13 src (xxx).W
        MOVE.L  $0000A000,D1    ;test14 src (xxx).L
        MOVE.B  #$2A,D1         ;test15 src #<data>
        
* Tricky
        MOVE.W  #$9100,D0       ;test16
        MOVE.L  #$9100,D0       ;test17
        MOVE.W  #$4214,D0       ;test18
        MOVE.L  #$4214,D0       ;test19
        MOVE.B  $00004340,D3    ;test20
        MOVE.B  $A340,D3        ;test21
        MOVE.B  $FFFFA340,D3    ;test22
        MOVE.B  $FFFF4340,D3    ;test23
        MOVE.W  $A340,D3        ;test24
        
        SIMHALT                 ;halt simulator

        END     START           ;last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
