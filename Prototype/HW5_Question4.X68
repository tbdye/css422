*------------------------------------------------------------------------------
* Title      : HW5 Question 4:  Pattern Finding and Cumulative Program
* Written by : Thomas Dye
* Date       : 2/22/16
* Description: 1.  Your program should start at the memory location $1000. Read
*              each byte data stored in memory between the addresses $7000 and
*              $8000 and compare it to the (byte) data pattern at $A570.
*
*              2.  If it finds a data (pattern) matching with the data at
*              $A570, it stores the longword address of the data in a memory
*              located just after the program code itself. Let's call this
*              address as Addr1.  If it fails to find the data within the
*              specified memory range ($7000 and $8000), then put
*              Addr1 = $7000.
*
*              3.  Then, add a series of bytes stored in 512 consecutive memory
*              locations beginning at that address, Addr1.
*
*              4.  Store the sum into memory as a WORD variable just after the
*              location of Addr1.  Let's call this address as Addsum. There is
*              a chance that the sum might exceed $FFFF, (exceeding the range
*              of word value), so you will also need to store the carry bit if
*              an overflow occurs.  Store the carry bit as a byte value in the
*              next memory location after the main sum.
*
*              5.  Print the Addr1, sum and carry bit in the output window.
*------------------------------------------------------------------------------

* Main-------------------------------------------------------------------------
START           ORG     $1000

* 1.  Display message prompt
                LEA     MSG_PROMPT,A1       ; Store the console message for output.
                JSR     SR_PrintString
                
*     Get User Input
                LEA     PATTERN_MEM,A1      ; Raw input will store at PATTERN_MEM
                MOVE.B  #2,D0               ; Read string from keyboard to A1
                TRAP    #15                 ; Get the user input from console, length in D1
                
*     Copy key into memory to be scanned
                MOVE.L  ASCII_KEY,$7114     ; Place name at some random address
                
* 2.  Match the string in memory
                LEA     BEGIN_USR_MEM,A0    ; Set up beginning address A0
                LEA     END_USR_MEM,A1      ; Set up ending address A1
                
                CLR.L   D2                  ; Clear D2 for use.
                
                MOVE.L  PATTERN_MEM,D2      ; Copy pattern to D2 for evaluation
                JSR     SR_ScanForKey       ; Scan memory for the pattern and display result.

* 3.  Fill the memory space with data
                MOVEA.L ADDR1,A0            ; Copy beginning address from ADDR1 to A0
                
                CLR.L   D1                  ; Clear D1 for use.
                
                MOVE.W  A0,D1               ; Copy beginning address for end offset
                ADD.W   LENGTH,D1           ; Add offset beyond beginning address
                MOVEA.L D1,A1               ; Set up ending address A1
                
                CLR.L   D2                  ; Clear D2 for use.
                
                MOVE.B  FILL_PATTERN,D2     ; Copy the fill pattern for use in D2
                JSR     SR_FillMem          ; Fill the memory between A0 and A1 with D2
                
* 4.  Calculate the sum from value of bytes in memory
                MOVEA.L ADDR1,A0            ; Reset beginning address A0, A1 is previously set
                
                CLR.L   D1                  ; Clear D1 for use.
                CLR.L   D2                  ; Clear D2 for use.          
                MOVE.B  #0,CARRY            ; Clear byte at CARRY address      
                
                MOVE.B  (A0),D1             ; Copy first byte for the sum
                JSR     SR_CalcSum          ; Calculate and save sum to ADDSUM.
                
* 5.  Print cumulative output
*     Display contents of ADDR1
                LEA     MSG_ADDR1,A1        ; Store the console message for output.
                JSR     SR_PrintString
                
                CLR.L   D1
                CLR.L   D2
                
                MOVEA.L ADDR1,A1            ; Prepare ADDR1 contents for output
                JSR     SR_FormatHex
                JSR     SR_PrintHexLong
                
*     Display the value of ADDSUM 
                LEA     MSG_ADDSUM,A1       ; Store the console message for output.
                JSR     SR_PrintString
                
                CLR.L   D0
                CLR.L   D1
                CLR.L   D2
                
                MOVEA.W ADDSUM,A1           ; Prepare ADDSUM contents for output
                JSR     SR_FormatHex
                JSR     SR_PrintHexWord

*     Display the value of CARRY
                LEA     MSG_CARRY,A1        ; Store the console message for output
                JSR     SR_PrintString
                
                CLR.L   D1
                
                MOVE.B  CARRY,D1            ; Prepare CARRY contents for output
                MOVE.B  #3,D0
                TRAP    #15
                
                SIMHALT                     ; halt simulator

* Subroutines------------------------------------------------------------------

* Scan For Key in Memory
SR_ScanForKey   CMP.L   (A0),D2             ; If the contents at A0 matches D2
                BEQ     sfkFound_match      ; Report that a match was found
                CMP.L   A0,A1               ; Otherwise, check to see if we're at the end
                BEQ     sfkEnd_scan         ; If so, exit the scan subroutine
                BRA     sfkAdvance_byte     ; Otherwise, evaluate the next word in memory

sfkAdvance_byte ADDA.W  #02,A0              ; Increment A0
                BRA     SR_ScanForKey       ; Begin scan from next location

sfkFound_match  LEA     MSG_SUCCESS,A1      ; Diplay success to console
                MOVE.B  #14,D0
                TRAP    #15
                MOVE.L  A0,ADDR1            ; Copy the pattern memory location to ADDR1
                RTS
                
sfkEnd_scan     LEA     MSG_FAILURE,A1      ; Display failure to console
                MOVE.B  #14,D0
                TRAP    #15
                MOVE.L  #$7000,ADDR1        ; Copy the location $7000 to ADDR1
                RTS
                
* Fill Memory with Pattern
SR_FillMem      CMP.L   A0,A1               ; Check to see if we're at the end
                BEQ     fmEnd_fill          ; If so, exit the fill subroutine
                MOVE.B  D2,(A0)+            ; Otherwise, fill the byte at A0 and advance to the next one.
                BRA     SR_FillMem          ; Continue looping until we're at the end
                
fmEnd_fill      RTS

* Calculate Sum
SR_CalcSum      CMP.L   A0,A1               ; Check to see if we're at the end
                BEQ     csEnd_Sum           ; If so, exit the calc sum subroutine
                ADD.W   D1,D2               ; Otherwise add the byte from D1 to the running total D2
                BCS     csSetCarry          ; If an overflow occurred, record it.
csReturn_calc   ADDA.W  #01,A0              ; Increment A0
                MOVE.B  (A0),D1             ; Copy the next value into D1
                BRA     SR_CalcSum          ; Loop again

csEnd_Sum       MOVE.W  D2,ADDSUM           ; Finished.  Copy the total to ADDSUM
                RTS

csSetCarry      MOVE.B  #1,CARRY            ; Record the carry bit to CARRY
                BRA     csReturn_calc
                
* Print String
SR_PrintString  MOVE.B  #14,D0              ; Will display from A1 without CR,LF.
                TRAP    #15                 ; Display to console.
                RTS

* Format Hex
SR_FormatHex    LEA     OUTPUT_BUFFER,A0    ; Use this address as the output buffer
                MOVE.B  #0,D3               ; Advancing bit displacement for nibbles left to right
                MOVE.B  #28,D4              ; Bit displacement to truncate all but one nibble
                
fhLoop          MOVE.W  A1,D2               ; Load/reload hex output into D2 for work

                LSL.L   D3,D2               ; For each loop, isolate the next nibble using displacement
                LSR.L   D4,D2               ; Truncate everything else except the nibble
                MOVE.B  D2,D1               ; Move the nibble to D1 for ASCII conversion
                
                JSR     SR_Conv_Ascii       ; Add the ASCII code
                MOVE.B  D1,(A0)+            ; Write the ASCII to the output buffer and advance 1 byte.
                
                ADD.B   #4,D3               ; Add another 4 bits to displacement to get next nibble
                CMP.B   #32,D3              ; If displacement = 32, we're done.
                BEQ     fhEndLoop           ; Terminate the output buffer
                BRA     fhLoop              ; Otherwise, continue processing
                
fhEndLoop       MOVE.B  #$0,(A0)+           ; Add a null character to the end of the output buffer
                RTS

* Convert to ASCII
SR_Conv_Ascii   CMP.B   #$9,D1              ; Is it in range of 0-9?
                BLE     caAdd30             ; It's a number
                CMP.B   #$F,D1              ; Is it A...F?
                BLE     caAdd37             ; It's A...F
                BRA     caReturn            ; Go Back

caAdd37         ADD.B   #$37,D1             ; Add 37
                BRA     caReturn            ; Go Back
                
caAdd30         ADD.B   #$30,D1             ; Add 30
caReturn        RTS

* Print Hex Number as Long
SR_PrintHexLong LEA     OUTPUT_BUFFER,A1    ; Load the output buffer for console output
                JSR     SR_PrintString
                RTS
                
*Print Hex Number as Word
SR_PrintHexWord LEA     OUTPUT_BUFFER,A1    ; Load the output buffer for console output
                ADDA.W  #4,A1               ; Displace output to show last Word only.
                JSR     SR_PrintString
                RTS

* Variables and constants------------------------------------------------------
CR              EQU     $0D
LF              EQU     $0A

BEGIN_USR_MEM   EQU     $7000               ; Location of start of stored data
END_USR_MEM     EQU     $8000               ; Location of end of stored data
OUTPUT_BUFFER   EQU     $8200               ; Location of ASCII Output Buffer
PATTERN_MEM     EQU     $A570               ; Location of stored pattern to match

FILL_PATTERN    DC.B    $AA                 ; Byte pattern for filling memory
LENGTH          DC.W    512                 ; Consecutive memory locations to fill

ASCII_KEY       DC.B    $43,$33,$50,$30
MSG_PROMPT      DC.B    'I have placed a name somewhere in memory.',CR,LF
                DC.B    'The odds of you actually guessing it are approximately 3720:1.',CR,LF,CR,LF
                DC.B    'Never tell me the odds!',CR,LF,CR,LF
                DC.B    'Who calculated the odds? :',0
MSG_SUCCESS     DC.B    'Hah! Nice going, nerd!',CR,LF,0
MSG_FAILURE     DC.B    'Dude, do you even Star Wars?',CR,LF,0
MSG_ADDR1       DC.B    CR,LF,'Contents of ADDR1 :$',0
MSG_ADDSUM      DC.B    CR,LF,'Cumulative Sum    :$',0
MSG_CARRY       DC.B    CR,LF,'Carry Bit         :',0

ADDR1           DS.L    1                   ; Pattern location will be end of program code.
ADDSUM          DS.W    1
CARRY           DS.B    1
                                            
                END     START               ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
