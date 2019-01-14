bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fclose,fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

;A file name and a text (defined in data segment) are given. The text contains lowercase letters, uppercase letters, digits and special characters. Replace all spaces from the text with character 'S'. Create a file with the given name and write the generated text to file.  

segment data use32 class=data
    givenText db "abcd    efg",0
    len equ $-givenText
    newText times len+1 db 0
    fileName db "fis.txt",0
    access db "w",0
    fileDescriptor dd -1
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
        
        mov ecx, len
        mov esi,givenText
        mov edi,newText
        loop_words: 
            
            lodsb 
            
            cmp al,' '
            jne skip 
            
            mov al,'S'
            
            skip: 
            stosb 
            
            loop loop_words
        
        push dword newText
        push dword [fileDescriptor]
        call [fprintf]
        add esp,4*2
        
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
 ; exit(0)
        end_:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
