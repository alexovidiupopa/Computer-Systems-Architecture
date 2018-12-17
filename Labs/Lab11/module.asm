bits 32 ; assembling for the 32 bits architecture

global start        

extern exit               
import exit msvcrt.dll    
;Read a sentence from the keyboard containing different characters (lowercase letters, big letters, numbers, special ones, etc). Obtain a new string with only the small case letters and another string with only the big case letters. Print both strings on the screen. 
segment data use32 class=data
    ; ...

segment code use32 class=code
    start:
        ; ...
    
        push    dword 0      
        call    [exit]       
