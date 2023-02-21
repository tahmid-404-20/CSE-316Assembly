.MODEL SMALL
.STACK 100H

.DATA
ARRAY_END DB ?
ARR1 DW 15 DUP(?)
ARR2 DW 15 DUP(?)
ARR3 DW 15 DUP(?)
LEN_ARR1 DW 0
LEN_ARR2 DW 0
LEN_ASCEND DW 1
LEN_TEMP DW 1
PREV DW ?

.CODE
MAIN PROC

    MOV AX, @DATA
    MOV DS, AX
    
    ; ARR1 INPUT    
    XOR SI,SI
    MOV ARRAY_END,0
  ARR1_INP:   
    CALL INP_SIGNED_ARRAY
    MOV ARR1[SI] , BX
    ADD SI,2
    INC LEN_ARR1
    CMP ARRAY_END, 0
    JE ARR1_INP
    
    
    ; COMPUTING
    
    MOV CX, LEN_ARR1
    XOR SI, SI
    MOV BX, ARR1[SI]
    MOV PREV, BX
    ADD SI,2    
    DEC CX    
    
    
   COM_LOOP:
    MOV BX, PREV
    CMP BX, ARR1[SI] ; PREV < A[I]
    JG ELSE
    INC LEN_TEMP
    
    MOV BX, LEN_TEMP
    CMP BX, LEN_ASCEND ; TEMP > ASCEND
    JL GET_READY
    MOV BX, LEN_TEMP
    MOV LEN_ASCEND, BX
    JMP GET_READY
    
    
   ELSE:
    MOV LEN_TEMP,1
    MOV ES, LEN_TEMP
    
   GET_READY:
    MOV BX, ARR1[SI]
    MOV PREV, BX
    ADD SI,2   
    
    LOOP COM_LOOP
    
    
    
    MOV AH,2
    ;NEW LINE
    MOV DL,0DH
    INT 21H   
    MOV DL,0AH
    INT 21H
    
    MOV BX, LEN_ASCEND
    CALL PRINT
    
    
    MOV AH, 4CH
    INT 21H

   
MAIN ENDP


; prints the number in bx, treats the msb as the sign bit
PRINT PROC
   PUSH AX
   PUSH BX   
   PUSH CX
   PUSH DX
   
   ; check if the number is zero
   CMP BX, 0
   JNE SHOW_NUMBER
   
   MOV DL, '0'
   MOV AH,2   
   INT 21H
   JMP GET_BACK_PRINT  
   
      
SHOW_NUMBER:
   MOV AX,BX
   MOV BX,10
   XOR DX,DX
   XOR CX,CX
   
   TEST AX, 8000H
   JZ GET_NUM
   
   ;the number is negative, 2's complement
   PUSH AX
   MOV AH, 2
   MOV DL, '-'
   INT 21H
   
   XOR DX,DX
   POP AX   
   NEG AX   
   
;ax = n, bx = 10   
GET_NUM:
   DIV BX
   PUSH DX
   INC CX
   
   XOR DX,DX ;avoid divide overflow
   CMP AX, 0    
   JNZ GET_NUM
   
   
   MOV AH, 2
PRINT_LOOP:
   POP DX
   ADD DL,'0'
   INT 21H
   LOOP PRINT_LOOP
   

GET_BACK_PRINT:
   POP DX
   POP CX
   POP BX
   POP AX    
   RET

PRINT ENDP


; signed input, give a minus - sign in front for negative number, and start number directly for positive, get number in bx
INP_SIGNED_ARRAY PROC
   PUSH AX   
   PUSH CX
   PUSH DX
   
   XOR BX,BX
   
   
   MOV AH,1
   INT 21H   
   CMP AL,'-'
   JE NEG_NUM_INPUT   
   
   CMP AL,' '
   JE INPUT_END
   ; IF YOU WANT TO SEPERATE USING ENTER   
   CMP AL,0DH
   JE INPUT_END_ARRAY
   CMP AL,0AH
   JE INPUT_END_ARRAY
   
   
POS_NUM_INP:  ;if pos input, then need to consider the very first digit
    MOV DX, 0 ; flag indicating positive number
    PUSH DX
    
    AND AX,000FH
    MOV CX,AX
    
    MOV AX,10
    MUL BX
    ADD AX,CX
    MOV BX,AX
    JMP INPUT_LOOP
    
NEG_NUM_INPUT:
    MOV DX, 1 ;flag indicating negative number
    PUSH DX 
    
    
INPUT_LOOP:
    MOV AH,1
    INT 21H
    
    CMP AL,' '
    JE INPUT_END
    CMP AL,0DH
    JE INPUT_END_ARRAY
    CMP AL,0AH
    JE INPUT_END_ARRAY
    
    AND AX,000FH
    MOV CX,AX
    
    MOV AX,10
    MUL BX
    ADD AX,CX
    MOV BX,AX
    JMP INPUT_LOOP

    
    JMP INPUT_END
    
INPUT_END_ARRAY:
    MOV ARRAY_END, 1    


INPUT_END:
    
    POP DX
    CMP DX,1
    JNE INPUT_RET
    NEG BX  
   
   
INPUT_RET:   
   POP DX
   POP CX
   POP AX    
   RET 
    
INP_SIGNED_ARRAY ENDP


END MAIN