INCLUDE Irvine32.inc

.386
.stack 4096
ExitProcess proto,dwExitCode:dword
FillConsoleOutputCharacterA proto :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FillConsoleOutputAttribute PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD

.data

EXTERN words:DWORD					; words in a pool of words
EXTERN wordCount:DWORD				; number of words in the pool

consoleHandle HANDLE 0				; handle to standard output device
bytesWritten  DWORD ?				; number of bytes written
crlf_new BYTE 13, 10				; ascii for new line
consoleInfo BYTE 22 DUP(?)			; current console info
homeCoord DWORD 0					; x=0, y=0 on screen clear

seed DWORD ?						; seed for random word picker

guess_word DWORD ?					; the word to be guessed by the player
word_length DWORD ?					; the length of guess_wrd

revealed_word BYTE 32 DUP(0)		; the portion of the word revealed to the player
					
letter_guessed BYTE ?				; the letter guessed by the player
guessed_letters BYTE 27 DUP(0)		; the letters the player has guessed so far
correct_letters DWORD 0				; the number of letters the player has found
wrong_guesses DWORD 0				; the number of incorrect guesses the player has made

; prompt text displayed to the player
prompt BYTE "Enter a letter (lowercase): ",0
guessed_display BYTE "Guessed: ",0
win_text BYTE "You Win!",0
lose_text BYTE "You Lose! The word was: ",0

EXTERN hangman_pointers:DWORD		; the hangman ascii arts
EXTERN max_wrong:DWORD				; the number of incorrect guesses the player can make

.code
main proc
	call GetRandomWord				; set the guess_word to a random word in words
	call GetWordLength
	call InitRevealedWord			; initialize the list of revealed words as a blank slate

game:
	call Clrscr
	call DisplayHangman				; display the hangman character in its current phase

	mov edx, OFFSET revealed_word	; print the word with the correctly guessed letters revealed
    call WriteToConsole	

	mov eax, wrong_guesses			; check for loss
	cmp eax, max_wrong
	je lose_end

	mov eax, correct_letters		; check for win
	mov ebx, word_length
	cmp ebx, eax
	je win_end

	call DisplayGuessed				; display guessed letters

	mov edx, OFFSET prompt			; get character from player
    call WriteToConsole
    call ReadChar					; character entered is stored in al
	mov letter_guessed, al

	call ValidateGuess
	cmp eax, 0
	jne game

	call AddGuess					; add guess to array and compare against word
	call CheckGuess
	jmp game

lose_end:
	mov edx, OFFSET lose_text		; inform the player they have lost and what the word was
	call WriteToConsole
	mov edx, guess_word
	jmp game_end

win_end:
	mov edx, OFFSET win_text		; inform the player they have won
	jmp game_end

game_end:
	call WriteToConsole
	invoke ExitProcess,0
main endp

WriteToConsole PROC
    pushad
    mov esi, edx															; preserve string pointer
    xor ecx, ecx

countLoop:																	; get length of string
    cmp BYTE PTR [esi], 0
    je  gotLength
    inc ecx
    inc esi
    jmp countLoop

gotLength:
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE									; get console output handle
    mov ebx, eax
    INVOKE WriteConsoleA, ebx, edx, ecx, ADDR bytesWritten, 0				; write message to console
	INVOKE WriteConsoleA, ebx, OFFSET crlf_new, 2, ADDR bytesWritten, 0		; go to next line
	popad
    ret
WriteToConsole ENDP

GetRandomWord PROC
	;random functions derived from textbook chapter 5, page 196
	call GetRandomSeed
	mov eax, wordCount
	call RandomInRange
	mov esi, OFFSET words
	mov eax, [esi + eax * 4]
	mov guess_word, eax
	ret
GetRandomWord ENDP

GetRandomSeed PROC
	INVOKE GetTickCount
    mov seed, eax
    ret
GetRandomSeed ENDP

RandomInRange PROC			; returns EAX = random number from 0 to range-1
    push ecx
    push edx
    mov ecx, eax            ; ECX = range
    mov eax, seed
    imul eax, 214013
    add eax, 2531011
    mov seed, eax
    shr eax, 16
    and eax, 7FFFh
    xor edx, edx
    div ecx                 ; EDX = remainder
    mov eax, edx            ; EAX = random result
    pop edx
    pop ecx
    ret
RandomInRange ENDP

GetWordLength PROC
    mov esi, guess_word
    xor ecx, ecx					; counter = 0
countLoop:
    mov al, [esi]
    cmp al, 0						; end of string?
    je done

    inc ecx							; increment length
    inc esi							; move to next char
    jmp countLoop

done:
    mov word_length, ecx
    ret
GetWordLength ENDP

InitRevealedWord PROC				; initialize blank un-revealed word
    mov esi, guess_word				; source
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
    shl eax, 2						; multiply by 4
    add esi, eax
    mov edx, [esi]
    call WriteToConsole	
    ret
DisplayHangman ENDP

ValidateGuess PROC
    ; check if lowercase a-z
	mov al, letter_guessed
    cmp al, 'a'
    jb reject
    cmp al, 'z'
    ja reject
    mov esi, OFFSET guessed_letters ; check duplicates
checkLoop:
    cmp BYTE PTR [esi], 0
    je accept
    cmp BYTE PTR [esi], al
    je reject
    inc esi
    jmp checkLoop
accept:								; input is valid
    mov eax, 0
    ret
reject:								; input is not valid
    mov eax, 1
    ret
ValidateGuess ENDP

DisplayGuessed PROC
	mov edx, OFFSET guessed_display
	call WriteToConsole

	mov edx, OFFSET guessed_letters
	call WriteToConsole
	ret
DisplayGuessed ENDP

AddGuess PROC
    mov esi, OFFSET guessed_letters

findEnd:
    mov al, [esi]
    cmp al, 0
    je store
    inc esi
    jmp findEnd

store:
    mov al, letter_guessed
    mov [esi], al
    inc esi
    mov BYTE PTR [esi], 0
    ret
AddGuess ENDP

CheckGuess PROC
    mov esi, guess_word
    mov edi, OFFSET revealed_word
    mov al, letter_guessed
    mov bl, 0

checkLoop:
    mov dl, [esi]
    cmp dl, 0
    je done

    cmp dl, al
    jne nextChar

    cmp BYTE PTR [edi], '_'
    jne nextChar

    mov [edi], al
    mov bl, 1
    inc correct_letters

nextChar:
    inc esi
    inc edi
    jmp checkLoop

done:
    cmp bl, 1
    je finished
    call WrongGuess

finished:
    ret
CheckGuess ENDP

WrongGuess PROC
	inc wrong_guesses
	ret
WrongGuess ENDP

end main