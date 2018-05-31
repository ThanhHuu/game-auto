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


Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

Dim $WAIT_LOAD = 5000;
Local $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Local $WINDOW_GAME = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"
Dim $FIRST_Y = 35

Func Login($currentY)
   If WinExists($WINDOW_LOGIN) Then
	  WinActivate($WINDOW_LOGIN)
	  If WinActive($WINDOW_LOGIN) Then
		 MouseClick($MOUSE_CLICK_LEFT, 14, $currentY)
		 While True
			If WinExists($WINDOW_GAME) Then
			   ExitLoop
			EndIf
			Sleep(2000)
		 WEnd
		 Sleep($WAIT_LOAD)
		 WinActivate($WINDOW_GAME)
	  Else
		 Local $msg = StringFormat("%s - %s", "login", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "login", "Not found window game")
		 _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc