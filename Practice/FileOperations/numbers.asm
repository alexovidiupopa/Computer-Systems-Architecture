bits 32 ; assembling for the 32 bits architecture

global start        

extern exit,scanf,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll 
import printf msvcrt.dll
import scanf msvcrt.dll   ; exit is a function that ends the calling process. It is defined in msvcrt.dll
;in this file I will read/print a number/more numbers from the keyboard
segment data use32 class=data
    a db 0
    integers times 100 dd 0
    format db "%d",0
    len db 0
    mes1 db "a=",0
    mes2 db "The number you read is:%d",10,13,0
    mesLen db "Length:%d",0
    mesPrint db "   %d",0
segment code use32 class=code
    start:
        push dword mes1 
        call [printf]
        add esp,4
    
        push dword a 
        push dword format 
        call [scanf]
        add esp,4*2
        
        push dword [a]
        push dword mes2
        call [printf]
        add esp,4*2
        
        
        
        ; read numbers until -1 is entered
        mov ecx,100
        cld 
        mov ebx,0
        read_numbers:
            push ecx 
            push dword mes1 
            call [printf]
            add esp,4
            
            push dword a
            push dword format 
            call [scanf]
            add esp,4*2
            
            mov eax,[a]
            cmp eax,-1
            je stop_reading
            
            mov dword [integers+4*ebx],eax   ; store the integer 
            
            inc ebx 
            pop ecx 
            loop read_numbers
        
        stop_reading:
            mov dword [len],ebx
            
        push dword [len] 
        push dword mesLen
        call [printf]
        add esp,4*2
        
        ; print the list of numbers
        mov ecx,[len]
        mov esi,integers  
        
        print_nums:
            push ecx
            lodsd
            push dword eax 
            push dword mesPrint
            call [printf]
            add esp,4*2 
            pop ecx
            loop print_nums
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
