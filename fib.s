				.text
				.global _start

_start:
				LDR R1, =INPUT	// R1 points to input
				LDR R0, [R1]	// R0 holds value of input
				BL fib
				B END

fib:			PUSH {LR}
				CMP R0, #2
				BLT lessthantwo // If less than 2, answer is 1
				SUB R1, R0, #1 // Recursive fibonacci calls
				SUB R2, R0, #2
				PUSH {R2}
				MOV R0, R1
				BL fib			// First recursive fibonacci
				POP {R2}
				PUSH {R0}
				MOV R0, R2
				BL fib			// Second recursive fibonacci
				MOV R2, R0
				POP {R1}
				ADD R0, R1, R2	// Add results 
				POP {LR}
				BX LR			// Recursion is done

lessthantwo:	MOV R0, #1
				POP {LR}
				BX LR

END:			B END


INPUT:			.word  10
