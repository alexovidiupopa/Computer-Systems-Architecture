bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; a - byte; b-word; d-doubleword; x-qword - signed
    a db 5
    b dw 100
    c db 7
    d dd 2134
    x dq 14614

; our code starts here
segment code use32 class=code
    start:
        ; d-(7-a*b+c)/a-6+x/2;
        xor eax,eax 
        xor ebx,ebx
        xor ecx,ecx 
        xor edx,edx
        mov bx,word [d]
        mov cx,word [d+2] ; cx:bx = d
        
        mov al,[a] ; al = a 
        imul word [b] ; ax = a * b
        
        mov dx, 7
        sub dx,ax ;dx = 7-a*b
        
        mov al,[c]
        cbw ; ax = c

        add dx,ax ;dx = 7-a*b+c
        
        mov ax,dx ; ax = 7-a*b+c
        idiv byte [a] ; al = (7-a*b+c)/a
        
        cbw ; ax = (7-a*b+c)/a
        cwd ; dx:ax = (7-a*b+c)/a
        
        sub bx,ax 
        sbb cx,dx ; cx:bx = d-(7-a*b+c)/a
        
        mov al,6
        cbw
        cwd ;dx:ax=6
        
        sub bx,ax
        sbb cx,dx ; cx:bx = d-(7-a*b+c)/a
        
        mov eax,[x]
        mov edx,[x+4] ;edx:eax = x 
        
        mov SI,2
        idiv SI ; eax = dx:ax = x/2
        
        add ax,bx
        adc dx,cx ; dx:ax = d-(7-a*b+c)/a-6+x/2
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
