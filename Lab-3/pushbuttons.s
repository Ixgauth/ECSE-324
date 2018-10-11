		.text
		.equ DATA_REGISTER, 0xFF200050
		.equ INTERRUPT_MASK_REGISTER, 0xFF200058
		.equ EDGE_CAPTURE_REGISTER, 0xFF20005C
		.global read_PB_data_ASM
		.global PB_data_is_pressed_ASM
		.global read_PB_edgecap_ASM
		.global PB_edgecap_is_pressed_ASM
		.global PB_clear_edgecap_ASM
		.global enable_PB_int_ASM
		.global disable_PB_int_ASM
		
read_PB_data_ASM:
		LDR R1, =DATA_REGISTER
		LDR R0, [R1]
		BX LR

PB_data_is_pressed_ASM:
		LDR R1, =EDGE_CAPTURE_REGISTER
		LDR R0, [R1]
		ldr r2, =DATA_REGISTER
		str r0, [r2]
		bx lr
		

read_PB_edgecap_ASM:
		LDR R1, =EDGE_CAPTURE_REGISTER
		LDR R0, [R1]
		BX LR

PB_edgecap_is_pressed_ASM:

PB_clear_edgecap_ASM:
		LDR R1, =EDGE_CAPTURE_REGISTER
		MOV R0, #0
		STR R0, [R1]

enable_PB_int_ASM:
		LDR R1, =INTERRUPT_MASK_REGISTER
		MOV R0, #15
		STR R0, [R1]
		bx lr

disable_PB_int_ASM:
		LDR R1, =INTERRUPT_MASK_REGISTER
		MOV R0, #0
		STR R0, [R1]

		.end
