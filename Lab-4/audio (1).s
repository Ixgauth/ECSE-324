			.text
			.equ Audio_Control, 0xFF203040
			.equ Audio_Fifospace, 0xFF203044
			.equ Audio_Leftdata, 0xFF203048
			.equ Audio_Rightdata, 0xFF20304C
			.global write_data_audio_ASM

write_data_audio_ASM:
			LDR R1, =Audio_Leftdata // Point to Leftdata register
			LDR R2, =Audio_Rightdata // Point to Rightdata register
			LDR R3, =Audio_Fifospace // Point to fifospace
			AND R4, R3, #0xFF000000 // Get value of WSLC
			AND R5, R3, #0x00FF0000 // Get value of WSRC
			CMP R4, #0 // Check if we still have space (WSLC)
			BEQ END // If we have no more space, program ends
			CMP R5, #0 // Check if we still have space (WSRC)
			BEQ END
			STR R0, [R1] // Store in Leftdata
			STR R0, [R2] // Store in RightData
			MOV R0, #1 // Return 1
			BX LR
END:		MOV R0, #0 // Return 0
			BX LR

			.end