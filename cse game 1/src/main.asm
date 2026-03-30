INCLUDE Irvine32.inc

.data
word1 BYTE "apple", 0
word2 BYTE "trump", 0
word3 BYTE "mango", 0
word4 BYTE "world", 0

words DWORD OFFSET word1, OFFSET word2, OFFSET word3, OFFSET word4
wordCount = 4


selectedWord DWORD ? 
hiddenWord BYTE 20 DUP(? )

.code
main PROC

call Randomize

mov eax, wordCount
call RandomRange

mov esi, OFFSET words
mov eax, [esi + eax * 4]
mov selectedWord, eax

mov esi, selectedWord
mov edi, OFFSET hiddenWord

create_loop :
mov al, [esi]
cmp al, 0
je done_create

mov BYTE PTR[edi], '_'

inc esi
inc edi
jmp create_loop

done_create :
mov BYTE PTR[edi], 0

mov edx, OFFSET hiddenWord
call WriteString
call Crlf

exit
main ENDP

END main