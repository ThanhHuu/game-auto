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
#include "utils.au3"
Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

Dim $WAIT_LOAD = 5000;
Local $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Local $WINDOW_GAME = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

Func AddAccount($usr, $pwd, $character)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 2000) Then
	  For $i = 0 To 4
		 MouseClick($MOUSE_CLICK_LEFT, 160, 260)
		 Sleep(100)
		 Send("{BS 32}")
		 Send("{DEL 32}")
		 Sleep(100)
		 Send($usr)
		 Send("{TAB}")
		 Sleep(100)
		 Send($pwd)
		 Send("{TAB}")
		 Sleep(100)
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
	  Next
   EndIf
EndFunc