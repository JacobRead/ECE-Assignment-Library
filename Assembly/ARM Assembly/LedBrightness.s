; LedBrightness.s
; Jacob Read
; Demonstrates how variying output duty cycle can change the brightness of an LED
; One Input will cycle through the following duty cycle outputs: {30, 60, 90, 10}
; Another gradually increments the duty cycle when held to "breathe" the LED
; This lab uses the onboard buttons and LED for the TM4C123GXL Launchpad Board, but
; the following additional hardware connections can be used instead:
;  One postive logic output on Port E4 (LED)
;  Two positive logic inputs on Ports E1 & E3 (Switches)

; Port Clock Register
SYSCTL_RCGCGPIO_R  EQU 0x400FE608

; PortE device registers
GPIO_PORTE_DATA_R  EQU 0x400243FC
GPIO_PORTE_DIR_R   EQU 0x40024400
GPIO_PORTE_AFSEL_R EQU 0x40024420
GPIO_PORTE_DEN_R   EQU 0x4002451C

; PortF device registers
GPIO_PORTF_DATA_R  EQU 0x400253FC
GPIO_PORTF_DIR_R   EQU 0x40025400
GPIO_PORTF_AFSEL_R EQU 0x40025420
GPIO_PORTF_AMSEL_R EQU 0x40025528
GPIO_PORTF_PCTL_R  EQU 0x4002552C
GPIO_PORTF_PUR_R   EQU 0x40025510
GPIO_PORTF_DEN_R   EQU 0x4002551C
GPIO_PORTF_LOCK_R  EQU 0x40025520
GPIO_PORTF_CR_R    EQU 0x40025524
GPIO_LOCK_KEY      EQU 0x4C4F434B

       IMPORT  TExaS_Init
       THUMB
	   AREA    DATA, ALIGN=2
       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB
       ALIGN 4
       EXPORT  portInit

portInit
	LDR R0, =SYSCTL_RCGCGPIO_R; R0 points to GPIO Clock
	LDR R1, [R0]; 				Read the Clock into R1
	ORR R1, #0x30; 				Turn on Port E/Port F Clock
	STR R1, [R0]; 				Write back to SYSCTL_RCGCGPIO_R
	NOP;						Wait 2 Clock cycles
	NOP
	
	; Initialize Port E for external Hardware Connections
	LDR R0, =GPIO_PORTE_DIR_R
	MOV R1, #0x10;				PE4 output, PE1/3 input (1 for out, 0 for in)
	STR R1, [R0]
	LDR R0, =GPIO_PORTE_DEN_R
	MOV R1, #0x1A;				enable PE4, PE1/3
	STR R1, [R0]

	; Initialize Port F for Launchpad Connections
    LDR R1, =GPIO_PORTF_LOCK_R
    LDR R0, =0x4C4F434B
    STR R0, [R1]
    LDR R1, =GPIO_PORTF_CR_R
    MOV R0, #0xFF
    STR R0, [R1]
    LDR R1, =GPIO_PORTF_AMSEL_R
    MOV R0, #0x0
    STR R0, [R1]
    LDR R1, =GPIO_PORTF_PCTL_R
    MOV R0, #0x0
    STR R0, [R1]
    LDR R1, =GPIO_PORTF_DIR_R
    MOV R0,#0x0E;				PF3-1 output, PF0/4 input(1 for out, 0 for in)
    STR R0, [R1]
    LDR R1, =GPIO_PORTF_AFSEL_R
    MOV R0, #0x0
    STR R0, [R1]
    LDR R1, =GPIO_PORTF_PUR_R
    MOV R0, #0x11
    STR R0, [R1]
    LDR R1, =GPIO_PORTF_DEN_R
    MOV R0, #0xFF;				enable Port F
    STR R0, [R1]
	 B      registerInit

registerInit
	AND R1, R1, #0x0;				R1 - Current Duty Cycle (30% Initially)
	ADD R1, #0x1E;
	AND R2, R2, #0x0;				R2 - Duty Cycle Counter
	MOV R2, R1
	AND R3, R3, #0x0;				R3 - Breathe Direction
	AND R6, R6, #0x0;				R6 - Breathe Duty Cycle
	AND R7, R7, #0x0;				R7 - Debounce Register
	 B      main

main	 
	 BL 	checkInputs
	CMP R0, #0x02
	 BHS 	updateCycleBreathe
	CMP R7, R0
	 BHS 	debounceInputs
	MOV R7, R0
	CMP R0, #0x01
	 BHS 	updateCycleRegister
	 B 		debounceInputs

	 
checkInputs
	LDR R8, =GPIO_PORTF_DATA_R
	LDR R8, [R8]
	AND R0, R8, #0x10
	LSR R0, R0, #0x3
	AND R8, R8, #0x01
	ADD R0, R0, R8
	EOR R0, R0, #0xFF
	AND R0, R0, #0x03
	LDR R8, =GPIO_PORTE_DATA_R
	LDR R8, [R8]
	AND R4, R8, #0x08
	LSR R4, R4, #0x02
	AND R8, R8, #0x02
	LSR R8, R8, #0x01
	ADD R8, R8, R4
	ORR R0, R0, R8
	 BX LR

debounceInputs
	MOV R2, R1
	MOV R7, R0
ledToggleLoop
	MOV R6, R2
	LDR R0, =GPIO_PORTE_DATA_R; Turn on PE4
	LDR R4, [R0]
	ORR R4, #0x10
	STR R4, [R0]
	LDR R0, =GPIO_PORTF_DATA_R; Turn on PF3-1
	LDR R4, [R0]
	ORR R4, #0x0E
	STR R4, [R0]
	MOV R5, #0x0
	ADD R5, R5, #0x64
	SUBS R5, R5, R2
	 BL setDelay
	LDR R0, =GPIO_PORTE_DATA_R; Turn off PE4
	LDR R4, [R0]
	AND R4, #0xEF
	STR R4, [R0]
	LDR R0, =GPIO_PORTF_DATA_R; Turn off PF3-1
	LDR R4, [R0]
	AND R4, #0xF1
	STR R4, [R0]
	MOV R2, R5
	 BL setDelay
	 B    main

updateCycleBreathe
	MOV R2, R6
	CMP R3, #0x01;				Is Duty Cycle increasing?
	 BHS  breatheInhale
	 B    breatheExhale
breatheInhale
	AND R3, R3, #0x0
	ADD R3, R3, #0x1
	CMP R2, #0x62;				Is Duty Cycle 98%?
	BHS  breatheExhale
	ADD R2, R2, #0x01
	 B    ledToggleLoop
breatheExhale
	AND R3, R3, #0x0
	CMP R2, #0x02
	BLS  breatheInhale
	SUBS R2, R2, #0x01
	 B    ledToggleLoop

updateCycleRegister
	CMP R1, #0x5A;				Is Duty Cycle = 90%
	 BHS  resetCycleRegister
	 B    incrementCycleRegister
resetCycleRegister
	MOV R1, #0x0A
	MOV R2, R1
	 B    ledToggleLoop	 
incrementCycleRegister
	ADD R1, R1, #0x14;			Increment 20%
	MOV R2, R1
	 B    ledToggleLoop

setDelay
	AND R0, R0, #0x00
	LDR R4, =us100
	LDR R4, [R4]
	LSR R2, R2, #0x01;			Delay (in 10ms units) = (Duty Cycle / 2)
incrementDelay
	ADD R0, R4, R0
	SUBS R2, R2, #0x01
	 BNE incrementDelay
waitDelay	
	SUBS R0, R0, #0x01
	 BNE    waitDelay
	 BX     LR
  
us100	FILL 4,0x000007D0,4;	location with 2,000 (100us)

     ALIGN
     END

