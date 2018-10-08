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
	  Local $count = 0
	  Local $checkSum = PixelChecksum($FIRST_CHARACTER[0], $FIRST_CHARACTER[1], $FIRST_CHARACTER[0] + 5, $FIRST_CHARACTER[1] + 5, 1, WinGetHandle($WINDOW_LOGIN))
	  While $checkSum = PixelChecksum($FIRST_CHARACTER[0], $FIRST_CHARACTER[1], $FIRST_CHARACTER[0] + 5, $FIRST_CHARACTER[1] + 5, 1, WinGetHandle($WINDOW_LOGIN))
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, $FIRST_CHARACTER[0], $FIRST_CHARACTER[1])
		 $count += 1
		 If $count = 10 Then
			WriteLogDebug("Login", "Error click character")
			ExitLoop
		 EndIf
	  WEnd

	  If LoggedIn($character) Then
		 WinActivate(GetWintitle($character))
		 Return True
	  EndIf
   EndIf
   If WinExists(GetWintitle(".*")) Or WinExists($WINDOW_NKVS) Then
	  ProcessClose("ClientX86.exe")
	  GUICtrlSetState($UI_FEATURE_HIDE_GRAPHIC, $GUI_CHECKED)
   EndIf
   Return False
EndFunc

Func LoggedIn($character)
   For $i = 0 To 5
	  If WinExists(GetWintitle($character)) Then
		 Return True
	  EndIf
	  Sleep(3000)
   Next
   Return False
EndFunc
