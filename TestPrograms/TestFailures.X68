*-----------------------------------------------------------
* Title      : Test ADD
* Written by : Thomas Dye
* Date       : 3/1/2016
* Description: Test basic functionality of ADD opcode.
*-----------------------------------------------------------
        ORG     $7000
START:  ADDI.W	#$4E71,D1               ;test failed
		ADDQ.L	#07,D7	                ;test failed	
        ADDA.L	#$3000AAAA,A6           ;test failed
		ADDI.L	#$D50000AA,D5           ;test failed
		ADDI.W	#$5555,D6               ;test failed
        
        MOVE.W	#$FFD0,(A3)             ;test failed
        MOVEA.W	(A6),A0                 ;test failed
		;MOVEM.W	A0/A1/A2/D5/D6/D7,$3A(A6,D4.L)  ;test failed
		;MOVEM.L	(A0)+,D0/D1/D2/A4/A3/A0/A1      ;test failed
        
        ;LSL.W	(A2)+                   ;test failed
		ASR.B	D6,D7                   ;test failed
		
		LEA	$DC00FF00,A2                ;test failed
		LEA	(A5),A4                     ;test failed
		LEA	-$20(A2,D7),A2              ;test failed
		
		MULS	#$4567,D1	            ;test failed
		
		SUB.L	#$00000055,D4           ;test failed
		SUB.L	#$FFFFFFEE,D7           ;test failed
		
        SIMHALT                ;halt simulator

        END     START          ;last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
