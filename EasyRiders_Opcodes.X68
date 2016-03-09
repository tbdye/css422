
*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 3/1/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Disassembler instruction opcode decoder
*------------------------------------------------------------------------------
* Add -------------------------------------------------------------------------
* Register list:
* A1: Trap #15 Input and Output (subject to frequent overwrites)
* A2: Current test opcode in use and sequence locator (read only)
* D0: Trap #15 task switch (subject to frequent overwrites)
* D7: Workspace for opcode evaluation
*---------------Opcode--Operands------------Comments---------------------------
OP_ADD          LEA     DISP_ADD,A1         ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.

                JSR     SR_Eval7to6         ;Reads A2, Returns D7
                
*   Print size
                MOVE.B  #5,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrntSize2bit     ;Reads D7, Returns void
                
                BTST    #8,(A2)             
                BEQ     opAddDnMode         ;Bit 8 = 0
                
                BRA     opAddEAMode         ;Bit 8 = 1
                
*   ADD <ea> + Dn --> Dn
opAddDnMode     JSR     SR_Eval5to3         ;Reads A2, Returns D7
                MOVE.W  D7,SRC_MODE         ;Copy bits to decode src mode
                
                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                MOVE.W  D7,SRC_REGISTER     ;Copy bits to decode src register
                
                MOVE.W  #0,DEST_MODE        ;Force Dn dest mode
                
                JSR     SR_Eval11to9        ;Reads A2, Returns D7
                MOVE.W  D7,DEST_REGISTER    ;Copy bits to decode dest register
                
                BRA     opAddPrintEA

*   ADD Dn + <ea> --> <ea>
opAddEAMode     MOVE.W  #0,SRC_MODE         ;Force Dn src mode
                
                JSR     SR_Eval11to9        ;Reads A2, Returns D7
                MOVE.W  D7,SRC_REGISTER     ;Copy bits to decode src register
                
                JSR     SR_Eval5to3         ;Reads A2, Returns D7
                MOVE.W  D7,DEST_MODE        ;Copy bits to decode dest mode
                
                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                MOVE.W  D7,DEST_REGISTER    ;Copy bits to decode dest register

*   Print source and destination EA
opAddPrintEA    JSR     SR_PrintEA          ;Reads SRC/DEST MODE/REGISTER storage, Returns void
                
                RTS

* Add Address -----------------------------------------------------------------
* Register list:
* A1: Trap #15 Input and Output (subject to frequent overwrites)
* D0: Trap #15 task switch (subject to frequent overwrites)
* D7: Workspace for opcode evaluation
*---------------Opcode--Operands------------Comments---------------------------
OP_ADDA         LEA     DISP_ADDA,A1        ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                JSR     SR_Eval8to6         ;Reads A2, Returns D7

*   Print size                
                MOVE.B  #4,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrntSize3bit     ;Reads D7, Returns void
                
                JSR     SR_Eval5to3         ;Reads A2, Returns D7
                MOVE.W  D7,SRC_MODE         ;Copy bits to decode src mode
                
                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                MOVE.W  D7,SRC_REGISTER     ;Copy bits to decode src register
                
                MOVE.W  #1,DEST_MODE        ;Force An dest mode
                
                JSR     SR_Eval11to9        ;Reads A2, Returns D7
                MOVE.W  D7,DEST_REGISTER    ;Copy bits to decode dest register
                
*   Print source and destination EA
                JSR     SR_PrintEA          ;Reads SRC/DEST MODE/REGISTER storage, Returns void
                
                RTS

* Add Immediate ---------------------------------------------------------------
* Register list:
* A1: Trap #15 Input and Output (subject to frequent overwrites)
* D0: Trap #15 task switch (subject to frequent overwrites)
* D7: Workspace for opcode evaluation
*---------------Opcode--Operands------------Comments---------------------------
OP_ADDI         LEA     DISP_ADDI,A1        ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                JSR     SR_Eval7to6         ;Reads A2, Returns D7
                
*   Print size  
                MOVE.B  #4,TAB_LENGTH       ;Print spaces between opcode name and EA              
                JSR     SR_PrntSize2bit     ;Reads D7, Returns void
                
                MOVE.W  #7,SRC_MODE         ;Force Absolute Short/Long/Immediate Data
                MOVE.W  #4,SRC_REGISTER     ;Force Immediate Data selection
                
                JSR     SR_Eval5to3         ;Reads A2, Returns D7
                MOVE.W  D7,DEST_MODE        ;Copy bits to decode dest mode
                
                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                MOVE.W  D7,DEST_REGISTER    ;Copy bits to decode dest register
                
*   Print source and destination EA
                JSR     SR_PrintEA          ;Reads SRC/DEST MODE/REGISTER storage, Returns void
                
                RTS

* Add Quick -------------------------------------------------------------------
* Optional opcode that is not required by this assignment
*---------------Opcode--Operands------------Comments---------------------------
OP_ADDQ         LEA     DISP_ADDQ,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* AND Logical -----------------------------------------------------------------
* Register list:
* A1: Trap #15 Input and Output (subject to frequent overwrites)
* A2: Current test opcode in use and sequence locator (read only)
* D0: Trap #15 task switch (subject to frequent overwrites)
* D7: Workspace for opcode evaluation
*---------------Opcode--Operands------------Comments---------------------------
OP_AND          LEA     DISP_AND,A1         ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                JSR     SR_Eval7to6         ;Reads A2, Returns D7
                
*   Print size
                MOVE.B  #5,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrntSize2bit     ;Reads D7, Returns void
                
                BTST    #8,(A2)             
                BEQ     opAndDnMode         ;Bit 8 = 0
                
                BRA     opAndEAMode         ;Bit 8 = 1
                
*   AND <ea> + Dn --> Dn
opAndDnMode     JSR     SR_Eval5to3         ;Reads A2, Returns D7
                MOVE.W  D7,SRC_MODE         ;Copy bits to decode src mode
                
                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                MOVE.W  D7,SRC_REGISTER     ;Copy bits to decode src register
                
                MOVE.W  #0,DEST_MODE        ;Force Dn dest mode
                
                JSR     SR_Eval11to9        ;Reads A2, Returns D7
                MOVE.W  D7,DEST_REGISTER    ;Copy bits to decode dest register
                
                BRA     opAndPrintEA

*   AND Dn + <ea> --> <ea>
opAndEAMode     MOVE.W  #0,SRC_MODE         ;Force Dn src mode
                
                JSR     SR_Eval11to9        ;Reads A2, Returns D7
                MOVE.W  D7,SRC_REGISTER     ;Copy bits to decode src register
                
                JSR     SR_Eval5to3         ;Reads A2, Returns D7
                MOVE.W  D7,DEST_MODE        ;Copy bits to decode dest mode
                
                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                MOVE.W  D7,DEST_REGISTER    ;Copy bits to decode dest register

*   Print source and destination EA
opAndPrintEA    JSR     SR_PrintEA          ;Reads SRC/DEST MODE/REGISTER storage, Returns void
                
                RTS

* AND Immediate ---------------------------------------------------------------
* Optional opcode that is not required by this assignment
* Register list:
* A1: Trap #15 Input and Output (subject to frequent overwrites)
* D0: Trap #15 task switch (subject to frequent overwrites)
* D7: Workspace for opcode evaluation
*---------------Opcode--Operands------------Comments---------------------------
OP_ANDI         LEA     DISP_ANDI,A1        ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                JSR     SR_Eval7to6         ;Reads A2, Returns D7
                
*   Print size                
                MOVE.B  #4,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrntSize2bit     ;Reads D7, Returns void
                
                MOVE.W  #7,SRC_MODE         ;Force Absolute Short/Long/Immediate Data
                MOVE.W  #4,SRC_REGISTER     ;Force Immediate Data selection
                
                JSR     SR_Eval5to3         ;Reads A2, Returns D7
                MOVE.W  D7,DEST_MODE        ;Copy bits to decode dest mode
                
                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                MOVE.W  D7,DEST_REGISTER    ;Copy bits to decode dest register
                
*   Print source and destination EA
                JSR     SR_PrintEA          ;Reads SRC/DEST MODE/REGISTER storage, Returns void
                
                RTS

* Arithmetic Shift Left -------------------------------------------------------
* Optional opcode that is not required by this assignment
*---------------Opcode--Operands------------Comments---------------------------
OP_ASL          LEA     DISP_ASL,A1         ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                BRA     OP_ShiftRot         ;Grouping for ASL/ASR/LSL/LSR/ROL/ROR
                
* Arithmetic Shift Right ------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_ASR          LEA     DISP_ASR,A1         ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                BRA     OP_ShiftRot         ;Grouping for ASL/ASR/LSL/LSR/ROL/ROR

* Branch Conditionally - Carry Clear ------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_BCC          LEA     DISP_BCC,A1         ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                BRA     OP_BccGroup         ;Grouping for BCC/BGT/BLE
                
* Grouping for BCC/BGT/BLE ----------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_BccGroup     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                
                CMP.B   #$00,D7
                BEQ     bg16bit             ;Evaluate as 16-bit Displacement
                
                CMP.B   #$FF,D7
                BEQ     bg32bit             ;Evaluate as 32-bit Displacement
                
*   Evaluate as 8-bit Displacement
                LEA     DISP_SIZE_B,A1      ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                MOVE.B  #5,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrintTab         ;Reads TAB_LENGTH, Returns console output.
                
                MOVE.W  (A2),D5             ;Reload full opcode for evaluation
                CLR.L   D7
                MOVE.B  D5,D7               ;Evaluate last byte only for SR_PrintHex
                
                MOVE.L  #2,D6               ;Number of characters to display.
                JSR     SR_PrintHex         ;Reads D6 and D7, Returns console output.
                
bgFinish        JSR     SR_PrintCRLF
                RTS

bg16bit         MOVE.B  #7,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrintTab         ;Reads TAB_LENGTH, Returns console output.

                MOVEA.L A2,A3               ;Copy the current instruction pointer location
                
                ADDA.W  #2,A3               ;The next word contains the absolute data.
                
                MOVE.W  (A3),D7             ;Prepare to print the data.
                MOVE.L  #4,D6               ;Number of characters to display
                JSR     SR_PrintHex         ;Reads D6 and D7, Returns console output.
                
                ADDA.W  #2,A2               ;Advance the instruction pointer.
                
                BRA     bgFinish

bg32bit         MOVE.B  #7,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrintTab         ;Reads TAB_LENGTH, Returns console output.

                MOVEA.L A2,A3               ;Copy the current instruction pointer location
                
                ADDA.W  #2,A3               ;The next word contains the absolute data.
                
                MOVE.W  (A3),D7             ;Prepare to print the data.
                MOVE.L  #8,D6               ;Number of characters to display
                JSR     SR_PrintHex         ;Reads D6 and D7, Returns console output.
                
                ADDA.W  #4,A2               ;Advance the instruction pointer.

                BRA     bgFinish

* Test a Bit and Change -------------------------------------------------------
* Optional opcode that is not required by this assignment
*---------------Opcode--Operands------------Comments---------------------------
OP_BCHG         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_BCHG,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Branch Conditionally - Greater Than -----------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_BGT          LEA     DISP_BGT,A1         ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                BRA     OP_BccGroup         ;Grouping for BCC/BGT/BLE

* Branch Conditionally - Less or Equal ----------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_BLE          LEA     DISP_BLE,A1         ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                BRA     OP_BccGroup         ;Grouping for BCC/BGT/BLE

* Clear an Operand ------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_CLR          LEA     DISP_CLR,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                JSR     SR_Eval7to6         ;Reads A2, Returns D7
                MOVE.B  D7,D4               ;Store size for EA decoding
                
                *   Print size
                MOVE.B  #5,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrntSize2bit     ;Reads D7, Returns void
                
                JSR     SR_Eval5to3         ;Returns op mode in D7
                MOVE.B  D7,D2
                
                JSR     SR_Eval2to0         ;Returns op register in D7
                MOVE.B  D7,D3
                
                JSR     EA_Decode_EA        ;Prints EA information
                
                JSR     SR_PrintCRLF
                RTS

* Compare ---------------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_CMP          LEA     DISP_CMP,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                JSR     SR_Eval7to6         ;Reads A2, Returns D7
                MOVE.B  D7,D4               ;Store size for EA decoding
                
                MOVE.B  #5,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrntSize2bit
                
                JSR     SR_Eval5to3         ;Reads A2, Returns D7
                MOVE.W  D7,SRC_MODE         ;Copy bits to decode src mode
                
                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                MOVE.W  D7,SRC_REGISTER     ;Copy bits to decode src register
                
                MOVE.W  #0,DEST_MODE        ;Force Dn dest mode
                
                JSR     SR_Eval11to9        ;Reads A2, Returns D7
                MOVE.W  D7,DEST_REGISTER    ;Copy bits to decode dest register

                JSR     SR_PrintEA          ;Reads SRC/DEST MODE/REGISTER storage, Returns void
                RTS
                
* Compare Immediate -----------------------------------------------------------
* Optional opcode that is not required by this assignment
*---------------Opcode--Operands------------Comments---------------------------
OP_CMPI         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_CMPI,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Signed Divide ---------------------------------------------------------------
* Optional opcode that is not required by this assignment
*---------------Opcode--Operands------------Comments---------------------------
OP_DIVS         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_DIVS,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Unsigned Divide ---------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_DIVU         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_DIVU,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Disassembler does not support provided opcode -------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_INVALID      LEA     DISP_INVALID,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #6,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrintTab
                
                MOVE.W  (A2),D7
                MOVE.L  #4,D6
                JSR     SR_PrintHex
                
                JSR     SR_PrintCRLF
                RTS

* Jump to Subroutine ----------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_JSR          LEA     DISP_JSR,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #7,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrintTab
                
                JSR     SR_Eval5to3
                MOVE.B  D7,D2
                
                JSR     SR_Eval2to0
                MOVE.B  D7,D3
                
                MOVE.B  #28,D4
                
                JSR     EA_Decode_EA
                
                JSR     SR_PrintCRLF
                RTS

* Load Effective Address ------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_LEA          LEA     DISP_LEA,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #7,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrintTab
                
                JSR     SR_Eval5to3
                MOVE.B  D7,D2
                
                JSR     SR_Eval2to0
                MOVE.B  D7,D3
                
                MOVE.B  #2,D4
                
                JSR     SR_Eval11to9
                MOVE.B  D7,D3
                MOVE.B  #1,D2               *LEA always loads into an address register directly
                
                JSR     EA_Decode_EA
                
                JSR     SR_PrintCRLF
                RTS

* Logical Shift Left ----------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_LSL          LEA     DISP_LSL,A1         ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                BRA     OP_ShiftRot         ;Grouping for ASL/ASR/LSL/LSR/ROL/ROR

* Logical Shift Right ---------------------------------------------------------
* Optional opcode that is not required by this assignment
*---------------Opcode--Operands------------Comments---------------------------
OP_LSR          LEA     DISP_LSR,A1         ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                BRA     OP_ShiftRot         ;Grouping for ASL/ASR/LSL/LSR/ROL/ROR

* Move Data from Source to Destination - Byte ---------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVE_B       LEA     DISP_MOVE,A1           ;
                MOVE.B  #14,D0              ;
                TRAP    #15
            
                LEA     DISP_SIZE_B,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #0,OP_SIZE               *Store size for EA decode
                                     
                BRA     MOVE_Basic
                
    
* Move Data from Source to Destination - Long ---------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVE_L       LEA     DISP_MOVE,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                LEA     DISP_SIZE_L,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #2,OP_SIZE              *Store size for EA decode       
                
                BRA     MOVE_Basic

* Move Data from Source to Destination - Word ---------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVE_W       LEA     DISP_MOVE,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                LEA     DISP_SIZE_W,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #1,OP_SIZE               *Store size for EA decode
                
                BRA     MOVE_Basic
                
                
*MOVE_Basic - all of the code that MOVE.B, MOVE.W, and MOVE.L share in common 
*---------------Opcode--Operands------------Comments---------------------------
MOVE_Basic      MOVE.B  #4,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrintTab

                MOVE.W  (A2),CURRENT_OP
                MOVE.B  #13,D4
            
                MOVE.W  CURRENT_OP,D2
                MOVE.B  #10,D5
                LSL.W   D5,D2
                LSR.W   D4,D2
            
                MOVE.W  CURRENT_OP,D3
                MOVE.B  #13,D5
                LSL.W   D5,D3
                LSR.W   D4,D3
            
                JSR     EA_Decode_EA

                MOVE.B  #13,D4
                
                LEA     DISP_COMMA,A1
                MOVE.B  #14,D0
                TRAP    #15
            
                MOVE.W  CURRENT_OP,D2
                MOVE.B  #7,D5
                LSL.W   D5,D2
                LSR.W   D4,D2
            
                MOVE.W  CURRENT_OP,D3
                MOVE.B  #4,D5
                LSL.W   D5,D3
                LSR.W   D4,D3

                JSR     EA_Decode_EA
            
                JSR     SR_PrintCRLF
                
                CLR.L   D2                  ;Clean up
                CLR.L   D3
                CLR.L   D4
                CLR.L   D5
                CLR.L   D6
                CLR.L   D7
                
                RTS


* Move Multiple Registers -----------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVEM        ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_MOVEM,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Move Quick ------------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVEQ        LEA     DISP_MOVEQ,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Signed Multiply -------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_MULS         LEA     DISP_MULS,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* No Operation ----------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_NOP          LEA     DISP_NOP,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Rotate (Without Extend) Left ------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_ROL          LEA     DISP_ROL,A1         ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                BRA     OP_ShiftRot         ;Grouping for ASL/ASR/LSL/LSR/ROL/ROR

* Rotate (Without Extend) Right -----------------------------------------------
* Optional opcode that is not required by this assignment
*---------------Opcode--Operands------------Comments---------------------------
OP_ROR          LEA     DISP_ROR,A1         ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                BRA     OP_ShiftRot         ;Grouping for ASL/ASR/LSL/LSR/ROL/ROR

* Return from Subroutine ------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_RTS          LEA     DISP_RTS,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Grouping for ASL/ASR/LSL/LSR/ROL/ROR ----------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_ShiftRot     JSR     SR_Eval7to6         ;Reads A2, Returns D7
                
*   Print size                
                MOVE.B  #5,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrntSize2bit     ;Reads D7, Returns void
                
                CMP.B   #%11,D7
                BEQ     opShRoMemory        ;%11
                
                MOVE.W  (A2),D7  * not sure why I can't just bittest out of (A2) directly
                BTST    #5,D7             
                BEQ     opShRoCount         ;Bit 5 = 0
                
                BRA     opShRoRegister      ;Bit 5 = 1

*   Memory Shifts
opShRoMemory    MOVE.W  #7,D2               ;Force Absolute Short/Long/Immediate Data mode
                MOVE.W  #4,D3               ;Force Immediate Data selection
                
                JSR     EA_Decode_EA        ;Reads D2 and D3, Returns void

                BRA     opShRoDone

*   Register Shifts using Immediate Count
opShRoCount     LEA     DISP_OCTOTHORPE,A1  ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                JSR     SR_Eval11to9        ;Reads A2, Returns D7
                
                CLR.L   D1                  ;Ensure output register is clear
                
                MOVE.W  D7,D1               ;Copy bits to D1 for console output.
                
                CMP.B   #0,D1
                BEQ     opShRoIfZero
                
opShRoDispCnt   MOVE.B  #3,D0               ;Will display signed number from D1
                TRAP    #15                 ;Display to console.
                
                LEA     DISP_COMMA,A1       ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                
                MOVE.W  #0,D2               ;Force Dn dest mode
                MOVE.W  D7,D3               ;Copy bits to decode dest register
                
                JSR     EA_Decode_EA        ;Reads D2 and D3, Returns void

                BRA     opShRoDone
                
*   Count is 8 if value is 0
opShRoIfZero    MOVE.W  #8,D1               ;#0 - value of zero represents a count of eight
                BRA     OpShRoDispCnt

*   Register Shifts using Register Count
opShRoRegister  MOVE.W  #0,SRC_MODE         ;Force Dn src mode

                JSR     SR_Eval11to9        ;Reads A2, Returns D7
                MOVE.W  D7,SRC_REGISTER     ;Copy bits to decode src register

                MOVE.W  #0,DEST_MODE        ;Force Dn dest mode

                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                MOVE.W  D7,DEST_REGISTER    ;Copy bits to decode dest register

*   Print source and destination EA
                JSR     SR_PrintEA          ;Reads SRC/DEST MODE/REGISTER storage, Returns void

                RTS

*   Print memory address
opShRoDone      JSR     SR_PrintCRLF
                RTS

* PseudoOp Simhalt ------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_SIMHALT      BRA     OP_INVALID
                
                ;LEA     DISP_SIMHALT,A1
                ;MOVE.B  #13,D0
                ;TRAP    #15
                ;MOVE.B  #1,BOOL_FINISHED    ;Mark that input machine code ended
                
                ;RTS

* Subtract --------------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_SUB          LEA     DISP_SUB,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                JSR     SR_Eval7to6         ;Reads A2, Returns D7
                
*   Print size
                MOVE.B  #5,TAB_LENGTH       ;Print spaces between opcode name and EA
                JSR     SR_PrntSize2bit     ;Reads D7, Returns void
                
                BTST    #8,(A2)             
                BEQ     opSubDnMode         ;Bit 8 = 0
                
                BRA     opSubEAMode         ;Bit 8 = 1
                
*   SUB Dn - <ea> --> Dn
opSubDnMode     JSR     SR_Eval5to3         ;Reads A2, Returns D7
                MOVE.W  D7,SRC_MODE         ;Copy bits to decode src mode
                
                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                MOVE.W  D7,SRC_REGISTER     ;Copy bits to decode src register
                
                MOVE.W  #0,DEST_MODE        ;Force Dn dest mode
                
                JSR     SR_Eval11to9        ;Reads A2, Returns D7
                MOVE.W  D7,DEST_REGISTER    ;Copy bits to decode dest register
                
                BRA     opSubPrintEA

*   SUB Dn + <ea> --> <ea>
opSubEAMode     MOVE.W  #0,SRC_MODE         ;Force Dn src mode
                
                JSR     SR_Eval11to9        ;Reads A2, Returns D7
                MOVE.W  D7,SRC_REGISTER     ;Copy bits to decode src register
                
                JSR     SR_Eval5to3         ;Reads A2, Returns D7
                MOVE.W  D7,DEST_MODE        ;Copy bits to decode dest mode
                
                JSR     SR_Eval2to0         ;Reads A2, Returns D7
                MOVE.W  D7,DEST_REGISTER    ;Copy bits to decode dest register

*   Print source and destination EA
opSubPrintEA    JSR     SR_PrintEA          ;Reads SRC/DEST MODE/REGISTER storage, Returns void
                
                RTS

* Subtract Address ------------------------------------------------------------
* Optional opcode that is not required by this assignment
*---------------Opcode--Operands------------Comments---------------------------
OP_SUBA         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_SUBA,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS
                
* Subtract Immediate ----------------------------------------------------------
* Optional opcode that is not required by this assignment
*---------------Opcode--Operands------------Comments---------------------------
OP_SUBI         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_SUBI,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS
                
* Subtract Quick --------------------------------------------------------------
* Optional opcode that is not required by this assignment
*---------------Opcode--Operands------------Comments---------------------------
OP_SUBQ         LEA     DISP_SUBQ,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS




















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
