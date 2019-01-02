    LJMP    START
    ORG 100H
    
START:
    MOV R0,#'A'
LOOP:
    LCALL   LCD_CLR
    
    MOV A,R0
    LCALL   WRITE_DATA
    LCALL   WAIT_KEY

    CJNE    A, #0BH,CHECK_0B
    MOV A,R0
    ADD A,#1
    MOV R0,A
    SJMP    LOOP

CHECK_0B:
    CJNE    A, #0AH,CHECK_0B
    MOV A,R0
    SUBB A,#1
    MOV R0,A
    SJMP    LOOP






