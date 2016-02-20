*-----------------------------------------------------------
* Title      :Prototype
* Written by :Ross Holzworth
* Date       :2/13/2016
* Description:A skeleton for a 68k disassembler 
*-----------------------------------------------------------    


*----------------Constants (I'm not sure where to put these)-    
CR      EQU     $0D
LF      EQU     $0A
*stack   EQU     $A000  
shift   EQU     12                   * Shift 12 bits
tst     EQU     $7000                *location of test file
charshft    EQU     28

 

* Program starts here

    ORG     $1000



start   *LEA     stack,SP        Load the SP (commented out. don't know why this is in the example)

*----------------Input ----------------------------------
        MOVE.W  #tst,A2         *collect input from the user to determine where to start in memory        


*---------Root Branch-----------------------------------
        LEA     jmp_table,A0    *Index into the table        
loop    JSR     PRNTADR
        CLR.L   D7              *Zero it
        MOVE.W  (A2),D7     *We'll play with it here
        MOVE.B  #shift,D1       *Shift 12 bits to the right  
        LSR.W   D1,D7           *Move the bits
        MULU    #6,D7       *Form offset     
        JSR     0(A0,D7)   *Jump indirect with index
        ADDA    #2,A2
        BRA     loop            
            

jmp_table   JMP BRANCH_0
            JMP BRANCH_1
            JMP BRANCH_2
            JMP BRANCH_3
            JMP BRANCH_4
            JMP BRANCH_5
            JMP BRANCH_6
            JMP BRANCH_7
            JMP BRANCH_8
            JMP BRANCH_9
            JMP BRANCH_A
            JMP BRANCH_B
            JMP BRANCH_C
            JMP BRANCH_D
            JMP BRANCH_E
            JMP BRANCH_F


*------------Branch 0------------

BRANCH_0    RTS


*-----------Branch 1-------------
*Possible Opwords: MOVE.B
BRANCH_1    
            LEA     MOVE,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     bsize,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     prnttab
            
            MOVE.B  #13,D4
            
            MOVE.W  (A2),D2
            MOVE.B  #10,D5
            LSL.W   D5,D2
            LSR.W   D4,D2
            
            MOVE.W  (A2),D3
            MOVE.B  #13,D5
            LSL.W   D5,D3
            LSR.W   D4,D3
            
            JSR     DECODE_EA

            LEA     comma,A1
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

            JSR     DECODE_EA
            
            LEA     linebreak,A1
            MOVE.B  #14,D0
            TRAP    #15
                       
            RTS

*-----------Branch 2-------------
*Possible Opwords: MOVE.L
BRANCH_2    RTS


*-----------Branch 3-------------
*Possible Opwords: MOVE.W
BRANCH_3    RTS

*-----------Branch 4-------------
BRANCH_4    LEA     NOP,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS

*-----------Branch 5-------------            
BRANCH_5    RTS

*-----------Branch 6-------------
BRANCH_6    RTS

*-----------Branch 7-------------
BRANCH_7    RTS

*-----------Branch 8-------------
BRANCH_8    RTS

*-----------Branch 9-------------
BRANCH_9    RTS

*-----------Branch A-------------
BRANCH_A    RTS

*-----------Branch B-------------
BRANCH_B    RTS

*-----------Branch C-------------
BRANCH_C    RTS

*-----------Branch D-------------
BRANCH_D    RTS

*-----------Branch E-------------
BRANCH_E    RTS

*-----------Branch F-------------
BRANCH_F    LEA     SIMHALT,A1
            MOVE.B  #14,D0
            TRAP    #15
            BRA end




*-------------Subroutines------------------

*prntadr prints the hex address in A2 when called
*Registers passed: A2
*Return: Null
PRNTADR     LEA char_table,A3    *load constants and table into registers
            MOVE.B  #0,D5        
            MOVE.B  #charshft,D4

loop2       *load the address to be printed into D6
            MOVE.W  A2,D6
        
            *isolate nibble in D6 to be printed as a hex character
            LSL.L   D5,D6        
            LSR.L   D4,D6

            *Multiply nibble by two, find character in char_table
            MULU    #2,D6
            LEA     0(A3,D6),A1

            *print char
            MOVE.B  #14,D0
            TRAP    #15
            
            *increment loop counter by four, check if loop is done
            ADD.B   #4,D5
            CMP.B   #32,D5
            BEQ     prnttab
            BRA     loop2

prnttab     *add a tab to the end of a printed string, leave subroutine
            LEA tab,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS

*DECODE_EA determines and prints the effective address mode and register of six bits
*Registers passed: D2(mode), D3(register)
*Return: null
DECODE_EA   LEA mode_table, A3
            LEA char_table, A4
            JMP 0(A3,D2)   

mode_table  JMP mode_000
            JMP mode_001
            JMP mode_010
            JMP mode_011
            JMP mode_100
            JMP mode_101
            JMP mode_110
            JMP mode_111           


*------mode_000------
*direct reference data register
mode_000    
            MOVE.B  #26,D5
            LEA     0(A4,D5),A1
            MOVE.B  #14,D0
            TRAP    #15

            MULS    #2,D3
            LEA 0(A4,D3),A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS


mode_001    RTS

mode_010    RTS

mode_011    RTS

mode_100    RTS

mode_101    RTS

mode_110    RTS

mode_111    RTS






NOP      DC.B    'NOP',CR,LF,0
SIMHALT  DC.B    'SIMHALT',CR,LF,0
MOVE     DC.B    'MOVE',0




char_table  DC.B    '0',0
            DC.B    '1',0
            DC.B    '2',0
            DC.B    '3',0
            DC.B    '4',0
            DC.B    '5',0
            DC.B    '6',0
            DC.B    '7',0
            DC.B    '8',0
            DC.B    '9',0
            DC.B    'A',0 
            DC.B    'B',0
            DC.B    'C',0
            DC.B    'D',0
            DC.B    'E',0
            DC.B    'F',0
tab         DC.B    '   ',0
comma       DC.B    ',',0
bsize       DC.B    '.B',0
wsize       DC.B    '.W',0
lsize       DC.B    '.L',0
linebreak   DC.B    CR,LF,0






end         SIMHALT

    END    START        ; last line of source



