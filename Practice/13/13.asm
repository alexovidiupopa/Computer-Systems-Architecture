bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
;A file name and a text (defined in the data segment) are given. The text contains lowercase letters, uppercase letters, digits and special characters. Transform all the lowercase letters from the given text in uppercase. Create a file with the given name and write the generated text to file. 
; declare external functions needed by our program
extern exit,fopen,fclose,fprintf,fwrite              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fclose msvcrt.dll
import fprintf msvcrt.dll
import fwrite msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    fileName db "fis.txt",0
    text db "abcd"
    len equ $-text
    access db "w",0
    fileDescriptor dd -1
    newText times len+1 db 0
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
        
        mov ecx,len 
        mov esi,text 
        mov edi,newText 
        loop_: 
            lodsb 
            
            cmp al,'a' 
            jl next_ 
            
            cmp al,'z'
            jg next_ 
            
            add al,'A'-'a'
            next_: 
            
            stosb 
            
            loop loop_
            
            
        push dword newText 
        push dword [fileDescriptor]
        call [fprintf]
        add esp,4*2 
        
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
        end_:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
