*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 2/29/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Disassembler instruction effective address decoder
*------------------------------------------------------------------------------
* SR_DecodeEA -----------------------------------------------------------------
* determines and prints the effective address mode and register of six bits
* Registers passed: D2(mode), D3(register)
* Return: null
*---------------Opcode--Operands------------Comments---------------------------
SR_Decode_EA    LEA     deModeTable,A3
                LEA     TABLE_HEXCHAR,A4
                MULU    #6,D2
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

                MULU    #2,D3
                LEA     0(A4,D3),A1
                MOVE.B  #14,D0
                TRAP    #15
                
                RTS

*   1 - Register Direct Address
deMode_001      MOVE.B  #20, D5
                LEA     0(A4,D5),A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MULU    #2,D3
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
                LEA     DISP_DOLLAR,A1
                MOVE.B  #14,D0
                TRAP    #15    
                
                ADDA.W  #2,A3
                MOVE.W  (A3),D7
                MOVE.B  #16,D5
                
                JSR     SR_PrintHex
                
                ADDA.W  #2,A2
                
                RTS
                

absData_001     CMP.B   #1,D3
                BNE     absData_100
                
                *absolute data long
                *read next two words from memory, print in hex
                LEA     DISP_DOLLAR,A1
                MOVE.B  #14,D0
                TRAP    #15    
                
                ADDA.W  #2,A3
                MOVE.L  (A3),D7
                MOVE.B  #0,D5
                
                JSR     SR_PrintHex
                
                ADDA.W  #4,A2
                
                RTS
                
absData_100     *immediate data
                *figure out how long the current commad is

                RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
