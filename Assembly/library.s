AREA library, CODE, READWRITE
EXPORT pin_connect_block0_setup
EXPORT pin_connect_block1_setup
EXPORT read_character
EXPORT output_character
EXPORT read_string
EXPORT output_string
EXPORT uart_init
EXPORT display_digit_on_7_seg
EXPORT read_from_push_btns
EXPORT illuminateLEDs
EXPORT illuminate_RGB_LED
EXPORT reverse_4_bit
EXPORT hex_ascii
EXPORT ascii_hex
EXPORT div_and_mod
EXPORT copy_row
EXPORT interrupt_init
EXPORT MORE_RAND
EXPORT interrupt_disable
EXPORT interrupt_enable
EXPORT SHOOT_RAND
EXPORT SEL_RAND

U0LSR EQU 0x14
IODIR EQU 0x8
IOSET EQU 0x4
IOCLR EQU 0xC
QCHAR EQU 0x71
ECHAR EQU 0x1B

ALIGN



SEL_RAND
STMFD sp!, {r1 - r12, lr}
LDR r4, =0xE0008008
LDRB r1, [r4]
BL div_and_mod
LDMFD sp!, {r1 - r12, lr}
BX lr


SHOOT_RAND
STMFD sp!, {r1 - r12, lr}
LDR r4, =0xE0008008
LDRB r1, [r4]
MOV r0, #22
BL div_and_mod
LDMFD sp!, {r1 - r12, lr}
BX lr

MORE_RAND
STMFD sp!, {r1 - r12, lr}
;generate a number between 0 - 9
LDR r4, =0xE0008008
LDRB r1, [r4]
MOV r0, #2
BL div_and_mod
LDMFD sp!, {r1 - r12, lr}
BX lr

interrupt_disable
	STMFD sp!, {r0 - r12, lr}
	LDR r4, =0xE0004004   ;reset and disable timer counter 0
LDR r5, =0xE0008004
	MOV r3, #0x2
	STR r3, [r4]
STR r3, [r5]
	LDR r4, =0xFFFFF014
	MOV r3, #0x70   ;turn off all interrupt except EINT1
	STR r3, [r4]
	LDMFD sp!, {r0 - r12, lr}
	BX lr

interrupt_enable
	STMFD sp!, {r0 - r12, lr}
	LDR r4, =0xE0004004   ;enable timer counter 0
LDR r5, =0xE0008004
	MOV r3, #0x1
	STR r3, [r4]
STR r3, [r5]
	LDR r4, =0xFFFFF010
	MOV r3, #0x70
	STR r3, [r4]
	LDMFD sp!, {r0 - r12, lr}
	BX lr


interrupt_init
	STMFD SP!, {r0- r12, lr}   ; Save registers
	; Push button setup
	LDR r0, =0xE002C000
	LDR r1, [r0]
	ORR r1, r1, #0x20000000
	BIC r1, r1, #0x10000000
	STR r1, [r0]  ; PINSEL0 bits 29:28 = 10
	; Uart0 RDA setup
	LDR r0, =0xE000C004
	LDR r1, [r0]
	ORR r1, r1, #0x1
	STR r1, [r0]
	LDR r0, =0xFFFFF000
	LDR r1, [r0, #0xC]
	LDR r1, =0x8070 ; External Interrupt 1 and UART1 & 0
	;STR r1, [r0, #0xC]
	;ORR r1, r1, #0x40   ;timer 1
	;ORR r1, r1, #0x30		;timer 0
	STR r1, [r0, #0xC]
	;Enable Interrupts
	LDR r0, =0xFFFFF000
	LDR r1, [r0, #0x10]
	LDR r1, =0x8070 ; External Interrupt 1 Uart0
	;ORR r1, r1, #0x40   ;timer 1
	;ORR r1, r1, #0x30		;timer 0
	STR r1, [r0, #0x10]
	;Timer 0 interrupt configuration
	LDR r0, =0xE0004010
	LDR r1, [r0, #4]
	ORR r1, #0x3
	STR r1, [r0, #4]
	LDR r1, =0x1C2000
	STR r1, [r0, #8]
	;Timer 1 interrupt configuration
	LDR r0, =0xE0008010
	LDR r1, [r0, #4]
	ORR r1, #0x3
	STR r1, [r0, #4]
	LDR r1, =0x4800
	STR r1, [r0, #8]
	; External Interrupt 1 setup for edge sensitive
	LDR r0, =0xE01FC148
	LDR r1, [r0]
	ORR r1, r1, #2  ; EINT1 = Edge Sensitive
	STR r1, [r0]
	; Enable FIQ's, Disable IRQ's
	MRS r0, CPSR
	BIC r0, r0, #0x40
	ORR r0, r0, #0x80
	MSR CPSR_c, r0

	LDMFD SP!, {r0-r12, lr} ; Restore registers
	BX lr             	   ; Return


copy_row
	STMFD sp!, {r2 - r12, lr}
	;r1 = row to transfer to
	;r0 = row to transfer from
	MOV r2, #1
MRL  CMP r2, #22
BEQ CRE
	LDRB r3, [r0, r2]
	STRB r3, [r1, r2]
	ADD r2, r2, #1
	B MRL
CRE
	LDMFD sp!, {r2 - r12, lr}
	BX lr

reverse_4_bit
	STMFD sp!, {r1,r2,r3,r4,lr}
	AND r1, r0, #1				 ;mask first bit
	MOV r1, r1, LSL #3		 ;push to fouth bit
	AND r2, r0, #2				 ;mask second bit
	MOV r2, r2, LSL #1		 ;push to third bit
	AND r3, r0, #4				 ;mask third bit
	MOV r3, r3, LSR #1		 ;push to second bit
	AND r4, r0, #8				 ;mask fourth bit
	MOV r4, r4, LSR #3		 ;push to first bit
	AND r0, r0, #0				 ;clear r0
	ADD r0, r0, r1				 ;add the registers into r0
	ADD r0, r0, r2
	ADD r0, r0, r3
	ADD r0, r0, r4			   ;return reversed 4 bit register in r0
	LDMFD sp!, {r1,r2,r3,r4,lr}
	BX lr


display_digit_on_7_seg
	STMFD sp!, {r1, r2, lr}
	LDR r1, =0xE0028000       	;io0pin
	LDR r2, =0x0026B7BC					;p0.2,3,4,7,8,9,10,12,13,15
	STR r2, [r1, #IODIR]				;set as outputs
	LDR r2, =0x0000B780					;all 1's
	STR r2, [r1, #IOCLR]  			;clear to use
	STR r0, [r1, #IOSET]        ;display value held in r0
	LDMFD sp!, {r1, r2, lr}
	BX lr

read_from_push_btns
	STMFD sp!, {r1, r2, r3, lr}
	LDR r1, =0xE0028010        ;io1pin
	LDR r0, [r1]			;read value passed in
	MVN r0, r0
	AND r0, #0x00F00000				;mask off p1.20-23 are ones
	LSR r0, r0, #20						;shift all the way right
	LDMFD sp!, {r1, r2, r3, lr}
	BX lr

illuminateLEDs
	STMFD sp!, {r1, r2, lr}
	LDR r1, =0xE0028010				;io1pin
	MOV r2, #0xF0000				;all 1's
STR r2, [r1, #IODIR]
	STR r2, [r1, #IOSET]		;clear
	STR r0, [r1, #IOCLR]			;store value passed in
	LDMFD sp!, {r1, r2, lr}
	BX lr

illuminate_RGB_LED
	STMFD sp!, {lr}
	LDR r1, =0xE0028000				;io0pin
	LDR r2, =0x0026B7BC  			;p0.17,18,21
	STR r2, [r1, #IODIR]			;set pins as output
	LDR r2, =0x00260000				;all 1's
	STR r2, [r1, #IOSET]			;clear
	STR r0, [r1, #IOCLR]			;store value passed in
	LDMFD sp!, {lr}
	BX lr

read_string
	STMFD sp!, {lr}
	MOV r0, #0
	STRB r0, [r4], #1
RSLOOP	BL read_character
	CMP r0, #13
	BEQ RSE
	STRB r0, [r4], #1
	BL output_character
	B RSLOOP
RSE	LDMFD sp!, {lr}
	BX lr

output_string
STMFD sp!, {lr}
OSLOOP	LDRB r0, [r4], #1
	BL output_character
	CMP r0, #0
	BNE OSLOOP
	LDMFD sp!, {lr}
	BX lr

read_character
 STMFD SP!, {r1 - r4, lr}
RCLOOP	LDR r1, =0xE000C000
 LDRB r2, [r1, #U0LSR]
	AND r3, r2, #1
	CMP r3, #1
	BNE RCLOOP
	LDRB r0, [r1]
	LDMFD SP!, {r1 - r4, lr}
	BX lr

output_character
	STMFD SP!, {r1 - r3, lr}
BCLOOP	LDR r1, =0xE000C000
	LDRB r2, [r1, #U0LSR]
	AND r3, r2, #32
	CMP r3, #32
	BNE BCLOOP
	STRB r0, [r1]
	LDMFD SP!, {r1 - r3, lr}
	BX lr

uart_init
STMFD sp!, {r0, r1, lr}
LDR r0, =0xE000C000
MOV r1, #131
STR r1, [r0, #0xC]
MOV r1, #10
STR r1, [r0]
MOV r1, #0
STR r1, [r0, #0x4]
MOV r1, #3
STR r1, [r0, #0xC]
LDMFD sp!, {r0, r1, lr}
BX lr

pin_connect_block0_setup
	STMFD sp!, {r0,r1,lr}
	LDR r0, =0xE002C000
	LDR r1, [r0]
	ORR r1, r1, #5
	BIC r1, r1, #0xFFFFFFFA
	STR r1, [r0]
	LDMFD sp!, {r0,r1,lr}
	BX lr

pin_connect_block1_setup
	STMFD sp!, {r0, r1, lr}
	LDR r0, =0xE002C004
	LDR	r1, [r0]
	;ORR r1, r1, #0
	BIC r1, r1, #0xFFFFFFFF
	STR r1, [r0]
	LDMFD sp!, {r0, r1, lr}
	BX lr

ascii_hex
	STMFD sp!, {lr}
	CMP r0, #0x40							;if ascii value is less than 40 just subtract 30 other wise subtract 37
	BLT AHSKIP
	SUB r0, r0, #0x7
AHSKIP	SUB r0, r0, #0x30
	LDMFD sp!, {lr}
	BX lr

hex_ascii
		STMFD sp!, {lr}
		CMP r0, #0x9							;if hex value is lower or equal to 9 Skip
		BLE HXSKIP
		ADD r0, r0, #0x7						;add 7
HXSKIP	ADD r0, r0, #0x30						;add 30
		LDMFD sp!, {lr}
		BX lr



div_and_mod
STMFD sp!, {r2-r12, lr}
MOV r5, #15			;initialize counter to 15
MOV r2, #0			;initialize quotient to 0
MOV r4, #0			;counter to check for negative number for r0
CMP r0, #0			;check if positive, if not take two's complement
BGT SKIP1
MVN r6, r0			;not
ADD r6, r6, #1		;add 1
MOV r0, r6			;mov into r0
ADD r4, r4, #1 		;increment the counter
SKIP1
CMP r1, #0     		;check if divided is positive, if not take two's complement
BGT SKIP2
MVN r7, r1			;not
ADD r7, r7, #1		;add 1
MOV r1, r7			;move into r7
ADD r4, r4, #1		;increment counter for negative numbers
SKIP2
MOV r0, r0, LSL #15		;logical shift left divisor 15 places
MOV r3, r1			;initialize remainder to dividend
LOOP
SUB r3, r3, r0 		;remainder = remainder - divisor
CMP r3, #0
BLT SKIP3			;branch if remainder < 0
MOV r2, r2, LSL #1
ADD r2, r2, #1
MOV r0, r0, LSR #1
B SKIP4
SKIP3
ADD r3, r3, r0
MOV r2, r2, LSL #1
MOV r0, r0, LSR #1
SKIP4
CMP r5, #0		;decrement counter, go back to loop if > 0
BLE FIN
SUB r5, r5, #1
B LOOP
FIN
CMP r4, #1			;check to see if there was a negative number
BNE DONE				;check to make sure only one was negative
MOV r6, #0
MVN r6, r2			;convert the
ADD r6, r6, #1		;numbers back to their original
MOV r2, r6			;form
DONE
MOV r0, r3			;move remainder to r0
MOV r1, r2			;move quotient to r1

LDMFD sp!, {r2-r12, lr}
BX lr

END
