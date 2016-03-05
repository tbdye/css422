*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 3/1/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Disassembler instruction effective address decoder
*------------------------------------------------------------------------------
* Decode Effective Address ----------------------------------------------------
* Determines and prints the effective address mode and register of six bits
* Registers in : D2(mode), D3(register), D4(op size)
* Registers out: none
*---------------Opcode--Operands------------Comments---------------------------
EA_Decode_EA    LEA     EA_ModeTable,A3     ;Load jump table to A3
                LEA     TABLE_HEXCHAR,A4    ;Load symbol table to A4 for output
                MULU    #6,D2
                JSR     0(A3,D2)
                RTS
                
* EA Mode Table ---------------------------------------------------------------
* Brief description of operation
* Registers in : 
* Registers out: 
*---------------Opcode--Operands------------Comments---------------------------
EA_ModeTable    JMP     EA_Mode_000         ;0 - Register Direct Data
                JMP     EA_Mode_001         ;1 - Register Direct Address
                JMP     EA_Mode_010         ;2 - Register Indirect Address
                JMP     EA_Mode_011         ;3 - Register Indirect Address Post Inc
                JMP     EA_Mode_100         ;4 - Register Indirect Address Pre Dec
                JMP     EA_Mode_101         ;5 - Not Supported
                JMP     EA_Mode_110         ;6 - Not Supported
                JMP     EA_Mode_111         ;7 - Absolute Data Short/Long/Immediate
                
* 0 - Register Direct Data ----------------------------------------------------
* Brief description of operation
* Registers in : 
* Registers out: 
*---------------Opcode--Operands------------Comments---------------------------
EA_Mode_000     MOVE.B  #26,D5
                LEA     0(A4,D5),A1         ; comments for clever things
                MOVE.B  #14,D0
                TRAP    #15

                MULU    #2,D3
                LEA     0(A4,D3),A1
                MOVE.B  #14,D0
                TRAP    #15
                
                RTS

* 1 - Register Direct Address -------------------------------------------------
* Brief description of operation
* Registers in : 
* Registers out: 
*---------------Opcode--Operands------------Comments---------------------------
EA_Mode_001     MOVE.B  #20, D5
                LEA     0(A4,D5),A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MULU    #2,D3
                LEA     0(A4,D3),A1
                MOVE.B  #14,D0      *redundant (remove or keep for readability?)
                TRAP    #15         * it's a good idea to refresh variables when the cost is low.
                                    * never know if this code will get moved or reused somewhere else.

                RTS

* 2 - Register Indirect Address -----------------------------------------------
* Brief description of operation
* Registers in : 
* Registers out: 
*---------------Opcode--Operands------------Comments---------------------------
EA_Mode_010     LEA     DISP_OPAREN,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                JSR     EA_Mode_001
                
                LEA     DISP_CPAREN,A1
                TRAP    #15

                RTS

* 3 - Register Indirect Address Post Inc --------------------------------------
* Brief description of operation
* Registers in : 
* Registers out: 
*---------------Opcode--Operands------------Comments---------------------------
EA_Mode_011     JSR     EA_Mode_010
                
                LEA     DISP_PLUS,A1
                MOVE.B  #14,D0
                TRAP    #15
                      
                RTS

* 4 - Register Indirect Address Pre Dec ---------------------------------------
* Brief description of operation
* Registers in : 
* Registers out: 
*---------------Opcode--Operands------------Comments---------------------------
EA_Mode_100     LEA     DISP_MINUS,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                JSR     EA_Mode_010

                RTS

* 5 - Not Supported ----------------------------------------------------------- 
* Should throw error
*---------------Opcode--Operands------------Comments---------------------------
EA_Mode_101     RTS

* 6 - Not Supported -----------------------------------------------------------
* Should throw error
*---------------Opcode--Operands------------Comments---------------------------
EA_Mode_110     RTS

* 7 - Absolute Short/Long/Immediate Data --------------------------------------
* Brief description of operation
* Registers in : 
* Registers out: 
*---------------Opcode--Operands------------Comments---------------------------
EA_Mode_111     MOVEA.L A2,A3
                CMP.B   #%000,D3
                BEQ     EA_AbsShort_000     ;%000
                CMP.B   #%001,D3
                BEQ     EA_AbsLong_001      ;%001
                CMP.B   #%100,D3
                BEQ     EA_Immed_100        ;%100
                
                BRA     EA_INVALID  * I decoupled this section and changed it to positive logic
                
* 0 - Absolute Data - Short ---------------------------------------------------
* Brief description of operation
* Registers in : 
* Registers out: 
*---------------Opcode--Operands------------Comments---------------------------
EA_AbsShort_000 LEA     DISP_DOLLAR,A1
                MOVE.B  #14,D0
                TRAP    #15    
                
                *read next word from memory, print in hex
                ADDA.W  #2,A3
                MOVE.W  (A3),D7
                MOVE.B  #16,D5
                
                JSR     SR_PrintHex
                
                ADDA.W  #2,A2
                
                RTS

* 1 - Absolute Data - Long ----------------------------------------------------
* Brief description of operation
* Registers in : 
* Registers out: 
*---------------Opcode--Operands------------Comments---------------------------
EA_AbsLong_001  LEA     DISP_DOLLAR,A1
                MOVE.B  #14,D0
                TRAP    #15    
                
                *read next two words from memory, print in hex
                ADDA.W  #2,A3
                MOVE.L  (A3),D7
                MOVE.B  #0,D5
                
                JSR     SR_PrintHex
                
                ADDA.W  #4,A2
                
                RTS

* 4 - Immediate Data ----------------------------------------------------------
* Brief description of operation
* Registers in : 
* Registers out: 
*---------------Opcode--Operands------------Comments---------------------------
EA_Immed_100    *immediate data

                LEA     DISP_OCTOTHORPE,A1  *immediate data is signified by a pound sign
                MOVE.B  #14,D0
                TRAP    #15   

                LEA     DISP_DOLLAR,A1      *All imediate data will be printed as hex
                MOVE.B  #14,D0
                TRAP    #15


                *figure out how long the current commad is                
                
                CMP.B   #1, D4  *For number in D4, 0 = .B, 1 = .W, 2 = .L
                BGT     Immed_Long
                
                ADDA.W  #2, A3
                MOVE.W  (A3),D7
                MOVE.B  #16,D5
                
                JSR     SR_PrintHex

                ADDA.W  #2,A2 *Advance over extension word
                RTS

Immed_Long      ADDA.W  #2,A3
                MOVE.L  (A3),D7
                MOVE.B  #0,D5

                JSR     SR_PrintHex

                ADDA.W  #4,A2 *Advance over extension words
                RTS                
                
                

* Invalid EA ------------------------------------------------------------------
* Brief description of operation
* Registers in : 
* Registers out: 
*---------------Opcode--Operands------------Comments---------------------------
EA_INVALID      RTS                         ;This should throw an error with output






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

