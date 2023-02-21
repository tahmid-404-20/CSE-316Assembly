.MODEL SMALL
.STACK 100H

.DATA
N DW ?
CR EQU 0DH
LF EQU 0AH

.CODE

MAIN PROC
    
    MOV AX,@DATA
    MOV DS,AX    
    
    XOR BX,BX
    
    
    
INPUT_LOOP:
    MOV AH,1
    INT 21H
    
    CMP AL,CR
    JE INPUT_END
    CMP AL,LF
    JE INPUT_END
    
    ;TEST WHETHER INPUT IS 0,1,2
    CMP AL,'0'
    JL INPUT_LOOP
    CMP AL,'2'
    JG INPUT_LOOP
    
    AND AX,000FH
    MOV CX,AX
    
    MOV AX,3
    MUL BX
    ADD AX,CX
    MOV BX,AX
    JMP INPUT_LOOP    

INPUT_END:
    
    MOV N,BX
    
    MOV BX, 0001H

    MOV CX,16
    MOV AH,2
    
    ;NEW LINE
    MOV DL,0DH
    INT 21H   
    MOV DL,0AH
    INT 21H    
PRINT_BIN:
    TEST N,BX
    JZ OUT_ZERO
    ; GOT 1
    MOV DL,'1'
    INT 21H
    JMP LOOP_TEST
    
   OUT_ZERO:
     MOV DL,'0'
     INT 21H
    
    LOOP_TEST:
        SHL BX,1
        LOOP PRINT_BIN
    
    
    MOV AH,4CH
    INT 21H        

    
MAIN ENDP
END MAIN