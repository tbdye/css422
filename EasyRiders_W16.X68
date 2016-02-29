*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 2/27/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Main
*---------------Opcode--Operands------------Comments---------------------------
START           ORG     $1000               ;Load at this address

* Display message prompt
                LEA     MSG_PROMPT,A1       ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
* Get User Input
                LEA     INPUT_BUFFER,A1     ;Raw input will store at INPUT_BUFFER
                MOVE.B  #2,D0               ;Read string from keyboard to A1
                TRAP    #15                 ;Get the user input from console, length in D1

* Convert ascii input to hex
                CLR.L   D0                  ;Use D0 and D1 to process ascii to hex conversion.
                CLR.L   D1                  ;Ensure both are clear of data.
                
                JSR     SR_AtoHLoop         ;Convert raw input ascii characters to hex
                MOVE.L  D7,INPUT_LOC        ;Store hex value user data location

* Process Instructions
                LEA     ROOT_JMP_TABLE,A0   ;Index into the table
                MOVEA.L INPUT_LOC,A2        ;Point to the location of input machine code
                
                MOVE.B  #0,LINECOUNT        ;Initialize counter to 0
                
piLoop          CMPI.B  #30,LINECOUNT       ;Pause output if screen lines = 30
                BEQ     FN_PauseOutput
piReturn        CLR.L   D5                  ;Clear D5 before it is used in PrintHex
                JSR     SR_PrintAddr
                CLR.L   D7                  ;Clear existing opcode, if any exists
                MOVE.W  (A2),D7             ;Load next opcode
                MOVE.B  #12,D0              ;Prepare a shift of 12 bits
                LSR.W   D0,D7               ;Use shift to isolate bits for root branch
                MULU    #6,D7               ;Form offset to travel on jump table 
                JSR     0(A0,D7)            ;Jump to appropriate opcode, then return
                CMP.B   #1,BOOL_FINISHED    ;Check if end of input machine code has been reached
                BEQ     TERMINATE           ;Exit the loop.
                ADDA    #2,A2               ;Advance to next opcode
                ADDQ.B  #1,LINECOUNT        ;Increment screen line counter
                BRA     piLoop 

TERMINATE       SIMHALT                     ;Halt the simulator

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

                CMP.B   #$0,D7
                BEQ     OP_ANDI             ;$0
                CMP.B   #$3,D7
                BEQ     OP_ADDI             ;$3
                CMP.B   #$8,D7
                BEQ     OP_BCHG             ;$8
                CMP.B   #$C,D7
                BEQ     OP_CMPI             ;$C

                JSR     SR_Eval7to6
                
                CMP.B   #%01,D7
                BEQ     OP_BCHG             ;%01

                BRA     OP_INVALID          ;No matches found

* From Root to Branch 4
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_4        JSR     SR_Eval11to8
                
                CMP.B   #$2,D7
                BEQ     OP_CLR              ;$2
                CMP.B   #$E,D7
                BEQ     BRANCH_4E           ;$E
                
                BEQ     SR_Eval11to6
                BEQ     OP_MOVEM            ;%1x001x
                BEQ     OP_LEA              ;%xxx111
                
                BRA     OP_INVALID          ;No matches found

* From Root to Branch 6
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_6        JSR     SR_Eval11to8
                
                CMP.B   #$4,D7
                BEQ     OP_BCC              ;$4
                CMP.B   #$E,D7
                BEQ     OP_BGT              ;$E
                CMP.B   #$F,D7
                BEQ     OP_BLE              ;$F
                
                BRA     OP_INVALID          ;No matches found

* From Root to Branch 8
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_8        JSR     SR_Eval8to6
                
                CMP.B   #%111,D7
                BEQ     OP_INVALID          ;%111 - Op not supported
                BRA     OP_DIVS             ;All other combinations

* From Root to Branch 8
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_9        JSR     SR_Eval8to6

                CMP.B   #%011,D7
                BEQ     OP_SUBA             ;%011
                CMP.B   #%111,D7
                BEQ     OP_SUBA             ;%111
                BRA     OP_SUB              ;All other combinations

* From Root to Branch B
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_B        JSR     SR_Eval8to6

                CMP.B   #%000,D7
                BEQ     OP_CMP              ;%000
                CMP.B   #%001,D7
                BEQ     OP_CMP              ;%001
                CMP.B   #%010,D7
                BEQ     OP_CMP              ;%010
                BRA     OP_INVALID          ;No matches found

* From Root to Branch C
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_C        JSR     SR_Eval8to6

                CMP.B   #%011,D7
                BEQ     OP_INVALID          ;%011 - Op not supported
                CMP.B   #%111,D7
                BEQ     OP_MULS             ;%111
                BRA     OP_AND              ;All other combinations

* From Root to Branch D
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_D        JSR     SR_Eval8to6

                CMP.B   #%011,D7
                BEQ     OP_ADDA             ;%011
                CMP.B   #%111,D7
                BEQ     OP_ADDA             ;%111
                BRA     OP_ADD              ;All other combinations

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
                
                CMP.B   #$7,D7
                BEQ     BRANCH_4E7          ;$7
                
                JSR     SR_Eval7to6
                
                CMP.B   #%10,D7
                BEQ     OP_JSR              ;%10
                BRA     OP_INVALID          ;No matches found
            
*------------------------------------------------------------------------------
* Third Level Branches - bits 3-0 ---------------------------------------------
*------------------------------------------------------------------------------
* From Branch 4E to Branch 4E7
*---------------Opcode--Operands------------Comments---------------------------
BRANCH_4E7      JSR     SR_Eval3to0

                CMP.B   #$1,D7
                BEQ     OP_NOP              ;$1
                CMP.B   #$5,D7
                BEQ     OP_RTS              ;$5
                BRA     OP_INVALID          ;No matches found

*------------------------------------------------------------------------------
* Opcodes ---------------------------------------------------------------------
*------------------------------------------------------------------------------
* Add
*---------------Opcode--Operands------------Comments---------------------------
OP_ADD          LEA     DISP_ADD,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Add Address
*---------------Opcode--Operands------------Comments---------------------------
OP_ADDA         LEA     DISP_ADDA,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Add Immediate
*---------------Opcode--Operands------------Comments---------------------------
OP_ADDI         BRA     OP_INVALID

* AND Logical
*---------------Opcode--Operands------------Comments---------------------------
OP_AND          BRA     OP_INVALID

* AND Immediate
*---------------Opcode--Operands------------Comments---------------------------
OP_ANDI         BRA     OP_INVALID

* Arithmetic Shift Left
*---------------Opcode--Operands------------Comments---------------------------
OP_ASL          BRA     OP_INVALID

* Arithmetic Shift Right
*---------------Opcode--Operands------------Comments---------------------------
OP_ASR          BRA     OP_INVALID

* Branch Conditionally - Carry Clear
*---------------Opcode--Operands------------Comments---------------------------
OP_BCC          BRA     OP_INVALID

* Test a Bit and Change
*---------------Opcode--Operands------------Comments---------------------------
OP_BCHG         BRA     OP_INVALID

* Branch Conditionally - Greater Than
*---------------Opcode--Operands------------Comments---------------------------
OP_BGT          BRA     OP_INVALID

* Branch Conditionally - Less or Equal
*---------------Opcode--Operands------------Comments---------------------------
OP_BLE          BRA     OP_INVALID

* Clear an Operand
*---------------Opcode--Operands------------Comments---------------------------
OP_CLR          BRA     OP_INVALID

* Compare
*---------------Opcode--Operands------------Comments---------------------------
OP_CMP          BRA     OP_INVALID

* Compare Immediate
*---------------Opcode--Operands------------Comments---------------------------
OP_CMPI         BRA     OP_INVALID

* Signed Divide
*---------------Opcode--Operands------------Comments---------------------------
OP_DIVS         BRA     OP_INVALID

* Disassembler does not support provided opcode
*---------------Opcode--Operands------------Comments---------------------------
OP_INVALID      LEA     DISP_INVALID,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Jump to Subroutine
*---------------Opcode--Operands------------Comments---------------------------
OP_JSR          BRA     OP_INVALID

* Load Effective Address
*---------------Opcode--Operands------------Comments---------------------------
OP_LEA          BRA     OP_INVALID

* Logical Shift Left
*---------------Opcode--Operands------------Comments---------------------------
OP_LSL          BRA     OP_INVALID

* Logical Shift Right
*---------------Opcode--Operands------------Comments---------------------------
OP_LSR          BRA     OP_INVALID

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
OP_MOVE_L       BRA     OP_INVALID

* Move Data from Source to Destination - Word
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVE_W       BRA     OP_INVALID

* Move Multiple Registers
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVEM        BRA     OP_INVALID

* Move Quick
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVEQ        BRA     OP_INVALID

* Signed Multiply
*---------------Opcode--Operands------------Comments---------------------------
OP_MULS         BRA     OP_INVALID

* No Operation
*---------------Opcode--Operands------------Comments---------------------------
OP_NOP          LEA     DISP_NOP,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Rotate (Without Extend) Left
*---------------Opcode--Operands------------Comments---------------------------
OP_ROL          BRA     OP_INVALID

* Rotate (Without Extend) Right
*---------------Opcode--Operands------------Comments---------------------------
OP_ROR          BRA     OP_INVALID

* Return from Subroutine
*---------------Opcode--Operands------------Comments---------------------------
OP_RTS          BRA     OP_INVALID

* PseudoOp Simhalt
*---------------Opcode--Operands------------Comments---------------------------
OP_SIMHALT      LEA     DISP_SIMHALT,A1
                MOVE.B  #13,D0
                TRAP    #15
                MOVE.B  #1,BOOL_FINISHED    ;Mark that input machine code ended
                RTS

* Subtract
*---------------Opcode--Operands------------Comments---------------------------
OP_SUB          BRA     OP_INVALID

* Subtract Address
*---------------Opcode--Operands------------Comments---------------------------
OP_SUBA         BRA     OP_INVALID

*------------------------------------------------------------------------------
* Functions -------------------------------------------------------------------
*------------------------------------------------------------------------------
* Pause Screen Output
*---------------Opcode--Operands------------Comments---------------------------
FN_PauseOutput  LEA     MSG_PAUSE,A1
                MOVE.B  #14,D0
                TRAP    #15
                MOVE.B  #5,D0
                TRAP    #15
                MOVE.B  #0,LINECOUNT
                BRA     piReturn

*------------------------------------------------------------------------------
* Subroutines -----------------------------------------------------------------
*------------------------------------------------------------------------------
* Ascii to Hex Loop
* Helper subroutine to process raw ascii and convert it to hex.
* Input Parameters: A1
* Return Parameters: D2.L contains the input number converted to hex
* Registers used internally: D0, D1
*---------------Opcode--Operands------------Comments---------------------------
SR_AtoHLoop     MOVE.B  (A1)+,D0            ; Get the first byte
                JSR     SR_Strip_Ascii      ; Get rid of the ASCII code.
                ADD.L   D0,D1               ; Load the char into D1
                CMPI.B  #$0,(A1)            ; Evaluate if there is more work to do.
                BEQ     athEndLoop          ; If not, exit the loop.
                LSL.L   #$4,D1              ; Otherwise, shift the char left in D1 for the next char
                BRA     SR_AtoHLoop         ; Continue working
  
athEndLoop      MOVE.L  D1,D7               ; Return hex number in D7
                RTS

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
                JMP     deMode_100          ;4 - Register Indirect Address Pre Dec
                JMP     deMode_101          ;5 - Not Supported
                JMP     deMode_110          ;6 - Not Supported
                JMP     deMode_111          ;7 - Absolute Data Short/Long/Immediate
                
*   0 - Register Direct Data
deMode_000      MOVE.B  #26,D5
                LEA     0(A4,D5),A1
                MOVE.B  #14,D0
                TRAP    #15

                MULS    #2,D3
                LEA     0(A4,D3),A1
                MOVE.B  #14,D0
                TRAP    #15
                
                RTS

*   1 - Register Direct Address
deMode_001      MOVE.B  #20, D5
                LEA     0(A4,D5),A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MULS    #2,D3
                LEA     0(A4,D3),A1
                MOVE.B  #14,D0      *redundant (remove or keep for readability?)
                TRAP    #15

                RTS

*   2 - Register Indirect Address
deMode_010      LEA     DISP_OPAREN,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                JSR     deMode_001
                
                LEA     DISP_CPAREN,A1
                TRAP    #15

                RTS

*   3 - Register Indirect Address Post Inc
deMode_011      JSR     deMode_010
                
                LEA     DISP_PLUS,A1
                MOVE.B  #14,D0
                TRAP    #15
                      
                RTS

*   4 - Register Indirect Address Pre Dec
deMode_100      LEA     DISP_MINUS,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                JSR     deMode_010

                RTS

*   5 - Not Supported 
*   Should throw error
deMode_101      RTS

*   6 - Not Supported
*   Should throw error
deMode_110      RTS

*   7 - Absolute Data Short/Long/Immediate
deMode_111      MOVEA.L A2,A3
                CMP.B   #0,D3
                BNE     absData_001
                
                *absolute data short
                *read next word from memory, print in hex
                LEA     DISP_DLR,A1
                MOVE.B  #14,D0
                TRAP    #15    
                
                ADDA.W  #2,A3
                MOVE.W  (A3),D7
                MOVE.B  #16,D5
                
                JSR     SR_PrintHex
                RTS
                

absData_001     CMP.B   #1,D3
                BNE     absData_100
                
absData_100

                RTS

* Evaluate Bits 3 to 0
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval3to0     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                MOVE.B  #12,D0              ;Prepare a shift of 12 bits
                LSL.W   D0,D7               ;Truncate up to forth nibble
                LSR.W   D0,D7               ;Isolate nibble
                RTS

* Evaluate Bits 7 to 4
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval7to4     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                MOVE.B  #12,D0              ;Prepare a shift of 12 bits
                LSL.W   #8,D7               ;Truncate up to third nibble
                LSR.W   D0,D7               ;Isolate nibble
                RTS

* Evaluate Bits 7 to 6
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval7to6     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                MOVE.B  #14,D0              ;Prepare a shift of 12 bits
                LSL.W   #8,D7               ;Truncate up to bit 7
                LSR.W   D0,D7               ;Isolate remainder
                RTS

* Evaluate Bits 8 to 3
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval8to3     RTS

* Evaluate Bits 8 to 6
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval8to6     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                MOVE.B  #13,D0              ;Prepare a shift of 13 bits
                LSL.W   #7,D7               ;Truncate up to bit 8
                LSR.W   D0,D7               ;Isolate remainder
                RTS

* Evaluate Bits 11 to 6
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval11to6    RTS

* Evaluate Bits 11 to 8
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval11to8    MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                MOVE.B  #12,D0              ;Prepare a shift of 12 bits
                LSL.W   #4,D7               ;Truncate up to second nibble
                LSR.W   D0,D7               ;Isolate nibble
                RTS

* Prints the hex address in A2 when called
* Registers passed: A2
* Return: Null
*---------------Opcode--Operands------------Comments---------------------------
SR_PrintAddr    MOVE.B  #28,D4              ;char shift
                MOVE.W  A2,D7
                JSR     SR_PrintHex
                JSR     SR_PrintTab
                RTS
                              
*Prints the hex number in D7
*Number of digits = 32-D5/4
*---------------Opcode--Operands------------Comments---------------------------

*   Load the address to be printed into D6
SR_PrintHex     LEA     TABLE_HEXCHAR, A3
                MOVE.L  D7,D6                
                MOVE.B  #28,D4
 
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
                BNE     SR_PrintHex
                RTS
                
* Add a tab to the end of a printed string, leave subroutine
*---------------Opcode--Operands------------Comments---------------------------
SR_PrintTab     LEA     DISP_TAB,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS

* Strip Ascii
* Remove the ascii code from the digits 0-9,a-f, or A-F
* Input Parameters: <D0> = ascii code
* Return Parameters: D0.B = number 0...F, returned as 00...0F
* Registers used internally: D0
* Assumptions: D0 contains $30-$39, $41-$46 or $61-66
*---------------Opcode--Operands------------Comments---------------------------
SR_Strip_Ascii  CMP.B   #$39,D0             ; Is it in range of 0-9?
                BLE     saSub30             ; It's a number
                CMP.B   #$46,D0             ; Is is A...F?
                BLE     saSub37             ; It's A...F
                SUB.B   #$57,D0             ; It's a...f
                BRA     saReturn            ; Go back
saSub37         SUB.B   #$37,D0             ; Strip 37
                BRA     saReturn            ; Go back
saSub30         SUB.B   #$30,D0             ; Strip 30
saReturn        RTS                         ; Go back

*------------------------------------------------------------------------------
* Variables and Constants -----------------------------------------------------
*------------------------------------------------------------------------------
*
*---------------Opcode--Operands------------Comments---------------------------
CR              EQU     $0D                 ;Carriage Return
LF              EQU     $0A                 ;Line feed

INPUT_BUFFER    EQU     $2000               ;Create an input buffer for ascii strings.
INPUT_LOC       DS.L    1                   ;Location to read input data
BOOL_FINISHED   DS.B    0                   ;Finished reading data
LINECOUNT       DS.B    1                   ;Storage for number of lines on screen

MSG_PROMPT      DC.B    'Load data from location: ',0
MSG_PAUSE       DC.B    'Press enter to continue output.',0
MSG_LINEBREAK   DC.B    CR,LF,0

DISP_ADD        DC.B    'ADD',0
DISP_ADDA       DC.B    'ADDA',0
DISP_NOP        DC.B    'NOP',0
DISP_MOVE       DC.B    'MOVE',0
DISP_INVALID    DC.B    'INVALID',0
DISP_SIMHALT    DC.B    'SIMHALT',0

DISP_DLR        DC.B    '$',0
DISP_MINUS      DC.B    '-',0
DISP_PLUS       DC.B    '+',0
DISP_OPAREN     DC.B    '(',0
DISP_CPAREN     DC.B    ')',0
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

                END     START               ;Do not put anything below this line.



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

    Status API Training Shop Blog About Pricing 

    © 2016 GitHub, Inc. Terms Privacy Security Contact Help 


