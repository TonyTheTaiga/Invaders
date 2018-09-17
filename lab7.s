    AREA interrupts, CODE, READWRITE
    EXPORT lab7
    EXPORT FIQ_Handler
    EXTERN read_character
    EXTERN output_character
    EXTERN output_string
    EXTERN read_string
    EXTERN display_digit_on_7_seg
    EXTERN reverse_4_bit
    EXTERN hex_ascii
    EXTERN ascii_hex
    EXTERN illuminateLEDs
    EXTERN illuminate_RGB_LED
    EXTERN div_and_mod
    EXTERN copy_row
    EXTERN interrupt_init
    EXTERN MORE_RAND
    EXTERN interrupt_disable
    EXTERN interrupt_enable
    EXTERN SHOOT_RAND
    EXTERN SEL_RAND

IODIR EQU 0x8
IOSET EQU 0x4
IOCLR EQU 0xC
QCHAR EQU 0x71
ECHAR EQU 0x1B


ecountsys = 35

segflag = 1

tilda = 0x7E

onoff = 1

systime = 0x78

timedisplay = 0x31,0x32,0x30," :TIME",0xA,0xD,0

thanks4p = "thanks for playing",0xA,0xD,0

ecount = 0x33,0x35," :ENEMIES",0xA,0xD,0 ;starting enemy count = 35

emovflag = 0        ;flag for enemy movement

charoffset = 11 ;offset for character

eshotoffset = 0 ;offset for enemy shot

eshotRow = 0

msoffset = 0

shotoffset = 0  ;offset for shot

largeShield = 0x53      ;character for large shield

smallShield = 0x73      ;character for small shield

eattackRow = 7       ;store the row location of the enemy character

uattackRow = 14    ;store the row location of the attack character

clears = 0xC,0xA,0xD,0   ;clear the screen

lives = 0x34," :LIVES",0xA,0xD,0

movement = 0  ;movement flag; 0 = still, 1 = left, 2 = right

emovement = 0 ;enemy movement flag; 0 = left, 1 = right

attack = 0      ;attack flag; 0 = no attack, 1 = attack

eattackflag = 0

eattackbypass = 0

eattackOffset = 0

uattack = 0x5E  ;character for user attack

eattack = 0x76  ;character for enemy attack

spacechar = 0x20 ;character for space " "

wtype = 0,0,1,0

otype = 0,0,4,0

mtype = 0,0,2,0

xtype = 0,0,0,0

score = 0x30,0x30,0x30,0x30," :SCORE",0xA,0xD,0  ;score holder / initially 0000

msflag = 0

msloc = 0    ;0 = spawn on left side 1 = spawn on the right side

level = 0x30," :LEVEL",0xA,0xD,0                ;level flag; level 1 = 0 level 10 = 9

mschar = 0x58

character = 0x41    ;character

gamestatus = 0 ;0 = running 1 = paused

pauseflag = 0 ;0 = running 1 = pause

timerflag = 1


emptrow = "|                     |",0xA,0xD,0

ggprompt = "Gameover",0xA,0xD
         = "Here are your stats",0xA,0xD,0

toprow  = "|---------------------|",0xA,0xD,0
row1    = "|                     |",0xA,0xD,0
row2    = "|       OOOOOOO       |",0xA,0xD,0
row3    = "|       MMMMMMM       |",0xA,0xD,0
row4    = "|       MMMMMMM       |",0xA,0xD,0
row5    = "|       WWWWWWW       |",0xA,0xD,0
row6    = "|       WWWWWWW       |",0xA,0xD,0
row7    = "|                     |",0xA,0xD,0
row8    = "|                     |",0xA,0xD,0
row9    = "|                     |",0xA,0xD,0
row10   = "|                     |",0xA,0xD,0
row11   = "|                     |",0xA,0xD,0
row12   = "|   SSS   SSS   SSS   |",0xA,0xD,0
row13   = "|   S S   S S   S S   |",0xA,0xD,0
row14   = "|                     |",0xA,0xD,0
row15   = "|          A          |",0xA,0xD,0
botrow = "|---------------------|",0xA,0xD,0

stoprow     = "|---------------------|",0xA,0xD,0
srow1   = "|                     |",0xA,0xD,0
srow2   = "|       OOOOOOO       |",0xA,0xD,0
srow3   = "|       MMMMMMM       |",0xA,0xD,0
srow4   = "|       MMMMMMM       |",0xA,0xD,0
srow5   = "|       WWWWWWW       |",0xA,0xD,0
srow6   = "|       WWWWWWW       |",0xA,0xD,0
srow7   = "|                     |",0xA,0xD,0
srow8   = "|                     |",0xA,0xD,0
srow9   = "|                     |",0xA,0xD,0
srow10  = "|                     |",0xA,0xD,0
srow11  = "|                     |",0xA,0xD,0
srow12  = "|   SSS   S S   SSS   |",0xA,0xD,0
srow13  = "|   S S   S S   S S   |",0xA,0xD,0
srow14  = "|                     |",0xA,0xD,0
srow15  = "|          A          |",0xA,0xD,0
sbotrow = "|---------------------|",0xA,0xD,0

ctoprow     = "|---------------------|",0xA,0xD,0
crow1   = "|                     |",0xA,0xD,0
crow2   = "|       OOOOOOO       |",0xA,0xD,0
crow3   = "|       MMMMMMM       |",0xA,0xD,0
crow4   = "|       MMMMMMM       |",0xA,0xD,0
crow5   = "|       WWWWWWW       |",0xA,0xD,0
crow6   = "|       WWWWWWW       |",0xA,0xD,0
crow7   = "|                     |",0xA,0xD,0
crow8   = "|                     |",0xA,0xD,0
crow9   = "|                     |",0xA,0xD,0
crow10  = "|                     |",0xA,0xD,0
crow11  = "|                     |",0xA,0xD,0
crow12  = "|   SSS   SSS   SSS   |",0xA,0xD,0
crow13  = "|   S S   S S   S S   |",0xA,0xD,0
crow14  = "|                     |",0xA,0xD,0
crow15  = "|          A          |",0xA,0xD,0
cbotrow = "|---------------------|",0xA,0xD,0


prompt  = "|---------------------|",0xA,0xD
                = "|                     |",0xA,0xD
                = "|        SPACE        |",0xA,0xD
                = "|       INVADERS      |",0xA,0xD
                = "|                     |",0xA,0xD
                = "|      O = 40 PTS     |",0xA,0xD
                = "|      M = 20 PTS     |",0xA,0xD
            = "|      W = 10 PTS     |",0xA,0xD
                = "|      X = ?? PTS     |",0xA,0xD
                = "|                     |",0xA,0xD
                = "|                     |",0xA,0xD
                = "| USE A AND D TO MOVE |",0xA,0xD
                = "| SPACE BAR TO SHOOT  |",0xA,0xD
                = "|                     |",0xA,0xD
                = "| PRESS SPACE TO PLAY |",0xA,0xD
                = "| PRESS EINT1 TO PAUSE|",0xA,0xD
            = "|---------------------|",0xA,0xD,0

pauseprompt     = "|---------------------|",0xA,0xD
                = "|                     |",0xA,0xD
                = "|        SPACE        |",0xA,0xD
                = "|       INVADERS      |",0xA,0xD
                = "|                     |",0xA,0xD
                = "|                     |",0xA,0xD
                = "|                     |",0xA,0xD
                = "|        PAUSED       |",0xA,0xD
                = "|                     |",0xA,0xD
                = "|                     |",0xA,0xD
                = "|                     |",0xA,0xD
                = "| USE A AND D TO MOVE |",0xA,0xD
                = "| SPACE BAR TO SHOOT  |",0xA,0xD
            = "|                     |",0xA,0xD
                = "|PRESS EINT1 TO RESUME|",0xA,0xD
                = "|  PRESS ESC TO QUIT  |",0xA,0xD
                = "|---------------------|",0xA,0xD,0

winprompt   = "You have cleared the level",0xA,0xD
            = "Press space to go to the next level",0xA,0xD
            = "Press q to quit the game",0xA,0xD,0


goprompt    = "|---------------------|",0xA,0xD
                = "|                     |",0xA,0xD
                = "|        SPACE        |",0xA,0xD
                = "|       INVADERS      |",0xA,0xD
                = "|                     |",0xA,0xD
                = "|                             |",0xA,0xD
              = "|                               |",0xA,0xD
                = "|                                 |",0xA,0xD
                = "|                             |",0xA,0xD
                = "|                     |",0xA,0xD
                = "|                     |",0xA,0xD
                = "|                                         |",0xA,0xD
            = "|      GAME OVER      |",0xA,0xD
            = "|                     |",0xA,0xD
            = "| PRESS ENTER TO PLAY |",0xA,0xD
                = "|  PRESS ESC TO QUIT  |",0xA,0xD
                = "|---------------------|",0xA,0xD,0


        ALIGN
RGB_GAME_STATUS
            DCD 0x00020000 ;0 - RED
            DCD 0x00200000 ;1 - GREEN
            DCD 0x00040000 ;2 - Blue
            DCD 0x00060000 ;3 - Purple
            DCD 0x00220000 ;4 - Yellow
            DCD 0x00260000 ;5 - WHITE
        ALIGN

        ALIGN
;level clock speed (dunno how this is gonna work yet just a place holder fuck)
level_SPEED
            DCD 0x00000000 ;1
            DCD 0x00000000 ;2
            DCD 0x00000000 ;3
            DCD 0x00000000 ;4
            DCD 0x00000000 ;5
            DCD 0x00000000 ;6
            DCD 0x00000000 ;7
            DCD 0x00000000 ;8
            DCD 0x00000000 ;9
            DCD 0x00000000 ;10
        ALIGN

    ALIGN
digits_SET
            DCD 0x00003780  ; 0
            DCD 0x00003000  ; 1
            DCD 0x00009580  ; 2
            DCD 0x00008780  ; 3
            DCD 0x0000A300  ; 4
            DCD 0x0000A680  ; 5
            DCD 0x0000B680  ; 6
            DCD 0x00000380  ; 7
            DCD 0x0000B780  ; 8
            DCD 0x0000A780  ; 9
            DCD 0x0000B380  ; A
            DCD 0x0000B780  ; B
            DCD 0x00003480  ; C
            DCD 0x00003780  ; D
            DCD 0x0000B480  ; E
            DCD 0x0000B080  ; F
        ALIGN

lab7
    STMFD sp!, {lr}
    ;start of lab 7
    ;Start counter 0
    ;LDR r1, =0xE0028000        ;io0pin
    ;LDR r2, =0x0026B7BC                    ;p0.2,3,4,7,8,9,10,12,13,15
    ;STR r2, [r1, #IODIR]   
    LDR r4, =prompt
    BL output_string
    LDR r0, =0x00260000
    BL illuminate_RGB_LED
ONEL    BL read_character
    CMP r0, #0x20
    BNE ONEL
    LDR r0, =0x00200000
    BL illuminate_RGB_LED
    BL interrupt_init
    LDR r1, =0xE0008004         ;timer for counter 1
    MOV r2, #1                  ;activate counter 1
    ;MOV r2, #1
    STR r2, [r1]
    LDR r0, =0xE0004004                 ;TCR0 address
    LDR r2, [r0]                            ;enable counter
    ORR r2, r2, #1
    STR r2, [r0]
    LDR r4, =emovement
    BL RAND_NUM
    STRB r0, [r4]
GAMESTART
    BL DISPLAY_LIFE
    BL PRINT_Board
    BL interrupt_enable
    LTORG
LOOP
    LDR r12, =ecountsys
    LDRB r11, [r12]
    CMP r11, #0
    BNE NXTT
    B NXTLVL
NXTT    LDR r12, =systime
    LDRB r11, [r12]
    CMP r11, #0
    BNE LOOP
    B PLYAGN
ENDGAME
    ;BL interrupt_disable
    ;LDR r4, =clears
    ;BL output_string
    ;LDR r4, =ggprompt
    ;BL output_string
    ;BL scorescreen
    LDMFD sp!,{lr}
    BX lr


FIQ_Handler
        LTORG
        STMFD SP!, {r0-r12, lr}   ; Save registers
        
TIM1    LDR r0, =0xE0008000             ;Timer 0 Intterupt Register, see which match register caused a interrupt.
        ;TIMER1 = 0xE0008000 bits 0 = MR0, 1 = MR1, 2 = MR2, 3 = MR3
        LDR r1, [r0]
        TST r1, #1
        BEQ EINT1

        STMFD sp!, {r0 - r12, lr}
        ;LDR r9, =onoff
        ;LDRB r8, [r9]
        ;CMP r8, #1
        ;BNE TIM1E
        LDR r1, =0xE0028000
        LDR r5, =score
        LDR r7, =segflag
        LDRB r6, [r7]
        CMP r6, #1
        BNE SCND
        LDR r2, =0x3C
        STR r2, [r1, #IOSET]
        LDR r2, =0x20
        STR r2, [r1, #IOCLR]
        LDRB r0, [r5, #3]
        BL ascii_hex
        LSL r0, #2
        LDR r4, =digits_SET
        LDR r0, [r4, r0]
        BL display_digit_on_7_seg
        ADD r6, r6, #1
        STRB r6, [r7]
        B TIM1E
SCND CMP r6, #2
        BNE THRD
        LDR r2, =0x3C
        STR r2, [r1, #IOSET]
        LDR r2, =0x10
        STR r2, [r1, #IOCLR]
        LDRB r0, [r5, #2]
        BL ascii_hex
        LSL r0, #2
        LDR r4, =digits_SET
        LDR r0, [r4, r0]
        BL display_digit_on_7_seg
        ADD r6, r6, #1
        STRB r6, [r7]
        B TIM1E
THRD CMP r6, #3
        BNE FRTH
        LDR r2, =0x3C
        STR r2, [r1, #IOSET]
        LDR r2, =0x8
        STR r2, [r1, #IOCLR]
        LDRB r0, [r5, #1]
        BL ascii_hex
        LSL r0, #2
        LDR r4, =digits_SET
        LDR r0, [r4, r0]
        BL display_digit_on_7_seg
        ADD r6, r6, #1
        STRB r6, [r7]
        B TIM1E
FRTH CMP r6, #4
        BNE TIM1E
        LDR r2, =0x3C
        STR r2, [r1, #IOSET]
        LDR r2, =0x4
        STR r2, [r1, #IOCLR]
        LDRB r0, [r5]
        BL ascii_hex
        LSL r0, #2
        LDR r4, =digits_SET
        LDR r0, [r4, r0]
        BL display_digit_on_7_seg
        MOV r6, #1
        STRB r6, [r7]
        B TIM1E
TIM1E   LDMFD sp!, {r0 - r12, lr}
        MOV r1, #0x1
        STR r1, [r0]
        LTORG
        B EINT1
        
        
        ; Check for EINT1 interrupt
EINT1   LDR r0, =0xE01FC140
        LDR r1, [r0]
        TST r1, #2
        BEQ UINT
        STMFD SP!, {r0-r12, lr}   ; Save registers
        LDR r4, =pauseflag
        LDRB r3, [r4]
        CMP r3, #0
        BNE RESUMEG
        ;pause game
        MOV r3, #1
        STRB r3, [r4]
        BL interrupt_disable
        LDR r0, =0x00040000
        BL illuminate_RGB_LED
        LDR r4, =pauseprompt
        BL output_string
EINTL   BL read_character
        CMP r0, #0x1B
        BEQ ENDGAME
        B EINTL
        B EINT1E
RESUMEG
        ;resume game
        MOV r3, #0
        STRB r3, [r4]
        BL PRINT_Board
        BL interrupt_enable
        LDR r0, =0x00200000
        BL illuminate_RGB_LED
        B EINT1E
EINT1E  LDMFD SP!, {r0-r12, lr}   ; Restore registers
        ORR r1, r1, #2      ; Clear Interrupt
        STR r1, [r0]
        LTORG
        B FIQ_Exit

UINT
        LDR r0, =0xE000C008
        LDR r1, [r0]
        CMP r1, #1
        BEQ TIMI
        STMFD SP!, {r0 - r12, lr}
        LTORG
        ;code to handle UART interrupt
        ;movement will be handled here
        BL read_character
        CMP r0, #0x61       ;check to see if w was pressed
        BNE UIR
        LTORG
        LDR r4, =movement   ;load movement flag
        MOV r1, #1
        STRB r1, [r4]               ;store a 1 in the flag to move left
        B UINTE
UIR CMP r0, #0x64
        BNE UIA
        LTORG
        LDR r4, =movement       ;load movement flag
        MOV r1, #2
        STRB r1, [r4]               ;store a 2 in the flag to move right
        B UINTE
UIA CMP r0, #0x20
        BNE UINTE
        LTORG
        LDR r4, =attack         ;load attack flag
        LDRB r3, [r4]
        CMP r3, #0              ;make sure there is no shot on the board
        BNE UINTE
        MOV r1, #1              ;update the shot flag
        STRB r1, [r4]           ;store a 1 to indentify a shot on the board
        ;copy the character offset into the shot offset
        LTORG
        LDR r4, =shotoffset
        LDR r3, =charoffset
        LDRB r2, [r3]
        STRB r2, [r4]
        LTORG
        B UINTE
UINTE   LDMFD SP!, {r0 - r12,lr}
        B TIMI
        
TIMI    LDR r0, =0xE0004000             ;Timer 0 Intterupt Register, see which match register caused a interrupt.
        ;TIMER1 = 0xE0008000 bits 0 = MR0, 1 = MR1, 2 = MR2, 3 = MR3
        LDR r1, [r0]
        TST r1, #1
        BEQ FIQ_Exit
        LTORG
        STMFD SP!, {r0 - r12, lr}
        ;code to handle what happens when timer interupts
        BL ENEMY_LIFE
        BL PRINT_Board
        LDR r4, =movement
        LDRB r3, [r4]
        CMP r3, #0
        BEQ CCC
        BL MOVE_Char
CCC     LDR r4, =attack
        LDRB r3, [r4]
        CMP r3, #1
        BNE EATMS
        BL DO_Uattack
EATMS   LDR r4, =eattackflag
        LDRB r3, [r4]
        CMP r3, #1
        BNE QSI
        BL ENEMY_SHOOT
        LTORG
        
QSI     LDR r4, =timerflag  ;1/4 second interval
        LDRH r1, [r4]
        MOV r0, #2
        BL div_and_mod
        CMP r0, #0
        BNE UMS
        LDR r4, =msflag     ;get ms flag
        LDRB r3, [r4]
        CMP r3, #1          ;check for ms on board
        BNE UMS     
        LDR r4, =msloc      ;if there is get ms spawn location
        LDRB r3, [r4]
        CMP r3, #0          ;check to see if spawned on left
        BNE UMSL
        BL MOVE_MSR         ;move right if spawned on left
        BL CHECK_MS         ;check for mother ship
        CMP r0, #0          
        BNE UMS
        LDR r4, =msflag     ;if there isnt, change flag to 0
        MOV r3, #0
        STRB r3, [r4]
        B UMS
        
UMSL    BL MOVE_MSL         ;move left if spawned on the right
        BL CHECK_MS         ;check for mothership
        CMP r0, #0
        BNE UMS
        LDR r4, =msflag     ;if no mothership change the flag
        MOV r3, #0
        STRB r3, [r4]
        B UMS
        
UMS     LDR r4, =timerflag
        LDRH r1, [r4]
        MOV r0, #5                  ;half second interval
        BL div_and_mod
        CMP r0, #0
        BNE MOVES
        LTORG
        BL MOVE_ENEMY
        LDR r4, =eattackflag        ;check if a enemy attack is on the board
        LDRB r3, [r4]               
        CMP r3, #1
        BEQ MOVE                    ;if there is skip
        LTORG
        BL EATTACK_COLCHK           ;check for valid column
        CMP r0, #1                  ;if its not skip
        BNE MOVE
        MOV r0, #1                  ;else update attack flag
        STRB r0, [r4]
        LDR r4, =eattackRow         ;copy attak row
        LDRB r3, [r4]
        LDR r4, =eshotRow           ;to shot row
        STRB r3,[r4]
        B MOVE  
        ;do some more shit to update the board heres
MOVE
        LDR r4, =timerflag
        LDRB r3, [r4]
        CMP r3, #10             ;one second interval
        BNE MOVES
        MOV r3, #1              ;increment timer counter
        STRB r3, [r4]
        BL TIME_LEFT            ;update time left
        LDR r4, =systime
        LDRB r3, [r4]
        SUB r3, r3, #1
        STRB r3, [r4]   
        LDR r4, =msflag         ;load mother ship flag
        LDRB r3, [r4]
        CMP r3, #1
        BEQ TIMIE               ;if there is a ms skip
        LTORG
        BL MORE_RAND            ;get a super random number
        CMP r0, #1                  
        BNE TIMIE               ;if not one skip
        STRB r0, [r4]           ;if it is store 1 in msflag             
        BL RAND_NUM
        LDR r4, =msloc          ;set spawn location
        STRB r0, [r4]
        CMP r0, #1
        BNE XXXX
        LDR r4, =row1
        MOV r3, #0x58
        LDR r7, =msoffset
        MOV r6, #21
        STRB r6, [r7]
        STRB r3, [r4, r6]
        B XXX
XXXX    LDR r4, =row1
        MOV r3, #0x58
        LDR r7, =msoffset
        MOV r6, #1
        STRB r6, [r7]
        STRB r3, [r4, r6]
        B XXX
        LTORG
XXX     B TIMIE

        
MOVES   LDR r4, =timerflag
        LDRB r3, [r4]
        ADD r3, r3, #1
        STRB r3, [r4]
        B TIMIE
TIMIE   LDMFD SP!, {r0 - r12, lr}
        MOV r1, #0x1
        STR r1, [r0]
        B FIQ_Exit

FIQ_Exit
        LDMFD SP!, {r0-r12, lr}
        SUBS pc, lr, #4
        
ENEMY_LIFE
    STMFD sp!, {r0 - r12, lr}
    LDR r12, =ecountsys
    MOV r11, #0
    STRB r11, [r12]
    LDR r4, =ecount
    MOV r3, #0x30
    STRB r3, [r4]
    STRB r3, [r4, #1]
    LDR r0, =row2
    BL ENEMY_LIFEC
    LDR r0, =row3
    BL ENEMY_LIFEC
    LDR r0, =row4
    BL ENEMY_LIFEC
    LDR r0, =row5
    BL ENEMY_LIFEC
    LDR r0, =row6
    BL ENEMY_LIFEC
    LDR r0,  =row7
    BL ENEMY_LIFEC
    LDR r0, =row8
    BL ENEMY_LIFEC
    LDR r0, =row9
    BL ENEMY_LIFEC
    LDR r0, =row10
    BL ENEMY_LIFEC
    LDR r0, =row11
    BL ENEMY_LIFEC
    LDMFD sp!, {r0 - r12, lr}
    BX lr

ENEMY_LIFEC
    STMFD sp!, {r1 - r12, lr}
    ;r0 = row
    LDR r12, =ecountsys
    LDRB r11, [r12]
    LDR r4, =ecount
    LDRB r3, [r4] ;tens
    LDRB r2, [r4, #1] ;ones
    MOV r6, #1   ;counter
ELCL    CMP r6, #22
    BEQ ELIFCE
    LDRB r1, [r0, r6]
    CMP r1, #0x4D
    BLT ELCI
    CMP r1, #0x57
    BGT ELCI
    ;a valid character so increment
    ADD r11, r11, #1
    STRB r11, [r12]
    ADD r2, r2, #1
    CMP r2, #0x39
    BGT ELCT
    STRB r2, [r4, #1]
    B ELCI
ELCT
    SUB r2, r2, #10
    STRB r2, [r4, #1]
    ADD r3, r3, #1
    STRB r3, [r4]
    B ELCI
ELCI    ADD r6, r6, #1
    B ELCL
ELIFCE  LDMFD sp!, {r1 - r12, lr}
    BX lr


PLYAGN
    ;STMFD sp!, {r0 - r12, lr}
    BL interrupt_disable
    LDR r4, =0x00060000
    BL illuminate_RGB_LED
    LDR r4, =clears
    BL output_string
    LDR r4, =ggprompt
    BL output_string
    BL scorescreen
    BL reset_board
    LDR r4, =level
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =uattackRow
    MOV r3, #14
    STRB r3, [r4]
    LDR r4, =lives
    MOV r3, #0x34
    STRB r3, [r4]
    LDR r4, =charoffset
    MOV r3, #11
    STRB r3, [r4]
    LDR r4, =msflag
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =attack
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =eattackflag
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =ecountsys
    MOV r3, #35
    STRB r3, [r4]
    LDR r4, =eattackRow
    MOV r3, #7
    STRB r3, [r4]
    LDR r4, =timedisplay
    MOV r3, #0x30
    STRB r3, [r4, #2]
    ADD r3, r3, #1
    STRB r3, [r4]
    ADD r3, r3, #1
    STRB r3, [r4, #1]
    LDR r4, =systime
    MOV r3, #78
    STRB r3, [r4]
    LDR r4, =score
    MOV r3, #0x30
    STRB r3, [r4]
    STRB r3, [r4, #1]
    STRB r3, [r4, #2]
    STRB r3, [r4, #3]
PAG BL read_character
    CMP r0, #0x71
    BEQ ENDGAME
    CMP r0, #0x20
    BEQ GAMESTART
    B PAG


NXTLVL
    ;STMFD sp!, {r0 - r12, lr}
    BL interrupt_disable
    LDR r4, =0x00060000
    BL illuminate_RGB_LED
    LDR r4, =clears
    BL output_string
    LDR r4, =winprompt
    BL output_string
    BL scorescreen
    BL reset_board
    LDR r4, =level
    LDRB r3, [r4]
    ADD r3, r3, #1
    STRB r3, [r4]
    LDR r4, =charoffset
    MOV r3, #11
    STRB r3, [r4]
    LDR r4, =uattackRow
    MOV r3, #14
    STRB r3, [r4]
    LDR r4, =msflag
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =attack
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =eattackflag
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =ecountsys
    MOV r3, #35
    STRB r3, [r4]
    LDR r4, =eattackRow
    MOV r3, #7
    STRB r3, [r4]
    LDR r4, =timedisplay
    MOV r3, #0x30
    STRB r3, [r4, #2]
    ADD r3, r3, #1
    STRB r3, [r4]
    ADD r3, r3, #1
    STRB r3, [r4, #1]
    LDR r4, =systime
    MOV r3, #0x78
    STRB r3, [r4]
    ;LDR r4, =score
    ;MOV r3, #0x30
    ;STRB r3, [r4]
    ;STRB r3, [r4, #1]
    ;STRB r3, [r4, #2]
    ;STRB r3, [r4, #3]
NLL BL read_character
    CMP r0, #0x71
    BEQ ENDGAME
    CMP r0, #0x20
    BEQ GAMESTART
    B NLL
    ;LDMFD sp!, {r0 - r12, lr}

PRINT_Board
        STMFD sp!, {r4, lr}
        LDR r4, =clears
        BL output_string
        LDR r4, =level
        BL output_string
        LDR r4, =lives
        BL output_string
        LDR r4, =timedisplay
        BL output_string
        LDR r4, =ecount
        BL output_string
        LDR r4, =score
        BL output_string
        LDR r4, =toprow
        BL output_string
        LDR r4, =row1
        BL output_string
        LDR r4, =row2
        BL output_string
        LDR r4, =row3
        BL output_string
        LDR r4, =row4
        BL output_string
        LDR r4, =row5
        BL output_string
        LDR r4, =row6
        BL output_string
        LDR r4, =row7
        BL output_string
        LDR r4, =row8
        BL output_string
        LDR r4, =row9
        BL output_string
        LDR r4, =row10
        BL output_string
        LDR r4, =row11
        BL output_string
        LDR r4, =row12
        BL output_string
        LDR r4, =row13
        BL output_string
        LDR r4, =row14
        BL output_string
        LDR r4, =row15
        BL output_string
        LDR r4, =botrow
        BL output_string
        LDMFD sp!, {r4, lr}
        BX lr
        
scorescreen
        STMFD sp!, {r0 - r12, lr}
        LDR r4, =score
        BL output_string
        LDR r4, =level
        BL output_string
        LDMFD sp!, {r0 - r12, lr}
        BX lr

DO_Uattack
        ;function to "move" the user attack across the board
        STMFD sp!, {r0 - r12, lr}
        ;move the attack
        LDR r4, =uattackRow      ;load the row location
        LDRB r3, [r4]
        LDR r6, =shotoffset    ;load the column of shot
        LDRB r5, [r6]
        LDR r9, =spacechar
        LDRB r8, [r9]
        CMP r3, #14
        BNE TTN     ;check row 13
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row14
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]
        LDR r0, =0x00020000
        BL illuminate_RGB_LED
        B MASKIP
TTN CMP r3, #13
        BNE TWV
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row14              ;load previous row and replace with a space to remove trail
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSS
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSS     LDR r4, =row13
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
TWV CMP r3, #12
        BNE ELVN
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row13
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSA
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSA     LDR r4, =row12
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        LDR r0, =0x00200000
        BL illuminate_RGB_LED
        B MASKIP
ELVN CMP r3, #11
        BNE TEN
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row12
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSB
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSB     LDR r4, =row11
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
TEN CMP r3, #10
        BNE NIN
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row11
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSC
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSC     LDR r4, =row10
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
NIN CMP r3, #9
        BNE EGT
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row10
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSD
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSD     LDR r4, =row9
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
EGT CMP r3, #8
        BNE SVN
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row9
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSG
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSG     LDR r4, =row8
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
SVN CMP r3, #7
        BNE SIX
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row8
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSE
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSE     LDR r4, =row7
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
SIX CMP r3, #6
        BNE FIV
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row7
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSK
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSK     LDR r4, =row6
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
FIV CMP r3, #5
        BNE FOUR
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row6
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSL
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSL     LDR r4, =row5
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
FOUR CMP r3, #4
        BNE THR
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row5
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSO
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSO     LDR r4, =row4
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
THR CMP r3, #3
        BNE TWO
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row4
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSM
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSM     LDR r4, =row3
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
TWO CMP r3, #2
        BNE ONE
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row3
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SSU
        MOV r8, #0x20
        STRB r8, [r4, r5]
SSU     LDR r4, =row2
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
ONE CMP r3, #1
        BNE ZER
        SUB r3, r3, #1              ;update the row
        STRB r3, [r4]
        LDR r4, =row2
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SAA
        MOV r8, #0x20
        STRB r8, [r4, r5]
SAA     LDR r4, =row1
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
ZER CMP r3, #0
        BNE MASKIP
        MOV r3, #14             ;update the row
        STRB r3, [r4]
        LDR r4, =row1
        LDRB r8, [r4, r5]
        CMP r8, #0x5E
        BNE SAB
        MOV r8, #0x20
        STRB r8, [r4, r5]
SAB     LDR r4, =toprow
        LDRB r0, [r4, r5]           ;load character at location before shot
        BL UATTACK_CHAR       ;load character at location after shot
        STRB r0, [r4, r5]     ;update the board with the character
        B MASKIP
MASKIP  LDMFD sp!, {r0 - r12, lr}
        BX lr
        LTORG
UATTACK_CHAR
        STMFD sp!, {r1 - r12, lr}
        ;check what is at board location to see what needs to be printed for the attack
        CMP r0, #0x20               ;if the spot is a space return a ^
        BNE BGS
        LDR r3, =uattack
        LDRB r2, [r3]
        MOV r0, r2
        B UASKIP
BGS CMP r0, #0x53           ;if the spot is a Big Shield return a small shield
        BNE SMS
        LDR r3, =smallShield
        LDRB r2, [r3]
        MOV r0, r2
        LDR r4, =attack             ;turn attack flag off
        MOV r3, #0
        STRB r3, [r4]
        LDR r4, =uattackRow
        MOV r3, #14
        STRB r3, [r4]
        B UASKIP
SMS CMP r0, #0x73           ;if the spot is a Small Shield return a space
        BNE ENAT
        LDR r3, =spacechar
        LDRB r2, [r3]
        MOV r0, r2
        LDR r4, =attack             ;turn attack flag off
        MOV r3, #0
        STRB r3, [r4]
        LDR r4, =uattackRow
        MOV r3, #14
        STRB r3, [r4]
        B UASKIP
ENAT CMP r0, #0x76              ;if the spot is a enemy attack return a tilda
        BNE WALLS
        LDR r3, =tilda
        LDRB r2, [r3]
        MOV r0, r2
        LDR r4, =attack             ;turn attack flag off
        MOV r3, #0
        STRB r3, [r4]
        LDR r4, =uattackRow
        MOV r3, #14
        STRB r3, [r4]
        B UASKIP
WALLS CMP r0, #0x2D             ;if the spot is a wall return same character
        BNE OSP
        LDR r4, =attack             ;turn attack flag off
        MOV r3, #0
        STRB r3, [r4]
        LDR r4, =uattackRow
        MOV r3, #14
        STRB r3, [r4]
        B UASKIP
OSP CMP r0, #0x4F   ;check to see if there is a O type enemy
        BNE MSP
        ;do score update here
        LDR r0, =otype
        BL UPDATE_SCORE
        LDR r3, =spacechar
        LDRB r0, [r3]
        LDR r4, =attack             ;turn attack flag off
        MOV r3, #0
        STRB r3, [r4]
        LDR r4, =uattackRow
        MOV r3, #14
        STRB r3, [r4]
        ;BL ENEMY_LIFE
        B UASKIP
MSP CMP r0, #0x4D   ;check to see if there is a M type enemy
        BNE WSP
        ;do score update here
        LDR r0, =mtype
        BL UPDATE_SCORE
        LDR r3, =spacechar
        LDRB r0, [r3]
        LDR r4, =attack             ;turn attack flag off
        MOV r3, #0
        STRB r3, [r4]
        LDR r4, =uattackRow
        MOV r3, #14
        STRB r3, [r4]
        ;BL ENEMY_LIFE
        B UASKIP
WSP CMP r0, #0x57   ;check to see if there is a W type enemy
        BNE XSP
        LDR r0, =wtype
        BL UPDATE_SCORE
        ;do score update here
        LDR r3, =spacechar
        LDRB r0, [r3]
        LDR r4, =attack             ;turn attack flag off
        MOV r3, #0
        STRB r3, [r4]
        LDR r4, =uattackRow
        MOV r3, #14
        STRB r3, [r4]
        ;BL ENEMY_LIFE
        B UASKIP
XSP CMP r0, #0x58   ;check to see if there is a X type enemy
        BNE UASKIP
        ;do score update here
        BL MS_SCORE
        LDR r0, =xtype
        BL UPDATE_SCORE
        LDR r3, =spacechar
        LDRB r0, [r3]
        LDR r4, =attack             ;turn attack flag off
        MOV r3, #0
        STRB r3, [r4]
        LDR r4, =uattackRow
        MOV r3, #14
        STRB r3, [r4]
        LDR r4, =msflag
        MOV r3, #0
        STRB r3, [r4]
        B UASKIP
UASKIP  ;BL ENEMY_LIFE
        LDMFD sp!, {r1 - r12, lr}
        BX lr
        
MS_SCORE
        STMFD sp!, {r0 - r12, lr}
        LDR r4, =xtype
        LDRB r3, [r4, #1] ;hunreds
        LDRB r2, [r4, #2] ;tens
        LDRB r1, [r4, #3] ;ones
        MOV r0, #3
        BL SEL_RAND
        CMP r0, #0
        BNE JJJ
        ADD r0, r0, #1
JJJ     STRB r0, [r4, #1]
        MOV r0, #10
        BL SEL_RAND
        STRB r0, [r4, #2]
        MOV r0, #10
        BL SEL_RAND
        STRB r0, [r4, #3]
        LDMFD sp!, {r0 - r12, lr}
        BX lr

MOVE_Char
        STMFD sp!, {r0 - r12, lr}
        LDR r9, =character          ;load character char
        LDRB r8, [r9]
        LDR r4, =row15                  ;load user row
        LDR r3, =spacechar          ;load space character
        LDRB r2, [r3]
        LDR r7, =charoffset         ;load offset of character
        LDRB r6, [r7]
        STRB r2, [r4, r6]           ;store space at current offset to remove character
        LDR r3, =movement               ;check to see which direction 1 = left, 2 = right
        LDRB r2, [r3]
        CMP r2, #1                          ;check to see if need to move left
        BNE movR
        ;handle case for moving left
        CMP r6, #1                          ;make sure it has room to move
        BEQ movE
        ;LDR r11, =spacechar            ;fill current location with a space
        ;LDRB r10, [r11]
        ;STRB r10, [r11, r6]
        SUB r6, r6, #1                  ;subtract 1 from offset
        STRB r6, [r7]                       ;store new offset
        STRB r8, [r4, r6]               ;store character char in new offset
        B movE
movR CMP r2, #2                     ;check to see if need to move right
        BNE movE
        ;handle case for moving right
        CMP r6, #21                         ;make sure it has room to move
        BEQ movE
        ;LDR r11, =spacechar            ;fill current location with space
        ;LDRB r10, [r11]
        ;STRB r10, [r11, r6]
        ADD r6, r6, #1                  ;add 1 from offset
        STRB r6, [r7]                       ;store new offset
        STRB r8, [r4, r6]               ;store character char in new offset
        B movE
movE MOV r2, #0                         ;clear movement flag
        STRB r2, [r3]
        LDMFD sp!, {r0 - r12, lr}
        BX lr


ENEMY_SHOOT
    STMFD sp!, {r0 - r12, lr}
    LDR r4, =eshotRow
    LDRB r3, [r4]
    LDR r8, =eattackOffset
    LDRB r5, [r8]
    CMP r3, #7
    BNE ES8
    ADD r3, r3, #1
    STRB r3, [r4]
    LDR r1, =row7
    LDRB r0, [r1, r5]
    BL EATTACK_CHAR
    STRB r0, [r1, r5]
    B ENSE
ES8 CMP r3, #8
    BNE ES9
    ADD r3, r3, #1
    STRB r3, [r4]
    LDR r4, =row7
    LDRB r3, [r4, r5]
    CMP r3, #0x76
    BNE AAA
    MOV r3, #0x20
    STRB r3, [r4, r5]
AAA LDR r1, =row8
    LDRB r0, [r1, r5]
    BL EATTACK_CHAR
    STRB r0, [r1, r5]
    B ENSE
ES9 CMP r3, #9
    BNE ES10
    ADD r3, r3, #1
    STRB r3, [r4]
    LDR r4, =row8
    LDRB r3, [r4, r5]
    CMP r3, #0x76
    BNE AAB
    MOV r3, #0x20
    STRB r3, [r4, r5]
AAB LDR r1, =row9
    LDRB r0, [r1, r5]
    BL EATTACK_CHAR
    STRB r0, [r1, r5]
    B ENSE
ES10 CMP r3, #10
    BNE ES11
    ADD r3, r3, #1
    STRB r3, [r4]
    LDR r4, =row9
    LDRB r3, [r4, r5]
    CMP r3, #0x76
    BNE AAC
    MOV r3, #0x20
    STRB r3, [r4, r5]
AAC LDR r1, =row10
    LDRB r0, [r1, r5]
    BL EATTACK_CHAR
    STRB r0, [r1, r5]
    B ENSE
ES11 CMP r3, #11
    BNE ES12
    ADD r3, r3, #1
    STRB r3, [r4]
    LDR r4, =row10
    LDRB r3, [r4, r5]
    CMP r3, #0x76
    BNE AAD
    MOV r3, #0x20
    STRB r3, [r4, r5]
AAD LDR r1, =row11
    LDRB r0, [r1, r5]
    BL EATTACK_CHAR
    STRB r0, [r1, r5]
    B ENSE
ES12 CMP r3, #12
    BNE ES13
    ADD r3, r3, #1
    STRB r3, [r4]
    LDR r4, =row11
    LDRB r3, [r4, r5]
    CMP r3, #0x76
    BNE AAE
    MOV r3, #0x20
    STRB r3, [r4, r5]
AAE LDR r1, =row12
    LDRB r0, [r1, r5]
    BL EATTACK_CHAR
    STRB r0, [r1, r5]
    B ENSE
ES13 CMP r3, #13
    BNE ES14
    ADD r3, r3, #1
    STRB r3, [r4]
    LDR r4, =row12
    LDRB r3, [r4, r5]
    CMP r3, #0x76
    BNE AAG
    MOV r3, #0x20
    STRB r3, [r4, r5]
AAG LDR r1, =row13
    LDRB r0, [r1, r5]
    BL EATTACK_CHAR
    STRB r0, [r1, r5]
    B ENSE
ES14 CMP r3, #14
    BNE ES15
    ADD r3, r3, #1
    STRB r3, [r4]
    LDR r4, =row13
    LDRB r3, [r4, r5]
    CMP r3, #0x76
    BNE AAF
    MOV r3, #0x20
    STRB r3, [r4, r5]
AAF LDR r1, =row14
    LDRB r0, [r1, r5]
    BL EATTACK_CHAR
    STRB r0, [r1, r5]
    B ENSE
ES15 CMP r3, #15
    BNE EST
    ADD r3, r3, #1
    STRB r3, [r4]
    LDR r4, =row14
    LDRB r3, [r4, r5]
    CMP r3, #0x76
    BNE AAJ
    MOV r3, #0x20
    STRB r3, [r4, r5]
AAJ LDR r1, =row15
    LDRB r0, [r1, r5]
    BL EATTACK_CHAR
    STRB r0, [r1, r5]
    B ENSE
EST CMP r3, #16
    BNE ENSE
    ;MOV r3, #7
    ;STRB r3, [r4]
    MOV r3, #0x20
    LDR r4, =row15
    STRB r3, [r4, r5]
    LDR r1, =botrow
    LDRB r0, [r1, r5]
    BL EATTACK_CHAR
    STRB r0, [r1, r5]
    B ENSE
ENSE    LDMFD sp!, {r0 - r12, lr}
    BX lr



EATTACK_CHAR
    STMFD sp!, {r1 - r12, lr}
    LDR r10, =eshotRow
    LDRB r9, [r10]
    CMP r0, #0x20               ;if the spot is a space return v
    BNE EBGS
    LDR r3, =eattack
    LDRB r2, [r3]
    MOV r0, r2
    B EASKIP
EBGS CMP r0, #0x53
    BNE ESMS
    LDR r3, =smallShield
    LDRB r2, [r3]
    MOV r0, r2
    LDR r4, =eattackflag
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =eshotRow
    MOV r3, r9
    STRB r3, [r4]
    B EASKIP
ESMS CMP r0, #0x73
    BNE UAT
    LDR r3, =spacechar
    LDRB r2, [r3]
    MOV r0, r2
    LDR r4, =eattackflag
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =eshotRow
    MOV r3, r9
    STRB r3, [r4]
    B EASKIP
UAT CMP r0, #0x5E
    BNE EWALLS
    LDR r3, =tilda
    LDRB r2, [r3]
    MOV r0, r2
    LDR r4, =eattackflag
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =eshotRow
    MOV r3, r9
    STRB r3, [r4]
    B EASKIP
EWALLS CMP r0, #0x2D
    BNE UAC
    LDR r4, =eattackflag
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =eshotRow
    MOV r3, r9
    STRB r3, [r4]
    B EASKIP
UAC CMP r0, #0x41
    BNE EASKIP
    ;subtract score
    BL SCORE_SUB
    BL DISPLAY_LIFE
    LDR r3, =spacechar
    LDRB r2, [r3]
    MOV r0, r2
    LDR r4, =charoffset
    MOV r3, #11
    STRB r3, [r4]
    LDR r4, =row15
    LDR r8, =character
    LDRB r7, [r8]
    STRB r7, [r4, r3]
    LDR r4, =eattackflag
    MOV r3, #0
    STRB r3, [r4]
    LDR r4, =eshotRow
    MOV r3, r9
    STRB r3, [r4]
    LDR r4, =lives
    LDRB r3, [r4]
    SUB r3, r3, #1
    STRB r3, [r4]
    BL DISPLAY_LIFE
    B EASKIP
EASKIP  LDMFD sp!, {r1 - r12, lr}
    BX lr


MOVE_ENEMY
        STMFD sp!, {r0 - r12, lr}
        LDR r4, =emovement
        LDRB r3, [r4]
        CMP r3, #0 ;check if enemy is moving left1
        BNE EMR
        ;check if enemy can move left
        LDR r0, =row2
        BL CHECK_WALLLEFT
        LDR r0, =row3
        BL CHECK_WALLLEFT
        LDR r0, =row4
        BL CHECK_WALLLEFT
        LDR r0, =row5
        BL CHECK_WALLLEFT
        LDR r0, =row6
        BL CHECK_WALLLEFT
        LDR r0, =row7
        BL CHECK_WALLLEFT
        LDR r0, =row8
        BL CHECK_WALLLEFT
        LDR r0, =row9
        BL CHECK_WALLLEFT
        LDR r0, =row10
        BL CHECK_WALLLEFT
        LDR r0, =row11
        BL CHECK_WALLLEFT
        LDR r0, =emovflag
        LDRB r1, [r0]
        CMP r1, #10
        BNE LGR             ;if not moveable exit, else move (implement moving down later)
        ;move enemy left
        LDR r4, =emovflag
        MOV r3, #0
        STRB r3, [r4]
        LDR r0, =row2
        BL MOVE_ELEFT
        LDR r0, =row3
        BL MOVE_ELEFT
        LDR r0, =row4
        BL MOVE_ELEFT
        LDR r0, =row5
        BL MOVE_ELEFT
        LDR r0, =row6
        BL MOVE_ELEFT
        LDR r0, =row7
        BL MOVE_ELEFT
        LDR r0, =row8
        BL MOVE_ELEFT
        LDR r0, =row9
        BL MOVE_ELEFT
        LDR r0, =row10
        BL MOVE_ELEFT
        LDR r0, =row11
        BL MOVE_ELEFT
        B EME
LGR
        LDR r4, =emovflag
        MOV r3, #0
        STRB r3, [r4]
        ;move enemy down
        ;change direction
        LDR r4, =emovement
        MOV r3, #1
        STRB r3, [r4]
        LDR r4, =eattackRow
        LDRB r3, [r4]
        CMP r3, #12
        BEQ EME
        B MVDWN
EMR CMP r3, #1
        BNE EME
        ;check if enemy can move right
        LDR r0, =row2
        BL CHECK_WALLRIGHT
        LDR r0, =row3
        BL CHECK_WALLRIGHT
        LDR r0, =row4
        BL CHECK_WALLRIGHT
        LDR r0, =row5
        BL CHECK_WALLRIGHT
        LDR r0, =row6
        BL CHECK_WALLRIGHT
        LDR r0, =row7
        BL CHECK_WALLRIGHT
        LDR r0, =row8
        BL CHECK_WALLRIGHT
        LDR r0, =row9
        BL CHECK_WALLRIGHT
        LDR r0, =row10
        BL CHECK_WALLRIGHT
        LDR r0, =row11
        BL CHECK_WALLRIGHT
        LDR r0, =emovflag
        LDRB r1, [r0]
        CMP r1, #10
        BNE RGL
        ;move enemy right
        LDR r4, =emovflag
        MOV r3, #0
        STRB r3, [r4]
        LDR r0, =row2
        BL MOVE_ERIGHT
        LDR r0, =row3
        BL MOVE_ERIGHT
        LDR r0, =row4
        BL MOVE_ERIGHT
        LDR r0, =row5
        BL MOVE_ERIGHT
        LDR r0, =row6
        BL MOVE_ERIGHT
        LDR r0, =row7
        BL MOVE_ERIGHT
        LDR r0, =row8
        BL MOVE_ERIGHT
        LDR r0, =row9
        BL MOVE_ERIGHT
        LDR r0, =row10
        BL MOVE_ERIGHT
        LDR r0, =row11
        BL MOVE_ERIGHT
        B EME
RGL
        LDR r4, =emovflag
        MOV r3, #0
        STRB r3, [r4]
        ;move enemy down
        ;change direction
        LDR r4, =emovement
        MOV r3, #0
        STRB r3, [r4]
        LDR r4, =eattackRow
        LDRB r3, [r4]
        CMP r3, #12
        BEQ EME
        B MVDWN
MVDWN
        LDR r4, =eattackRow
        LDRB r3, [r4]
        ADD r3, r3, #1
        STRB r3, [r4]
        LDR r0, =row10
        LDR r1, =row11
        BL copy_row
        LDR r0,  =emptrow
        LDR r1, =row10
        BL copy_row
        LDR r0, =row9
        LDR r1, =row10
        BL copy_row
        LDR r0,  =emptrow
        LDR r1, =row9
        BL copy_row
        LDR r0, =row8
        LDR r1, =row9
        BL copy_row
        LDR r0,  =emptrow
        LDR r1, =row8
        BL copy_row
        LDR r0, =row7
        LDR r1, =row8
        BL copy_row
        LDR r0,  =emptrow
        LDR r1, =row7
        BL copy_row
        LDR r0, =row6
        LDR r1, =row7
        BL copy_row
        LDR r0,  =emptrow
        LDR r1, =row6
        BL copy_row
        LDR r0, =row5
        LDR r1, =row6
        BL copy_row
        LDR r0,  =emptrow
        LDR r1, =row5
        BL copy_row
        LDR r0, =row4
        LDR r1, =row5
        BL copy_row
        LDR r0,  =emptrow
        LDR r1, =row4
        BL copy_row
        LDR r0, =row3
        LDR r1, =row4
        BL copy_row
        LDR r0,  =emptrow
        LDR r1, =row3
        BL copy_row
        LDR r0, =row2
        LDR r1, =row3
        BL copy_row
        LDR r0,  =emptrow
        LDR r1, =row2
        BL copy_row
EME LDMFD sp!, {r0 - r12, lr}
        BX lr

MOVE_ERIGHT
        STMFD sp!, {r1 - r12, lr}
        MOV r2, #21
        LDR r7, =spacechar
        LDRB r6, [r7]
MRL     CMP r2, #1
        BEQ MRE
        SUB r3, r2, #1
        LDRB r1, [r0, r3]
        STRB r6, [r0, r3]
        CMP r1, #0x5E
        BNE MVRS
        MOV r1, r6
MVRS    STRB r1, [r0, r2]
        SUB r2, r2, #1
        B MRL
MRE     LDMFD sp!, {r1 - r12, lr}
        BX lr

MOVE_ELEFT
        STMFD sp!, {r1 - r12, lr}
        MOV r2, #1
        LDR r7, =spacechar
        LDRB r6, [r7]
MLL     CMP r2, #21
        BEQ MLE
        ADD r3, r2, #1
        LDRB r1, [r0, r3]
        STRB r6, [r0, r3]
        CMP r1, #0x5E
        BNE MVLS
        MOV r1, r6
MVLS    STRB r1, [r0, r2]
        ADD r2, r2, #1
        B MLL
MLE     LDMFD sp!, {r1 - r12, lr}
        BX lr

CHECK_WALLLEFT
        STMFD sp!, {r3 - r12, lr}
        ;this checks if it is a valid movement for the enemy to make
        ;return 0 or 1 in r2, 0 = not valid, 1 = valid
        LDR r4, =emovflag
        LDRB r3, [r4]
        LDRB r1, [r0, #1]   ;loads character right next to the wall
        CMP r1, #0x20                ;checks to see if that character is a space
        BEQ LLL
        CMP r1, #0x5E
        BEQ LLL
        B WALLLE
LLL     ADD r3, r3, #1
        STRB r3, [r4]
WALLLE  LDMFD sp!, {r3 - r12, lr}
        BX lr

CHECK_WALLRIGHT
      STMFD sp!, {r3 - r12, lr}
      ;takes in a row and checks if there is a free space or not
      LDR r4, =emovflag
      LDRB r3, [r4]
      LDRB r1, [r0, #21]        ;checks right most space
      CMP r1, #0x20
      BEQ RRR
      CMP r1, #0x5E
      BEQ RRR
      B WALLRE
RRR   ADD r3, r3, #1
      STRB r3, [r4]
WALLRE  LDMFD sp!, {r3 - r12, lr}
        BX lr


EATTACK_COLCHK
    STMFD sp!, {r1 - r12, lr}
    ;return answer in r0
    ;check if the colum has a enemy character
    BL SHOOT_RAND
    CMP r0, #0
    BNE BBB
    ADD r0, r0, #1
BBB MOV r3, r0
    LDR r8, =eattackOffset
    STRB r3, [r8]
    MOV r0, #0
    LDR r4, =row7
    LDRB r2, [r4, r3]                   ;get character at offset
    CMP r2, #0x4C
    BLT CHCK8
    CMP r2, #0x57
    BGT CHCK8
    MOV r0, #1
    B BEARE
CHCK8
    LDR r4, =row8
    LDRB r2, [r4, r3]
    CMP r2, #0x4C
    BLT CHK9
    CMP r2, #0x57
    BGT CHK9
    MOV r0, #1
    B BEARE
CHK9
    LDR r4, =row9
    LDRB r2, [r4, r3]
    CMP r2, #0x4C
    BLT CHK10
    CMP r2, #0x57
    BGT CHK10
    MOV r0, #1
    B BEARE
CHK10
    LDR r4, =row10
    LDRB r2, [r4, r3]
    CMP r2, #0x4C
    BLT CHK11
    CMP r2, #0x57
    BGT CHK11
    MOV r0, #1
    B BEARE
CHK11
    LDR r4, =row11
    LDRB r2, [r4, r3]
    CMP r2, #0x4C
    BLT BEARE
    CMP r2, #0x57
    BGT BEARE
    MOV r0, #1
    B BEARE
BEARE   LDMFD sp!, {r1 - r12, lr}
    BX lr



RAND_NUM
        STMFD sp!, {r1 - r12, lr}
        ;get random number
        ;load current time from timer, and mod it to get either 1 or 0
        LDR r4, =0xE0008008     ;load Timer Counter 1 Address
        LDRB r3, [r4]                   ;load current value of Timer
        MOV r1, r3
        MOV r0, #2
        BL div_and_mod              ;mod by 2 to get either 1 or 0 answer return in r0
        LDMFD sp!, {r1 - r12, lr}
        BX lr

CHECK_MS
    STMFD sp!, {r1 - r12, lr}
    LDR r4, =row1       ;row for mother ship
    MOV r0, #0  ;assume that there is no a MS on board
    MOV r2, #1   ;offset
CHKMSL  CMP r2, #22
    BEQ CHKMSE
    LDRB r1, [r4, r2]
    ADD r2, r2, #1
    CMP r1, #0x58
    BNE CHKMSL
    MOV r0, #1
    B CHKMSE
CHKMSE  LDMFD sp!, {r1 - r12, lr}
    BX lr

MOVE_MSL
        STMFD sp!, {r0 - r12, lr}
        LDR r4, =row1
        LDR r6, =msoffset
        LDRB r5, [r6]
        CMP r5, #1
        BEQ RMSL
        MOV r3, #0x20
        STRB r3, [r4, r5]
        SUB r5, r5, #1
        STRB r5, [r6]
        MOV r3, #0x58
        STRB r3, [r4, r5]
        B MSLE
RMSL    MOV r3, #0x20
        STRB r3, [r4, r5]
MSLE    LDMFD sp!, {r0 - r12, lr}
    BX lr

MOVE_MSR
        STMFD sp!, {r0 - r12, lr}
        LDR r4, =row1
        LDR r6, =msoffset
        LDRB r5, [r6]
        CMP r5, #21
        BEQ RMSR
        MOV r3, #0x20
        STRB r3, [r4, r5]
        ADD r5, r5, #1
        STRB r5, [r6]
        MOV r3, #0x58
        STRB r3, [r4, r5]
        B MSRE
RMSR    MOV r3, #0x20
        STRB r3, [r4, r5]
MSRE LDMFD sp!, {r0 - r12, lr}
        BX lr

SPAWN_MOTHERSHIP
    STMFD sp!, {r0 - r12, lr}
    LDR r4, =msloc
    LDRB r3, [r4]
    MOV r0, #0x58
    LDR r4, =row1
    CMP r3, #0
    BNE SPWNR
    STRB r0, [r4, #1]
    B SMSE
SPWNR
    STRB r0, [r4, #21]
SMSE    LDMFD sp!, {r0 - r12, lr}
    BX lr

TIME_LEFT
    STMFD sp!, {r0 - r12, lr}
    LDR r4, =timedisplay
    LDRB r3, [r4, #2]       ;ones
    LDRB r2, [r4, #1]       ;tens
    LDRB r1, [r4]       ;hundreds
    CMP r3, #0x30
    BEQ TENS
    SUB r3, r3, #1
    STRB r3, [r4, #2]
    B TLE
TENS
    CMP r2, #0x30
    BEQ HUNDS
    MOV r3, #0x39
    STRB r3, [r4, #2]
    SUB r2, r2, #1
    STRB r2, [r4, #1]
    B TLE
HUNDS
    CMP r1, #0x30
    BEQ TLE
    MOV r2, #0x39
    STRB r2, [r4, #1]
    SUB r1, r1, #1
    STRB r1, [r4]
    B TLE
TLE LDMFD sp!, {r0 - r12, lr}
    BX lr

UPDATE_SCORE
    STMFD sp!, {r1 - r12, lr}
    ;r0 =
    LDR r5, =score
    LDRB r4, [r5] ;thousands
    LDRB r3, [r5, #1] ;hundreds
    LDRB r2, [r5, #2] ;tens
    LDRB r1, [r5, #3] ;ones
    LDRB r9, [r5]
    LDRB r7, [r0, #3] ;ones from string
    LDRB r6, [r0, #2] ;tens from string
    LDRB r8, [r0, #1] ;hundred string
USONE
    ADD r1, r1, r7
    CMP r1, #0x39
    BGT USOS
    STRB r1, [r5, #3]
    B USTEN
USOS
    SUB r1, r1, #0xA
    STRB r1, [r5, #3]
    ADD r2, r2, #1
USTEN
    ADD r2, r2, r6
    CMP r2, #0x39
    BGT USTS
    STRB r2, [r5, #2]
    B USHUN
USTS
    SUB r2, r2, #0xA
    STRB r2, [r5, #2]
    ADD r3, r3, #1
USHUN
    ADD r3, r3, r8
    CMP r3, #0x39
    BGT USHS
    STRB r3, [r5, #1]
    B USTHO
USHS
    SUB r3, r3, #0xA
    STRB r3, [r5, #1]
    ADD r9, r9, #1
USTHO
    STRB r9, [r5]
USEE    LDMFD sp!, {r1 - r12, lr}
    BX lr
    
SCORE_SUB
    STMFD sp!, {r0 - r12, lr}
    LDR r4, =score
    LDRB r0, [r4] ;thousands
    LDRB r1, [r4, #1] ;Hundreds
    CMP r1, #0x30
    BEQ YYY
    SUB r1, r1, #1
    STRB r1, [r4, #1]
    B SSE
YYY MOV r5, #0x30
    STRB r5, [r4, #1]
    STRB r5, [r4, #2]
    STRB r5, [r4, #3]
    CMP r0, #0x30
    BEQ OOO
    SUB r0, r0, #1
    STRB r0, [r4]
    B OOO
OOO LDMFD sp!, {r0 - r12, lr}
    BX lr


DISPLAY_LIFE
    STMFD sp!, {r0 - r12, lr}
    LDR r4, =lives
    LDRB r3, [r4]
    SUB r3, r3, #0x30
    CMP r3, #4
    BNE DL3
    LDR r0, =0x000F0000
    BL illuminateLEDs
    B DLE
DL3 CMP r3, #3
    BNE DL2
    LDR r0, =0x000E0000
    BL illuminateLEDs
    B DLE
DL2 CMP r3, #2
    BNE DL1
    LDR r0, =0x000C0000
    BL illuminateLEDs
    B DLE
DL1 CMP r3, #1
    BNE DL0
    LDR r0, =0x00080000
    BL illuminateLEDs
    B DLE
DL0
    LDR r0, =0x00000000
    BL illuminateLEDs
    CMP r3, #0
    BEQ ENDGAME
    ;do something for when you die
DLE LDMFD sp!, {r0 - r12, lr}
    BX lr

reset_board
    STMFD sp!, {r0 - r12, lr}
    LDR r0, =stoprow
    LDR r1, =toprow
    BL copy_row
    LDR r0, =srow1
    LDR r1, =row1
    BL copy_row
    LDR r0, =srow2
    LDR r1, =row2
    BL copy_row
    LDR r0, =srow3
    LDR r1, =row3
    BL copy_row
    LDR r0, =srow4
    LDR r1, =row4
    BL copy_row
    LDR r0, =srow5
    LDR r1, =row5
    BL copy_row
    LDR r0, =srow6
    LDR r1, =row6
    BL copy_row
    LDR r0, =srow7
    LDR r1, =row7
    BL copy_row
    LDR r0, =srow8
    LDR r1, =row8
    BL copy_row
    LDR r0, =srow9
    LDR r1, =row9
    BL copy_row
    LDR r0, =srow10
    LDR r1, =row10
    BL copy_row
    LDR r0, =srow11
    LDR r1, =row11
    BL copy_row
    LDR r0, =srow12
    LDR r1, =row12
    BL copy_row
    LDR r0, =srow13
    LDR r1, =row13
    BL copy_row
    LDR r0, =srow14
    LDR r1, =row14
    BL copy_row
    LDR r0, =srow15
    LDR r1, =row15
    BL copy_row
    LDR r0, =sbotrow
    LDR r1, =botrow
    BL copy_row
    LDMFD sp!, {r0 - r12, lr}
    BX lr


    END
