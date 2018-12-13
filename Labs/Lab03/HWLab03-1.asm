bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; a - byte, b - word, c - double word, d - qword - Unsigned representation
    a db 10
    b dw 256
    c dd 310
    d dq 200123131312h
; our code starts here
segment code use32 class=code
    start:
        ; 10) compute (a+d+d)-c+(b+b)  
        xor eax,eax
        xor ebx,ebx
        
        mov al,[a] ; al = a 
        mov ah,0 ; ax = a 
        mov dx,0 ; dx:ax = a 
        mov edx,0 ; edx:eax = a 
        
        add eax,[d] 
        adc edx,[d+4] ; edx:eax = a+d 
        
        add eax,[d]
        adc eax,[d+4] ; edx:eax = a+d+d
        
        mov bx,word [c] 
        mov cx,word [c+2]  ; cx:bx = c dword
        
        mov ecx,0 ; ecx:ebx = c qword
        
        sub eax,ebx 
        sbb edx,ecx ; edx:eax = (a+d+d)-c
        
        mov bx,[b]
        add bx,[b] ; bx = b+b
        
        mov cx,0 ; cx:bx = b+b
        mov ecx,0 ; ecx:ebx = b+b
        
        add eax,ebx
        adc edx,ecx ; edx:eax = (a+d+d)-c+(b+b)
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program


