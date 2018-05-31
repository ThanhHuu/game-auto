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

DIM $TIME_TO_STORE=20000
DIM $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"
Func BuyItems($level)
   If WinExists($WindowGame) Then
	  WinActivate($WindowGame)
	  If WinActive($WindowGame) Then
		 Send("{TAB}")
		 ; Mua PhuHoiThanh
		 MouseClick($MOUSE_CLICK_LEFT, 1400,490, 2)
		 Sleep($TIME_TO_STORE)
		 Send("{ESC}")
		 MouseClick($MOUSE_CLICK_LEFT, 750, 600)
		 Sleep(300)
		 MouseClick($MOUSE_CLICK_LEFT, 225,360)
		 Sleep(300)
		 MouseClick($MOUSE_CLICK_LEFT, 240,360)
		 Sleep(300)
		 Send("20")
		 MouseClick($MOUSE_CLICK_LEFT, 780, 670)
		 Sleep(300)
		 Send("{ESC}")
		 If $level = 80 Then
			; Mua Mana,ThucAn
			MouseClick($MOUSE_CLICK_LEFT, 20, 400)
			Sleep(3000)
			MouseClick($MOUSE_CLICK_LEFT, 225,400)
			Sleep(300)
			MouseClick($MOUSE_CLICK_LEFT, 410,360)
			Sleep(300)
			Send("82")
			MouseClick($MOUSE_CLICK_LEFT,780, 670)
			Sleep(300)
			MouseClick($MOUSE_CLICK_LEFT, 410,410)
			Sleep(300)
			Send("3")
			MouseClick($MOUSE_CLICK_LEFT,780, 670)
			Send("{ESC}")
		 EndIf
	  Else
		 Local $msg = StringFormat("%s - %s", "buy_items", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "buy_items", "Not found window game")
		 _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc
