				.text
				.global _start

_start:
				MOV R1, #104		// Random numbers for R1, R2, R3
				MOV R2, #107		// Tests to see if stack works
				MOV R3, #105
				BL findmax			// start subroutine
				B END

findmax:		PUSH {R1 - R3}		// save values for registers
				LDR R0, =RESULT		// R0 points to the result location (max)
				LDR R2, [R0, #4]	// R2 holds the number of elements in the list
				ADD R3, R0, #8		// R3 points to the first number
				LDR R1, [R3]		// R1 holds the first number in the list
				MOV R0, R1			// R0 is set to max number
				B LOOP

LOOP:			SUBS R2, R2, #1		// decrement the loop counter
				BEQ DONE			// end loop if counter has reached 0
				ADD R3, R3, #4		// R3 points to the next number in the list
				LDR R1, [R3]		// R1 holds the next number in the list
				CMP R0, R1			// check if it is greater than the maximum
				BGE LOOP			// if no, branch back to loop
				MOV R0, R1			// if yes, update the current max
				B LOOP				// branch back to the loop


DONE:			POP {R1 - R3}
				BX LR 		

END:			B END				// infinite loop!

RESULT:			.word	0			// memory assigned for result location
N:				.word	7			// number of entries in the list
NUMBERS:		.word	4, 5, 3, 6	// the list data
				.word	1, 8, 2
