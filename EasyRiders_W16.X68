*------------------------------------------------------------------------------
* Title      : 68K Disassember Final Project
* Written by : Thomas Dye and Ross Holzworth
* Date       : 2/29/16
* Description: CSS 422 Final Project - University of Washington | Bothell
* Instructor : Dr. Yang Peng
*------------------------------------------------------------------------------
* Main ------------------------------------------------------------------------
*---------------Opcode--Operands------------Comments---------------------------
START           ORG     $1000               ;Load at this address

                INCLUDE 'EasyRiders_Parser.X68'

TERMINATE       SIMHALT                     ;Halt the simulator

*------------------------------------------------------------------------------

                INCLUDE 'EasyRiders_Branch.X68'
                INCLUDE 'EasyRiders_Opcodes.X68'
                INCLUDE 'EasyRiders_Functions.X68'
                INCLUDE 'EasyRiders_Subroutines.X68'
                INCLUDE 'EasyRiders_EAs.X68'
                INCLUDE 'EasyRiders_Definitions.X68'

                END     START               ;Do not put anything below this line.

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
