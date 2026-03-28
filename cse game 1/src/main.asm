; AddTwo.asm - adds two 32-bit integers.
; Chapter 3 example
INCLUDE Irvine32.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword
.data
guess_word BYTE "hello",0
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
	mov edx, OFFSET hangman
    call WriteString
    call Crlf			

	invoke ExitProcess,0
main endp
end main