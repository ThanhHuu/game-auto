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
#include "logout.au3"


Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Local $FIRST_Y = 35

Func Login($character)
   If LoggedIn($character) Then
	  WriteLogDebug("login", StringFormat("%s loggedin", $character))
   Else
	  If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 10000) Then
		 Local $index = FindIndex($character)
		 MouseClick($MOUSE_CLICK_LEFT, 14, $FIRST_Y + $index*17)
		 WriteLogDebug("login", StringFormat("Login for %s", $character))
		 If WaitingLogin($character) Then
			Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
			WinActivate($winTitle)
			Return True
		 Else
			Logout($character)
			Return False
		 EndIf
	  EndIf
   EndIf
EndFunc

Func WaitingLogin($character)
   Local $windowCharacter = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & "]"
   For $i = 0 To 80
	  If WinExists($windowCharacter) Then
		 Return True
	  EndIf
	  Sleep(1000)
   Next
   Return False
EndFunc

Func LoggedIn($character)
   Local $windowCharacter = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & "]"
   Return WinExists($windowCharacter)
EndFunc
