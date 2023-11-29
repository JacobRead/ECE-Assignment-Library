; Jacob Read 2/1/2021


; ASM code takes 4 bit integers stored in x3050


; and stores their sum into x3051





	.ORIG x3000


MAIN	LEA R0, INTS


	LDR R0, R0, #0		; R0 = x3050


	LDR R1, R0, #0		; R1 = AB


	RSHFA R2, R1, #4	; R2 = A


	LSHF R1, R1, #12	; 16-BIT REGISTER


	RSHFA R1, R1, #12 	; R1 = B


	ADD R1, R1, R2		; R1 = A + B


	STR R1, R0, #1



INTS	.FILL x3050

	.END