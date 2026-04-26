.386
.model flat, stdcall
option casemap:none

PUBLIC hangman_pointers
PUBLIC max_wrong
PUBLIC titleArt

.data

titleArt BYTE " _______  __   __  _______  _______  ______                         ",13,10
         BYTE "|       ||  | |  ||       ||       ||    _ |                        ",13,10
         BYTE "|  _____||  | |  ||    _  ||    ___||   | ||                        ",13,10
         BYTE "| |_____ |  |_|  ||   |_| ||   |___ |   |_||_                       ",13,10
         BYTE "|_____  ||       ||    ___||    ___||    __  |                      ",13,10
         BYTE " _____| ||       ||   |    |   |___ |   |  | |                      ",13,10
         BYTE "|_______||_______||___|    |_______||___|  |_|                      ",13,10
         BYTE " __   __  _______  __    _  _______  __   __  _______  __    _  __  ",13,10
         BYTE "|  | |  ||   _   ||  |  | ||       ||  |_|  ||   _   ||  |  | ||  | ",13,10
         BYTE "|  |_|  ||  |_|  ||   |_| ||    ___||       ||  |_|  ||   |_| ||  | ",13,10
         BYTE "|       ||       ||       ||   | __ |       ||       ||       ||  | ",13,10
         BYTE "|       ||       ||  _    ||   ||  ||       ||       ||  _    ||__| ",13,10
         BYTE "|   _   ||   _   || | |   ||   |_| || ||_|| ||   _   || | |   | __  ",13,10
         BYTE "|__| |__||__| |__||_|  |__||_______||_|   |_||__| |__||_|  |__||__|",13,10
		 BYTE 13,10,"Press any key to start!",0

hang0 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",13,10,0

hang1 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",13,10,0

hang2 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",13,10,0

hang3 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
"/|   |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",13,10,0

hang4 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
"/|\  |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",13,10,0

hang5 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
"/|\  |",0Dh,0Ah,\
"/    |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",13,10,0

hang6 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" O   |",0Dh,0Ah,\
"/|\  |",0Dh,0Ah,\
"/ \  |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",13,10,0

hang7 BYTE \
" +---+",0Dh,0Ah,\
" |   |",0Dh,0Ah,\
" X   |",0Dh,0Ah,\
"/|\  |",0Dh,0Ah,\
"/ \  |",0Dh,0Ah,\
"     |",0Dh,0Ah,\
"======",13,10,0

hangman_pointers DWORD OFFSET hang0, OFFSET hang1, OFFSET hang2, OFFSET hang3
                 DWORD OFFSET hang4, OFFSET hang5, OFFSET hang6, OFFSET hang7

max_wrong DWORD 7

END