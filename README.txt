css422
======

University of Washington | Bothell - Winter 2016
Course:  CSS 422 - Hardware and Computer Organization
Instructor:  Dr. Yang Peng

Course Description:

An introduction to the architecture, operation, and organization of a modern
computing machine. Topics covered include basic logic operations,
state-machines, register models, memory organization, peripherals,
and system issues. Assembly language taught in order to understand the
instruction set architecture and memory model of the computer.
===============================================================================

This project is an inverse assembler that converts a memory image of
instructions and data back to 68000 assembly language and outputs the
disassembled code to the console. The program is designed to operate between
memory addresses $1000 and $3000. Optional test code can also be loaded into
memory outside of these address ranges.

The disassembler is designed to run on the Sim68K I/O console provided with the
EASy68K Editor/Assembler. If default fonts and console window sizes are
maintained, the disassembler will print one page of output at a time.

Instructions are disassembled line-by-line using the following format:

	Memory Location Opcode Operand(s)

If the disassembler encounters instructions that are not supported, the DATA
label will be supplied to the console in the format:

	Memory Location DATA $WXYZ

The output $WXYZ is the hexadecimal number that could not be decoded.