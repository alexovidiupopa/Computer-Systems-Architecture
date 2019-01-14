bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
;Read two numbers a and b (in base 10) from the keyboard and determine the order relation between them (either a < b, or a = b, or a > b). Display the result in the following format: "<a> < <b>, <a> = <b> or <a> > <b>". 
; declare external functions needed by our program
extern exit,scanf,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    printLess db "%d<%d",0
    printGreater db "%d>%d",0
    printEqual db "%d=%d",0
    readFormatA db "%d",0
    readFormatB db "%d",0
    a dd 0
    b dd 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword a
        push dword readFormatA
        call [scanf]
        add esp,4*2
        
        push dword b
        push dword readFormatB
        call [scanf]
        add esp,4*2
        
        mov eax,[a]
        cmp eax,[b]
        jl less 
        jg greater
        je equal
        
        less:
        
        push dword [b]
        push dword [a]
        push dword printLess
        call [printf]
        add esp,4*3
        jmp end_
        greater: 
        
        push dword [b]
        push dword [a]
        push dword printGreater 
        call [printf]
        add esp,4*3
        jmp end_
        equal: 
        
        push dword [b]
        push dword [a]
        push dword printEqual
        call [printf]
        add esp,4*3
        
        end_:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
