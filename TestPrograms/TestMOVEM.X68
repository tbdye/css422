*-----------------------------------------------------------
* Title      : Test MOVEM
* Written by : Thomas Dye
* Date       : 3/11/2016
* Description: Test basic functionality of MOVEM opcode.
*-----------------------------------------------------------
        ORG     $7000
START:
*   various EA modes
        MOVEM       D0-D7,-(A7)                     ;test1
        MOVEM       (A7)+,D0-D7                     ;test2

        MOVEM       A0-A6,-(A7)                     ;test3
        MOVEM       (A7)+,A0-A6                     ;test4
  
        MOVEM       A0-A6/D0-D7,-(A7)               ;test5
        MOVEM       (A7)+,A0-A6/D0-D7               ;test6
 
        MOVEM       D0-D7/A0-A6,$2468               ;test7
        MOVEM       D0-D7/A0-A6,$2468               ;test8

*   test different sizes        
        MOVEM.W     (A1)+,D0-D7                     ;test9
        MOVEM.L     (A1)+,D0-D7                     ;test10
        MOVEM.L     D0-D7/A0-A6,$1234               ;test11

        MOVEM.L     (A5),D0-D2/D5-D7/A0-A3/A6       ;test12
        MOVEM.W     D0-D5/D7/A0-A6,-(A7)            ;test13
        MOVEM.W     (A7)+,D0-D5/D7/A0-A6            ;test14

        MOVEM.L     A0/A1/A2/D5/D6/D7,$3A(A6,D4.L)  ;test15
        MOVEM.L     (A0)+,D0/D1/D2/A4/A3/A0/A1      ;test16
      
        SIMHALT                ;halt simulator

        END     START          ;last line of source









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
