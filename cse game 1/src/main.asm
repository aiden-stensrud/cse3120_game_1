; AddTwo.asm - adds two 32-bit integers.
; Chapter 3 example
INCLUDE Irvine32.inc

.386
.stack 4096
ExitProcess proto,dwExitCode:dword
.data
guess_word BYTE "hello",0
revealed_word BYTE "_____",0

prompt BYTE "Enter a letter (lowercase): ",0
input  BYTE ?

hangman BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
"/|\  |",0Dh,0Ah,\
"/ \  |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",0Dh,0Ah,0

.code
main proc
;prottasha code here
	mov	eax,4				
	add	eax,6	
	; prints the inital hangman character
	mov edx, OFFSET hangman
    call WriteString
    call Crlf
	mov edx, OFFSET revealed_word
    call WriteString
    call Crlf		

	mov edx, OFFSET prompt ; get character from player
    call WriteString
    call ReadChar        ; AL = character entered
    mov input, al        ; store it
    call Crlf

	invoke ExitProcess,0
main endp

InitRevealedWord PROC ; initialize blank un-revealed word
    mov esi, OFFSET guess_word      ; source
    mov edi, OFFSET revealed_word   ; destination
buildLoop:
    mov al, [esi]
    cmp al, 0
    je done
    mov BYTE PTR [edi], '_'         ; replace with underscore
    inc esi
    inc edi
    jmp buildLoop
done:
    mov BYTE PTR [edi], 0           ; null terminate
    ret
InitRevealedWord ENDP

end main