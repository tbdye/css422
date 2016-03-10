*-----------------------------------------------------------
* Title      : Test ADD
* Written by : Thomas Dye
* Date       : 3/10/2016
* Description: Test basic functionality of MOVEQ opcode.
*-----------------------------------------------------------
        ORG     $7000
START:




*   all ea for MOVEM
        MOVEM       D0-D7,(A1)
        MOVEM       D0-D7,-(A1)
        
        MOVEM       (A1),D0-D7
        MOVEM       (A1)+,D0-D7
        
*   test different sizes
        MOVEM.W     (A1)+,D0-D7
        MOVEM.L     (A1)+,D0-D7
        
        MOVEM.L D0-D7/A0-A6,$1234
        MOVEM.L (A5),D0-D2/D5-D7/A0-A3/A6
        MOVEM.W (A7)+,D0-D5/D7/A0-A6
        MOVEM.W D0-D5/D7/A0-A6,-(A7) 

        
        SIMHALT                ;halt simulator

        END     START          ;last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
