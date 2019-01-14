bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,scanf,fprintf,fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll                  ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    fileName db "fis.txt",0
    access db "w",0
    readFormat db "%d",0
    stop dd 0
    number dd 0
    max equ 100
    printFormat db "%d ",0
    fileDescriptor dd -1
    seven dw 7
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
        mov ecx,max 
        
        read_nums: 
            push ecx 
            
            push dword number
            push dword readFormat
            call [scanf]
            add esp,4*2
            
            mov eax,[number]
            cmp eax,[stop]
            je stop_read
            
            push eax 
            pop ax 
            pop dx
            
            div word [seven]
            
            cmp dx,0
            jnz skip 
            
            push dword [number] 
            push dword printFormat
            push dword [fileDescriptor]
            call [fprintf]
            add esp,4*3
            
            skip:
            pop ecx
            loop read_nums
        
        stop_read:
        end_:
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
