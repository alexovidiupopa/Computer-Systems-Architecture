;12)Two strings of characters of equal length are given. Calculate and display the results of the interleaving of the letters, for the two possible interlaces (the letters of the first string in an even position, respectively the letters from the first string in an odd positions). Where no character exist in the source string, the ‘ ’ character will replace it in the destination string. 
bits 32 

global start        

extern exit,printf 
extern calculate                ; we declare our function from the other module as being extern. 
import exit msvcrt.dll    
import printf msvcrt.dll
        
segment data use32 class=data
    s1 db "123456"     ; our first string 
    len equ $-s1 
    s2 db "abcdef"     ; our second string 
    
    x times len+len dd ''        ; our first result string (of length 2*len)
    y times len+len dd ''        ; our second result string (of length 2*len)
    
segment code use32 class=code
    start:
        ; call the function the first time, with the parameters s1,s2,length and x. 
        ; After this call, x will be equal to the string formed by the elements of s1 on even positions (0,2,..) and the elements of s2 
        ; on odd positions (1,3,...)
        push dword s1
        push dword s2
        push dword len 
        push dword x
        call calculate      ; we call the calculate function from the other module 
        add esp,4*4         ; we clear the stack 
        
        ; we print our string x.
        push dword x
        call [printf]
        add esp,4
        
        ; call the function the first time, with the parameters s1,s2,length and y. 
        ; After this call, y will be equal to the string formed by the elements of s2 on even positions (0,2,..) and the elements of s1 
        ; on odd positions (1,3,...)
        push dword s2
        push dword s1
        push dword len 
        push dword y
        call calculate        ; we call the calculate function from the other module
        add esp,4*4           ; we clear the stack 
        
        ;we print our string y.
        push dword y
        call [printf]
        add esp,4
        
        push    dword 0
        call    [exit]       
