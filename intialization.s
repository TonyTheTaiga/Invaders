	  AREA    initialization, CODE, READWRITE
	  EXPORT base_init
	  EXPORT interrupt_init
	  EXPORT default_setup	
	  EXPORT disable_interrupts
		  
	  ALIGN

base_init
	STMFD SP!, {r0, r1, lr}	

	;UART0
	LDR r0, =0xE000C00C		;load address into memory and store value of 131
	MOV r1, #131			;8-bit word length, 1 stop bit, no parity
	STR r1, [r0]			;disable break control, enable divisor latch access
	LDR r0, =0xE000C000		;load address into memory and store value of 10
	MOV r1, #10				;set lower divisor latch for 115,200 baud
	STR r1, [r0]
	LDR r0, =0xE000C004		;load address into memory and store value of 0
	MOV r1, #0				;set upper divisor latch for 115,200 baud
	STR r1, [r0]
	LDR r0, =0xE000C00C		;load address into memory and store value of 3
	MOV r1, #3				;8-bit word length, 1 stop bit, no parity
	STR r1, [r0]			;disable break control, disable divisor latch access
			
	;PINSEL0
	LDR r0, =0xE002C000  		
	LDR r1, [r0]
	ORR r1, r1, #5				;store 0101 in the first four bits for the UART in PINSEL0
	BIC r1, r1, #0xFFFFFFFA		;clear the remaining bits for GPIO
	STR r1, [r0]

	;PINSEL1
	LDR r0, =0xE002C004 		
	LDR r1, [r0]
	ORR r1, r1, #0				;store all zeros in PINSEL1 for GPIO
	BIC r1, r1, #0xFFFFFFFF
	STR r1, [r0]
	
	LDMFD sp!, {r0, r1, lr}
	BX lr


default_setup
	STMFD SP!, {lr}			
	LDR r1, =0xE0028000		;IO0PIN
	LDR r3, =0x00263F80		;set P0.7 - PO.13, P0.17, P0.18, and P0.19 as outputs
	STR r3, [r1, #8]		
	LDR r3, =0x00001F80		;illuminate a zero in the 7 seg display
	STR r3, [r1, #4]		
	
	LDR r3, =0x00260000 	;illuminate white RGB
	STR r3, [r1, #12]	
	LDR r1, =0xE0028010		;IO1PIN
	LDR r3, =0x000F0000		;set P1.16 - P1.19 as outputs
	STR r3, [r1, #8]	
	LDR r3, =0x000F0000		;illuminate all LEDs
	STR r3, [r1, #12]		
	LDMFD SP!, {lr}			
	BX lr
	
	
	
interrupt_init       
	STMFD SP!, {r0-r1, lr}   ; Save registers 
	
	; Push button setup		 
	LDR r0, =0xE002C000
	LDR r1, [r0]
	ORR r1, r1, #0x20000000
	BIC r1, r1, #0x10000000
	STR r1, [r0]  ; PINSEL0 bits 29:28 = 10

	; Enable Timer 0
	LDR r1, =0xE0004004	
	MOV r2, #1
	STR r2, [r1]
		
	; Classify sources as IRQ or FIQ
	LDR r0, =0xFFFFF000
	LDR r1, [r0, #0xC]
	ORR r1, r1, #0x8000 ; External Interrupt 1
	ORR r1, r1, #0x40	; UART0
	ORR r1, r1, #0x10	; Timer 0
	STR r1, [r0, #0xC]

	; Enable Interrupts
	LDR r0, =0xFFFFF000
	LDR r1, [r0, #0x10] 
	ORR r1, r1, #0x8000 ; External Interrupt 1
	ORR r1, r1, #0x40	; UART0
	ORR r1, r1, #0x10	; Timer 0
	STR r1, [r0, #0x10]

	; UART0 interrupt setup
	LDR r0, =0xE000C004
	LDR r1, [r0]
	ORR r1, r1, #1  ; UART0 Interupt Enable Register bit 0
	STR r1, [r0]
		
	; External Interrupt 1 setup for edge sensitive
	LDR r0, =0xE01FC148
	LDR r1, [r0]
	ORR r1, r1, #2  ; EINT1 = Edge Sensitive
	STR r1, [r0]

	; Timer 0 setup
	LDR r0, =0xE0004014
	LDR r1, [r0]
	ORR r1, r1, #0x18	; interrupts and resets when MR1 = TC
	STR r1, [r0]
	LDR r2, =0x1C2000
	STR r2, [r0, #8]	; store tenth second interval in MR1
	
	; Enable FIQ's, Disable IRQ's
	MRS r0, CPSR
	BIC r0, r0, #0x40
	ORR r0, r0, #0x80
	MSR CPSR_c, r0

	LDMFD SP!, {r0-r1, lr} ; Restore registers
	BX lr             	   ; Return


disable_interrupts
	STMFD SP!, {r0-r1, lr}
	
	LDR r0, =0xFFFFF000
	LDR r1, [r0, #0x14] 
	ORR r1, r1, #0x8000 ; External Interrupt 1
	ORR r1, r1, #0x40	; UART0
	ORR r1, r1, #0x10	; Timer 0
	STR r1, [r0, #0x14]
	
	MRS r0, CPSR
	ORR r0, r0, #0x40		;disable FIQ's
	MSR CPSR_c, r0
	LDMFD SP!, {r0-r1, lr}
	BX lr
	
	
	END