*-----------------------------------------------------------
* Title      : Test Failures
* Written by : Thomas Dye
* Date       : 3/10/2016
* Description: Test basic functionality of known failed opcodes.
*-----------------------------------------------------------
        ORG     $7000
START:  ADDI.W	#$4E71,D1
		ADDQ.L	#07,D7
        ADDA.L	#$3000AAAA,A6
		ADDI.L	#$D50000AA,D5
		ADDI.W	#$5555,D6
        
        MOVE.W	#$FFD0,(A3)
        MOVEA.W	(A6),A0
		;MOVEM.W	A0/A1/A2/D5/D6/D7,$3A(A6,D4.L)  ;test 8 failed
		;MOVEM.L	(A0)+,D0/D1/D2/A4/A3/A0/A1      ;test 9 failed
        
        LSL.W	(A2)+
		ASR.B	D6,D7
		
		LEA	$DC00FF00,A2
		LEA	(A5),A4
		LEA	-$20(A2,D7),A2
		
		MULS	#$4567,D1
		
		SUB.L	#$00000055,D4
		SUB.L	#$FFFFFFEE,D7
		
        SIMHALT                ;halt simulator

        END     START          ;last line of source












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
