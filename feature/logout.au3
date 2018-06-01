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

Local $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Local $WINDOW_GAME = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

Func Logout($currentY)
   If WinExists($WINDOW_LOGIN) Then
	  If Not WinActive($WINDOW_LOGIN) Then
		 WinActivate($WINDOW_LOGIN)
		 Sleep(500)
	  EndIf
	  If WinActive($WINDOW_LOGIN) Then
		 ; Click thoat game
		 MouseClick($MOUSE_CLICK_RIGHT , 14, $currentY)
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, 50, $currentY + 15)
		 Sleep(100)

		 ; click xoa khoi danh sach
		 MouseClick($MOUSE_CLICK_RIGHT , 14, $currentY)
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, 50, $currentY + 60)
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, 70, 100)
	  Else
		 Local $msg = StringFormat("%s - %s", "login", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "login", "Not found window game")
		 _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc