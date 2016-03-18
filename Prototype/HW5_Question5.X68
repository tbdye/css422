*------------------------------------------------------------------------------
* Title      : Decode a floating point number
* Written by : Thomas Dye
* Date       : 2/21/16
* Description: Write a program in 68K assembly code to decipher IEEE 32-bit
*              floating point hexadecimal representation to sign bit, exponent
*              bit, and mantissa bits. Program specifications follow:
*   1. Your program should start at the memory location $400.
*
*   2. The program should print the instruction in the output window to get a
*   user input: "Please enter IEEE 32-bit floating point number in
*   hexadecimal:"
*
*   3. User Input should be in IEEE 32-bit floating point number Hexadecimal
*   format.
*
*   4. After getting the user input, save the number in the memory address
*   right after your program code.
*
*   5. Then print out the following information to the output window:
*   Sign bit: ("+" or "-"), Exponent: (in decimal) and Mantissa: (in decimal).
*   For example, if the user input is :C0680000, then the memory should have
*   the data: C0680000 in the address right after your program code, and then
*   the output window shows:
*       Sign bit: -
*       Exponent:128
*       Mantissa: 13
*------------------------------------------------------------------------------

* Main-------------------------------------------------------------------------
START           ORG     $400

* Display message prompt
                LEA     MSG_PROMPT,A1       ; Store the console message for output.
                MOVE.B  #14,D0              ; Will display from A1 without CR,LF.
                TRAP    #15                 ; Display to console.
* Get User Input
                LEA     INPUT_BUFFER,A1     ; Raw input will store at INPUT_BUFFER
                MOVE.B  #2,D0               ; Read string from keyboard to A1
                TRAP    #15                 ; Get the user input from console, length in D1

* Convert ascii input to hex
                CLR.L   D0                  ; Use D0 and D1 to process ascii to hex conversion.
                CLR.L   D1                  ; Ensure both are clear of data.
                
                JSR     SR_AtoHLoop         ; Convert raw input ascii characters to hex
                MOVE.L  D2,INPUT_NUM        ; Store hex value of user input

* Display sign for output
                LEA     MSG_SIGN,A1         ; Begin output for sign.
                MOVE.B  #14,D0              ; Will display from A1 without CR,LF.
                TRAP    #15                 ; Display to console.
                
                LSL.L   #1,D2               ; Shift left to remove and evaluate MSB of input number   
                BCS     FN_DispNegative     ; If number is negative, display '-'
                BRA     FN_DispPositive     ; Otherwise, display '+'
                
* Display the exponent in decimal
return_expo     LEA     MSG_EXPO,A1         ; Begin output for exponent.
                MOVE.B  #14,D0              ; Will display from A1 without CR,LF.
                TRAP    #15                 ; Display to console.
                
                CLR.L   D1                  ; Use D1 to display the exponent
                
                ROL.L   #8,D2               ; Rotate exponent bits to small end
                MOVE.B  D2,D1               ; Copy the exponent bits to D1 for output
                
                MOVE.B  #3,D0               ; Will display signed number from D1
                TRAP    #15                 ; Display to the console.
                
* Display mantissa in decimal
                LEA     MSG_MANT,A1
                MOVE.B  #14,D0              ; Will display from A1 without CR,LF.
                TRAP    #15                 ; Display to console.
                
                CLR.L   D1                  ; Use D1 to display the mantissa
                
                LSR.L   #8,D2               ; Truncate the exponent bits
return_mant     BTST    #0,D2               ; Test if LSB is zero.
                BEQ     FN_ShiftMant        ; If it is, continue shifting to small end.
                MOVE.L  D2,D1               ; Copy the mantissa to D1 for output
                
                MOVE.B  #3,D0               ; Will display signed number from D1
                TRAP    #15                 ; Display to the console.

                SIMHALT                     ; halt simulator                

* Functions--------------------------------------------------------------------

FN_DispNegative LEA     CHAR_MINUS,A1       ; Format and display output.
                MOVE.B  #14,D0
                TRAP    #15
                BRA     return_expo
                
FN_DispPositive LEA     CHAR_PLUS,A1        ; Format and display output.
                MOVE.B  #14,D0
                TRAP    #15
                BRA     return_expo
                
FN_ShiftMant    LSR.L   #1,D2               ; Left shift until 0's on right are gone.
                BRA     return_mant   

* Subroutines------------------------------------------------------------------

* Ascii to Hex Loop
* Helper subroutine to process raw ascii and convert it to hex.
* Input Parameters: A1
* Return Parameters: D2.L contains the input number converted to hex
* Registers used internally: D0, D1
* Assumptions:
SR_AtoHLoop     MOVE.B  (A1)+,D0            ; Get the first byte
                JSR     SR_Strip_Ascii      ; Get rid of the ASCII code.
                ADD.L   D0,D1               ; Load the char into D1
                CMPI.B  #$0,(A1)            ; Evaluate if there is more work to do.
                BEQ     athEndLoop          ; If not, exit the loop.
                LSL.L   #$4,D1              ; Otherwise, shift the char left in D1 for the next char
                BRA     SR_AtoHLoop         ; Continue working
  
athEndLoop      MOVE.L  D1,D2               ; Return hex number in D2
                RTS

* Strip Ascii
* Remove the ascii code from the digits 0-9,a-f, or A-F
* Input Parameters: <D0> = ascii code
* Return Parameters: D0.B = number 0...F, returned as 00...0F
* Registers used internally: D0
* Assumptions: D0 contains $30-$39, $41-$46 or $61-66
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

* Variables and constants------------------------------------------------------
CR              EQU     $0D
LF              EQU     $0A
INPUT_BUFFER    EQU     $0600               ; Create an input buffer for ascii strings.

MSG_PROMPT      DC.B    'Please enter IEEE 32-bit floating point number in hexadecimal:',0
MSG_SIGN        DC.B    'Sign bit: ',0
MSG_EXPO        DC.B    'Exponent:',0
MSG_MANT        DC.B    CR,LF,'Mantissa: ',0

CHAR_PLUS       DC.B    '+',CR,LF,0
CHAR_MINUS      DC.B    '-',CR,LF,0

INPUT_NUM       DS.L    1                   ; Number location will be end of program code.
                                            ; INPUT_NUM must be last line of code.
                END     START               ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
