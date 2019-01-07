bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fscanf,fclose,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll 
import fscanf msvcrt.dll 
import printf msvcrt.dll  
import fclose msvcrt.dll                       ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    format db "%d",0
    file db "file.txt",0
    descriptor dd -1
    access db "r",0
    a dd 0
    message dd "fk",0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword access 
        push dword file 
        call [fopen]
        add esp,4*2
        
        cmp eax,0 
        je error_ 
        
        mov [descriptor],eax
        
        push dword a
        push dword format 
        push dword [descriptor]
        call [fscanf]
        add esp,4*3
        ; push dword access 
        ; push dword file 
        ; call [fopen]
        ; add esp,4*2
        
        
        
        ; mov [descriptor],eax 
        
        ; push dword [a]
        ; push dword format  
        ; push dword [descriptor] 
        ; call [fscanf]
        ; add esp,4*3
      
        
        push dword [a]
        call [printf]
        add esp,4
        
        push dword [descriptor]
        call [fclose]
        add esp,4
        jmp end_
        
         error_:
        ; push dword message 
        ; call [printf]
        ; add esp,4
        end_: 
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
