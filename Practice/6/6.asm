bits 32 ; assembling for the 32 bits architecture
;A text file is given. Read the content of the file, determine the digit with the highest frequency and display the digit along with its frequency on the screen. The name of text file is defined in the data segment. 
; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,printf,fread,fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileName db "fis.txt",0
    access db "r",0
    fileDescriptor dd -1
    max equ 100
    content times max+1 db 0
    freq times 10 db 0
    pFormat db "%d  %c",0
    max2 dd 0
    letter dd 0
    aux dd 0
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
        
        
        loop_read: 
            
            push dword [fileDescriptor]
            push dword max 
            push dword 1 
            push dword content 
            call [fread]
            add esp,4*4
            
            cmp eax,0 
            je out_
            
            mov ecx,eax 
            mov esi,content
            cld 
            loop_content: 
                
                xor eax,eax
                lodsb 
                
                cmp al,'0'
                jl skip_ 
                
                cmp al,'9'
                jg skip_ 
                
                sub al, '0'
                
                mov edi,eax
                
                add [freq+edi],byte 1
                
                skip_:
                loop loop_content
            jmp loop_read
        out_:
        mov ecx, 10
        mov edi, 0 
        
        loop_print: 
            xor eax,eax
             
            
            mov al,[freq+edi] 
            
            cmp eax,[max2]
            jl skip2_
            
            mov [max2],eax
            
            mov [aux],edi 
            mov eax,[aux]
            add eax,'0'
            
            mov [letter],eax
            
            skip2_:
            
            inc edi
            loop loop_print
            
            
        push dword [letter]
        push dword [max2]
        push dword pFormat
        call [printf]
        add esp,4*3
        
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
        end_:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
