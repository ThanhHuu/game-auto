#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#RequireAdmin
#include <Date.au3>
#include <File.au3>
#include "utils.au3"
Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Local $WINDOW_GAME = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"
Local $FIRST_Y = 35

Func Login($index, $character)
   If LoggedIn($character) Then
	  Local $msg = StringFormat("%s - %s", "login", StringFormat("%s loggedin", $character))
	  WriteLog("login", $msg)
   Else
	  If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 2000) Then
		 MouseClick($MOUSE_CLICK_LEFT, 14, $FIRST_Y + $index*17)
		 WaitingLogin($character)
		 WinActivate($WINDOW_GAME)
	  EndIf
   EndIf
EndFunc

Func WaitingLogin($character)
   Local $windowCharacter = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & "]"
   For $i = 0 To 20
	  If WinExists($windowCharacter) Then
		 ExitLoop
	  EndIf
	  Sleep(2000)
   Next
EndFunc

Func LoggedIn($character)
   Local $windowCharacter = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & "]"
   Return WinExists($windowCharacter)
EndFunc