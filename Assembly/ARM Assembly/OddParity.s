; OddParity.s
; Jacob Read
; Implements an odd parity with 3 inputs and 1 output
; Hardware connections:
;  TM4C123GXL Launchpad Board 
;  One postive logic output on Port D5 (LED)
;  Three positive logic inputs on Ports D0 - D2 (Switch)

GPIO_PORTD_DATA_R  EQU 0x400073FC
GPIO_PORTD_DIR_R   EQU 0x40007400
GPIO_PORTD_DEN_R   EQU 0x4000751C
SYSCTL_RCGCGPIO_R  EQU 0x400FE608
       PRESERVE8 
       AREA   Data, ALIGN=4
       ALIGN 4
       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB
       EXPORT OddParity

OddParity
;Initializations
	LDR R0, =SYSCTL_RCGCGPIO_R; R0 points to GPIO Clock
	LDR R1, [R0]; 				Read the Clock into R1
	ORR R1, #0x08; 				Turn on Port D Clock
	STR R1, [R0]; 				Write back to SYSCTL_RCGCGPIO_R
	NOP;						Wait 2 Clock cycles
	NOP
	LDR R0, =GPIO_PORTD_DIR_R
	MOV R1, #0x20;				PD5 output, PD0-PD2 input (1 for out, 0 for in)
	STR R1, [R0]
	LDR R0, =GPIO_PORTD_DEN_R
	MOV R1, #0x27;				enable PD5, PD0-PD2
	STR R1, [R0] 

loop
;Read inputs
	LDR R0, =GPIO_PORTD_DATA_R
	LDR R1, [R0]
	AND R2, R1, #0x02;			R2 = B
	LSR R2, R2, #1
	AND R3, R1, #0x04; 			R3 = C
	LSR R3, R3, #2
	AND R1, R1, #0x01; 			R1 = A

;Calculate output
	EOR R0, R2, R3;  R0 = B ^ C
	EOR R0, R0, R1;  R0 = A ^ (B^C)
	EOR R0, #1;      R0 = !R0

;Write output
	LSL R0, R0, #5
	LDR R1, =GPIO_PORTD_DATA_R
	STR R0, [R1]
    B    loop
    
    ALIGN
    END
               