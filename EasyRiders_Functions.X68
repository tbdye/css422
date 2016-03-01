*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 2/29/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Disassembler functions
*------------------------------------------------------------------------------
* Pause Screen Output ---------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
FN_PauseOutput  LEA     MSG_PAUSE,A1
                MOVE.B  #14,D0
                TRAP    #15
                MOVE.B  #5,D0
                TRAP    #15
                MOVE.B  #0,LINECOUNT
                BRA     piReturn
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
