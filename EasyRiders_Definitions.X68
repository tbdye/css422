*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 3/1/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Disassembler variables, constants, and definitions
*------------------------------------------------------------------------------
* Equates
*---------------Opcode--Operands------------Comments---------------------------
CR              EQU     $0D                 ;Carriage Return
LF              EQU     $0A                 ;Line feed

* Printed Messages
*---------------Opcode--Operands------------Comments---------------------------
MSG_PROMPT      DC.B    'Load data from location: ',0
MSG_PAUSE       DC.B    'Press enter to continue output.',0
MSG_LINEBREAK   DC.B    CR,LF,0

* Printed Opcodes
*---------------Opcode--Operands------------Comments---------------------------
DISP_ADD        DC.B    'ADD',0
DISP_ADDA       DC.B    'ADDA',0
DISP_ADDI       DC.B    'ADDI',0
DISP_ADDQ       DC.B    'ADDQ',0
DISP_AND        DC.B    'AND',0
DISP_ANDI       DC.B    'ANDI',0
DISP_ASL        DC.B    'ASL',0
DISP_ASR        DC.B    'ASR',0
DISP_BCC        DC.B    'BCC',0
DISP_BCHG       DC.B    'BCHG',0
DISP_BGT        DC.B    'BGT',0
DISP_BLE        DC.B    'BLE',0
DISP_CLR        DC.B    'CLR',0
DISP_CMP        DC.B    'CMP',0
DISP_CMPI       DC.B    'CMPI',0
DISP_DIVS       DC.B    'DIVS',0
DISP_DIVU       DC.B    'DIVU',0
DISP_INVALID    DC.B    'INVALID, got: ',0
DISP_JSR        DC.B    'JSR',0
DISP_LEA        DC.B    'LEA',0
DISP_LSL        DC.B    'LSL',0
DISP_LSR        DC.B    'LSR',0
DISP_MOVE       DC.B    'MOVE',0
DISP_MOVEM      DC.B    'MOVEM',0
DISP_MOVEQ      DC.B    'MOVEQ',0
DISP_MULS       DC.B    'MULS',0
DISP_NOP        DC.B    'NOP',0
DISP_ROL        DC.B    'ROL',0
DISP_ROR        DC.B    'ROR',0
DISP_RTS        DC.B    'RTS',0
DISP_SIMHALT    DC.B    'SIMHALT',0
DISP_SUB        DC.B    'SUB',0
DISP_SUBA       DC.B    'SUBA',0
DISP_SUBI       DC.B    'SUBI',0
DISP_SUBQ       DC.B    'SUBQ',0

* Printed Symbols
*---------------Opcode--Operands------------Comments---------------------------
DISP_OCTOTHORPE DC.B    '#',0
DISP_DOLLAR     DC.B    '$',0
DISP_MINUS      DC.B    '-',0
DISP_PLUS       DC.B    '+',0
DISP_OPAREN     DC.B    '(',0
DISP_CPAREN     DC.B    ')',0
DISP_TAB        DC.B    '   ',0
DISP_COMMA      DC.B    ',',0
DISP_SIZE_B     DC.B    '.B',0
DISP_SIZE_L     DC.B    '.L',0
DISP_SIZE_W     DC.B    '.W',0

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

* Defined Storage
*---------------Opcode--Operands------------Comments---------------------------                
BOOL_FINISHED   DS.B    1                   ;Finished reading data
LINECOUNT       DS.B    1                   ;Storage for number of lines on screen
SRC_MODE        DS.W    1                   ;Storage for the source EA mode type
SRC_REGISTER    DS.W    1                   ;Storage for the source EA register ID
DEST_MODE       DS.W    1                   ;Storage for the destination EA mode type
DEST_REGISTER   DS.W    1                   ;Storage for the destination EA register ID
INPUT_BUFFER    DS.L    1                   ;Create an input buffer for ascii strings.
INPUT_LOC       DS.L    1                   ;Location to read input data



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
