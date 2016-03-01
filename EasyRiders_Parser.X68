*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 2/29/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Command Parser --------------------------------------------------------------
* Register list:
* A0: Root branch jump table (do not overwrite)
* A1: Trap #15 Input and Output (subject to frequent overwrites)
* A2: Current test opcode in use and sequence locator (advance sequence only)
* D0: Trap #15 task switch (subject to frequent overwrites)
* D1: Trap #15 string input (subject to frequent overwrites)
* D7: Current test opcode workspace
*---------------Opcode--Operands------------Comments---------------------------
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
                MOVE.B  #0,BOOL_FINISHED    ;Initialize boolean to false
                
piLoop          CMPI.B  #30,LINECOUNT       ;Pause output if screen lines = 30
                BEQ     FN_PauseOutput
                
piReturn        JSR     SR_PrintAddr
                ADDQ.B  #1,LINECOUNT        ;Increment screen line counter
                
                CLR.L   D7                  ;Clear existing opcode, if any exists
                
                MOVE.W  (A2),D7             ;Load next opcode
                MOVE.B  #12,D0              ;Prepare a shift of 12 bits
                LSR.W   D0,D7               ;Use shift to isolate bits for root branch
                MULU    #6,D7               ;Form offset to travel on jump table 
                JSR     0(A0,D7)            ;Jump to appropriate opcode, then return
                
                CMP.B   #1,BOOL_FINISHED    ;Check if end of input machine code has been reached
                BEQ     TERMINATE           ;Exit the loop.
                
                ADDA.W  #2,A2               ;Advance to next opcode
                BRA     piLoop


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
