bits 32 ; assembling for the 32 bits architecture
;A text file is given. Read the content of the file, count the number of vowels and display the result on the screen. The name of text file is defined in the data segment. 
; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,printf,fread,fclose,fscanf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fread msvcrt.dll
import printf msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    vowels dd 0
    fileName db "fis.txt",0
    access db "r",0
    fileDescriptor dd -1
    max equ 100
    pFormat db "%d",0
    rFormat db "%c",0
    content times max+1 db 0
    len db 0
    stop dd '.'
    character dd 0
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
        
        push dword [fileDescriptor]
        push dword 100 
        push dword 1
        push dword content 
        call [fread]
        add esp,4*4 
        
        mov ecx,eax 
        mov esi,content 
        
        loop_: 
            lodsb 
            
            cmp al, 'a'
            je increase 
            cmp al, 'e'
            je increase 
            cmp al, 'i'
            je increase 
            cmp al, 'o'
            je increase 
            cmp al, 'u'
            jmp next
            increase: 
            add [vowels],byte 1
            next:
            loop loop_
            
        push dword [vowels] 
        push dword pFormat
        call [printf]
        add esp,4*2
        
end_:
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
