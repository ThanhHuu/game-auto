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

Func TryLuckyCard()
   If WinExists($WindowGame) Then
	  If Not WinActive($WindowGame) Then
		 WinActivate($WindowGame)
		 Sleep(500)
	  EndIf
	  If WinActive($WindowGame) Then
		 MouseClick($MOUSE_CLICK_LEFT, 450,590)
		 Sleep(500)
		 Local $firstY = 260;
		 Local $currentX = 390;
		 For $i = 0 To 2
			MouseClick($MOUSE_CLICK_LEFT, $currentX ,$firstY)
			Sleep(100)
			$currentX += 115
		 Next
		 $currentX -= 115
		 For $j = 0 To 2
			MouseClick($MOUSE_CLICK_LEFT, $currentX ,$firstY)
			Sleep(100)
			$firstY += 130
		 Next
		 Send("{ESC}")
	  Else
		 Local $msg = StringFormat("%s - %s", "lucky_card", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "lucky_card", "Not found window game")
	  _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc