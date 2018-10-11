			.text
			.equ HEX_1, 0xFF200020
			.equ HEX_2, 0xFF200030
			.global HEX_clear_ASM
			.global HEX_flood_ASM
			.global HEX_write_ASM

HEX_clear_ASM: 
			LDR R1, =HEX_1 // First HEX address
			LDR R2, =HEX_2 // Second HEX address
			MOV R8, #0x00000000 // Value for clearing HEX display
			MOV R3, #6 // Counter for HEX loop
			B LOOP_AND
LOOP_AND:	AND R4, R0, #1 // Check if least significant bit is 1 or 0
			CMP R4, #1 // If AND result is 1, then we clear HEX display
			BEQ CLEAR
			LSR R0, #1 // Shift right to next bit
			SUB R3, R3, #1 // Decrement counter
			ADD R1, R1, #1 // Increment first address
			CMP R3, #2 // Check if loop was done 4 times
			BEQ LOOP_AND_2 // If it has, then we go to second address
			B LOOP_AND
CLEAR:		STRB R8, [R1]
			LSR R0, #1 // Shift right to next bit
			SUB R3, R3, #1 // Decrement counter
			ADD R1, R1, #1 // Increment first address
			CMP R3, #2 // Check if loop was done 4 times
			BEQ LOOP_AND_2 // If it has, then we go to second address
			B LOOP_AND
LOOP_AND_2:	AND R4, R0, #1
			CMP R4, #1
			BEQ CLEAR_2
			LSR R0, #1
			SUB R3, R3, #1
			ADD R2, R2, #1 // Increment second address
			CMP R3, #0 // If loop is done 6 times, program is done
			BEQ END
			B LOOP_AND_2
CLEAR_2:	STRB R8, [R2]
			LSR R0, #1
			SUB R3, R3, #1
			ADD R2, R2, #1 // Increment second address
			CMP R3, #0 // If loop is done 6 times, program is done
			BEQ END
			B LOOP_AND_2
END:		BX LR 



HEX_flood_ASM:
			LDR R1, =HEX_1 // First HEX address
			LDR R2, =HEX_2 // Second HEX address
			MOV R8, #0xFFFFFFFF // Value for flooding HEX display
			MOV R3, #6 // Counter for HEX loop
			B LOOP_FL
LOOP_FL:	AND R4, R0, #1 // Check if least significant bit is 1 or 0
			CMP R4, #1 // If AND result is 1, then we flood HEX display
			BEQ FLOOD
			LSR R0, #1 // Shift input right to next bit
			SUB R3, R3, #1 // Decrement counter
			ADD R1, R1, #1 // Increment first address
			CMP R3, #2 // Check if loop was done 4 times
			BEQ LOOP_FL_2 // If it has, then we go to second address
			B LOOP_FL
FLOOD:		STRB R8, [R1] // Make all segments equal 1
			LSR R0, #1 // Shift right to next bit
			SUB R3, R3, #1 // Decrement counter
			ADD R1, R1, #1 // Increment first address
			CMP R3, #2 // Check if loop was done 4 times
			BEQ LOOP_AND_2 // If it has, then we go to second address
			B LOOP_AND
LOOP_FL_2:	AND R4, R0, #1
			CMP R4, #1 // If AND result is 1, then we flood HEX display
			BEQ FLOOD_2
			LSR R0, #1 // Shift input right to next bit
			SUB R3, R3, #1
			ADD R2, R2, #1 // Increment second address
			CMP R3, #0 // If loop is done 6 times, program is done
			BEQ END
			B LOOP_FL_2
FLOOD_2:	STRB R8, [R2] // Make all segments equal 1
			LSR R0, #1 // Shift input right to next bit
			SUB R3, R3, #1
			ADD R2, R2, #1 // Increment second address
			CMP R3, #0 // If loop is done 6 times, program is done
			BEQ END
			B LOOP_FL_2

HEX_write_ASM:
			LDR R2, =HEX_1 // First HEX address
			LDR R3, =HEX_2 // Second HEX address
			MOV R4, #6
			MOV r7, #0x0000000F
			B choose_number

choose_number:
			MOV R8, #0x00000071			//code for F
			CMP r1, r7					//check if r1 is F
			BEQ loop_write				//if so r8 already holds value for F move to writing
			sub r7, r7, #1				//otherwise decrement and chack the next number down

			MOV R8, #0x00000079			//code for E
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1
			
			MOV R8, #0x0000005E			//code for D
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x00000039			//code for C
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x0000007C			//code for B
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x00000077			//code for A
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x0000006F			//code for 9
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x0000007F			//code for 8
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x00000007			//code for 7
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x0000007D			//code for 6
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x0000006D			//code for 5
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x00000066			//code for 4
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x0000004F			//code for 3
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x0000005B			//code for 2
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x00000006			//code for 1
			CMP r1, r7
			BEQ loop_write
			sub r7, r7, #1

			MOV R8, #0x0000003F			//code for 0
			CMP r1, r7
			BEQ loop_write				//really its going to branch there either way but if it's not equal we have a bigger problem anyway

loop_write:
			AND R5, R0, #1 // Check if least significant bit is 1 or 0
			CMP R5, #1 // If AND result is 1, then we write to HEX display
			BEQ write
			LSR R0, #1 // Shift input right to next bit
			SUB R4, R4, #1 // Decrement counter
			ADD R2, R2, #1 // Increment first address
			CMP R4, #2 // Check if loop was done 4 times
			BEQ loop_write_2 // If it has, then we go to second address
			B loop_write

write:		
			STRB R8, [R2] // write number chosen above
			LSR R0, #1 // Shift right to next bit
			SUB R4, R4, #1 // Decrement counter
			ADD R1, R1, #1 // Increment first address
			CMP R4, #2 // Check if loop was done 4 times
			BEQ loop_write_2 // If it has, then we go to second address
			B loop_write

loop_write_2:
			AND R5, R0, #1
			CMP R5, #1 // If AND result is 1, then we write to HEX display
			BEQ write_2
			LSR R0, #1 // Shift input right to next bit
			SUB R4, R4, #1
			ADD R3, R3, #1 // Increment second address
			CMP R4, #0 // If loop is done 6 times, program is done
			BEQ END
			B loop_write_2

write_2:
			STRB R8, [R3] // write number chosen above
			LSR R0, #1 // Shift input right to next bit
			SUB R4, R4, #1
			ADD R3, R3, #1 // Increment second address
			CMP R4, #0 // If loop is done 6 times, program is done
			BEQ END
			B write_2
			 
			.end	
