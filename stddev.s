				.text
				.global _start

_start:
				LDR R4, =RESULT		//R4 points to the result location
				LDR R2, [R4, #4]	//R2 holds the number of elements in the list
				ADD R3, R4, #8		//R3 points to the first number
				LDR R0, [R3]		//R0 holds the first number in the list (minimum)
				LDR R5, [R3]		//R5 also holds first number in the list (maximum)

LOOP:			SUBS R2, R2, #1		// decrement the loop counter
				BEQ SUBSHIFT		// end loop if counter has reached 0
				ADD R3, R3, #4		// R3 points to the next number in the list
				LDR R1, [R3]		// R1 holds the next number in the list
				CMP R1, R0			// check if it is less than minimum
				BLT LESS			// if yes, update minimum value
				CMP R1, R5			// if no, check if it is greater than maximum
				BLE LOOP			// if no, branch back to loop
				MOV R5, R1			// if yes, update maximum value			
				B LOOP				// branch back to the loop

LESS:			MOV R0, R1			// update minimum value
				B LOOP

SUBSHIFT:		SUBS R6, R5, R0		// subtract min from max
				LSR R4, R6, #2		// divide subtract by 4

END:			B END				// infinite loop!

RESULT:			.word	0			// memory assigned for result location
N:				.word	7			// number of entries in the list
NUMBERS:		.word	4, 5, 3, 6	// the list data
				.word	1, 8, 2
