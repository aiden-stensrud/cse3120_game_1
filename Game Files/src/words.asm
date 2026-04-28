INCLUDE Irvine32.inc
.386
option casemap:none

CloseHandle PROTO :DWORD
GENERIC_READ          EQU 80000000h
OPEN_EXISTING         EQU 3
FILE_ATTRIBUTE_NORMAL EQU 80h

PUBLIC words
PUBLIC wordCount
PUBLIC LoadWords

.data

filename BYTE "words.txt",0
fileHandle DWORD ?
bytesRead  DWORD ?
fileBuffer  BYTE 4096 DUP(0)
wordStorage BYTE 4096 DUP(0)
words     DWORD 256 DUP(0)     ; public pointer array
wordCount DWORD 0              ; public number of words

.code

LoadWords PROC
    pushad
    ; open file
    INVOKE CreateFileA, OFFSET filename, GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
    mov fileHandle, eax
	; read file
    INVOKE ReadFile, fileHandle, OFFSET fileBuffer, SIZEOF fileBuffer - 1, OFFSET bytesRead, 0
    ; close file
    INVOKE CloseHandle, fileHandle
	; null terminate loaded bytes
    mov esi, OFFSET fileBuffer
    add esi, bytesRead
    mov BYTE PTR [esi], 0
	; load vars
	mov esi, OFFSET fileBuffer
	mov edi, OFFSET wordStorage
	mov ebx, OFFSET words
	mov wordCount, 0

nextLine:
skipBlank:
    mov al, [esi]
    cmp al, 13
    je skipChar
    cmp al, 10
    je skipChar
    cmp al, 0
    je done
    jmp beginWord

skipChar:
    inc esi
    jmp skipBlank

beginWord: ; store pointer to word
    mov [ebx], edi
    add ebx, 4
    inc wordCount
	copyChars:
    mov al, [esi]
    cmp al, 0
    je finishWord
    cmp al, 13
    je finishWord
    cmp al, 10
    je finishWord
    mov [edi], al
    inc edi
    inc esi
    jmp copyChars

finishWord:
    mov BYTE PTR [edi], 0
    inc edi

skipLineEnd:
    mov al, [esi]
    cmp al, 13
    je eatEnd
    cmp al, 10
    je eatEnd
    cmp al, 0
    je done
    jmp nextLine

eatEnd:
    inc esi
    jmp skipLineEnd

done:
	popad
	ret
LoadWords ENDP

END