INCLUDE Irvine32.inc
.386
.stack 4096
includelib winmm.lib
PlaySoundA PROTO :DWORD, :DWORD, :DWORD

PUBLIC PlayGameTheme
PUBLIC PlayTitleTheme

.data

game_theme BYTE "Music\\game.wav",0
title_theme BYTE "Music\\title.wav",0

.code

PlayTitleTheme PROC
	INVOKE PlaySoundA, OFFSET title_theme, 0, 8h OR 1h
	ret
PlayTitleTheme ENDP

PlayGameTheme PROC
	INVOKE PlaySoundA, OFFSET game_theme, 0, 8h OR 1h
	ret
PlayGameTheme ENDP

end