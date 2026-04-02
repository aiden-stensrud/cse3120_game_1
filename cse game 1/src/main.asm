INCLUDE Irvine32.inc

.386
.stack 4096
ExitProcess proto,dwExitCode:dword
.data
; listed 20 words
word1  BYTE "cat", 0
word2  BYTE "dog", 0
word3  BYTE "four", 0
word4  BYTE "goat", 0
word5  BYTE "tiger", 0
word6  BYTE "world", 0
word7  BYTE "pizza", 0
word8  BYTE "water", 0
word9  BYTE "planet", 0
word10 BYTE "orange", 0
word11 BYTE "cabana", 0
word12 BYTE "chair", 0
word13 BYTE "pencil", 0
word14 BYTE "school", 0
word15 BYTE "polish", 0
word16 BYTE "elegance", 0
word17 BYTE "abandon", 0
word18 BYTE "bread", 0
word19 BYTE "zebra", 0
word20 BYTE "window", 0

; addresses
words DWORD OFFSET word1, OFFSET word2, OFFSET word3, OFFSET word4, OFFSET word5
DWORD OFFSET word6, OFFSET word7, OFFSET word8, OFFSET word9, OFFSET word10
DWORD OFFSET word11, OFFSET word12, OFFSET word13, OFFSET word14, OFFSET word15
DWORD OFFSET word16, OFFSET word17, OFFSET word18, OFFSET word19, OFFSET word20

wordCount = 20

selectedWord DWORD ?
hiddenWord BYTE 20 DUP(?)


guess_word DWORD ?
word_length DWORD ?
revealed_word BYTE "_____",0
letter_guessed BYTE ?
guessed_letters BYTE 27 DUP(0)
correct_letters DWORD 0
wrong_guesses DWORD 0
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

hang3 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
"/|   |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",0

hang4 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
"/|\  |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",0

hang5 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
"/|\  |",0Dh,0Ah,\
"/    |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",0

hang6 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
"/|\  |",0Dh,0Ah,\
"/ \  |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",0

hangman_pointers DWORD OFFSET hang0, OFFSET hang1, OFFSET hang2, OFFSET hang3
         DWORD OFFSET hang4, OFFSET hang5, OFFSET hang6

.code
main proc
	call GetRandomWord ; set the guess_word to a random word in words
	call GetWordLength

game:
	call Clrscr
	call DisplayHangman ; display the hangman character in its current phase

	mov edx, OFFSET revealed_word ; print the word with the correctly guessed letters revealed
    call WriteString
    call Crlf	

	mov eax, wrong_guesses ; check for loss
	cmp eax,6
	je lose_end

	mov eax, correct_letters ; check for win
	mov ebx, word_length
	cmp ebx, eax
	je win_end

	call DisplayGuessed	 ; display guessed letters

	mov edx, OFFSET prompt ; get character from player
    call WriteString
    call ReadChar ; character entered is stored in al
    call Crlf

	call AddGuess ; add guess to array and compare against word
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

GetRandomWord PROC
	;random functions derived from textbook chapter 5, page 196
	call Randomize
	mov eax, wordCount
	call RandomRange
	mov esi, OFFSET words
	mov eax, [esi + eax * 4]
	mov guess_word, eax
GetRandomWord ENDP

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

DisplayHangman PROC
    mov esi, OFFSET hangman_pointers
    mov eax, wrong_guesses
    shl eax, 2              ; multiply by 4
    add esi, eax
    mov edx, [esi]
    call WriteString
	call Crlf
    ret
DisplayHangman ENDP

DisplayGuessed PROC
	mov edx, OFFSET guessed_display
	call WriteString

	mov edx, OFFSET guessed_letters
	call WriteString

	call Crlf
	ret
DisplayGuessed ENDP

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
    mov bl, 0

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