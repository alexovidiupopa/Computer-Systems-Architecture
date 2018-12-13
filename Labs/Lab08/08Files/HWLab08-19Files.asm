bits 32 
;A file name and a text (which can contain any type of character) are given in data segment. Calculate the sum of digits in the text. Create a file with the given name and write the result 
;to file. 
global start        

extern exit, fopen, fclose, fprintf, fread             
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll    
import fread msvcrt.dll
segment data use32 class=data
    text db "21234abc5efesriuys!!!@##@!%"
    len equ $-text              
    
    fileName db "out.txt",0     ; the file name we were given 
    accessMode db "w",0         ; we will be writing in the file, the access mode needs to be "w"
    fileDescriptor dd -1        ; we need a double word in which to keep the value of the file descriptor returned when opening the file
    
    format db "%d",0            ; the print format 
    sum dd 0                    ; the variable in which we compute the sum
segment code use32 class=code
    start:
        mov esi,text        ; we store the adress of the text in esi 
        mov ecx,len         ; we store the length of the text in ecx 
        
        cld                 ; DF = 0, iterate from left to right, although the direction is not important
        
        loopString:         
            lodsb           ; AL = current byte from text 
            
            cmp al,'0'      ; compare the ascii code of al to the ascii code of 0       
            jl skip         ; if ascii (al) < ascii (0), it's obviously not a digit, so we jump to the label skip
            
            cmp al,'9'      ; compare the ascii code of al to the ascii code of 9 
            jg skip         ; if ascii (al) > ascii (9), it's obviously not a digit, so we jump to the label skip
            
            sub al,48       ; at this point the al is a digit, so we substract the value of '0', which is 48, to now have in al a value between [0,9]
            
            add [sum],al    ; we add al to the sum 
            
            skip:           ; here is where we jump in case al isn't a digit
            cld             ; DF = 0 
            loop loopString     ; we loop again
            
    print: 
        ; the following part is equivalent to f.open() in C 
        push dword accessMode           ; we push the access mode, which is "w" for writing 
        push dword fileName             ; we push the file name (out.txt)
        call [fopen]                    ; we call the fopen function 
        add esp,4*2                     ; we clear the stack
        
        mov [fileDescriptor],eax        ; we store eax into fileDescriptor 
        
        cmp eax,0     ; we check if the file was opened correctly
        je end_
        
        ; the following part does the equivalent in C: fprintf(file_descriptor,%d,sum)
        push dword [sum]                ; we push the sum onto the stack 
        push dword format               ; we push the format (%d) onto the stack 
        push dword [fileDescriptor]     ; we push the file descriptor we have stored previously from eax
        call [fprintf]                  ; we call the fprintf function
        add esp,4*3                     ; we clear the stack 
        
        ; the following part closes the file, equivalent to fileDescriptor.close() in C 
        push dword [fileDescriptor]     ;we push the file descriptor 
        call [fclose]                   ; we call the fclose function 
        add esp,4                       ; we clear the stack 
        
        end_:
        ; exit(0)
        push    dword 0      
        call    [exit]      
