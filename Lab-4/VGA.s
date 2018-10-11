		.text
		.global VGA_clear_charbuff_ASM
		.global VGA_clear_pixelbuff_ASM
		.global VGA_write_char_ASM
		.global VGA_write_byte_ASM
		.global VGA_draw_point_ASM
		.global VGA_write_test_ASM
		.equ PIXEL_BUFFER, 0xC8000000
		.equ CHARACTER_BUFFER, 0XC9000000


VGA_clear_pixelbuff_ASM:
		LDR r4, =PIXEL_BUFFER // Point to pixel buffer address
		mov r2, #-1 // Initialize x
		mov r3, #0 // Initialize y
		mov r0, #0 // Store 0 into R0
		mov r5, #300 
		add r5, r5, #20 // Set max x for pixel buffer
		B clear_pixel_loop_outer // Go to outer loop

clear_pixel_loop_outer:
		add r2, r2, #1 // Increment x
		cmp r2, r5 // If x reaches end, then clearing is finished
		beq end
		mov r3, #0 // If not, set y to 0 and start inner loop
		b clear_pixel_loop_inner
		


clear_pixel_loop_inner:
		cmp r3, #240 // Check if y reached 240
		beq clear_pixel_loop_outer // If it did, then increment outer loop
		lsl r6, r3, #10 // Left shift y by 10 (multiply by 2^10)
		lsl r7, r2, #1 // Left shift x by 1 (multiply by 2)
		add r6, r6, r7 // Add two results together to get address offset
		ldr r4, =PIXEL_BUFFER // Point to pixel buffer address
		add r4, r4, r6 // Add ofset (R6) to pixel buffer address
		strh r0, [r4] // Store 0 at new address (clear pixel buffer)
		add r3, r3, #1 // Increment y and continue loop
		b clear_pixel_loop_inner
	


VGA_clear_charbuff_ASM:
		LDR r4, =CHARACTER_BUFFER // Point to character buffer address
		mov r2, #-1 // Initialize x
		mov r3, #0 // Initialize y
		mov r0, #0 // 0 used to clear character buffer
		B clear_char_loop_outer


clear_char_loop_outer:
		add r2, r2, #1 // Increment x
		cmp r2, #80 // If x reaches the end, clearing is finished
		beq end
		mov r3, #0 // If not, set y to 0 and start inner loop
		b clear_char_loop_inner


clear_char_loop_inner:
		cmp r3, #60 // Check if y reached end
		beq clear_char_loop_outer // If it has, go back to outer loop
		lsl r5, r3, #7 // Left shift y by 7 (multiply by 2^7)
		add r5, r5, r2 // Add x to result
		ldr r4, =CHARACTER_BUFFER // Point to character buffer address
		add r4, r4, r5 // Add offset to buffer address
		strb r0, [r4] // Clear character buffer at new address
		add r3, r3, #1 // Increment y and continue inner loop
		b clear_char_loop_inner


VGA_write_char_ASM:
		cmp r0, #79 // If x is greater than 79, x is invalid
		bgt end
		cmp r1, #59 // If y is greater than 59, y is invalid
		bgt end
		cmp r0, #0 // If x is less than 0, x is invalid
		blt end
		cmp r1, #0 // If y is less than 0, y is invalid
		blt end
		ldr r4, =CHARACTER_BUFFER // Point to characer buffer address
		add r4, r4, r0 // Add x to character buffer address
		mov r5, #128 // Put 128 into R5
		mul r3, r1, r5 // Multiply y by 128 could use shift but this works equally well
		add r4, r4, r3 // Add result to character buffer address
		strb r2, [r4] // Store char into new address
		mov r0, r4 // Update x value
		b end




VGA_write_byte_ASM:
		cmp r0, #79 // If x is greater than 79, x is invalid
		bgt end
		cmp r1, #59 // If y is greater than 59, y is invalid
		bgt end
		cmp r0, #0 // If x is less than 0, x is invalid
		blt end
		cmp r1, #0 // If y is less than 0, y is invalid
		blt end
		mul r1, #128 // multiply by 2^7
		ldr r4, =CHARACTER_BUFFER // Point to character buffer address
		add r0, r0, r1 // Add y to x value
		ldr r3, =ASCII // Point to ASCII array
		mov r5, r2 // Put byte into r5
		lsr r5, #4 // Right shift byte by 4 (divide by 2^4)
		ldrb R6, [R3, R5] // Load proper ASCII value (of first half of byte) into R6
		strb r6, [r4, r0] // Store ASCII value into buffer address plus x		
		add r0, r0, #1 // Increment x
		mov r5, r2 // Put byte into R5
		and r5, #15 // AND byte with 15 (10000)
		ldrb R6, [R3, R5] // Load proper ASCII value (of second half of byte) into R6
		strb r6, [r4, r0] // Store R6 into buffer address plus x		
		b end
		


VGA_draw_point_ASM:
		mov r8, #300 
		add r8, r8, #19 // Store 319 into R8
		cmp r0, r8 // If x is greater than 319, x is invalid 
		bgt end
		cmp r1, #239 // If y is greater than 239, y is invalid
		bgt end
		cmp r0, #0 // If x is less than 0, x is invalid
		blt end
		cmp r1, #0 // If y is less than 0, y is invalid
		blt end
		ldr r4, =PIXEL_BUFFER // Point to pixel buffer address
		mov r5, #2 // Put 2 into R5
		mul r0, r0, r5 // Multiply x by 2
		mov r7, #1024 // Put 1024 into R7
		mul r1, r1, r7 // Multiply y by 1024
		add r4, r4, r0 // Add x to pixel buffer address
		add r4, r4, r1 // Add y to pixel buffer address
		strh r2, [r4] // Store colour into new address 
		b end

VGA_write_test_ASM:
		ldr r4, =0xC9000001
		mov r3, #69
		strb r3, [r4]
		b end

end:
		bx lr


ASCII:	.byte 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70


		.end
