*-----------------------------------------------------------
* Title      : Test ADD
* Written by : Thomas Dye
* Date       : 2/29/2016
* Description: Test basic functionality of ADD opcode.
*-----------------------------------------------------------
        ORG     $7000
START:

* Test Size (also tests Dn as dest and Dn as src)
        ADD.B  D7,D0           ;test01 size byte
        ADD.W  D6,D1           ;test02 size word
        ADD.L  D5,D2           ;test03 size long 
    
* Test Destination EA
        ADD.B  D1,(A0)         ;test04 dest (An)
        ADD.B  D1,(A0)+        ;test05 dest (An)+
        ADD.B  D1,-(A0)        ;test06 dest -(An)
        ADD.B  D1,$42A6        ;test07 dest (xxx).W
        ADD.B  D1,$0000A000    ;test08 dest (xxx).L

* Test Source EA
        ADD.W  A1,D1           ;test09 src An
        ADD.B  (A1),D1         ;test10 src (An)
        ADD.B  (A1)+,D1        ;test11 src (An)+
        ADD.B  -(A1),D1        ;test12 src -(An)
        ADD.W  $42A6,D1        ;test13 src (xxx).W
        ADD.L  $0000A000,D1    ;test14 src (xxx).L - failed dest
        
* Tricky
        ADD.B  $4340,D3        ;test15 - failed dest
        ADD.B  $0000A340,D3    ;test16 - failed dest
        ADD.B  $0000A340,D3    ;test17 - failed dest
        ADD.B  $FFFF4340,D3    ;test18 - failed dest
        ADD.W  $0000A340,D3    ;test19 - failed dest
        
        SIMHALT                ;halt simulator

        END     START          ;last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
