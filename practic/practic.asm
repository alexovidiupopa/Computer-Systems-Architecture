;Se citeste de la tastatura un nume de fisier care contine propoz (termina cu .)
;Afisati ultimul cuv din fiecare propoz in consola, cuvantul fiind afisat invers.

bits 32 

global start        

extern exit,scanf,printf,fclose,fopen,fread               
import exit msvcrt.dll 
import scanf msvcrt.dll 
import printf msvcrt.dll 
import fopen msvcrt.dll 
import fclose msvcrt.dll 
import fread msvcrt.dll 

segment data use32 class=data
    fileName times 20 db 0
    formatReadKeyboard db "%s",0
    fileDescriptor dd -1
    accessMode db "r",0
    max equ 100
    text times 100 db 0
    numberOfChars dd 0
    result times 100 db 0
    format db "%d ",0
    wordMax times 20 db 0
    printFormat db "%s  ",0
    endLine db 10,13,0
segment code use32 class=code
    start:
        ; read the file name from keyboard 
        push dword fileName 
        push dword formatReadKeyboard 
        call [scanf]
        add esp,4*2 
        
        ; open the file
        push dword accessMode
        push dword fileName 
        call [fopen]
        add esp,4*2 
        
        ;check if file opened correctly, if not jump to end_ 
        cmp eax,0 
        je end_
        
        mov [fileDescriptor],eax 
        
        read: 
            
        ;read the text. it has maximum 100 elements, so no loop validation required.
        push dword [fileDescriptor]
        push dword max 
        push dword 1 
        push dword text 
        call [fread]
        add esp,4*4 
        
       
        mov [numberOfChars],eax 
        
        ; save the necessary registers
        mov ecx,[numberOfChars]
        mov esi,text
        mov edi,wordMax
        cld
        loop_sentence: 
            push ecx
            lodsb  ; al = current byte
            
            ; see if current byte is '.'. if yes,go to point
            cmp al,'.'
            je point
            
            ; see if current byte is ' '. if yes,skip
            cmp al,' '
            je skip 
           
            ; else store the letter and jump to the next 
            
            stosb
            jmp next
                
            point: 
                ; print the last word
              
                push dword wordMax 
                push dword printFormat
                call [printf]
                add esp,4 
                
                jmp next
                
            skip: 
                ;re-initialize the temporary word 
                mov edi, wordMax 
                mov ecx, 20 
                reinit: 
                    mov al,0 
                    stosb 
                    loop reinit 
                mov edi,wordMax
                
            next: 
            
            pop ecx 
            loop loop_sentence
            
        
        ;just checked if the sentence was read correctly 
        ; push dword text  
        ; call [printf]
        ; add esp,4
        
        
        ; close the file 
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
        
        end_:
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
