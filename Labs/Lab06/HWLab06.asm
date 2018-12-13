bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions 

                          
; 25. A string of bytes is given. Obtain the mirror image of the binary representation of this string of bytes.
; Ex : s DB 01011100b, 10001001b, 11100101b             5C | 89 | E5
; Result : d DB 10100111b, 10010001b, 00111010b.        A7 | 91 | 3A

segment data use32 class=data
    S db 01011100b , 10001001b , 11100101b , 0Fh     ; added 0Fh just to test it all
    L equ $-S
    D times L db 0


segment code use32 class=code
    start:
        mov ecx , 0
        mov cl , L  ; we keep the length in CL
        mov esi , S     ; we keep the element in S
        mov edi , D+L-1     ; we put the element in the opposite location of D
        
        loop_string:
            cld     ; we go through S from left to right, DF = 0
            lodsb   ; we put element from S in AL 
            
            mov dl , cl     ; we save CL in DL
            mov cl , 8      ; we do the mirror image for 8 bits  (a byte)
            mov ebx , 0     ; we clear EBX , in which we will keep the mirror image
            
            mirror_image:
                rcl al , 1      ; we take the bits one by one by using the carry flag
                rcr bl , 1      ; we put the bits one by one in reverse order in BL
            loop mirror_image     ; loops 8 times for each bit in the byte
            
            mov al , bl     ; we put the palindrome into AL
            mov cl , dl     ; we resume to the outer loop
            
            std    ; we go through D from right to left
            stosb   ; we put element from AL in D
        loop loop_string
        
        push    dword 0     
        call    [exit]       
