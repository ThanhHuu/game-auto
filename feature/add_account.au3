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
#include "logout.au3"
Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

Dim $WAIT_LOAD = 5000;
Local $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Local $WINDOW_GAME = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

Func AddAccount($usr, $pwd, $character)
   If WinExists($WINDOW_LOGIN) Then
	  If Not WinActive($WINDOW_LOGIN) Then
		 WinActivate($WINDOW_LOGIN)
		 Sleep(500)
	  EndIf
	  If WinActive($WINDOW_LOGIN) Then
		 Local $count = 0
		 Local $maxLoop = 5
		 While $count < $maxLoop
			$count += 1
			MouseClick($MOUSE_CLICK_LEFT, 160, 260)
			Sleep(100)
			Send("{BS 32}")
			Send("{DEL 32}")
			Send($usr)
			Send("{TAB}")
			Send($pwd)
			Send("{TAB}")
			Send($character)
			Sleep(100)
			MouseClick($MOUSE_CLICK_LEFT, 260, 220)
			Sleep(100)
			If WinExists("[TITLE:Thông báo;CLASS:#32770]") Then
			   ControlClick("[TITLE:Thông báo;CLASS:#32770]", "", "[CLASS:Button;INSTANCE:1]")
			   Logout(34)
			Else
			   ExitLoop
			EndIf
		 WEnd
	  Else
		 Local $msg = StringFormat("%s - %s", "add_account", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "add_account", "Not found window game")
	  _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc