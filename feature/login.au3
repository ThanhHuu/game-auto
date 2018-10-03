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

Func Login($paramDic)
   Local $character = $paramDic.Item($PARAM_CHAR)
   If WinExists(GetWintitle($character)) Then
	  Return True
   EndIf
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 3000) Then
	  MouseClick($MOUSE_CLICK_LEFT, $FIRST_CHARACTER[0], $FIRST_CHARACTER[1])
	  If LoggedIn($character) Then
		 WinActivate(GetWintitle($character))
		 Return True
	  EndIf
   EndIf
   Return False
EndFunc

Func LoggedIn($character)
   For $i = 0 To 50
	  If WinExists(GetWintitle($character)) Then
		 Return True
	  EndIf
	  Sleep(3000)
   Next
   Return False
EndFunc
