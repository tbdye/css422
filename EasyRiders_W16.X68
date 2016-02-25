*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 2/24/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Main
*---------------Opcode--Operands------------Comments---------------------------
START           ORG     $1000               ;Load at this address

*   Get User Input
                MOVE.W  #$7000,A2           ;TEMP collect input from the user to determine where to start in memory

*   Process Instructions
                LEA     ROOT_JMP_TABLE,A0   ;Index into the table        
piLoop          JSR     SR_PrintAddr
                CLR.L   D7                  ;Zero it
                MOVE.W  (A2),D7             ;We'll play with it here
                MOVE.B  #12,D1              ;Shift 12 bits to the right  
                LSR.W   D1,D7               ;Move the bits
                MULU    #6,D7               ;Form offset     
                JSR     0(A0,D7)            ;Jump indirect with index
                ADDA    #2,A2
                BRA     piLoop 

*------------------------------------------------------------------------------
* Root Branch - bits 15-12 ----------------------------------------------------
*------------------------------------------------------------------------------
* Root Level Jump Table
*---------------Opcode--Operands------------Comments---------------------------
ROOT_JMP_TABLE  JMP     BRANCH_0            ;$0 - Bit Manipulation/MOVEP/Immediate
                JMP     OP_MOVE_B           ;$1 - Move Byte
                JMP     OP_MOVE_L           ;$2 - Move Long
                JMP     OP_MOVE_W           ;$3 - Move Word
                JMP     BRANCH_4            ;$4 - Miscellaneous
                JMP     OP_INVALID          ;$5 - ADDQ/SUBQ/Scc/DBcc/TRAPc c
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
* From Root to Branch 0
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_0        JSR     SR_Eval11to8

                BEQ     OP_ANDI             ;$0
                BEQ     OP_ADDI             ;$3
                BEQ     OP_BCHG             ;$8
                BEQ     OP_CMPI             ;$C

                JSR     SR_Eval7to6
                BEQ     OP_BCHG             ;%01

                BRA     OP_INVALID          ;No matches found

* From Root to Branch 4
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_4        BRA     OP_NOP              ;Temp unconditional branch for testing
                JSR     SR_Eval11to8
                
                BEQ     OP_CLR              ;$2
                BEQ     BRANCH_4E           ;$E
                
                BEQ     SR_Eval11to6
                BEQ     OP_MOVEM            ;%1x001x
                BEQ     OP_LEA              ;%xxx111
                
                BRA     OP_INVALID          ;No matches found

* From Root to Branch 6
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_6        JSR     SR_Eval11to8
                
                BEQ     OP_BCC              ;$4
                BEQ     OP_BGT              ;$E
                BEQ     OP_BLE              ;$F
                
                BRA     OP_INVALID          ;No matches found

* From Root to Branch 8
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_8        JSR     SR_Eval8to6
                
                BEQ     OP_INVALID          ;%111 - Op not supported
                BRA     OP_DIVS

* From Root to Branch 8
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_9        JSR     SR_Eval8to6

                BEQ     OP_SUBA             ;%011
                BEQ     OP_SUBA             ;%111
                BRA     OP_SUB

* From Root to Branch B
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_B        JSR     SR_Eval8to6

                BEQ     OP_CMP              ;%000
                BEQ     OP_CMP              ;%001
                BEQ     OP_CMP              ;%010
                BRA     OP_INVALID          ;No matches found

* From Root to Branch C
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_C        JSR     SR_Eval8to6

                BEQ     OP_INVALID          ;%011 - Op not supported
                BEQ     OP_MULS             ;%111
                BRA     OP_AND

* From Root to Branch D
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_D        JSR     SR_Eval8to6

                BEQ     OP_ADDA             ;%011
                BEQ     OP_ADDA             ;%111
                BRA     OP_ADD

* From Root to Branch E
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_E        JSR     SR_Eval8to3

                BEQ     OP_ASR              ;%0xxx00
                BEQ     OP_LSR              ;%0xxx01
                BEQ     OP_ROR              ;%0xxx11
                BEQ     OP_ASL              ;%1xxx00
                BEQ     OP_LSL              ;%1xxx01
                BEQ     OP_ROL              ;%1xxx11
                BRA     OP_INVALID

* From Root to Branch F
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_F        BRA     OP_SIMHALT

*------------------------------------------------------------------------------
* Second Level Branches - bits 7-4 --------------------------------------------
*------------------------------------------------------------------------------
* From Branch 4 to Branch 4E
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_4E       JSR     SR_Eval7to4

                BEQ     BRANCH_4E7          ;$7
                
                JSR     SR_Eval7to6
                
                BEQ     OP_JSR              ;%10
                BRA     OP_INVALID          ;No matches found
            
*------------------------------------------------------------------------------
* Third Level Branches - bits 3-0 ---------------------------------------------
*------------------------------------------------------------------------------
* From Branch 4E to Branch 4E7
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_4E7      JSR     SR_Eval3to0

                BEQ     OP_NOP              ;$1
                BEQ     OP_RTS              ;$5
                BRA     OP_INVALID          ;No matches found

*------------------------------------------------------------------------------
* Opcodes ---------------------------------------------------------------------
*------------------------------------------------------------------------------
* Add
*---------------Opcode--Operands------------Comments---------------------------
OP_ADD

* Add Address
*---------------Opcode--Operands------------Comments---------------------------
OP_ADDA

* Add Immediate
*---------------Opcode--Operands------------Comments---------------------------
OP_ADDI

* AND Logical
*---------------Opcode--Operands------------Comments---------------------------
OP_AND

* AND Immediate
*---------------Opcode--Operands------------Comments---------------------------
OP_ANDI

* Arithmetic Shift Left
*---------------Opcode--Operands------------Comments---------------------------
OP_ASL

* Arithmetic Shift Right
*---------------Opcode--Operands------------Comments---------------------------
OP_ASR

* Branch Conditionally - Carry Clear
*---------------Opcode--Operands------------Comments---------------------------
OP_BCC

* Test a Bit and Change
*---------------Opcode--Operands------------Comments---------------------------
OP_BCHG

* Branch Conditionally - Greater Than
*---------------Opcode--Operands------------Comments---------------------------
OP_BGT

* Branch Conditionally - Less or Equal
*---------------Opcode--Operands------------Comments---------------------------
OP_BLE

* Clear an Operand
*---------------Opcode--Operands------------Comments---------------------------
OP_CLR

* Compare
*---------------Opcode--Operands------------Comments---------------------------
OP_CMP

* Compare Immediate
*---------------Opcode--Operands------------Comments---------------------------
OP_CMPI

* Signed Divide
*---------------Opcode--Operands------------Comments---------------------------
OP_DIVS

* Disassembler does not support provided opcode
*---------------Opcode--Operands------------Comments---------------------------
OP_INVALID

* Jump to Subroutine
*---------------Opcode--Operands------------Comments---------------------------
OP_JSR

* Load Effective Address
*---------------Opcode--Operands------------Comments---------------------------
OP_LEA

* Logical Shift Left
*---------------Opcode--Operands------------Comments---------------------------
OP_LSL

* Logical Shift Right
*---------------Opcode--Operands------------Comments---------------------------
OP_LSR

* Move Data from Source to Destination - Byte
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVE_B       LEA     DISP_MOVE,A1           ;
                MOVE.B  #14,D0              ;
                TRAP    #15
            
                LEA     DISP_SIZE_B,A1
                MOVE.B  #14,D0
                TRAP    #15
            
                JSR     SR_PrintTab
            
                MOVE.B  #13,D4
            
                MOVE.W  (A2),D2
                MOVE.B  #10,D5
                LSL.W   D5,D2
                LSR.W   D4,D2
            
                MOVE.W  (A2),D3
                MOVE.B  #13,D5
                LSL.W   D5,D3
                LSR.W   D4,D3
            
                JSR     SR_Decode_EA

                LEA     DISP_COMMA,A1
                MOVE.B  #14,D0
                TRAP    #15
            
                MOVE.W  (A2),D2
                MOVE.B  #7,D5
                LSL.W   D5,D2
                LSR.W   D4,D2
            
                MOVE.W  (A2),D3
                MOVE.B  #4,D5
                LSL.W   D5,D3
                LSR.W   D4,D3

                JSR     SR_Decode_EA
            
                LEA     MSG_LINEBREAK,A1
                MOVE.B  #14,D0
                TRAP    #15
                       
                RTS

* Move Data from Source to Destination - Long
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVE_L

* Move Data from Source to Destination - Word
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVE_W

* Move Multiple Registers
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVEM

* Move Quick
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVEQ

* Signed Multiply
*---------------Opcode--Operands------------Comments---------------------------
OP_MULS

* No Operation
*---------------Opcode--Operands------------Comments---------------------------
OP_NOP          LEA     DISP_NOP,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Rotate (Without Extend) Left
*---------------Opcode--Operands------------Comments---------------------------
OP_ROL

* Rotate (Without Extend) Right
*---------------Opcode--Operands------------Comments---------------------------
OP_ROR

* Return from Subroutine
*---------------Opcode--Operands------------Comments---------------------------
OP_RTS

* PseudoOp Simhalt
*---------------Opcode--Operands------------Comments---------------------------
OP_SIMHALT      LEA     DISP_SIMHALT,A1
                MOVE.B  #13,D0
                TRAP    #15
                BRA     TERMINATE

* Subtract
*---------------Opcode--Operands------------Comments---------------------------
OP_SUB

* Subtract Address
*---------------Opcode--Operands------------Comments---------------------------
OP_SUBA

*------------------------------------------------------------------------------
* Subroutines -----------------------------------------------------------------
*------------------------------------------------------------------------------
* SR_DecodeEA determines and prints the effective address mode and register of
* six bits
* Registers passed: D2(mode), D3(register)
* Return: null
*---------------Opcode--Operands------------Comments---------------------------
SR_Decode_EA    LEA     deModeTable,A3
                LEA     TABLE_HEXCHAR,A4
                JSR     0(A3,D2)
                RTS
                
*   EA Mode Table
deModeTable     JMP     deMode_000          ;0 - Register Direct Data
                JMP     deMode_001          ;1 - Register Direct Address
                JMP     deMode_010          ;2 - Register Indirect Address
                JMP     deMode_011          ;3 - Register Indirect Address Post Inc
                JMP     deMode_100          ;4 - Register Indirect Address Post Dec
                JMP     deMode_101          ;5 - Not Supported
                JMP     deMode_110          ;6 - Not Supported
                JMP     deMode_111          ;7 - Absolute Data Short/Long/Immediate
                
*   0 - Register Direct Data
deMode_000      MOVE.B  #26,D5
                LEA     0(A4,D5),A1
                MOVE.B  #14,D0
                TRAP    #15

                MULS    #2,D3
                LEA 0(A4,D3),A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS

*   1 - Register Direct Address
deMode_001      RTS

*   2 - Register Indirect Address
deMode_010      RTS

*   3 - Register Indirect Address Post Inc
deMode_011      RTS

*   4 - Register Indirect Address Post Dec
deMode_100      RTS

*   5 - Not Supported
deMode_101      RTS

*   6 - Not Supported
deMode_110      RTS

*   7 - Absolute Data Short/Long/Immediate
deMode_111      RTS

* Evaluate Bits 3 to 0
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval3to0     RTS

* Evaluate Bits 7 to 4
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval7to4     RTS

* Evaluate Bits 7 to 6
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval7to6     RTS

* Evaluate Bits 8 to 3
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval8to3     RTS

* Evaluate Bits 8 to 6
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval8to6     RTS

* Evaluate Bits 11 to 6
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval11to6    RTS

* Evaluate Bits 11 to 8
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval11to8    RTS

* Prints the hex address in A2 when called
* Registers passed: A2
* Return: Null
*---------------Opcode--Operands------------Comments---------------------------
SR_PrintAddr    LEA     TABLE_HEXCHAR,A3    ;load constants and table into registers
                MOVE.B  #0,D5        
                MOVE.B  #28,D4              ;char shift

*   Load the address to be printed into D6
paLoop          MOVE.W  A2,D6
        
*   Isolate nibble in D6 to be printed as a hex character
                LSL.L   D5,D6        
                LSR.L   D4,D6

*   Multiply nibble by two, find character in char_table
                MULU    #2,D6
                LEA     0(A3,D6),A1

*   Print char
                MOVE.B  #14,D0
                TRAP    #15
            
*   Increment loop counter by four, check if loop is done
                ADD.B   #4,D5
                CMP.B   #32,D5
                BEQ     SR_PrintTab         ;Exits loop
                BRA     paLoop
                
* Add a tab to the end of a printed string, leave subroutine
*---------------Opcode--Operands------------Comments---------------------------
SR_PrintTab     LEA     DISP_TAB,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS

*------------------------------------------------------------------------------
* Variables and Constants -----------------------------------------------------
*------------------------------------------------------------------------------
*
*---------------Opcode--Operands------------Comments---------------------------
CR              EQU     $0D                 ;Carriage Return
LF              EQU     $0A                 ;Line feed

MSG_WELCOME     DC.B    'Welcome message to display here.',CR,LF,0
MSG_LINEBREAK   DC.B    CR,LF,0

DISP_NOP        DC.B    'NOP',0
DISP_MOVE       DC.B    'MOVE',0
DISP_SIMHALT    DC.B    'SIMHALT',0

DISP_TAB        DC.B    '   ',0
DISP_COMMA      DC.B    ',',0
DISP_SIZE_B     DC.B    '.B',0
DISP_SIZE_W     DC.B    '.W',0
DISP_SIZE_L     DC.B    '.W',0

TABLE_HEXCHAR   DC.B    '0',0
                DC.B    '1',0
                DC.B    '2',0
                DC.B    '3',0
                DC.B    '4',0
                DC.B    '5',0
                DC.B    '6',0
                DC.B    '7',0
                DC.B    '8',0
                DC.B    '9',0
                DC.B    'A',0 
                DC.B    'B',0
                DC.B    'C',0
                DC.B    'D',0
                DC.B    'E',0
                DC.B    'F',0

TERMINATE       SIMHALT                     ;Halt the simulator

                END     START               ;Do not put anything below this line.

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
