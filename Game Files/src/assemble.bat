@ECHO OFF

setlocal

SET IRVINE=..\Irvine

set PATH=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin;C:\Program Files (x86)\Windows Kits\8.1\bin\x86;C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools;C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\tools;C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\ide;C:\Program Files (x86)\HTML Help Workshop;C:\Program Files (x86)\MSBuild\14.0\bin\;C:\windows\Microsoft.NET\Framework\v4.0.30319\;C:\windows\SysWow64;C:\windows\system32;C:\windows;C:\windows\System32\Wbem;C:\windows\System32\WindowsPowerShell\v1.0\;C:\windows\System32\OpenSSH\;C:\Program Files (x86)\Windows Kits\8.1\Windows Performance Toolkit\;%PATH%

set LIB=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\lib;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\atlmfc\lib;C:\Program Files (x86)\Windows Kits\10\lib\10.0.10240.0\ucrt\x86;C:\Program Files (x86)\Windows Kits\8.1\lib\winv6.3\um\x86;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6.1\Lib\um\x86

set LIBPATH=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\atlmfc\lib;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\lib

set INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\include;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\atlmfc\include;C:\Program Files (x86)\Windows Kits\10\Include\10.0.10240.0\ucrt;C:\Program Files (x86)\Windows Kits\8.1\Include\um;C:\Program Files (x86)\Windows Kits\8.1\Include\shared;C:\Program Files (x86)\Windows Kits\8.1\Include\winrt

echo Assembling main.asm...
ml.exe /c /nologo /Sg /Zi /Fo"main.obj" /Fl"main.lst" /I "%IRVINE%" /W3 /errorReport:prompt /Tamain.asm
IF ERRORLEVEL 1 GOTO build_fail

echo Assembling words.asm...
ml.exe /c /nologo /Sg /Zi /Fo"words.obj" /Fl"words.lst" /I "%IRVINE%" /W3 /errorReport:prompt /Tawords.asm
IF ERRORLEVEL 1 GOTO build_fail

echo Assembling hangman_art.asm...
ml.exe /c /nologo /Sg /Zi /Fo"hangman_art.obj" /Fl"hangman_art.lst" /I "%IRVINE%" /W3 /errorReport:prompt /Tahangman_art.asm
IF ERRORLEVEL 1 GOTO build_fail

echo Assembling music.asm...
ml.exe /c /nologo /Sg /Zi /Fo"music.obj" /Fl"music.lst" /I "%IRVINE%" /W3 /errorReport:prompt /Tamusic.asm
IF ERRORLEVEL 1 GOTO build_fail

echo Linking hangman.exe...
link.exe /ERRORREPORT:PROMPT /OUT:"hangman.exe" /NOLOGO /LIBPATH:%IRVINE% main.obj words.obj hangman_art.obj music.obj user32.lib irvine32.lib kernel32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /MANIFEST /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /manifest:embed /DEBUG /SUBSYSTEM:CONSOLE /TLBID:1 /DYNAMICBASE:NO /MACHINE:X86 /SAFESEH:NO
IF ERRORLEVEL 1 GOTO build_fail

echo.
echo Build successful: hangman.exe
GOTO end

:build_fail
echo.
echo Build failed.

:end
endlocal