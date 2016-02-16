*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 2/16/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Peng Yang
*------------------------------------------------------------------------------
* Label         Opcode  Operands    Comments
* 0             17      25          37
                ORG     $1000       ;Load at this address
INPUT           NOP                 ;TBD
                BRA     ROOT_BRANCH ;Process input


*------------------------------------------------------------------------------
* Root Branch
* Label         Opcode  Operands    Comments
* 0             17      25          37
BRANCH_ROOT                         ;Process bits 15-12
                CMP.B   #%0000,D1   ;Bit Manipulation/MOVEP/Immediate
                BEQ     BRANCH_0
                
                CMP.B   #%0001,D1   ;Move Byte
                BEQ     MOVE
                
                CMP.B   #%0010,D1   ;Move Long
                BEQ     MOVE
                
                CMP.B   #%0011,D1   ;Move Word
                BEQ     MOVE
                
                CMP.B   #%0100,D1   ;Miscellaneous
                BEQ     BRANCH_4
                
                CMP.B   #%0101,D1   ;ADDQ/SUBQ/Scc/DBcc/TRAPc c
                BEQ     BRANCH_5
                
                CMP.B   #%0110,D1   ;Bcc/BSR/BRA
                BEQ     BRANCH_6
                
                CMP.B   #%0111,D1   ;MOVEQ
                BEQ     MOVEQ
                
                CMP.B   #%1000,D1   ;OR/DIV/SBCD
                BEQ     BRANCH_8
                
                CMP.B   #%1001,D1   ;SUB/SUBX
                BEQ     BRANCH_9
                
                CMP.B   #%1011,D1   ;CMP/EOR
                BEQ     BRANCH_B
                
                CMP.B   #%1100,D1   ;AND/MUL/ABCD/EXG
                BEQ     BRANCH_C
                
                CMP.B   #%1101,D1   ;ADD/ADDX
                BEQ     BRANCH_D
                
                CMP.B   #%1110,D1   ;Shift/Rotate/Bit Field
                BEQ     BRANCH_E
                
                BRA     INVALID_OP  ;No matches found

*------------------------------------------------------------------------------
* First Level Branches - bits 11-8
* Label         Opcode  Operands    Comments
* 0             17      25          37
BRANCH_0
                BEQ     BRANCH_00
                BEQ     BRANCH_04
                BEQ     BRANCH_08
                BEQ     BRANCH_0A
                BEQ     BRANCH_0C
                BEQ     BCHG
                BRA     INVALID_OP  ;No matches found

BRANCH_4
                BEQ     BRANCH_42
                BEQ     BRANCH_4C
                BEQ     BRANCH_4E
                BEQ     MOVEM       ;FIX: I think there's a bug with this and it'll catch 4C
                BEQ     MOVEM
                BEQ     LEA
                BRA     INVALID_OP  ;No matches found

BRANCH_5

BRANCH_8

BRANCH_9

BRANCH_B

BRANCH_C

BRANCH_D

BRANCH_E

*------------------------------------------------------------------------------
* Second Level Branches - bits 7-4
* Label         Opcode  Operands    Comments
* 0             17      25          37
BRANCH_00

BRANCH_04

BRANCH_08

BRANCH_0A

BRANCH_0C

BRANCH_42

BRANCH_4C

BRANCH_4E
                BEQ     BRANCH_4E7
                BEQ     JSR
                BRA     INVALID_OP  ;No matches found
            
*------------------------------------------------------------------------------
* Third Level Branches - bits 3-0
* Label         Opcode  Operands    Comments
* 0             17      25          37
BRANCH_4E7
                BEQ     NOP
                BEQ     RTS
                BRA     INVALID_OP  ;No matches found

*------------------------------------------------------------------------------
* Opcodes
* Label         Opcode  Operands    Comments
* 0             17      25          37
ADD

ADDA

ADDQ

AND

ANDI

ASL

ASR

BCC

BCHG

CLR

CMP

CMPA

CMPI

DIVS

EOR

EORI

JSR

LEA

LSL

LSR

MOVE

MOVEM

MOVEQ

MULS

NOP

ROL

ROR

RTS

SUB

SUBA

SUBI

*------------------------------------------------------------------------------
* Subroutines
* Label         Opcode  Operands    Comments
* 0             17      25          37
DECODE_MODE

DECODE_REG

DISPLAY_OUTPUT

INVALID_MODE

INVALID_OP
                NOP                 ;Do error stuff
                BRA     INPUT       ;Take next input

*------------------------------------------------------------------------------
* Variables and Constants
* Label         Opcode  Operands    Comments
* 0             17      25          37

CR              EQU     $0D         ;Carriage Return
LF              EQU     $0A         ;Line feed

START_TEXT      DC.B    'Welcome message to display here.',CR,LF,0

TERMINATE       SIMHALT             ;Halt the simulator
                END     START       ;Do not put anything below this line.



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
