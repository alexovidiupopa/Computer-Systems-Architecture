bits 32

global concatenate

segment code use32 class=code:
    concatenate:
        mov edi,[esp+4]
        mov esi,[esp+28]
        mov ecx,[esp+24] 
        rep movsb 
        
        mov esi,[esp+20]
        mov ecx,[esp+16] 
        rep movsb 
        
        mov esi,[esp+12]
        mov ecx,[esp+8] 
        rep movsb 
        
        ret