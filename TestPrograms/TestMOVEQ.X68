*-----------------------------------------------------------
* Title      : Test ADD
* Written by : Thomas Dye
* Date       : 3/10/2016
* Description: Test basic functionality of MOVEQ opcode.
*-----------------------------------------------------------
        ORG     $7000
START:

        MOVEQ #1,D0
        MOVEQ #$FF,D0
        
        SIMHALT                ;halt simulator

        END     START          ;last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
