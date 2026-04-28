INCLUDE Irvine32.inc
.386
.stack 4096
includelib winmm.lib
PlaySoundA PROTO :DWORD, :DWORD, :DWORD
.data

game_theme BYTE "Music\\game.wav",0

.code

PlayGameTheme PROC
	INVOKE PlaySoundA, OFFSET game_theme, 0, 8h
	ret
PlayGameTheme ENDP

end