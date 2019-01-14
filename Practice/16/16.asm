bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fread,printf,fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
;A text file is given. Read the content of the file, count the number of letters 'y' and 'z' and display the values on the screen. The file name is defined in the data segment. 
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileName db "fis.txt",0
    access db "r",0
    max equ 100 
    content times max+1 db 0
    noY dd 0
    noZ dd 0
    pFormat db "No of Y:%d and of Z:%d",0
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
        
           loop_content: 
                push dword [fileDescriptor]
                push dword max 
                push dword 1 
                push dword content 
                call [fread]
                add esp,4*4 
                
                cmp eax,0 
                je stop_read
                
                mov ecx,eax 
                mov esi,content
                cld                 
                read_content: 
                    lodsb 
                    
                    cmp al,'y'
                    je incY 
                    cmp al,'z'
                    je incZ 
                    
                    loop read_content
                    incY: 
                        add [noY],byte 1
                        loop read_content
                    incZ: 
                        add [noZ],byte 1
                        loop read_content
                    
                jmp loop_content
        stop_read: 
        push dword [noZ]
        push dword [noY] 
        push dword pFormat
        call [printf] 
        add esp,4*3
        
        ;push dword [fileDescriptor]
        ;call [fclose]
        ;add esp,4
        end_:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
