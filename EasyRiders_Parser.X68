*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 2/29/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Display Header Message ------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
*   Display welcome message
                LEA     MSG_WELCOME,A1      ;Store the console message for output.
                MOVE.B  #13,D0              ;Will display from A1 with CR,LF.
                TRAP    #15                 ;Display to console.
                
                MOVE.B  #7,LINECOUNT        ;Initialize counter (welcome + prompts)

* Get Input -------------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------                
*   Display start location prompt
FN_InputLoop    LEA     MSG_LOC_START,A1    ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.

*   Get User Input
                LEA     INPUT_BUFFER,A1     ;Raw input will store at INPUT_BUFFER
                MOVE.B  #2,D0               ;Read string from keyboard to A1
                TRAP    #15                 ;Get the user input from console, length in D1

*   Convert ascii input to hex
                CLR.L   D0                  ;Use D0 and D1 to process ascii to hex conversion.
                CLR.L   D1                  ;Ensure both are clear of data.
                
                JSR     SR_AtoHLoop         ;Convert raw input ascii characters to hex
                MOVE.L  D7,DATA_START_LOC   ;Store hex value user data location
                
                LEA     MSG_LINEBREAK,A1    ;Append linefeed to the end of user input
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                JSR     SR_CheckStart       ;Reads DATA_START_LOC, Returns D7
                CMP.B   #1,D7               ;If D7 == 1, input was invalid, so start over.
                BEQ     FN_InputLoop
                
*   Display end location prompt
giEndAddrLoop   LEA     MSG_LOC_END,A1      ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
*   Get User Input
                LEA     INPUT_BUFFER,A1     ;Raw input will store at INPUT_BUFFER
                MOVE.B  #2,D0               ;Read string from keyboard to A1
                TRAP    #15                 ;Get the user input from console, length in D1

*   Convert ascii input to hex
                CLR.L   D0                  ;Use D0 and D1 to process ascii to hex conversion.
                CLR.L   D1                  ;Ensure both are clear of data.
                
                JSR     SR_AtoHLoop         ;Convert raw input ascii characters to hex
                MOVE.L  D7,DATA_END_LOC     ;Store hex value user data location
                
                LEA     MSG_LINEBREAK,A1    ;Append linefeed to the end of user input
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                JSR     SR_CheckEnd         ;Reads DATA_END_LOC, Returns D7
                CMP.B   #1,D7               ;If D7 == 1, input was invalid, so start over.
                BEQ     giEndAddrLoop
                
                BRA     FN_Cmd_Parser

* Command Parser --------------------------------------------------------------
* Register list:
* A0: Root branch jump table (do not overwrite)
* A1: Trap #15 Input and Output (subject to frequent overwrites)
* A2: Current test opcode in use and sequence locator (advance sequence only)
* A6: End of test data pointer (do not overwrite)
* D0: Trap #15 task switch (subject to frequent overwrites)
* D1: Trap #15 string input (subject to frequent overwrites)
* D7: Current test opcode workspace
*---------------Opcode--Operands------------Comments---------------------------
FN_Cmd_Parser   LEA     ROOT_JMP_TABLE,A0   ;Index into the table
                MOVEA.L DATA_START_LOC,A2   ;Point to the location of beginning test data
                MOVEA.L DATA_END_LOC,A6     ;Point to the location of ending test data
                
cpLoop          CMPI.B  #29,LINECOUNT       ;Pause output if screen lines = 29
                BEQ     FN_PauseOutput
                
cpReturn        JSR     SR_PrintAddr
                ADDQ.B  #1,LINECOUNT        ;Increment screen line counter
                
                CLR.L   D7                  ;Clear existing opcode, if any exists
                
                MOVE.W  (A2),D7             ;Load next opcode
                MOVE.B  #12,D0              ;Prepare a shift of 12 bits
                LSR.W   D0,D7               ;Use shift to isolate bits for root branch
                MULU    #6,D7               ;Form offset to travel on jump table 
                JSR     0(A0,D7)            ;Jump to appropriate opcode, then return
                
                CMP.W   A6,A2               ;Check if end of input machine code has been reached
                BGE     Fn_Terminate        ;Exit the loop.
                
                ADDA.W  #2,A2               ;Advance to next opcode
                BRA     cpLoop
                
* Pause Screen Output ---------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
FN_PauseOutput  LEA     MSG_PAUSE,A1
                MOVE.B  #14,D0
                TRAP    #15
                MOVE.B  #5,D0
                TRAP    #15
                MOVE.B  #0,LINECOUNT
                BRA     cpReturn

* Terminate -------------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
Fn_Terminate    LEA     MSG_RESTART,A1      ;Store the console message for output.
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
*   Get User Input
                LEA     INPUT_BUFFER,A1     ;Raw input will store at INPUT_BUFFER
                MOVE.B  #2,D0               ;Read string from keyboard to A1
                TRAP    #15                 ;Get the user input from console, length in D1
                
                LEA     MSG_LINEBREAK,A1    ;Append linefeed to the end of user input
                MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                TRAP    #15                 ;Display to console.
                
                MOVE.B  #5,LINECOUNT        ;Reset counter (question + prompts)

                MOVE.L  INPUT_BUFFER,D7         
                CMPI.L  #$79657300,D7       ;Match for ASCII value of 'yes'
                BEQ     FN_InputLoop        ;Restart the program

                BRA     END_PROGRAM















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
