; AddTwo.asm - adds two 32-bit integers.
; Chapter 3 example
INCLUDE Irvine32.inc

.386
.stack 4096
ExitProcess proto,dwExitCode:dword
.data
guess_word BYTE "hello",0
word_length DWORD ?
revealed_word BYTE "_____",0
letter_guessed BYTE ?
guessed_letters BYTE 27 DUP(0)
correct_letters DWORD 0
wrong_guesses BYTE 0
prompt BYTE "Enter a letter (lowercase): ",0
guessed_display BYTE "Guessed: ",0
input  BYTE ?
win_text BYTE "You Win!",0
lose_text BYTE "You Lose!",0

hang0 BYTE \ ; hangman ascii arts
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",0

hang1 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",0

hang2 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",0

.code
main proc
;prottasha code here
	mov	eax,4				
	add	eax,6	
	call GetWordLength
game:
	call Clrscr
	mov edx, OFFSET hang0
    call WriteString
    call Crlf
	mov edx, OFFSET revealed_word
    call WriteString
    call Crlf	
	movzx eax, wrong_guesses ; check for loss
	cmp eax,6
	je lose_end
	mov eax, correct_letters ; check for win
	mov ebx, word_length
	cmp ebx, eax
	je win_end
	mov edx, OFFSET guessed_display ; display guessed letters
	call WriteString
	mov edx, OFFSET guessed_letters
	call WriteString
	call Crlf	

	mov edx, OFFSET prompt ; get character from player
    call WriteString
    call ReadChar        ; AL = character entered
    mov input, al        ; store it
    call Crlf
	call AddGuess
	call CheckGuess
	jmp game
lose_end:
	mov edx, OFFSET lose_text
	jmp game_end
win_end:
	mov edx, OFFSET win_text
	jmp game_end
game_end:
	call WriteString
	call Crlf
	invoke ExitProcess,0
main endp

GetWordLength PROC
    mov esi, OFFSET guess_word   ; pointer to string
    xor ecx, ecx                 ; counter = 0
countLoop:
    mov al, [esi]
    cmp al, 0                    ; end of string?
    je done
    inc ecx                      ; increment length
    inc esi                      ; move to next char
    jmp countLoop
done:
    mov word_length, ecx
    ret
GetWordLength ENDP

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

AddGuess PROC
    mov esi, OFFSET guessed_letters
	mov letter_guessed, al
findEnd:
    mov al, [esi]
    cmp al, 0            ; find null terminator
    je store
    inc esi
    jmp findEnd
store:
	mov al, letter_guessed
    mov [esi], al       ; store new char
    inc esi
    mov BYTE PTR [esi], 0 ; re-add null terminator
    ret
AddGuess ENDP

CheckGuess PROC
    mov esi, OFFSET guess_word
    mov edi, OFFSET revealed_word
    mov bl, 0              ; changedFlag = 0
checkLoop:
    mov dl, [esi]
    cmp dl, 0
    je done
    cmp dl, al
    jne nextChar
    cmp BYTE PTR [edi], '_'
    jne nextChar
    mov [edi], al          ; reveal letter
    mov bl, 1              ; mark that we changed something
	inc correct_letters
nextChar:
    inc esi
    inc edi
    jmp checkLoop
done:
    cmp bl, 1
    je finished            ; at least one match - done
    call WrongGuess        ; no matches - wrong guess
finished:
    ret
CheckGuess ENDP

WrongGuess PROC
	inc wrong_guesses
	ret
WrongGuess ENDP

end main