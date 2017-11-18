				.text
				.global _start

_start:
				LDR R4, =RESULT			//R4 points to result
				LDR R2, [R4, #4]		//R2 holds number of elements in list
				ADD R3, R4, #8			//R3 now points to first number
				LDR R1, [R3]			//R1 holds first number in the list
				MOV R6, #1				//R6 now holds a numberical 1
				MOV R7, #0				//R7 now holds a numerical 0
				MOV R5, #0

LOOP:			ADD R5, R5, R1			//Adds value of R1 to the total
				SUBS R2, R2, #1			//Decrement R2
				BEQ ENDLOOPONE			//If  R2 now zero, move to loop two
				ADD R3, R3, #4			//R3 points to next number in the list
				LDR R1, [R3]			//R1 holds next number in the list
				B LOOP  				//Repeat

ENDLOOPONE:		LDR R2, [R4, #4]		//R2 holds number of elements in list

LOOPTWO:		CMP R6, R2				//Test to see if R6 = R2, place in R8
				BEQ LOOPTHREE			//If so, move to loop three
				ADD R7, R7, #1			//Add one to R7
				LSL R6, R6, #1			//Shift R6 one to the left
				B LOOPTWO				//Repeat

LOOPTHREE:		LSR R5, R5, #1			//Shift total to the right by one
				SUBS R7, R7, #1			//Decrement counter by one
				BEQ DONELOOPTHREE		//If R7 is zero leave loop
				B LOOPTHREE				//Else repeat

DONELOOPTHREE:	ADD R3, R4, #8			//R3 now points to first number
				LDR R0, [R3]			//R0 now holds first number
				LDR R2, [R4, #4]		//R2 holds number of elements in list

LOOPFINAL:		SUBS R0, R0, R5			//Subtract R5 (mean) from zero
				STR R0, [R3]
				SUBS R2, R2, #1			//Decrement R2
				BEQ END					//If R2 zero, move to end
				ADD R3, R3, #4			//R3 points to next number in the list
				LDR R0, [R3]			//R0 holds next number in the list
				B LOOPFINAL				//Else repeat

END:			B END 					//endless loop	

RESULT:			.word	0			// memory assigned for result location
N:				.word	8			// number of entries in the list
NUMBERS:		.word	4, 5, 3, 6	// the list data
				.word	1, 8, 2, 9
