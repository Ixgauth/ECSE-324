		.text
		.equ TIM0, 0xFFC08000
		.equ TIM1, 0xFFC09000
		.equ TIM2, 0xFFD00000
		.equ TIM3, 0xFFD01000
		.global HPS_TIM_config_ASM
		.global HPS_TIM_read_INT_ASM
		.global HPS_TIM_clear_INT_ASM


HPS_TIM_config_ASM:
		MOV R9, #4 // Initialize counter
		B config_LOOP
config_LOOP:
		AND R10, R0, #1 // Check if least significant bit is 1
		CMP R10, #1 // If it is, then we config that specific timer
		BEQ CONFIG
		LSR R0, #1 // Shift right to next bit
		SUB R9, R9, #1
		B config_LOOP
CONFIG:	CMP R9, #4 // If counter is 4, then R5 points to first timer
		LDREQ R5, =TIM0
		CMP R9, #3 // If counter is 3, then R5 points to second timer
		LDREQ R5, =TIM1
		CMP R9, #2 // If counter is 2, then R5 points to third timer
		LDREQ R5, =TIM2
		CMP R9, #1 // If counter is 1, then R5 points to last timer
		LDREQ R5, =TIM3
		CMP R9, #0 // If counter is 0, then the loop is done
		BEQ DONE
		LDR R6, [R0, #0x8] 
		AND R6, R6, #0x6 // E bit is disabled while others are the same
		STR R6, [R5, #0x8]
		LDR R6, [R0, #0x4] // Load timeout element
		STR R6, [R5]
		LDR R6, [R5, #0x8] // Load LD_en element
		LSL R6, R6, #1 // Left shift by 1
		LDR R7, [R0, #0xC] // Load INT_en element
		LSL R7, R7, #2
		LDR R8, [R0, #0x10] // Load enable element
		ORR R10, R6, R7 // Perform OR function for LD_en, INT_en and enable
		ORR R10, R10, R8
		STR R10, [R5, #0x8]
		B config_LOOP 

HPS_TIM_read_INT_ASM:
		LDR R1, =TIM0 // Addresses of each timer
		LDR R2, =TIM1
		LDR R3, =TIM2
		LDR R4, =TIM3
		MOV R6, #4 // Initialize counter
		B LOOP
LOOP:	AND R5, R0, #1 // Check if least significant bit is 1
		CMP R5, #1
		BEQ S_READ
		LSR R0, #1 // Shift right to next bit
		SUB R6, R6, #1 // Decrement counter
		B LOOP
S_READ: CMP R6, #4 // If counter is 4, then load S-bit from first timer
		LDREQ R7, [R1, #0x10]
		CMP R6, #3 // If counter is 3, load S-bit from second timer
		LDREQ R7, [R2, #0x10]
		CMP R6, #2 // If counter is 2, load S-bit from third timer
		LDREQ R7, [R3, #0x10]
		CMP R6, #1 // If counter is 1, load S-bit from last timer
		LDREQ R7, [R4, #0x10]
		CMP R6, #0 // Check if loop is done, if it is then we're done
		BEQ DONE
		B LOOP
DONE: 	BX LR
		
		
HPS_TIM_clear_INT_ASM:
		LDR R1, =TIM0 // Addresses of each timer
		LDR R2, =TIM1
		LDR R3, =TIM2
		LDR R4, =TIM3
		MOV R6, #4 // Initialize counter
		B C_LOOP
C_LOOP:	AND R5, R0, #1 // Check if least significant bit is 1
		CMP R5, #1
		BEQ CLEAR
		LSR R0, #1 // Shift right to next bit
		SUB R6, R6, #1 // Decrement counter
		B C_LOOP
CLEAR:	CMP R6, #4 // If counter is 4, then load F-bit from first timer
		LDREQ R7, [R1, #0xC] // Reading F bit clears both F and S bits 
		CMP R6, #3 // If counter is 3, load F-bit from second timer
		LDREQ R7, [R2, #0xC]
		CMP R6, #2 // If counter is 2, load F-bit from third timer
		LDREQ R7, [R3, #0xC]
		CMP R6, #1 // If counter is 1, load F-bit from last timer
		LDREQ R7, [R4, #0xC]
		CMP R6, #0 // If counter is 0, the loop is done
		BEQ DONE
		B C_LOOP
		

		.end
