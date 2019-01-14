bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf,printf,fprintf,fopen,fclose              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import scanf msvcrt.dll 
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fprintf msvcrt.dll                         ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    fileName db "fis.txt",0
    fileDescriptor dd -1
    access db "w",0
    max equ 100
    numbers times max dd 0
    len dd 0
    numberOfOnes db 0
    intFormat db "%d ",0
    hexFormat db "%x ",0
    number dd 0
    stop dd -1
    aux dd 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx,max
        xor ebx,ebx 
        mov edi,numbers
        read_nums: 
            push ecx 
            push ebx 
            
            push dword number
            push dword intFormat 
            call [scanf]
            add esp,4*2
            
            mov eax,[number]
            cmp eax,[stop]
            je stop_read
            
            stosd 
            pop ebx
            inc ebx 
            pop ecx
            loop read_nums
            
        stop_read:
            mov dword [len],ebx
            
        push dword access
        push dword fileName
        call [fopen]
        add esp,4*2
        
        cmp eax, 0
        je end_
        
        mov [fileDescriptor],eax
        
        mov ecx,[len]
        mov esi,numbers 
        
        print_num:
            push ecx 
            
            lodsd 
            
            mov [aux],eax 
            
            
            push dword [aux]
            push dword intFormat 
            push dword [fileDescriptor]
            call [fprintf]
            add esp,4*3 
            
            push dword [aux]
            push dword hexFormat 
            push dword [fileDescriptor]
            call [fprintf]
            add esp,4*3 
            
            mov eax,[aux]
            xor ecx,ecx 
            loop_digits: 
                cmp eax,0
                je out_
                shr eax,1
                jnc skip
                inc ecx 
                skip:
                jmp loop_digits
            out_:
            push dword ecx
            push dword intFormat 
            push dword [fileDescriptor]
            call [fprintf]
            add esp,4*3 
            
            pop ecx 
            
            loop print_num
        ; exit(0)
        
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
        end_:
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
