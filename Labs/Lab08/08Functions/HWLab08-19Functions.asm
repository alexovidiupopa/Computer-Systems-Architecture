bits 32 
; Read one byte and one word from the keyboard. Print on the screen "YES" if the bits of the byte read are found consecutively among the bits of the word and "NO" otherwise. Example: a = 10 = 0000 1010b
; b = 256 = 0000 0001 0000 0000b
; The value printed on the screen will be NO.
; a = 0Ah = 10 = 0000 1010b
; b = 6151h = 24913 = 0110 0001 0101 0001b
; The value printed on the screen will be YES (you can find the bits on positions 5-12).
global start        

extern exit,scanf,printf               
import exit msvcrt.dll    
import scanf msvcrt.dll
import printf msvcrt.dll
;To solve the problem, we must first say that there are x ways the bits from the byte could be found consecutively in the word: 0-7,1-8,...,9-16. Therefore, we can olate all the cases and compare each 
;isolated b with the value from a. In case a==b, we jump to yes scenario. 
segment data use32 class=data
    ; ...
    a dw 0
    b dd 0
    
    yes dd "yes",0
    no dd "no",0
    
    read_a db "a=",0
    read_b db "b=",0
    format db "%d",0            ; Attention! If we want to read hex numbers, %d becomes %x. In this format we can only read numbers in decimal
    print_format db "%s",0      
    
    cases dw 0000000011111111b
    
segment code use32 class=code
    start:
        xor eax,eax
        xor edx,edx
        ;"a="
        push dword read_a         
        call [printf]
        add esp, 4
        
        ;read the value of a
        push dword a
        push dword format
        call [scanf]
        add esp, 4*2
        
        ;"b="
        push dword read_b
        call [printf]
        add esp, 4
        
        ;read the value of b
        push dword b
        push dword format
        call [scanf]
        add esp, 4*2
        
        mov ecx,10     ;there are 10 cases, so we iterate 10 times 
        
        ;we convert [a] into a word, and keep it into dx.
        mov dl,[a]
        mov dh,0       ; now dx = a 
        
        loop_word:
            mov ax,[b]        ; we save b in ax 
            and ax,[cases]    ; we isolate bits 0-7/1-8.../9-16 of ax (b) 
            
          
            cmp ax,dx         ; we compare ax (b) with dx (a)
            je yes_scenario   ; if they are equal, we jump to printing yes 
                              ; else, we go forward 
                              ; and now we shift with one position to the left the value of cases
            shl dx,1          ; we also need to shift to the left the value of dx (a), for it to be compared correctly. 
                              ; This was my mistake when I showed you the code today at the lab.
            
            mov bx, [cases]
            shl bx, 1
            mov [cases],bx
            
            loop loop_word     ;ecx is decremented and we loop again
            
        no_scenario:
            ;print "no"
            push dword no               ; the same as below, but the string is "no"
            push dword print_format     ; the same as below 
            call [printf]               ; the same as below 
            add esp,4*2                 ; the same as below 
            jmp end_    ; jump to the end, to avoid the "yes" part
            
        yes_scenario:
            ;print "yes"
            push dword yes          ; push "yes" onto the stack
            push dword print_format ; push "%s" onto the stack, to print a string
            call [printf]           ; call printf 
            add esp, 4*2            ; clear the stack
            
        end_:
        push dword 0      
        call [exit]       
