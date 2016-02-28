*-----------------------------------------------------------
* Title      : Test Branches
* Written by : Thomas Dye
* Date       : 2/28/16
* Description: Test all banches with basic commands
*-----------------------------------------------------------
START   ORG     $7000

* Put program code here
        ADD.B   D0,D1
        ADDA.W  D0,A0
        ADDI.B  #1,D0
        AND.B   D0,D1
        ANDI.B  #1,D0
        ASL.B   #1,D0
        ASR.B   #1,D0
        BCC.B   test1
one     BCHG.L  #1,D0
        BGT     test2
two     BLE     test3    
three   CLR.B   D0
        CMP.B   D0,D1
        CMPI.B  #1,D0
        NOT.W   D1      ; Triggers OP_INVALID
        DIVS.W  #1,D1
        JSR     test4   ; Triggers JSR, then RTS
        LEA     msg,A0
        LSL.B   #1,D0
        LSR.B   #1,D0
        MOVE.B  D0,D1
        MOVE.L  D0,D1
        MOVE.W  D0,D1
        MOVEM.W D0,-(SP)
        MOVEQ.L #1,D0
        MULS.W  D0,D1
        NOP
        ROL.B   #1,D0
        ROR.B   #1,D0
        SUB.B   #1,D0
        SUBA.W  #1,A0

        SIMHALT         ; halt simulator

test1   BRA     one
test2   BRA     two
test3   BRA     three
test4   RTS

msg     DC.B    'test5',0

        END     START   ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
