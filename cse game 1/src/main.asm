INCLUDE Irvine32.inc

.386
.stack 4096
ExitProcess proto,dwExitCode:dword
FillConsoleOutputCharacterA proto :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
FillConsoleOutputAttribute PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD

.data

; EXTERNS FROM words.asm
EXTERN words:DWORD					; words in a pool of words
EXTERN wordCount:DWORD				; number of words in the pool
EXTERN titleArt:BYTE				; title screen ascii art
LoadWords PROTO						; load words from txt

; EXTERNS FROM hangman_art.asm
EXTERN hangman_pointers:DWORD		; the hangman ascii arts
EXTERN max_wrong:DWORD				; the number of incorrect guesses the player can make

; EXTERNS FROM music.asm
PlayGameTheme PROTO					; plays the music during gameplay
PlayTitleTheme PROTO				; plays the music when the title is displayed
PlayWinSFX PROTO					; plays the sound effect on win
PlayLoseSFX PROTO					; plays the sound effect on lose

; VARS FOR HADNLING CONSOLE OUTPUT
consoleHandle HANDLE 0				; handle to standard output device
bytesWritten  DWORD ?				; number of bytes written
newline BYTE 13,10,0

; VARS FOR TRACKING THE HIDDEN PHRASE
seed DWORD ?						; seed for random word picker
guess_word DWORD ?					; the word to be guessed by the player
word_length DWORD ?					; the length of guess_wrd
revealed_word BYTE 64 DUP(0)		; the portion of the word revealed to the player

; VARS FOR TRACKING USER INPUT AND GUESSES					
letter_guessed BYTE ?				; the letter guessed by the player
guessed_letters BYTE 27 DUP(0)		; the letters the player has guessed so far
guessed_count	DWORD 0				; the number of letters the player has guessed so far
guess_colors WORD 27 DUP(0)			; what to color each guess on the display list
oneChar			BYTE ?,0			; temp var for cmparing a player's input character
correct_letters DWORD 0				; the number of letters the player has found
wrong_guesses DWORD 0				; the number of incorrect guesses the player has made

; TEXT DISPLAYED TO THE PLAYER
titlePrompt BYTE "Press any key to start!",0
prompt BYTE "Enter a letter (lowercase): ",0
guessed_display BYTE "Guessed: ",0
commaSpace		BYTE ", ",0
win_text BYTE "You Win!",13,10,0
lose_text BYTE "You Lose!",13,10,"The phrase was: ",0
exit_text BYTE "Press any key to exit.",0

.code
main proc
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle, eax

	call Clrscr
	call PlayTitleTheme		; play title theme
	INVOKE SetConsoleTextAttribute, consoleHandle, 0Dh
	mov edx, OFFSET titleArt ; load title screen until a key is pressed
	call WriteToConsole
	INVOKE SetConsoleTextAttribute, consoleHandle, 07h
	mov edx, OFFSET titlePrompt
	call WriteToConsole
	call ReadChar
	call Clrscr

	call LoadWords
	call GetRandomWord				; set the guess_word to a random word in words
	call GetWordLength
	call InitRevealedWord			; initialize the list of revealed words as a blank slate
	call CheckSpace					; spaces count as a free guess
	call PlayGameTheme				; play main music

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
	INVOKE SetConsoleTextAttribute, consoleHandle, 04h
	mov edx, OFFSET lose_text		; inform the player they have lost and what the word was
	call WriteToConsole
	call PlayLoseSFX				; play lose sound effect
	INVOKE SetConsoleTextAttribute, consoleHandle, 07h
	mov edx, guess_word
	call WriteToConsole
	mov edx, OFFSET newline
	jmp game_end

win_end:
	call PlayWinSFX					; play win sound effect
	INVOKE SetConsoleTextAttribute, consoleHandle, 0Eh
	mov edx, OFFSET win_text		; inform the player they have won
	jmp game_end

game_end:
	call WriteToConsole
	INVOKE SetConsoleTextAttribute, consoleHandle, 07h
	mov edx, OFFSET exit_text
	call WriteToConsole
	call ReadChar
	call Clrscr
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
	mov BYTE PTR [edi],13			; carriage return
	inc edi
	mov BYTE PTR [edi],10			; line feed
	inc edi
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
	pushad
	mov edx, OFFSET guessed_display
	call WriteToConsole
	mov esi, OFFSET guessed_letters
	mov edi, OFFSET guess_colors
    mov ecx, guessed_count
    shr ecx, 1

printLoop:     ; print letter
	cmp ecx, 0
	je done
    mov al, [esi]
    mov oneChar, al
	push esi
    push edi
    push ecx
	INVOKE SetConsoleTextAttribute, consoleHandle, WORD PTR [edi]
    mov edx, OFFSET oneChar
    call WriteToConsole
	INVOKE SetConsoleTextAttribute, consoleHandle, 07h
    pop ecx
    pop edi
    pop esi
	inc esi
	add edi, 2
    dec ecx
    jz done
	push esi
    push edi
    push ecx
    mov edx, OFFSET commaSpace     ; print comma + space
    call WriteToConsole
	pop ecx
    pop edi
    pop esi
    jmp printLoop

done:
	mov edx, OFFSET newline
	call WriteToConsole	
	popad
	ret
DisplayGuessed ENDP

AddGuess PROC
    mov esi, OFFSET guessed_letters
	mov edi, OFFSET guess_colors

findEnd:
    mov al, [esi]
    cmp al, 0
    je store
    inc esi
	add edi, 2
    jmp findEnd

store:
    mov al, letter_guessed
    mov [esi], al
    inc esi
    mov BYTE PTR [esi], 0
	mov WORD PTR [edi], 04h
	inc guessed_count
	push esi
    mov esi, guess_word
    mov ecx, word_length

checkLoop:
    cmp ecx, 0
    je doneCheck
    cmp al, [esi]
    je correct
    inc esi
    dec ecx
    jmp checkLoop

correct:
    mov WORD PTR [edi], 02h

doneCheck:
    pop esi
    inc guessed_count
    ret
AddGuess ENDP

CheckGuess PROC
    mov esi, guess_word
    mov edi, OFFSET revealed_word
    mov al, letter_guessed
    mov bl, 0

checkLoop:
    mov dl, [esi]
    cmp dl, 13
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

CheckSpace PROC
    mov esi, guess_word
    mov edi, OFFSET revealed_word
    mov al, ' '

checkLoop:
    mov dl, [esi]
    cmp dl, 13
    je finished
    cmp dl, al
    jne nextChar
    cmp BYTE PTR [edi], '_'
    jne nextChar
    mov [edi], al
    inc correct_letters

nextChar:
    inc esi
    inc edi
    jmp checkLoop

finished:
    ret
CheckSpace ENDP

WrongGuess PROC
	inc wrong_guesses
	ret
WrongGuess ENDP

end main