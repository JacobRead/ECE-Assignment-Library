.ORIG	x3000

;--------------------------- PACMAN ---------------------------;
; Directions: Use the wasd keys to move the around the MAZE.   ;
; You win when you eat the 'o' on the screen. If you get caught;
; by the ghosts, you lose!                  	               ;
;--------------------------------------------------------------;


	JSR 	INIT
	JSR 	DISPLAY
BIGNEXT	JSR	GETINPUT
	JSR	UPDATEHEAD
	JSR	UPDATE_MAZE			
	JSR	MOVE_HEAD
	JSR	DISPLAY
	JSR	CHECK_END
	BRNZP 	BIGNEXT

	HALT
MAZE	.FILL	X5000
;-------------------------------------------------------------;
; Initializes the position of the head (stored at HEAD_P) and ;
; and stores the corresponding character '<' in the first     ;
; frame.						      ;
; Input		: None                                        ;
; Output	: Position of the head, stored at HEAD_P      ;
;-------------------------------------------------------------;

INIT
	ST	R7, IN_R7
	LD	R1, MAZE	; Base address of the MAZE
	LD	R2, C_OFF	
	ADD	R1, R1, R2
	ADD	R1, R1, #2	; Start at the top left corner

	LD	R0, HEAD
	STR	R0, R1, #0 	; Store head char (1st frame)	
	ST	R1, HEAD_P
	
	LD	R7, IN_R7
	RET

HEAD	.FILL	x3C
HEAD_P	.BLKW	#1
IN_R7	.BLKW	#1



;-------------------------------------------------------------;
; Loads next frame into location MAZE, and updates HEAD_P to  ;
; point to the a location on the next frame 		      ;			      ;
; Input		: Pointer to MAZE(R1), position of head(R0)   ;
; Output	: Pointer to MAZE(R1), position of head(R0)   ; 
;-------------------------------------------------------------;

UPDATE_MAZE
	ST	R7, UA_R7
	
	LD 	R3, FRAME_N
	LD	R4, FRAME_T
	ADD	R3, R3, #1
	ST 	R3, FRAME_N
	ADD	R3, R3, R4
	
	BRZ	REP_FRAME	
	LD	R2, MAZE_O
	ADD	R0, R0, R2
	ADD	R1, R1, R2
	ST	R0, HEAD_P
	ST	R1, MAZE
	RET

REP_FRAME
	AND	R5, R5, #0
	ST	R5, FRAME_N
	LD	R2, MAZE_N
	ADD	R0, R0, R2
	ADD	R1, R1, R2

	ST R0, HEAD_P ;Added
	ST R1, MAZE ;Added

	LD	R7, UA_R7
	RET

FRAME_N	.FILL	#0
FRAME_T	.FILL	#-23
UA_R7	.BLKW	#1

MAZE_O	.FILL #1058
MAZE_N	.FILL #-23276



;-------------------------------------------------------------;
; This subroutine displays the MAZE			      ;
; Input		: None                                        ;
; Output	: Until it is modified, always frame 1 	      ;	  	
;-------------------------------------------------------------;

DISPLAY 
	ST	R7, DS_R7

	LD 	R1, MAZE
	ST	R1,TEMPD
	LD	R2, C_OFF	; R1 is column counter
	LD	R3, R_OFF	; R2 is row counter

D_MAZE	
	ADD	R0, R1, #0
	PUTS	
	LD 	R0, LF
	OUT
	ADD	R1, R1, R2
	ADD	R3, R3, #-1
	BRP	D_MAZE		; Prints each row	 

	LD	R1,TEMPD
	LD	R7, DS_R7
	RET

C_OFF	.FILL	#46
R_OFF	.FILL	#23
LF	.FILL	x0A
DS_R7	.BLKW	#1
TEMPD	.BLKW	#1



;-------------------------------------------------------------;
; This subroutine stores the INPUT			      ;
; Input		: w,a,s,d,W,A,S,D, or other                   ;
; Output	: None					      ;	  	
;-------------------------------------------------------------;

GETINPUT
	ST R7,GIRET
	GETC
	ST R0,NEWPUT
	LD R7,GIRET
	RET

GIRET	.BLKW X1
NEWPUT	.BLKW X1

	

;-------------------------------------------------------------;
; This subroutine calculates the HEAD POSITION		      ;
; Input		: NEWPUT has Input Character                  ;
; Output	: R0 has the new position for the head	      ;	  	
;-------------------------------------------------------------;

UPDATEHEAD
	ST R7,UHRET
	ST R1,NERO
	LD R1,HEAD_P
	ST R1,PREVPNT

	LD R1,NEWPUT
	LD R4,CHCASE


	LD R3,W
	ADD R2,R1,R3
	BRZ WSAVEUH
	ADD R2,R2,R4
	BRZ WSAVEUH


	LD R3,A
	ADD R2,R1,R3
	BRZ ASAVEUH
	ADD R2,R2,R4
	BRZ ASAVEUH


	LD R3,S
	ADD R2,R1,R3
	BRZ SSAVEUH
	ADD R2,R2,R4
	BRZ SSAVEUH


	LD R3,D
	ADD R2,R1,R3
	BRZ DSAVEUH
	ADD R2,R2,R4
	BRZ DSAVEUH
	BRNZP OWIE


WSAVEUH	LD R3, HEAD_P
	LD R4,WPRESS
	ADD R5,R3,R4
	ST R5, SAVENEW
	LDI R6,SAVENEW
	LD R2, ASST
	ADD R2,R2,R6
	BRZ OWIE
	ST R5,HEAD_P
	LD R6, JUAN
	ST R6,WBLOCK
	LD R6, ZERO
	ST R6,NOPRESS
	BRNZP NEXTUH

ASAVEUH	LD R3, HEAD_P
	LD R4,APRESS
	ADD R5,R3,R4
	ST R5, SAVENEW
	LDI R6,SAVENEW
	LD R2, ASST
	ADD R2,R2,R6
	BRZ OWIE
	ST R5,HEAD_P
	LD R6, JUAN
	ST R6,ABLOCK
	LD R6, ZERO
	ST R6,NOPRESS
	BRNZP NEXTUH

SSAVEUH	LD R3, HEAD_P
	LD R4,SPRESS
	ADD R5,R3,R4
	ST R5, SAVENEW
	LDI R6,SAVENEW
	LD R2, ASST
	ADD R2,R2,R6
	BRZ OWIE
	ST R5,HEAD_P
	LD R6, JUAN
	ST R6,SBLOCK
	LD R6, ZERO
	ST R6,NOPRESS
	BRNZP NEXTUH

DSAVEUH	LD R3, HEAD_P
	LD R4,DPRESS
	ADD R5,R3,R4
	ST R5, SAVENEW
	LDI R6,SAVENEW
	LD R2, ASST
	ADD R2,R2,R6
	BRZ OWIE
	ST R5,HEAD_P
	LD R6, JUAN
	ST R6,DBLOCK
	LD R6, ZERO
	ST R6,NOPRESS
	BRNZP NEXTUH

OWIE	BRNZP NEXTUH

NEXTUH	LD R0,HEAD_P
	LD R1,NERO
	LD R7,UHRET
	RET


UHRET	.BLKW	X1
SAVENEW	.BLKW	X1
PREVPNT	.BLKW	X1
NERO	.BLKW	X1
WBLOCK	.BLKW	X1
ABLOCK	.BLKW	X1
SBLOCK	.BLKW	X1
DBLOCK	.BLKW	X1
W	.FILL	XFFA9
A	.FILL	XFFBF
S	.FILL	XFFAD
D	.FILL	XFFBC
CHCASE	.FILL	XFFE0
WPRESS	.FILL	XFFD2
APRESS	.FILL	XFFFE
SPRESS	.FILL	X002E
DPRESS	.FILL	X0002
ASST	.FILL	XFFD6
JUAN	.FILL	#1
NOPRESS	.FILL	#1
ZERO	.FILL	X0



;-------------------------------------------------------------;
; This subroutine moves the HEAD			      ;
; Input		: HEAD PTR in RO		              ;
; Output	: HEAD IS STORED			      ;	  	
;-------------------------------------------------------------;

MOVE_HEAD
	ST R7,MHRET
	ST R0,L7R
	LDI R6,L7R
	ST R6,L8R
	LD R5,SPACE
	LD R6,PREVPNT
	STR R5,R6,#0
	LD R3,HEAD
	STR R3,R0,#0
	
	LD R7,MHRET
	RET

MHRET	.BLKW	X1
L8R	.BLKW	X1
L7R	.BLKW	X1
SPACE	.FILL	X20
	


;-------------------------------------------------------------;
; This subroutine checks for an END			      ;
; Input		: None			                      ;
; Output	: None					      ;	  	
;-------------------------------------------------------------;

CHECK_END
	ST R7,CERET
	LD R3,L8R
	ADD R4,R3,#0
	LD R5,WINCH
	ADD R4,R4,R5
	BRz WINMESS

	ADD R4,R3,#0
	LD R5 LOSCH
	ADD R4,R4,R5
	BRZ LOSEMESS
	
SWCASE	LD R3,L7R	;CHECKS IF MOVING INTO WHERE A U USED TO BE
	LD R4,PFAME
	ADD R3,R3,R4
	ST R3,HOLD
	LDI R3,HOLD
	LD R4 LOSCH
	ADD R4,R3,R4
	BRZ PHASETOO
	BRNZP CEREAL

PHASETOO BRNZP #0	;CHECKS BASED ON POSITION AND INPUT IF SWITCHED OCCURED (DO NOT FORGET TO RESET NOPRESS AND ALL OTHERS?)
	LD R2, WBLOCK
	BRP WINST
	LD R2, ABLOCK
	BRP AINST
	LD R2, SBLOCK
	BRP SINST
	BRNZP DINST

WINST	BRNZP #0		;IF W WAS PRESSED CHECK LOCATION BELOW ME FOR A U, IF YES LOSE, IF NO CEREAL
	LD R2,L7R
	LD R3,C_OFF
	ADD R2,R2,R3
	ST R2,HOLD
	LDI R2, HOLD
	LD R4, LOSCH
	ADD R4,R4,R2
	BRZ LOSEMESS	
	BRNZP CEREAL

AINST	BRNZP #0		;IF W WAS PRESSED CHECK LOCATION BELOW ME FOR A U, IF YES LOSE, IF NO CEREAL
	LD R2,L7R
	LD R3,DPRESS
	ADD R2,R2,R3
	ST R2,HOLD
	LDI R2, HOLD
	LD R4, LOSCH
	ADD R4,R4,R2
	BRZ LOSEMESS	
	BRNZP CEREAL

SINST	BRNZP #0		;IF W WAS PRESSED CHECK LOCATION BELOW ME FOR A U, IF YES LOSE, IF NO CEREAL
	LD R2,L7R
	LD R3,C_OFF
	NOT R3,R3
	ADD R3,R3,#1
	ADD R2,R2,R3
	ST R2,HOLD
	LDI R2, HOLD
	LD R4, LOSCH
	ADD R4,R4,R2
	BRZ LOSEMESS	
	BRNZP CEREAL

DINST	BRNZP #0		;IF W WAS PRESSED CHECK LOCATION BELOW ME FOR A U, IF YES LOSE, IF NO CEREAL
	LD R2,L7R
	LD R3,DPRESS
	NOT R3,R3
	ADD R3,R3,#1
	ADD R2,R2,R3
	ST R2,HOLD
	LDI R2, HOLD
	LD R4, LOSCH
	ADD R4,R4,R2
	BRZ LOSEMESS	
	BRNZP CEREAL
	

CEREAL
	LD R3, ZERO
	ST R3,WBLOCK
	ST R3,ABLOCK
	ST R3,SBLOCK
	ST R3,DBLOCK
	LD R7,CERET
	RET
	
WINMESS
	LEA R0, GAME_GOOD
	PUTS
	HALT
	
LOSEMESS
	LEA R0,GAME_OVER
	PUTS
	HALT

CERET	.BLKW	X1
WINCH	.FILL	XFF91
LOSCH	.FILL	XFFAB
PFAME	.FILL	#-1058
HOLD	.BLKW	X1
	

;-------------------------------------------------------------;
;-------------------------------------------------------------;


GAME_OVER
	.STRINGZ " Game Over! You Lose!"

GAME_GOOD
	.STRINGZ " Game Over! You Win!"

;START MAZE CODE do a blkw to make this start at x5000
GAP	.BLKW	X1EB2

.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                         U *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * * U * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                                           *"
	.STRINGZ "*   * * * * * * * * * U * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * * U * * * * * * * * *   *"
	.STRINGZ "*                                           *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * * U * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "* U                                         *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"

	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                       U   *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *           U           *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                     U                     *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                     U                     *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o     U           *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*   U                                       *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                     U     *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *         U             *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                   U                       *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                       U                   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o       U         *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*     U                                     *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                   U       *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *       U               *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                 U                         *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                         U                 *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o         U       *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*       U                                   *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                 U         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *     U                 *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*               U                           *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                           U               *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o           U     *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         U                                 *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                               U           *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *   U                   *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*             U                             *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                             U             *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o             U   *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*           U                               *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                             U             *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     * U                     *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*           U                               *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                               U           *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o               U *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*             U                             *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                           U               *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     * U * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*         U                                 *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                                 U         *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * * U *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*               U                           *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                         U                 *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * * U * * * *   * * * *   * * * *   *"
	.STRINGZ "*       U                                   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                                   U       *"
	.STRINGZ "*   * * * *   * * * *   * * * * U * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                 U                         *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                       U                   *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*     U     U                               *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                               U     U     *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                   U                       *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                     U                     *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   U         U                             *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                             U         U   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                     U                     *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                   U                       *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "* U             U                           *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                           U             U *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                       U                   *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                 U                         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                 U                         *"
	.STRINGZ "* U * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * * U *"
	.STRINGZ "*                         U                 *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                         U                 *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                           *"
	.STRINGZ "*         * * * * U * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                   U                       *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "* U *               *   *               * U *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                       U                   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * * U * * * *         *"
	.STRINGZ "*                                           *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                           *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     * U *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                     U                     *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * * U *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "* U * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                     U                     *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   * U *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                                           *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                           *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     * U *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                       U                 U *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "* U                 U                       *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   * U *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                                           *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                           *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * * U * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * * U *"
	.STRINGZ "*                         U                 *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                 U                         *"
	.STRINGZ "* U * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * * U * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                                           *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                           *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *       U               *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     * U *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                           U               *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*               U                           *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "* U *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o         U       *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                                           *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                           *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *         U             *     * U *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                             U             *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*             U                             *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "* U *     *     o       U         *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                                           *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                           *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * * U *"
	.STRINGZ "*   *     *           U           *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                           U               *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*               U                           *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o     U           *     *   *"
	.STRINGZ "* U * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                                           *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                           *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *       U *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * * U * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                         U                 *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                 U                         *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * * U * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "* U       *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                                           *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                           *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*         *     *   *   *   *     *       U *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * * U * * * *   * * * *   *"
	.STRINGZ "*                       U                   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                   U                       *"
	.STRINGZ "*   * * * *   * * * * U * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * *   * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "* U       *     *   *   *   *     *         *"
	.STRINGZ "*         * * * *   * * *   * * * *         *"
	.STRINGZ "*                                           *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	.STRINGZ "*                                           *"
	.STRINGZ "*         * * * *   * * *   * * * *       U *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*   *     *                       *     *   *"
	.STRINGZ "*   *     *   * * * * U * * * *   *     *   *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*                     U                     *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*   *               *   *               *   *"
	.STRINGZ "*   * * * * * * * * *   * * * * * * * * *   *"
	.STRINGZ "*                     U                     *"
	.STRINGZ "*   * * * *   * * * *   * * * *   * * * *   *"
	.STRINGZ "*   *     *   * * * * U * * * *   *     *   *"
	.STRINGZ "*   *     *     o                 *     *   *"
	.STRINGZ "*   * * * * * * *   * * *   * * * * * * *   *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "*         *     *   *   *   *     *         *"
	.STRINGZ "* U       * * * *   * * *   * * * *         *"
	.STRINGZ "*                                           *"
	.STRINGZ "* * * * * * * * * * * * * * * * * * * * * * *"
	
	.END