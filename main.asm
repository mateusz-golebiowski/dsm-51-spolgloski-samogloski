TEXT    EQU 10H
LED     EQU P1.7
BUZZER  EQU P1.5

    LJMP    START
    ORG 100H
    
START:
    MOV DPTR, #TEXT
    MOV A, #0
    MOVX @DPTR, A
    MOV R1,#0

    MOV R0, #'A'
LOOP:
    MOV A, R1
    CJNE    A, #32,NEXT
    SJMP END
NEXT:
    LCALL   LCD_CLR
    MOV DPTR, #TEXT
    MOVX A,@DPTR
    LCALL   WRITE_TEXT
    MOV A, R0
    LCALL   WRITE_DATA
    LCALL   WAIT_KEY

    CJNE    A, #0AH,CHECK_0B
    CJNE    R0, #41H,PREV_LETTER
    MOV R0,#5AH
    SJMP    LOOP
PREV_LETTER:
    MOV A, R0
    SUBB A,#1
    MOV R0, A
    SJMP    LOOP

CHECK_0B:
    CJNE    A, #0BH,CHECK_0F
    CJNE    R0, #5AH,NEXT_LETTER
    MOV R0,#41H
    SJMP    LOOP
NEXT_LETTER:
    MOV A, R0
    ADD A,#1
    MOV R0, A
    SJMP    LOOP
    
CHECK_0F:
    CJNE    A, #0FH,CHECK_OE
    MOV DPTR, #TEXT
    MOV A, R1
    SJMP LOOP2

CHECK_OE:
    CJNE    A, #0EH,LOOP
END:
    MOV DPTR, #TEXT
    
    LCALL   LCD_CLR
    

LOOP3:
    MOVX A,@DPTR
    JZ  START
   
    
    LCALL   WRITE_DATA
    MOV A,#10 ;czekaj czas 10*100ms=1s
	LCALL	DELAY_100MS ;podprogram z EPROMu
    MOVX A, @DPTR
CHECK_A:
    CJNE    A,#41H, CHECK_E
    SJMP SPEAKER

CHECK_E:
    CJNE    A,#45H, CHECK_I
    SJMP SPEAKER

CHECK_I:
    CJNE    A,#49H, CHECK_O
    SJMP SPEAKER

CHECK_O:
    CJNE    A,#4FH, CHECK_U
    SJMP SPEAKER

CHECK_U:
    CJNE    A,#55H, CHECK_Y
    SJMP SPEAKER

CHECK_Y:
    CJNE    A,#59H, DIODA
    SJMP SPEAKER


CONT:
    INC DPTR
    SJMP LOOP3

LOOP2:
    JZ ADD_LETTER
    INC DPTR
    DEC A
    SJMP LOOP2

ADD_LETTER:
    MOVX A, @DPTR
    MOV A, R0
    MOVX @DPTR,A
    INC DPTR
    MOV A, #0
    MOVX @DPTR, A
    INC R1
    MOV R0, #'A'
    LJMP    LOOP


;;;
SPEAKER:
    CLR BUZZER
    MOV A,#10 ;czekaj czas 10*100ms=1s
	LCALL	DELAY_100MS ;podprogram z EPROMu
    SETB BUZZER
    SJMP    CONT
DIODA:
    CLR LED
    MOV A,#10 ;czekaj czas 10*100ms=1s
	LCALL	DELAY_100MS ;podprogram z EPROMu
    SETB LED
    SJMP    CONT


;LITERA:     
 ;   DB   0 , 0 , 14 , 1 , 15 , 17 , 15 , 4            ;ą
 ;   DB   2 , 4 , 14 , 16 , 16 , 17 , 14 , 0           ;ć
 ;   DB   0 , 32 , 14 , 17 , 31 , 16 , 14 , 4          ;ę
 ;   DB   12 , 4 , 6 , 12 , 4 , 4 , 14 , 0             ;ł
 ;   DB   2 , 4 , 22 , 25 , 17 , 17 , 17 , 0           ;ń
  ;  DB   2 , 4 , 14 , 17 , 17 , 17 , 14 , 0           ;ó
 ;   DB   2 , 4 , 15 , 16 , 14 , 1 , 30 , 0            ;ś
 ;   DB   2 , 4 , 31 , 2 , 4 , 8 , 31 , 0              ;ź
;    DB   2 , 4 , 31 , 2 , 4 , 8 , 31 , 0              ;ź


;TEXT:      DB   'AĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ',0