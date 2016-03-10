*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 3/1/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Disassembler instruction branch decoder
*------------------------------------------------------------------------------
* Root Branch - bits 15-12 ----------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
ROOT_JMP_TABLE  JMP     BRANCH_0            ;$0 - Bit Manipulation/MOVEP/Immediate
                JMP     OP_MOVE_B           ;$1 - Move Byte
                JMP     OP_MOVE_L           ;$2 - Move Long
                JMP     OP_MOVE_W           ;$3 - Move Word
                JMP     BRANCH_4            ;$4 - Miscellaneous
                JMP     BRANCH_5            ;$5 - ADDQ/SUBQ/Scc/DBcc/TRAPc c
                JMP     BRANCH_6            ;$6 - Bcc/BSR/BRA
                JMP     OP_MOVEQ            ;$7 - MOVEQ
                JMP     BRANCH_8            ;$8 - OR/DIV/SBCD
                JMP     BRANCH_9            ;$9 - SUB/SUBX
                JMP     OP_INVALID          ;$A - Unassigned, Reserved
                JMP     BRANCH_B            ;$B - CMP/EOR
                JMP     BRANCH_C            ;$C - AND/MUL/ABCD/EXG
                JMP     BRANCH_D            ;$D - ADD/ADDX
                JMP     BRANCH_E            ;$E - Shift/Rotate/Bit Field
                JMP     BRANCH_F            ;$F - Coproccessor and CPU 32 Extensions

*------------------------------------------------------------------------------
* First Level Branches - bits 11-8 --------------------------------------------
*------------------------------------------------------------------------------
* From Root to Branch 0 -------------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace (set by SR_Eval11to8 and SR_Eval7to6)
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_0        JSR     SR_Eval11to8        ;Reads A2, Returns D7

                CMP.B   #$2,D7
                BEQ     OP_ANDI             ;$2
                CMP.B   #$4,D7
                BEQ     OP_SUBI             ;$4
                CMP.B   #$6,D7
                BEQ     OP_ADDI             ;$6
                CMP.B   #$C,D7
                BEQ     OP_CMPI             ;$C

                BRA     OP_INVALID          ;No matches found

* From Root to Branch 4 -------------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace (set by SR_Eval11to8 and SR_Eval11to6)
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_4        JSR     SR_Eval11to8        ;Reads A2, Returns D7
                
                CMP.B   #$2,D7
                BEQ     OP_CLR              ;$2
                CMP.B   #$E,D7
                BEQ     BRANCH_4E           ;$E

                JSR     SR_Eval11to6        ;Reads A2, Returns D7
                ANDI.B  #%00101110,D7       ;Mask out bits where index = 0 for eval
                
                CMP.B   #%00100010,D7
                BEQ     OP_MOVEM            ;%1x001x

                JSR     SR_Eval8to6         ;Reads A2, Returns D7
                
                CMP.B   #%111,D7
                BEQ     OP_LEA              ;%111

                BRA     OP_INVALID          ;No matches found

* From Root to Branch 5 -------------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_5        MOVE.W  (A2),D7             ;Reload full opcode for evaluation

                BTST    #8,D7
                BEQ     OP_ADDQ             ;Bit 8 = 0
                BTST    #8,D7
                BNE     OP_SUBQ             ;Bit 8 = 1
                
                BRA     OP_INVALID          ;No matches found

* From Root to Branch 6 -------------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace (set by SR_Eval11to8)
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_6        JSR     SR_Eval11to8        ;Reads A2, Returns D7
                
                CMP.B   #$4,D7
                BEQ     OP_BCC              ;$4
                CMP.B   #$E,D7
                BEQ     OP_BGT              ;$E
                CMP.B   #$F,D7
                BEQ     OP_BLE              ;$F
                
                BRA     OP_INVALID          ;No matches found

* From Root to Branch 8 -------------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace (set by SR_Eval8to6)
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_8        JSR     SR_Eval8to6         ;Reads A2, Returns D7
                
                CMP.B   #%011,D7
                BEQ     OP_DIVU             ;%011
                CMP.B   #%111,D7
                BEQ     OP_DIVS             ;%111
                
                BRA     OP_INVALID          ;No matches found

* From Root to Branch 9 -------------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace (set by SR_Eval8to6)
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_9        JSR     SR_Eval7to6         ;Reads A2, Returns D7

                CMP.B   #%11,D7
                BEQ     OP_SUBA             ;%11

                JSR     SR_Eval8to4         ;Reads A2, Returns D7
                ANDI.B  #%00010011,D7       ;Mask out bits where index = 0 for eval
                
                CMP.B   #%00010000,D7
                BEQ     OP_INVALID          ;%1xx00 - Op not supported
                
                BRA     OP_SUB              ;All other combinations

* From Root to Branch B -------------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace (set by SR_Eval8to6)
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_B        JSR     SR_Eval8to6         ;Reads A2, Returns D7

                CMP.B   #%000,D7
                BEQ     OP_CMP              ;%000
                CMP.B   #%001,D7
                BEQ     OP_CMP              ;%001
                CMP.B   #%010,D7
                BEQ     OP_CMP              ;%010
                
                BRA     OP_INVALID          ;No matches found

* From Root to Branch C -------------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace (set by SR_Eval8to6)
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_C        JSR     SR_Eval8to6         ;Reads A2, Returns D7

                CMP.B   #%011,D7
                BEQ     OP_MULU             ;%011
                CMP.B   #%111,D7
                BEQ     OP_MULS             ;%111
                
                JSR     SR_Eval8to4         ;Reads A2, Returns D7
                ANDI.B  #%00011111,D7       ;Mask out bits where index = 0 for eval
                
                CMP.B   #%00010000,D7
                BEQ     OP_INVALID          ;%10000 - Op not supported
                
                JSR     SR_Eval8to4         ;Reads A2, Returns D7
                ANDI.B  #%00010011,D7       ;Mask out bits where index = 0 for eval
                
                CMP.B   #%00010000,D7
                BEQ     OP_INVALID          ;%1xx00 - Op not supported
                
                BRA     OP_AND              ;All other combinations

* From Root to Branch D -------------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace (set by SR_Eval8to6)
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_D        JSR     SR_Eval8to4         ;Reads A2, Returns D7
                ANDI.B  #%00010011,D7       ;Mask out bits where index = 0 for eval

                CMP.B   #%00010000,D7
                BEQ     OP_INVALID          ;%1xx00 - Op not supported
                
                JSR     SR_Eval7to6         ;Reads A2, Returns D7

                CMP.B   #%11,D7
                BEQ     OP_ADDA             ;%11
                
                BRA     OP_ADD              ;All other combinations

* From Root to Branch E -------------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace (set by SR_Eval8to3)
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_E        JSR     SR_Eval11to6        ;Reads A2, Returns D7
                ANDI.B  #%00111111,D7       ;Mask out bits where index = 0 for eval
*   Catch memory shifts                
                CMP.B   #%00000011,D7
                BEQ     OP_ASR              ;%000011
                CMP.B   #%00001011,D7
                BEQ     OP_LSR              ;%001011
                CMP.B   #%00011011,D7
                BEQ     OP_ROR              ;%011011

                CMP.B   #%00000111,D7
                BEQ     OP_ASL              ;%000111
                CMP.B   #%00001111,D7
                BEQ     OP_LSL              ;%001111
                CMP.B   #%00011111,D7
                BEQ     OP_ROL              ;%011111

                ANDI.B  #%00111011,D7       ;Mask out bits where index = 0 for eval
                
                CMP.B   #%00010011,D7
                BEQ     OP_INVALID          ;%010x11
                
*   Catch count and register shifts
                JSR     SR_Eval8to3         ;Reads A2, Returns D7
                ANDI.B  #%00100011,D7       ;Mask out bits where index = 0 for eval
                
                CMP.B   #%00000000,D7
                BEQ     OP_ASR              ;%0xxx00
                CMP.B   #%00000001,D7
                BEQ     OP_LSR              ;%0xxx01
                CMP.B   #%00000011,D7
                BEQ     OP_ROR              ;%0xxx11
                CMP.B   #%00100000,D7
                BEQ     OP_ASL              ;%1xxx00
                CMP.B   #%00100001,D7
                BEQ     OP_LSL              ;%1xxx01
                CMP.B   #%00100011,D7
                BEQ     OP_ROL              ;%1xxx11
                
                BRA     OP_INVALID

* From Root to Branch F -------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_F        BRA     OP_SIMHALT

*------------------------------------------------------------------------------
* Second Level Branches - bits 7-4 --------------------------------------------
*------------------------------------------------------------------------------
* From Branch 4 to Branch 4E --------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace (set by SR_Eval7to4 and SR_Eval7to6)
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_4E       JSR     SR_Eval7to4         ;Reads A2, Returns D7
                
                CMP.B   #$7,D7
                BEQ     BRANCH_4E7          ;$7
                
                JSR     SR_Eval7to6         ;Reads A2, Returns D7
                
                CMP.B   #%10,D7
                BEQ     OP_JSR              ;%10
                
                BRA     OP_INVALID          ;No matches found
            
*------------------------------------------------------------------------------
* Third Level Branches - bits 3-0 ---------------------------------------------
*------------------------------------------------------------------------------
* From Branch 4E to Branch 4E7 ------------------------------------------------
* Register list:
* A2: Current test opcode in use and sequence locator (do not modify)
* D7: Current test opcode workspace (set by SR_Eval3to0)
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_4E7      JSR     SR_Eval3to0         ;Reads A2, Returns D7

                CMP.B   #$1,D7
                BEQ     OP_NOP              ;$1
                CMP.B   #$5,D7
                BEQ     OP_RTS              ;$5
                
                BRA     OP_INVALID          ;No matches found









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
