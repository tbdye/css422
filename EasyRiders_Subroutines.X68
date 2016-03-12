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

* Check Test Data Start Address -----------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_CheckStart   MOVE.L  DATA_START_LOC,D0

                CMP.L   #$400,D0            ;No addresses below $0400 are allowed. 
                BLT     csFailAddrLow
                
                BTST    #0,D0               ;If the LSB is 1, the address is odd and invalid.
                BNE     csFailAddrOdd

                MOVE.L  #0,D7               ;D7 == 0 indicates the addr is valid.
csFinish        RTS

csFailAddrLow   LEA     MSG_ADDR_LOW,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.L  #1,D7               ;D7 == 1 indicates the addr is invalid.
                BRA     csFinish
                
csFailAddrOdd   LEA     MSG_ADDR_ODD,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.L  #1,D7               ;D7 == 1 indicates the addr is invalid.
                BRA     csFinish

* Check Test Data End Address -------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_CheckEnd     MOVE.L  DATA_START_LOC,D0
                MOVE.L  DATA_END_LOC,D1
                
                BTST    #0,D1               ;If the LSB is 1, the address is odd and invalid.
                BNE     ceFailAddrOdd
                
                CMP.L   D0,D1               ;The ending addr must be greater than starting addr
                BLT     ceFailAddrOrder

                MOVE.L  #0,D7               ;D7 == 0 indicates the addr is valid.
ceFinish        RTS

ceFailAddrOrder LEA     MSG_ADDR_ORDER,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.L  #1,D7
                BRA     ceFinish
                
ceFailAddrOdd   LEA     MSG_ADDR_ODD,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.L  #1,D7               ;D7 == 1 indicates the addr is invalid.
                BRA     ceFinish

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

* Evaluate Bits 7 to 0 --------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval7to0     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                LSL.W   #8,D7               ;Truncate up to bit 7
                LSR.W   #8,D7               ;Isolate remainder
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

* Evaluate Bits 8 to 4 --------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_Eval8to4     MOVE.W  (A2),D7             ;Reload full opcode for evaluation
                LSL.W   #7,D7               ;Truncate up to bit 8
                MOVE.B  #11,D0              ;Prepare a shift of 11 bits
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
SR_PrintAddr    CLR.L   D7
                MOVE.W  A2,D7
                MOVE.L  #8,D6
                JSR     SR_PrintHex
                
                MOVE.B  #3,TAB_LENGTH       ;Tab length = 3
                JSR     SR_PrintTab
                RTS

* Print Effective Addresses ---------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
SR_PrintEA      MOVE.W  SRC_MODE,D2
                MOVE.W  SRC_REGISTER,D3
                JSR     EA_Decode_EA        ;Reads D2 and D3, Returns void

                LEA     DISP_COMMA,A1       ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                MOVE.W  DEST_MODE,D2
                MOVE.W  DEST_REGISTER,D3
                JSR     EA_Decode_EA        ;Reads D2 and D3, Returns void
                
                LEA     MSG_LINEBREAK,A1    ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                RTS
                              
* Print in Hex ----------------------------------------------------------------
* Convert hex values to ASCII and display them to the console.  The number of
*   characters displayed is specified by D6, where valid ranges are 0 to 8 in
*   decimal.
*   Example:  $00001112 displaying two characters will print '12'.
* Registers:
* D6: Digits to print (from right to left)
* D7: Data to print                
*---------------Opcode--Operands------------Comments---------------------------
SR_PrintHex     MOVEM.L D3-D6,-(SP)         ;Store registers to stack
                
                LEA     TABLE_HEXCHAR,A3
                MULU.W  #4,D6               ;Convert number of digits to total bits (4 bits per char)
                
                MOVE.L  #32,D3              ;Set the total number of bits
                SUB.L   D6,D3               ;Set the bit displacement for nibbles left to right
                MOVE.L  #28,D4              ;Bit displacement to truncate all but one nibble
                
phLoop          MOVE.L  D7,D5               ;Load/reload hex output into D5 for work.

                LSL.L   D3,D5               ;For each loop, isolate the next nibble using displacement
                LSR.L   D4,D5               ;Truncate everything else except the nibble
                
                MULU    #2,D5               ;Multiply nibble by two, find character in char_table
                LEA     0(A3,D5),A1         ;Store the character for output
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                ADD.B   #4,D3               ;Add another 4 bits to displacement to get next nibble
                CMP.B   #32,D3              ;If displacement = 32, we're done.
                BNE     phLoop

                MOVEM.L (SP)+,D3-D6         ;Replace registers from stack
                RTS

* Print .B, .W, or .L ---------------------------------------------------------
* Size is displayed immediately after the opcode.  Input is 2 bits
*---------------Opcode--Operands------------Comments---------------------------
SR_PrntSize2bit MOVEM.L A0-A6/D0-D6,-(SP)   ;Store registers to stack
                
                CMP.B   #%00,D7
                BEQ     psSizeB             ;%00
                CMP.B   #%01,D7
                BEQ     psSizeW             ;%01
                CMP.B   #%10,D7
                BEQ     psSizeL             ;%10

                BRA     psError             ;Return to parent if error exists

* Print .W, or .L ---------------------------------------------------------
* Size is displayed immediately after the opcode.  Input is 3 bits
*---------------Opcode--Operands------------Comments---------------------------
SR_PrntSize3bit MOVEM.L A0-A6/D0-D6,-(SP)   ;Store registers to stack

                CMP.B   #%011,D7
                BEQ     psSizeW             ;%011
                CMP.B   #%111,D7
                BEQ     psSizeL             ;%111
                
                BRA     psError             ;Return to parent if error exists

*   Print .B        
psSizeB         LEA     DISP_SIZE_B,A1      ;Store the console message for output.
                MOVE.B  #0,OP_SIZE          ;Store the size of the EA.
                BRA     psDone

*   Print .W
psSizeW         LEA     DISP_SIZE_W,A1      ;Store the console message for output.
                MOVE.B  #1,OP_SIZE          ;Store the size of the EA.
                BRA     psDone           

*   Print .L
psSizeL         LEA     DISP_SIZE_L,A1      ;Store the console message for output.
                MOVE.B  #2,OP_SIZE          ;Store the size of the EA.
                BRA     psDone

*   Print size symbol
psDone          MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                JSR     SR_PrintTab         ;Reads none, Return void

psError         MOVEM.L (SP)+,A0-A6/D0-D6   ;Replace registers from stack
                RTS

* Print linebreak -------------------------------------------------------------
* Prints a CR,LF at the end of a printed string
*---------------Opcode--Operands------------Comments---------------------------
SR_PrintCRLF    LEA     MSG_LINEBREAK,A1
                MOVE.B  #14,D0
                TRAP    #15             
                RTS
                
* Print tab -------------------------------------------------------------------
* D7: Number of spaces to print
*---------------Opcode--Operands------------Comments---------------------------
SR_PrintTab     CLR.L   D7
                MOVE.B  TAB_LENGTH,D7       ;Move data to D7 as a decreasing counter
                
ptLoopStart     CMP.B   #0,D7               ;If the counter is zero, end the loop.
                BEQ     ptLoopFinish        ;The loop is not finished, print a space.

                LEA     DISP_SPACE,A1       ;Print a single space on the console
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                SUBQ.B  #1,D7               ;Decrease the loop counter by 1
                BRA     ptLoopStart
                
ptLoopFinish    RTS

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
