bits 32 ; assembling for the 32 bits architecture
;Read a file name and a text from the keyboard. Create a file with that name in the current folder and write the text that has been read to file. Observations: The file name has maximum 30 characters. The text has maximum 120 characters.
; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf,fclose,fprintf,fopen               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fclose msvcrt.dll
import fprintf msvcrt.dll
import fopen msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileName times 31 db 0
    text times 121 db 0
    access db "w",0
    fileDescriptor dd -1
    stop dd '$'
    rFormat db "%c",0
    letter dd 0
    pFormat db "%s",0
; our code starts here
segment code use32 class=code
    start:
        mov ecx,30
        mov edi,fileName 
        cld
        loop_fileName: 
            ; we read characters until $ is read 
            push ecx 
            
            push dword letter 
            push dword rFormat 
            call [scanf]
            add esp,4*2
            
            xor eax,eax
            mov eax,[letter]
            cmp eax,[stop]
            je stop_read1
            
            stosb
            
            pop ecx 
            loop loop_fileName
            
        stop_read1:
        
        mov ecx,120
        mov edi,text 
        cld
        loop_text: 
            ; we read characters until $ is read 
            push ecx 
            
            push dword letter 
            push dword rFormat 
            call [scanf]
            add esp,4*2
            
            xor eax,eax
            mov eax,[letter]
            cmp eax,[stop]
            je stop_read2
            
            stosb
            
            pop ecx 
            loop loop_text
        
        stop_read2:
        
        push dword access
        push dword fileName 
        call [fopen]
        add esp,4*2
        
        cmp eax,0
        je final_
        
        mov [fileDescriptor],eax
        
        push dword text
        push dword [fileDescriptor]
        call [fprintf]
        add esp,4*2
        
        push dword [fileDescriptor]
        call [fclose]
        add esp,4
        
        final_:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
