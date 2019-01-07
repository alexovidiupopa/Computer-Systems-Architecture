bits 32 ; assembling for the 32 bits architecture
;A text file is given. Read the content of the file, determine the uppercase letter with the highest frequency and display the letter along with its frequency on the screen. The name of text file is defined in the data segment. 

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fread,fclose,printf                ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import fopen msvcrt.dll 
import fread msvcrt.dll 
import fclose msvcrt.dll
import printf msvcrt.dll     ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileName db "fis.txt",0
    accessMode db "r",0
    fileDescriptor dd -1
    sir resb 100
    len equ 100
    appearences times 26 db 0 
    max db 0 
    maxLetter db 0 
    message db "Letter %c appeared %d times",0
    readChars db 0
    aux db 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword accessMode
        push dword fileName 
        call [fopen]
        add esp,4*2
        
        cmp eax,0
        je end_
        
        mov [fileDescriptor],eax
        readLoop: 
            
            push dword [fileDescriptor]
            push dword len 
            push dword 1 
            push dword sir
            call [fread]
            add esp,4*4
            
            cmp eax,0 
            je clean 
            
            mov ecx,eax
            mov esi,sir 
            cld
            characters: 
                lodsb 
                cmp al,'A'
                jl next
                
                cmp al,'Z'
                jg next 
                
                sub al,'A'
                mov [aux],al
                mov esi,[aux]
                add [appearences+esi],byte 1
                
                next:
                loop characters
            loop readLoop
        clean: 
            push dword [fileDescriptor]
            call [fclose]
            add esp,4
            
        mov ecx,26
        mov esi,appearences
        loop_appearences: 
            lodsb 
            cmp al,[max]
            jg next2
            mov [max],al
            add al,'A'
            mov [maxLetter],al
            
            next2:
            loop loop_appearences
        
        push dword message 
        push dword [maxLetter]
        push dword [max] 
        call [printf]
        add esp,4*3
        
        end_:
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
