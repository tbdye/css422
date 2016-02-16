*-----------------------------------------------------------
* Title      :Prototype
* Written by :Ross Holzworth
* Date       :2/13/2016
* Description:A skeleton for a 68k disassembler 
*-----------------------------------------------------------    
    ORG    $1000
    
CR      EQU     $0D
LF      EQU     $0A
stack   EQU     $A000      
shift   EQU     12                   * Shift 12 bits
tst     EQU     $7000                *location of test file
charshft    EQU     28

 

* Program starts here

    ORG     $1000

start   LEA     stack,SP        *Load the SP
        LEA     jmp_table,A0    *Index into the table
        MOVE.W  #tst,A2
loop    BSR     prntadr
        CLR.L   D7              *Zero it
        MOVE.W  (A2)+,D7     *We'll play with it here
        MOVE.B  #shift,D1       *Shift 12 bits to the right  
        LSR.W   D1,D7           *Move the bits
        MULU    #6,D7       *Form offset     
        JSR     0(A0,D7)   *Jump indirect with index

prntadr     LEA char_table,A3
            MOVE.B  #0,D5
            MOVE.B  #charshft,D4
loop2       MOVE.W  A2,D6
            LSL.L   D5,D6
            LSR.L   D4,D6
            MULU    #2,D6
            LEA     0(A3,D6),A1
            ADD.B   #4,D5
            MOVE.B  #14,D0
            TRAP    #15
            CMP.B   #32,D5
            BEQ     prntend
            BRA     loop2

prntend     LEA tab,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
            

jmp_table   JMP code0000
            JMP code0001
            JMP code0010
            JMP code0011
            JMP code0100
            JMP code0101
            JMP code0110
            JMP code0111
            JMP code1000
            JMP code1001
            JMP code1010
            JMP code1011
            JMP code1100
            JMP code1101
            JMP code1110
            JMP code1111



code0000    BRA loop

code0001    BRA loop

code0010    BRA loop

code0011    BRA loop

code0100    LEA     op0100,A1
            MOVE.B  #14,D0
            TRAP    #15
            BRA loop
            
code0101    BRA loop

code0110    BRA loop

code0111    BRA loop

code1000    BRA loop

code1001    BRA loop

code1010    BRA loop

code1011    BRA loop

code1100    BRA loop

code1101    BRA loop

code1110    BRA loop

code1111    LEA     op1111,A1
            MOVE.B  #14,D0
            TRAP    #15
            BRA end

op0100      DC.B    'NOP',CR,LF,0
op1111      DC.B    'SIMHALT',CR,LF,0

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

end         SIMHALT

    END    START        ; last line of source

