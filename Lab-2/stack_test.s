			.text
			.global _start

_start:
			LDR R5, =NUMBERS
			LDR R13, =0x00000044
			LDR R0, [R5]
			LDR R1, [R5, #4]
			LDR R2, [R5, #8]
			SUB R13, R13, #4
			STR R0, [R13]
			STMDB R13!, {R1, R2}
			LDMIA R13!, {R0 - R2}

END:		B END

NUMBERS:	.word 4, 5, 6
