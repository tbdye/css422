*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 2/29/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Disassembler instruction opcode decoder
*------------------------------------------------------------------------------
* Add -------------------------------------------------------------------------
* Register list:
* A1: Trap #15 Input and Output (subject to frequent overwrites)
* A2: Current test opcode in use and sequence locator (sequence as necessary)
* D0: Trap #15 task switch (subject to frequent overwrites)
*---------------Opcode--Operands------------Comments---------------------------
OP_ADD          LEA     DISP_ADD,A1         ;Store the console message for output.
                ;MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                MOVE.B  #13,D0 ; remove later
                TRAP    #15                 ;Display to console.

                ;JSR     SR_Eval8to6         ;Get bits for OPMODE to display size
                
                ;JSR     SR_PrintSize
                
                RTS

* Add Address -----------------------------------------------------------------
* Register list:
* A1: Trap #15 Input and Output (subject to frequent overwrites)
* D0: Trap #15 task switch (subject to frequent overwrites)
*---------------Opcode--Operands------------Comments---------------------------
OP_ADDA         LEA     DISP_ADDA,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Add Immediate ---------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_ADDI         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_ADDI,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Add Quick -------------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_ADDQ         LEA     DISP_ADDQ,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* AND Logical -----------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_AND          LEA     DISP_AND,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* AND Immediate ---------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_ANDI         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_ANDI,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Arithmetic Shift Left -------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_ASL          LEA     DISP_ASL,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Arithmetic Shift Right ------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_ASR          LEA     DISP_ASR,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Branch Conditionally - Carry Clear ------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_BCC          LEA     DISP_BCC,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Test a Bit and Change -------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_BCHG         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_BCHG,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Branch Conditionally - Greater Than -----------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_BGT          ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_BGT,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Branch Conditionally - Less or Equal ----------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_BLE          ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_BLE,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Clear an Operand ------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_CLR          LEA     DISP_CLR,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Compare ---------------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_CMP          LEA     DISP_CMP,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Compare Immediate -----------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_CMPI         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_CMPI,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Signed Divide ---------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_DIVS         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_DIVS,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Disassembler does not support provided opcode -------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_INVALID      LEA     DISP_INVALID,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #28,D4              ;char shift
                MOVE.W  (A2),D7
                CLR.L   D5                  ;bugfix
                JSR     SR_PrintHex
                
                LEA     MSG_LINEBREAK,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS

* Jump to Subroutine ----------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_JSR          ADDA.W  #2,A2               ;Need to advance input for testing
                ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_JSR,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Load Effective Address ------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_LEA          ADDA.W  #2,A2               ;Need to advance input for testing
                ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_LEA,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Logical Shift Left ----------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_LSL          LEA     DISP_LSL,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Logical Shift Right ---------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_LSR          LEA     DISP_LSR,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Move Data from Source to Destination - Byte ---------------------------------
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
                
                CLR.L   D2                  ;Clean up
                CLR.L   D3
                CLR.L   D4
                CLR.L   D5
                CLR.L   D6
                       
                RTS
                
    BRA     OP_INVALID
* Move Data from Source to Destination - Long ---------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVE_L       LEA     DISP_MOVE,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Move Data from Source to Destination - Word ---------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_MOVE_W       LEA     DISP_MOVE,A1
                MOVE.B  #13,D0
                TRAP    #15
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
OP_ROL          LEA     DISP_ROL,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Rotate (Without Extend) Right -----------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_ROR          LEA     DISP_ROR,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Return from Subroutine ------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_RTS          LEA     DISP_RTS,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* PseudoOp Simhalt ------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_SIMHALT      LEA     DISP_SIMHALT,A1
                MOVE.B  #13,D0
                TRAP    #15
                MOVE.B  #1,BOOL_FINISHED    ;Mark that input machine code ended
                RTS

* Subtract --------------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_SUB          LEA     DISP_SUB,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS

* Subtract Address ------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_SUBA         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_SUBA,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS
                
* Subtract Immediate ----------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_SUBI         ADDA.W  #2,A2               ;Need to advance input for testing
                LEA     DISP_SUBI,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS
                
* Subtract Quick --------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
OP_SUBQ         LEA     DISP_SUBQ,A1
                MOVE.B  #13,D0
                TRAP    #15
                RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
