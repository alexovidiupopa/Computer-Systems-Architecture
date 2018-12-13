bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; DECLARATIONS ADDITION-BYTE 21
    ; a db 15
    ; b db 3
    ; c db 6
    ; d db 3
    
    ;DECLARATIONS ADDITION-WORD 21
    ; a dw 15
    ; b dw 3
    ; c dw 6
    ; d dw 3
    
    ;DECLARATIONS MULTIPLICATION- BYTE 21
    ; a db 5
    ; b db 6
    ; c db 3
    ; d dw 10
    
    ;DECLARATIONS MULTIPLICATION- BYTE + WORD 21
    a db 0
    b db 2
    c db 3
    d db 6
    e dw 5
    f dw 8
    g dw 13
    h dw 6

; our code starts here
segment code use32 class=code
    start:
        xor eax,eax
        xor ebx,ebx
        xor ecx,ecx
        xor edx,edx
        ; Calculate 15/3-no declarations required
        ; mov AX, 15
        ; mov DL, 3
        ; div DL
        
        ;Calculate (a-b)+(d-c) on bytes (21). For a = 15, b = 3, c = 6 , d = 3 => expression result is 9, stored in AL register. Declarations above.
        ; mov AL,[a]
        ; sub AL, [b]
        ; mov AH, [d]
        ; sub AH, [c]
        ; add AL,AH
        
        ;Calculate a-c+d-7+b-(2+d) on words (21) . For a = 15, b = 3, c = 6 , d = 3 => expression result is 3, stored in the AX register. Declarations above.
        ; mov AX,[a]
        ; sub AX,[c]
        ; add AX,[d]
        ; sub AX, 7
        ; add AX,[b]
        ; mov BX, 2
        ; add BX, [d]
        ; sub AX,BX
        
        ;Calculate d-[3*(a+b+2)-5*(c+2)]. For a = 5 , b = 6 , c = 3 bytes , d = 10 word => expression result is -4, stored in the BX register. Declarations above.
        ; mov BX,[d]
        ; mov AL,[a]
        ; add AL,[b]
        ; add AL, 2
        ; mov AH, 3
        ; mul AH 
        ; mov CX,AX
        ; mov AL,[c]
        ; add AL, 2
        ; mov AH,5
        ; mul AH
        ; sub CX,AX
        ; sub BX, CX
        
        ;Calculate (f*g-a*b*e)/(h+c*d). For a = 0, b = 2 , c = 3 , d = 6 bytes , e = 5 , f = 4 , g = 8 , h = 7 words => expression result is 4 stored in AX with remainder 8 stored in DX. Declarations above.
        mov ax,[f]
        mul word [g]
        mov bx,ax
        mov al,[a]
        mul byte [b]
        mul word [e]
        sub bx,ax
        mov al,[c]
        mul byte [d]
        add ax,[h]
        mov cx,ax
        mov ax,bx
        div word cx
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
