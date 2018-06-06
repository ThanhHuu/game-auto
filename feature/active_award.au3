#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#RequireAdmin
#include <AutoItConstants.au3>
#include <File.au3>
#include <Date.au3>
#include "utils.au3"
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

DIM $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

;GetActiveAward()
Func GetActiveAward()
   If ActiveWindowWithinTimeOut($WindowGame, 1000) Then
	  Local $eventWinPos = [247, 90]
	  If PressKeyWithinTimeOut($eventWinPos, "{F11}", 1000) Then
		 MouseClick($MOUSE_CLICK_LEFT, 560, 125)
		 Sleep(100)
		 For $i = 0 To 4
			MouseClick($MOUSE_CLICK_LEFT, 260, 565)
			Sleep(100)
		 Next
		 PressKeyWithinTimeOut($eventWinPos, "{ESC}", 1000)
	  EndIf
   EndIf
EndFunc