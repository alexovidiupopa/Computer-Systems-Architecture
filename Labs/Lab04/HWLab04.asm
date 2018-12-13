bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; Ex 24: Given the doubleword M, compute the doubleword MNew as follows:

    ; the bits 0-3 a of MNew are the same as the bits 5-8 a of M.
    ; the bits 4-7 a of MNew have the value 1
    ; the bits 27-31 a of MNew have the value 0
    ; the bits 8-26 of MNew are the same as the bits 8-26 a of M.
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    M dd 00101101101110011011000010100011b
    MNew dd 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ebx, 0  ;we compute the result in ebx
        
        mov eax,[M] ;eax is now = M
        
        and eax, 00000000000000000000000111100000b ; we isolate bits 5-8 of M,using the logical and
        
        mov cl, 5 ; we will be doing a rotation with 5 positions, so cl gets 5
        ror eax,cl ; we rotate 5 positions to the right 
        or ebx,eax ; we put the bits 5-8 of M into the result, on positions 0-3
        
        or ebx, 00000000000000000000000011110000b ;we force bits 4-7 of ebx to have the value 1, using the logical or
        
        and ebx,00000111111111111111111111111111b  ;we force bits 27-31 of ebx to have the value 0, using the logical and
        
        mov eax,[M] ; EAX is now = M
        
        and eax, 00000111111111111111111100000000b ;we isolate bits 8-26 of M 
        or ebx,eax ; now the 8-26 bits stored in ebx are the same as the 8-26 bits of M
        
        mov [MNew],ebx ;we move the register value into the MNEw variable
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
