.386
.model flat, stdcall
option casemap:none

CreateFileA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadFile    PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CloseHandle PROTO :DWORD
GENERIC_READ          EQU 80000000h
OPEN_EXISTING         EQU 3
FILE_ATTRIBUTE_NORMAL EQU 80h

PUBLIC words
PUBLIC wordCount
PUBLIC LoadWords

.data

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
word16 BYTE "i love very long sentences", 0
word17 BYTE "abandon", 0
word18 BYTE "bread", 0
word19 BYTE "zebra", 0
word20 BYTE "window", 0

words DWORD OFFSET word1, OFFSET word2, OFFSET word3, OFFSET word4, OFFSET word5
      DWORD OFFSET word6, OFFSET word7, OFFSET word8, OFFSET word9, OFFSET word10
      DWORD OFFSET word11, OFFSET word12, OFFSET word13, OFFSET word14, OFFSET word15
      DWORD OFFSET word16, OFFSET word17, OFFSET word18, OFFSET word19, OFFSET word20

wordCount DWORD 20

.code

LoadWords PROC
	ret
LoadWords ENDP

END