bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
;Read numbers (in base 10) in a loop until the digit '0' is read from the keyboard. Determine and display the smallest number from those that have been read. 
; declare external functions needed by our program
extern exit,scanf,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    number dd 0 
    minim dd 12345h 
    format db "%d",0
    stop dd 0
; our code starts here
segment code use32 class=code
    start:
        read: 
            push dword number 
            push dword format 
            call [scanf]
            add esp,4*2
    
            mov eax,[number]
            cmp eax,[stop]
            je stop_read
            
            cmp eax,[minim]
            jge skip_
            
            mov [minim],eax 
            
            skip_: 
            jmp read 
            
        stop_read: 
        
        push dword [minim]
        push dword format 
        call [printf]
        add esp,4*2 
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
