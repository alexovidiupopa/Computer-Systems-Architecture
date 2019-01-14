bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
;Read two doublewords a and b in base 16 from the keyboard. Display the sum of the low parts of the two numbers and the difference between the high parts of the two numbers in base 16 Example:
;a = 00101A35h
;b = 00023219h
;sum = 4C4Eh
;difference = Eh
; declare external functions needed by our program
extern exit,scanf,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll 
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    sumPrint db "sum=%xh",10,13,0
    difPrint db "dif=%xh",0
    sum dw 0 
    dif dw 0 
    a dd 0 
    b dd 0
    readFormat db "%x",0
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword a 
        push dword readFormat
        call [scanf]
        add esp,4*2
        
        push dword b 
        push dword readFormat
        call [scanf]
        add esp,4*2
        
        xor eax,eax 
        mov ax,word [a]
        add ax,word [b]
        
        push dword eax 
        push dword sumPrint 
        call [printf]
        add esp,4*2
        
        xor eax,eax 
        mov ax,word [a+2]
        sub ax,word [b+2]
        
        push dword eax 
        push dword difPrint 
        call [printf]
        add esp,4*2
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
