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
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

DIM $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"
Func TryLuckyRound()
   If WinExists($WindowGame) Then
	  WinActivate($WindowGame)
	  If WinActive($WindowGame) Then
		 Send("j")
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 1240,630)
		 Sleep(500)
		 For $i = 0 To 4
			MouseClick($MOUSE_CLICK_LEFT, 630,540, 2)
			Sleep(5000)
		 Next
		 MouseClick($MOUSE_CLICK_LEFT, 1050,790)
		 Sleep(500)
		 Send("{ESC}")
	  Else
		 Local $msg = StringFormat("%s - %s", "lucky_round", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "lucky_round", "Not found window game")
	  _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc
