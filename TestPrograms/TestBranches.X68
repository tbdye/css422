*-----------------------------------------------------------
* Title      : Test Branches
* Written by : Thomas Dye
* Date       : 3/11/16
* Description: Test all banches with basic commands.  Can't actually run on its own.
*-----------------------------------------------------------
START   ORG     $6FFC

* Assigned opcodes here
test1   BRA     done
first   ADD.B   D0,D1       ; D200 - ADD
        ADDA.W  D0,A0       ; D0C0 - ADDA
        ADDI.B  #$FF,D0     ; 0600 00FF - ADDI
        ADDI.B  #1,D0       ; 5200 - ADDQ (need to add)
        AND.B   D0,D1       ; C200 - AND
        ANDI.B  #1,D0       ; 0200 0001 - ANDI
        ASL.B   #1,D0       ; E300 - SHIFT_ROT
        ASR.B   #1,D0       ; E200 - SHIFT_ROT
        BCC     test1       ; 64E6 - BCC (00006FFC)
        BCC.B   test1       ; 64E4 - BCC (00006FFC)
        BCC.W   test1       ; 6400 FFE2 - BCC (00006FFC)
        BGT     test2       ; 6E00 0058 - BCC (00007076)
        BGT.B   test2       ; 6E54 - BCC (00007076)
        BGT.W   test2       ; 6E00 0052 - BCC (00007076)
        BLE     $702E       ; 6F06 - BCC (0000702E)
        BLE.B   $702E       ; 6F04 - BCC (0000702E)
        BLE.W   $702E       ; 6F00 0002 - BCC (0000702E)
        CLR.B   D0          ; 4200 - CLR
        CMP.B   D0,D1       ; B200 - CMP
        CMPI.B  #1,D0       ; 0C00 0001 - CMPI
        DIVS.W  #1,D1       ; 83FC 0001 - DIVS
        DIVU.W  #1,D1       ; 82FC 0001 - DIVU
        JSR     test4       ; 4EB9 0000707A - JSR (JSR displacement may shift if opcodes are added)
        LEA     msg,A0      ; 41F9 0000707C - LEA (LEA displacement may shift if opcodes are added)
        LSL.B   #1,D0       ; E308 - SHIFT_ROT
        LSR.B   #1,D0       ; E208 - SHIFT_ROT
        MOVE.B  D0,D1       ; 1200 - MOVEB
        MOVE.L  D0,D1       ; 2200 - MOVEL
        MOVE.W  D0,D1       ; 3200 - MOVEW
        MOVEM.W D0,-(SP)    ; 48A7 8000 - MOVEM_TO_EA
        MOVEQ.L #1,D0       ; 7001 - MOVEQ
        MULS.W  D0,D1       ; C3C0 - MULS
        NOP                 ; 4E71 - NOP
        NOT.W   D1          ; 4641 - NOT (Triggers OP_INVALID)
        ROL.B   #1,D0       ; E318 - SHIFT_ROT
        ROR.B   #1,D0       ; E218 - SHIFT_ROT
        SUB.B   #1,D0       ; 5300 - SUBQ (need to add)
        SUB.B   #$FF,D0     ; 0040 00FF - SUBI
        SUB.B   D0,D1       ; 9200 - SUB
        SUBA.W  #1,A0       ; 5348 - SUBQ
        SUBA.W  #$FF,A0     ; 90FC 00FF - SUBA

* Optional opcodes here
        ;BCHG.L  #1,D0       ; 0840 0001 - BIT_OP
        
done    SIMHALT             ; halt simulator

test2   BRA     done
test3   BRA     done
test4   RTS

msg     DC.B    'test5',0

        END     START       ; last line of source














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
