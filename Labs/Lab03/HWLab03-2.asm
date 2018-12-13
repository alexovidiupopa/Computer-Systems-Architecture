bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;a - byte, b - word, c - double word, d - qword - Signed representation
    a db 13
    b dw 270
    c dd 400
    d dq 800
; our code starts here
segment code use32 class=code
    start:
        ; 10) compute b+c+d+a-(d+c)
        mov ax,[b] ; ax = b
        cwd ;dx:ax = b
        
        mov bx, word [c]
        mov cx, word [c+2] ; dx:ax = c 
        
        add ax,bx
        adc dx,cx ; dx:ax = b + c 
        
        cdq ; edx:eax = b + c 
        
        add eax,[d]
        adc edx,[d+4] ; edx:eax = b + c + d

        mov ebx,eax
        mov ecx,edx
        
        mov al,[a]
        cbw ; ax = a
        cwd ; dx:ax = a
        cdq ; edx:eax = a 
        
        add ebx,eax
        adc ecx,edx ; ecx:ebx = b+c+d+a
        
        mov ax,word [c]
        mov dx, word[c+2] ; dx:ax = c
        cdq ;edx:eax = c
        
        add eax,[d]
        adc edx,[d+4] ; edx:eax = d+c 
        
        sub ebx,eax
        sbb ecx,edx ; ebx:ecx = (b+c+d+a)-(d+c)
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
