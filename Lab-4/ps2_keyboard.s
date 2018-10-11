			.text
			.equ PS2_Data, 0xFF200100
			.global read_PS2_data_ASM

read_PS2_data_ASM:
			LDR R1, =PS2_Data // Point to data register
			LDR R1, [R1] // Dereference R1 
			AND R2, R1, #0x8000 // Check if RVALID bit is 1 or 0
			CMP R2, #0x8000
			BEQ READ_DATA // If it's 1, then we read data
			MOV R0, #0 // return 0
			B END
READ_DATA:	MOV R3, R1 // Load data from data register
			STRB R3, [R0]
			MOV R0, #1 //return 1
			B END
END:		BX LR

			.end
			
