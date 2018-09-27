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
#include "constant.au3"

Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

Func Login($character)
   If Not WinExists(GetWintitle($character)) Then
	  If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 10000) Then
		 Local $index = FindIndex($character)
		 MouseClick($MOUSE_CLICK_LEFT, $FIRST_CHARACTER[0], $FIRST_CHARACTER[1] + $index*17)
		 If LoggedIn($character) Then
			Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
			WinActivate($winTitle)
			Return True
		 Else
			Return False
		 EndIf
	  EndIf
   EndIf
EndFunc

Func LoggedIn($character)
   Local $windowCharacter = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & "]"
   For $i = 0 To 50
	  If WinExists($windowCharacter) Then
		 Return True
	  EndIf
	  Sleep(3000)
   Next
   Return False
EndFunc
