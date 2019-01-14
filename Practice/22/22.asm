bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
;A file name and a decimal number (on 16 bits) are given (the decimal number is in the unsigned interpretation). Create a file with the given name and write each digit composing the number on a different line to file. 
; declare external functions needed by our program
extern exit,fopen,fprintf,fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import fopen msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fprintf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileName db "fis.txt",0
    access db "w",0
    number dd 1234
    printFormat db "%d",10,13,0
    fileDescriptor dd -1
; our code starts here
segment code use32 class=code
    start:
        push dword access
        push dword fileName 
        call [fopen]
        add esp,4*2
    
        cmp eax,0 
        je end_ 
        
        mov [fileDescriptor],eax
        
        
        mov eax,[number]
        mov bx, word 10
        
        loop_:
            xor edx,edx
            
            div bx
            
            cmp ax,0 
            jnz skip
            
            cmp dx,0
            je out_ 
            skip: 
            pushad 
            
            push dword edx 
            push dword printFormat 
            push dword [fileDescriptor]
            call [fprintf]
            add esp,4*3 
            
            popad 

            mov dx,0 
            push dx 
            push ax 
            pop eax 
            
            jmp loop_
        out_:
        
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
        end_:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
