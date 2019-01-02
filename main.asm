    LJMP START
    ORG 100H
START:
    MOV R0,#LCDWC ;dane do LCD
    MOV R1,#LCDRC ;stan LCD
    MOV A,#48H ;ustaw adres generatora
    LCALL WRITE ;znaków dla znaku 1
    INC R0 ;
    MOV DPTR,#LITERA ;ładowanie tablicy "ś"
    MOV R3,#8 ;długość t. LITERA
    CLR F0

LOOP:
    CLR A
    MOVC A,@A+DPTR
    LCALL WRITE ;wysyła t. LITERA
    INC DPTR ;
    DJNZ R3,LOOP
    DEC R0 ;adres wpisu instrukcji

    MOV A,#1 ;kasuj dane wyświetlacza
    ACALL WRITE
    MOV A,#0FH ;włącz wyświetlacz
    ACALL WRITE ;i mruganie kursora
    INC R0 ;

    MOV DPTR,#TEXT1 ;początek TEXT1

WRITE_TXT:
    CLR A
    MOVC A,@A+DPTR ;element TEXT
    JZ LOOP1 ;wskaźnik końca tablicy
    LCALL WRITE ;wpis na wyświetlacz
    INC DPTR ;zwiększenie adresu
    SJMP WRITE_TXT ;wykonuj do końca tablicy
LOOP1:
    LCALL WAIT_ENT_ESC ;czekaj na ENTER lub ESC
    JC LOOP1 ;jesli C=0 to jest enter i program idzie dalej, jesli C=1 to ESC i wraca to oczekiwania na klawisz
    LCALL LCD_CLR ;czysc wyswietlacz
    CPL F0
    JB F0,RAZ
    MOV DPTR,#TEXT1
    SJMP WRITE_TXT
RAZ:
    MOV DPTR,#TEXT2
    SJMP WRITE_TXT


;**************************************
;Podprogram wpisu danych lub instrukcji
;na wyświetlacz LCD
;Zakłada prawidłowe adresy w R0 i R1
WRITE:
    MOV R2,A ;kopia ACC
BUSY:
    MOVX A,@R1 ;czyta LCDRC
    JB ACC.7,BUSY
    MOV A,R2
    MOVX @R0,A ;wysyła do LCDWC
    RET
;**************************************
;Tabela bajtów definiujących literę 'ś'
LITERA:
    DB 00000010B
    DB 00000100B
    DB 00001110B
    DB 00010000B
    DB 00001110B
    DB 00000001B
    DB 00011110B
    DB 00000000B
;**************************************
TEXT1:
    DB 'imie i nazwisko '
    DB 'MI',1,' USZATEK ',0
TEXT2:
    DB 'MI',1,' USZATEK '
    DB 'imie i nazwisko ',0 