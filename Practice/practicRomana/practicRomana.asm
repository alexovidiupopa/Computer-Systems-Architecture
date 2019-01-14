bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,printf,fclose,fread               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll                        ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fclose msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    
    fileName db "fisier.txt",0
    accessMode db "r",0
    fileDescriptor dd -1
    max equ 100 
    message times max+1 db 0
    decodedMessage times max+1 db 0
    format db "%c",0
    letter dd 0
    len dd 0
    stop dd '.'
    format_p db "%c",0
    int_format db "%d",0
    a dd 'a'
    b dd 'b'
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
        
        read_:
            
            push dword [fileDescriptor]
            push dword 1 
            push dword 1 
            push dword letter
            call [fread] 
            add esp,4*4 
            
            cmp eax,0 
            je out_
            
            xor eax,eax 
            mov eax,[letter]
            
            cmp eax,'a' 
            jl skip 
            
            cmp eax,'z'
            jg skip 
            
            cmp eax,'y'
            je Y 
            cmp eax,'z'
            je Z
            
            sub eax,byte 2
          
            
            jmp print
            
            Y: 
                mov eax,'a'
                jmp print 
                
            Z: 
                mov eax,'b'
                jmp print 
                
            skip:
            print: 
            push dword eax 
            push dword format_p 
            call [printf]
            add esp,4*2 
            
            
            jmp read_ 
        out_:
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
        end_:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
