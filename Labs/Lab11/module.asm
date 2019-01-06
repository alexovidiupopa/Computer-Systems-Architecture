bits 32 ; assembling for the 32 bits architecture

extern _readSentence
extern _sentence
extern _length

global _getLetters   
;Read a sentence from the keyboard containing different characters (lowercase letters, big letters, numbers, special ones, etc). Obtain a new string with only the small case letters and another string with only the big case letters. Print both strings on the screen. 
segment data public use32 class=data
    resultStringAddress dd 0
    

segment code public use32 class=code
    _getLetters:
        push ebp 
        mov ebp, esp
        
        sub esp,4*2
        
        mov eax,[ebp+8] 
        mov [resultStringAddress],eax 
        
		push dword [resultStringAddress]
		call printf
		add esp, 4*1

        mov edi,[resultStringAddress]
        mov esi,_sentence
        mov ecx,_length
        cld
        loop_sentence: 
            lodsb    ; al = current byte from sentence 
            
            cmp al,'A'
            jl next_
            
            cmp al,'Z'
            jg next_
            
            stosb
            next_:
            loop loop_sentence
        add esp,4*2
        mov esp,ebp 
        pop ebp 
        ret      
