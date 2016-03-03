*-----------------------------------------------------------
* Title      : Test SHIFTROT
* Written by : Thomas Dye
* Date       : 3/1/2016
* Description: Test basic functionality of SHIFTROT group.
*-----------------------------------------------------------
        ORG     $7000
START:

* Test Size (also immediate mode and tests Dn as dest)
        ASL.B   #1,D0           ;test01 - E300
        ASR.W   #1,D1           ;test02 - E241
        LSL.L   #1,D2           ;test03 - E38A
        LSR.B   #1,D3           ;test04 - E20B
        ROL.W   #1,D4           ;test05 - E35C
        ROR.L   #1,D5           ;test06 - E29D
    
* Test Register to Register Shift Mode
        ASR.B   D7,D0           ;test07 - EE20
        LSL.B   D6,D1           ;test08 - ED29
        ROL.B   D5,D2           ;test09 - EB3A

* Test Immediate Shift Mode
        ASR.B   #6,D0           ;test10 - EC00
        LSL.B   #7,D0           ;test11 - EF08
        ROL.B   #8,D0           ;test12 - E118

* Test Register Shift Mode
        ASR.W   (A0)            ;test13 - E0D0 - fails
        LSL.W   (A0)+           ;test14 - E3D8 - fails
        ROL.W   -(A0)           ;test15 - E7E0 - fails
        ASR.W   $42A6           ;test16 - E0F8 42A6 - fails
        LSL.W   $9100           ;test17 - E3F9 00009100 - fails
        ROL.W   $0000A000       ;test18 - E7F9 0000A000 - fails
        
        SIMHALT                ;halt simulator

        END     START          ;last line of source









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
