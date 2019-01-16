TEXT    EQU 10H ;rezerwacja pamieci
LED     EQU P1.7
BUZZER  EQU P1.5

    LJMP    START
    ORG 100H
    
START:
    MOV DPTR, #TEXT ;poczatkowa wartosc ciagu
    MOV A, #0       ;przypisanie zera
    MOVX @DPTR, A
    MOV R1,#0 ;R1-dlugosc tekstu

    MOV R0, #'A' ;przechowuje litere 
LOOP:
    MOV A, R1
    CJNE    A, #32,NEXT ;jeżeli długosc 32 zakoncz wczytywanie
    SJMP END
NEXT:
    LCALL   LCD_CLR
    MOV DPTR, #TEXT
    MOVX A,@DPTR
    LCALL   WRITE_TEXT  ;wyswietla aktualnie wpisany tekst
    MOV A, R0   ;wczytanie litery z menu
    LCALL   WRITE_DATA  ;wyświetlenie kolejne litery
    LCALL   WAIT_KEY

    CJNE    A, #0AH,CHECK_0B ;jeżeli wcisnieto A
    CJNE    R0, #41H,PREV_LETTER ;jezeli litera z menu A przejdz dalej
    MOV R0,#5AH ; litera menu Z
    SJMP    LOOP
PREV_LETTER:
    MOV A, R0   ;zmiana litery na poprzednia
    SUBB A,#1
    MOV R0, A
    SJMP    LOOP

CHECK_0B:
    CJNE    A, #0BH,CHECK_0F ;jezeli wcisnieto B
    CJNE    R0, #5AH,NEXT_LETTER ; jżeli litera z menu Z
    MOV R0,#41H ; litera z menu A
    SJMP    LOOP
NEXT_LETTER:
    MOV A, R0   ;zmiana litery na nastepna
    ADD A,#1
    MOV R0, A
    SJMP    LOOP
    
CHECK_0F:
    CJNE    A, #0FH,CHECK_OE ;jeżeli wciesnieto F
    MOV DPTR, #TEXT 
    MOV A, R1   ;wczytaj dlugosc tekstu
    SJMP LOOP2

CHECK_OE:
    CJNE    A, #0EH,LOOP    ;jeżeli wcisnieto E
END:
    MOV DPTR, #TEXT
    
    LCALL   LCD_CLR
    

LOOP3:
    MOVX A,@DPTR
    JZ  START   ;Jezeli zakonczono sprawdzanie przejdz na poczatek
   
    
    LCALL   WRITE_DATA ;Wyswietl litere
    MOV A,#10 ;czekaj czas 10*100ms=1s
	LCALL	DELAY_100MS ;podprogram z EPROMu
    MOVX A, @DPTR
CHECK_A:                        ;Sprawdzanie liter
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
    INC DPTR    ;zwieksz wskaznik
    SJMP LOOP3

LOOP2:
    JZ ADD_LETTER   ;Jezeli A 0 skocz do ADD_LETTER
    INC DPTR    ;Zwiększ wskaźni na tekst
    DEC A   ;Zmniejsz A o 1
    SJMP LOOP2

ADD_LETTER:
    MOV A, R0 ;Dodaj do ciagu kolejna litere
    MOVX @DPTR,A
    INC DPTR    
    MOV A, #0   ;przypisz 0 na koncu ciagu
    MOVX @DPTR, A
    INC R1  ;zwieksz dlugosc ciagu o 1
    MOV R0, #'A'    ;ustaw litere menu na A
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
