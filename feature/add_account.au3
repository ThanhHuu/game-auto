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
Local $usr = "ngoc_anh1"
Local $pwd = "Ngoc@nh91"
Local $character = "ChuLamDoiA"

If WinExists($WINDOW_LOGIN) Then
   WinActivate($WINDOW_LOGIN)
   If WinActive($WINDOW_LOGIN) Then
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
   Else
	  Local $msg = StringFormat("%s - %s", "login", "Can not active window game")
	  _FileWriteLog($LOG_FILE, $msg)
   EndIf
Else
   Local $msg = StringFormat("%s - %s", "login", "Not found window game")
	  _FileWriteLog($LOG_FILE, $msg)
EndIf
