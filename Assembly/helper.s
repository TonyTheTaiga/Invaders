	  AREA	   helper, CODE, READWRITE
	  EXPORT random_number  
	  EXPORT char_check
	  EXPORT spawn_check
	  EXPORT enemy_check
	  EXPORT move_check	  
		  
	  ALIGN

random_number
	STMFD SP!, {lr}			
	LDR r1, =0xE0008008		;load current value from Timer 1
	LDR r0, [r1]
	LDMFD SP!, {lr}			
	BX lr
	

char_check
		STMFD SP!, {lr}			;check if value is equal to any character orientation
		MOV r9, #0
		CMP r7, #0x5E
		BNE NXT
		MOV r9, #1
		B NXT4
NXT		CMP r7, #0x76
		BNE NXT2
		MOV r9, #1
		B NXT4
NXT2	CMP r7, #0x3C
		BNE NXT3
		MOV r9, #1
		B NXT4
NXT3	CMP r7, #0x3E
		BNE NXT4
		MOV r9, #1
NXT4	LDMFD SP!, {lr}			;return a 1 (true) or 0 (false) in r7
		BX lr
	

enemy_check
		STMFD SP!, {lr}
		CMP r12, r3			;check if char is an enemy char
		BNE FIXIT
		MOV r12, #1			;set flag
		
LEFT	CMP r11, #1			;space to the left
		BNE RIGHT
		SUB r4, r4, #1		;subtract 1 from the column
		CMP r7, r1			;compare with enemy coordinates
		BNE lNXT
		CMP r4, r5
		BNE lNXT
		ADD r4, r4, #1		;add back to orignal column
		B FIXIT
lNXT	CMP r7, r2
		BNE FELIX
		CMP r4, r6
		BNE FELIX
		ADD r4, r4, #1
		B FIXIT
		
RIGHT	CMP r11, #2			;right
		BNE UP
		ADD r4, r4, #1		
		CMP r7, r1
		BNE rNXT
		CMP r4, r5
		BNE rNXT
		SUB r4, r4, #1
		B FIXIT
rNXT	CMP r7, r2
		BNE FELIX
		CMP r4, r6
		BNE FELIX
		SUB r4, r4, #1
		B FIXIT
		
UP		CMP r11, #3			;up
		BNE DOWN
		SUB r7, r7, #1
		CMP r7, r1
		BNE uNXT
		CMP r4, r5
		BNE uNXT
		ADD r7, r7, #1
		B FIXIT
uNXT	CMP r7, r2
		BNE FELIX
		CMP r4, r6
		BNE FELIX
		ADD r7, r7, #1
		B FIXIT
		
DOWN	ADD r7, r7, #1		;down
		CMP r7, r1
		BNE dNXT
		CMP r4, r5
		BNE dNXT
		SUB r7, r7, #1
		B FIXIT
dNXT	CMP r7, r2
		BNE FELIX
		CMP r4, r6
		BNE FELIX
		SUB r7, r7, #1

FIXIT	MOV r12, #0		
FELIX	LDMFD SP!, {lr}
		BX lr


spawn_check
		STMFD SP!, {lr}
		MOV r0, #0			;create counter
		MOV r9, #0			;create flag
		MOV r8, r2			;store backup of starting row
		MOV r12, #13		;set upper column bound
		MOV r1, #7			;lower bound
CHK0	CMP r2, #7			;check for collision with player character
		BNE CHK1
		B CLCHK
CHK1	CMP r2, #8
		BNE CHK2
		B CLCHK
CHK2	CMP r2, #9
		BEQ CLCHK
RTRN1	ADD r0, r0, #1		;increment counter
		ADD r10, r3, #1		;change bounds for second enemy
		SUB r11, r3, #1
		ADD r12, r6, #3
		SUB r1, r6, #3
		CMP r2, r11			;check for collision against second enemy
		BNE CHK3
		B CLCHK
CHK3	CMP r2, r3
		BNE CHK4
		B CLCHK
CHK4	CMP r2, r10
		BEQ CLCHK
RTRN2	ADD r0, r0, #1		;increment counter
		ADD r10, r4, #1		;change bounds for second enemy
		SUB r11, r4, #1
		ADD r12, r7, #3
		SUB r1, r7, #3
		CMP r2, r11			;check for collision against third enemy
		BNE CHK5
		B CLCHK
CHK5	CMP r2, r4
		BNE CHK6
		B CLCHK
CHK6	CMP r2, r10
		BNE FIXED
CLCHK   CMP r5, r1
		BGE CLCHK2
		CMP r0, #0
		BEQ RTRN1
		CMP r0, #1
		BEQ RTRN2
		B FIXED
CLCHK2	CMP r5, r12
		BLE SWITCH1
		CMP r0, #0
		BEQ RTRN1
		CMP r0, #1
		BEQ RTRN2
		B FIXED
SWITCH1 CMP r9, #1
		BEQ SWITCH2
		MOV r0, #0			;reset coutner
		ADD r2, r2, #2		;add two rows to enemey row and check again
		CMP r2, #13			;check if no more addition possible
		BGE SUBTIME
		B CHK0
SUBTIME MOV r9, #1
		MOV r2, r8			;restore original row
		B CHK0
SWITCH2 MOV r0, #0			;reset counter
		SUB r2, r2, #2		;sub two rows from enemy row and check again
		B CHK0
FIXED	LDMFD SP!, {lr}
		BX lr


move_check
		STMFD SP!, {lr}		
		CMP r0, #0x20		;check if surrounding characters are applicable movements, return 1 if so
		BNE CHAR1			;check for space
		MOV r0, #1
		B JUNIOR
CHAR1	CMP r0, #0x5E		;check for each of the 4 user characters
		BNE CHAR2
		MOV r0, #1
		B JUNIOR
CHAR2	CMP r0, #0x76
		BNE CHAR3
		MOV r0, #1
		B JUNIOR
CHAR3	CMP r0, #0x3E
		BNE CHAR4
		MOV r0, #1
		B JUNIOR
CHAR4	CMP r0, #0x3C
		BNE EN5p1
		MOV r0, #1
		B JUNIOR
EN5p1	CMP r1, r8			;compare with the coordinates of enemy 1
		BNE EN6p1
		CMP r2, r11
		BNE EN6p1
		MOV r0, #1
		B JUNIOR
EN6p1	CMP r1, r10			;compare with the coordinates of enemy 2
		BNE JUNIOR
		CMP r2, r12
		BNE JUNIOR
		MOV r0, #1
JUNIOR	LDMFD SP!, {lr}
		BX lr


	END