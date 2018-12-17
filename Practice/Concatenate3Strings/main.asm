bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf
extern concatenate               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd "abcd"
    len_a equ $-a
    b dd "efgh"
    len_b equ $-b 
    c dd "ijkl",0
    len_c equ $-c 
    x times len_a+len_b+len_c+1 dd 0

; our code starts here
segment code use32 class=code
    start:
        push dword a 
        push dword len_a 
        push dword b
        push dword len_b 
        push dword c
        push dword len_c 
        push dword x 
        call concatenate 
        add esp,4*7
        
        push dword x 
        call [printf] 
        add esp,4
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
