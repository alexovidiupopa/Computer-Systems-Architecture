bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
;A text file is given. The text contains letters, spaces and points. Read the content of the file, determine the number of words and display the result on the screen. (A word is a sequence of characters separated by space or point) 
; declare external functions needed by our program
extern exit,fopen,fread,fclose,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fread msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileName db "fis.txt",0
    access db "r",0
    fileDescriptor dd -1
    numberW dd 0
    okW db 0 
    okSpecial db 0
    len db 0 
    char dd 0
    format db "%d",0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword access
        push dword fileName
        call [fopen]
        add esp,4*2 
        
        cmp eax,0 
        je end_ 
        
        mov [fileDescriptor],eax 
        
        read: 
            push dword [fileDescriptor]
            push dword 1 
            push dword 1 
            push dword char 
            call [fread]
            add esp,4*4 
            
            cmp eax,0 
            je out_ 
            
            mov eax,[char]
            
            cmp eax,'.'
            je special 
            cmp eax,' '
            je special 
            
            mov [okW],byte 1
            mov [okSpecial],byte 0
            jmp skip
            
            special: 
            mov [okW],byte 0
            
            cmp [okSpecial],byte 1
            je skip
            
            mov [okSpecial],byte 1
            
            add [numberW],byte 1
            
            skip:
            jmp read 
        out_:
        
        push dword [numberW]
        push dword format 
        call [printf]
        add esp,4*2
        
        
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
        end_:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
