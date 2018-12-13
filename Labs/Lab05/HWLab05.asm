bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

;10)Se dau doua siruri de caractere S1 si S2. Sa se construiasca sirul D prin concatenarea elementelor sirului S2 in ordine inversa cu elementele de pe pozitiile pare din sirul S1. 
; S1: '+', '2', '2', 'b', '8', '6', 'X','8'
; S2: 'a', '4', '5'
; D: '5', '4', 'a', '2','b', '6', '8'
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    s1 db '+','2','2','b','8','6','X','8','0'
    l1 equ $-s1
    s2 db 'a','4','5','b'
    l2 equ $-s2
    d times (l1/2)+l2 db 0 ; we allocate the necessary memory for d, which is half the length of the first string + the whole length of the other string
    aux db 0 
; our code starts here
segment code use32 class=code
    start:
        mov ecx,l2    ; initialize ecx with the length of the second string

        mov esi,l2-1   ; initialize the index of the second string from the end 
      
        mov edi,0 ; initialize the starting point of the d string with 0
        
        jecxz end_loop_second_string  ; jump if ecx (l2) is 0
        
        second_string:
            mov al,[s2+esi]     ; al = s2[esi]
            mov [d+edi],al      ; d[edi] = al = s2[esi]
            dec esi             ; esi = esi - 1 
            inc edi             ; edi = edi + 1     
        loop second_string      ; ecx is decremented
        
        end_loop_second_string:
        
        mov ecx,l1/2       ; ecx gets half the length of the first string 
        
        mov esi,1             ; we start from 1 ( the second position )
        
        jecxz end_loop_first_string    ; jump if ecx (l1/2-2) is 0 
        
        first_string:
            mov al,[s1+esi]      ; al = s1[esi]
            mov [d+edi],al       ; d[edi] = al = s1[esi] 
            add esi,2            ; esi = esi + 2 
            inc edi              ; edi = edi + 1 
        loop first_string        ; ecx is decremented
        
        end_loop_first_string:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
