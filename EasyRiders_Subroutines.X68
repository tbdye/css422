*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 2/29/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Disassembler subroutines
*------------------------------------------------------------------------------
* Ascii to Hex Loop -----------------------------------------------------------
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

* Evaluate Bits 2 to 0 --------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval2to0     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                MOVE.B  #13,D0              ;Prepare a shift of 12 bits
                LSL.W   D0,D7               ;Truncate up to bit 2
                LSR.W   D0,D7               ;Isolate remainder
                RTS

* Evaluate Bits 3 to 0 --------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval3to0     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                MOVE.B  #12,D0              ;Prepare a shift of 12 bits
                LSL.W   D0,D7               ;Truncate up to forth nibble
                LSR.W   D0,D7               ;Isolate nibble
                RTS

* Evaluate Bits 5 to 3 --------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval5to3     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                MOVE.B  #10,D0              ;Prepare a shift of 10 bits
                LSL.W   D0,D7               ;Truncate up to bit 5
                MOVE.B  #13,D0              ;Prepare a shift of 13 bits
                LSR.W   D0,D7               ;Isolate remainder
                RTS

* Evaluate Bits 7 to 4 --------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval7to4     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                LSL.W   #8,D7               ;Truncate up to third nibble
                MOVE.B  #12,D0              ;Prepare a shift of 12 bits
                LSR.W   D0,D7               ;Isolate nibble
                RTS

* Evaluate Bits 7 to 6 --------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval7to6     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                LSL.W   #8,D7               ;Truncate up to bit 7
                MOVE.B  #14,D0              ;Prepare a shift of 12 bits
                LSR.W   D0,D7               ;Isolate remainder
                RTS

* Evaluate Bits 8 to 3 --------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval8to3     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                LSL.W   #7,D7               ;Truncate up to bit 8
                MOVE.B  #10,D0              ;Prepare a shift of 12 bits
                LSR.W   D0,D7               ;Isolate remainder
                RTS

* Evaluate Bits 8 to 6 --------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval8to6     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                LSL.W   #7,D7               ;Truncate up to bit 8
                MOVE.B  #13,D0              ;Prepare a shift of 13 bits
                LSR.W   D0,D7               ;Isolate remainder
                RTS

* Evaluate Bits 11 to 6 -------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval11to6    MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                LSL.W   #4,D7               ;Truncate up to bit 11
                MOVE.B  #10,D0              ;Prepare a shift of 10 bits
                LSR.W   D0,D7               ;Isolate remainder
                RTS

* Evaluate Bits 11 to 8 -------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval11to8    MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                LSL.W   #4,D7               ;Truncate up to second nibble
                MOVE.B  #12,D0              ;Prepare a shift of 12 bits
                LSR.W   D0,D7               ;Isolate nibble
                RTS

* Evaluate Bits 11 to 9 -------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval11to9    MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                LSL.W   #4,D7               ;Truncate up to bit 11
                MOVE.B  #13,D0              ;Prepare a shift of 13 bits
                LSR.W   D0,D7               ;Isolate remainder
                RTS

* Print Address ---------------------------------------------------------------
* Prints the hex address in A2 when called
* Registers passed: A2
* Return: Null
*---------------Opcode--Operands------------Comments---------------------------
SR_PrintAddr    CLR     D5
                MOVE.B  #28,D4              ;char shift
                MOVE.W  A2,D7
                JSR     SR_PrintHex
                JSR     SR_PrintTab
                RTS
                              
* Print in Hex ----------------------------------------------------------------
* Number of digits = 32-D5/4
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
                
                CLR.L   D5
                RTS

* Print .B, .W, or .L ---------------------------------------------------------
* Size is displayed immediately after the opcode.
*---------------Opcode--Operands------------Comments---------------------------
SR_PrintSize    MOVEM.L A0-A6/D0-D6,-(SP)   ;Store registers to stack
                
                CMP.B   #%00,D7
                BEQ     psSizeB             ;%00
                CMP.B   #%01,D7
                BEQ     psSizeW             ;%01
                CMP.B   #%10,D7
                BEQ     psSizeL             ;%10

                BRA     psError             ;Return to parent if error exists

*   Print .B        
psSizeB         LEA     DISP_SIZE_B,A1      ;Store the console message for output.
                BRA     psDone

*   Print .W
psSizeW         LEA     DISP_SIZE_W,A1      ;Store the console message for output.
                BRA     psDone           

*   Print .L
psSizeL         LEA     DISP_SIZE_L,A1      ;Store the console message for output.
                BRA     psDone

*   Print size symbol
psDone          MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                JSR     SR_PrintTab         ;Reads none, Return void

psError         MOVEM.L (SP)+,A0-A6/D0-D6   ;Replace registers from stack
                RTS
                
* Print tab -------------------------------------------------------------------
* Prints a tab at the end of a printed string
*---------------Opcode--Operands------------Comments---------------------------
SR_PrintTab     LEA     DISP_TAB,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS

* Strip Ascii -----------------------------------------------------------------
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




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
