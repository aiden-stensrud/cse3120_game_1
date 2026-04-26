.386
.model flat, stdcall
option casemap:none

PUBLIC hangman_pointers
PUBLIC max_wrong
PUBLIC titleArt

.data

titleArt BYTE "    o__ __o                                                          o         o                                                                                  o   ",13,10
         BYTE "   /v     v\                                                        <|>       <|>                                                                                <|>  ",13,10
         BYTE "  />       <\                                                       < >       < >                                                                                / \  ",13,10
         BYTE " _\o____         o       o   \o_ __o      o__  __o   \o__ __o        |         |      o__ __o/  \o__ __o     o__ __o/  \o__ __o__ __o      o__ __o/  \o__ __o    \o/  ",13,10
         BYTE "      \_\__o__  <|>     <|>   |    v\    /v      |>   |     |>       o__/_ _\__o     /v     |    |     |>   /v     |    |     |     |>    /v     |    |     |>    |   ",13,10
         BYTE "            \   < >     < >  / \    <\  />      //   / \   < >       |         |    />     / \  / \   / \  />     / \  / \   / \   / \   />     / \  / \   / \   < >  ",13,10
         BYTE "  \         /    |       |   \o/     /  \o    o/     \o/            <o>       <o>   \      \o/  \o/   \o/  \      \o/  \o/   \o/   \o/   \      \o/  \o/   \o/        ",13,10
         BYTE "   o       o     o       o    |     o    v\  /v __o   |              |         |     o      |    |     |    o      |    |     |     |     o      |    |     |     o   ",13,10
         BYTE "   <\__ __/>     <\__ __/>   / \ __/>     <\/> __/>  / \            / \       / \    <\__  / \  / \   / \   <\__  < >  / \   / \   / \    <\__  / \  / \   / \  _<|>_ ",13,10
         BYTE "                             \o/                                                                                   |                                                  ",13,10
         BYTE "                              |                                                                            o__     o                                                  ",13,10
         BYTE "                             / \                                                                           <\__ __/>                                                  ",13,10,0

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