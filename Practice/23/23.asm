bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        
;A file name and a hexadecimal number (on 16 bits) are given. Create a file with the given name and write each nibble composing the hexadecimal number on a different line to file. 

; declare external functions needed by our program
extern exit,fopen,fclose,fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fclose msvcrt.dll
import fprintf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    fileName db "fis.txt",0 
    format db "%x",10,13,0
    access db "w",0
    number dw 1234h
    fileDescriptor dd -1
    bitMask dd 0000000000001111b
    moves db 12,8,4,0
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
        mov ax,[number]
        mov ecx,4 
        
        nibbles: 
            push ecx 
            
            sub ecx,1 
            mov esi, ecx 
            
            mov cl, [moves+esi]
            
            ;mov ecx,8
            mov ebx,eax
            ;xor eax,eax 
            ;mov eax,ecx 
            
            shr ax,cl 
            xor dx,dx 
            mov dx,ax 
            and dx,[bitMask] 
            
            
            push dword edx
            push dword format 
            push dword [fileDescriptor]
            call [fprintf]
            add esp,4*3
            
           
            pop ecx 
            
            loop nibbles 
        
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
        end_:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
