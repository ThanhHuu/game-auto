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
		 MouseClick($MOUSE_CLICK_LEFT, 930,330, 2)
		 Sleep($TIME_TO_STORE)
		 Send("{ESC}")
		 MouseClick($MOUSE_CLICK_LEFT, 500, 400)
		 Sleep(300)
		 MouseClick($MOUSE_CLICK_LEFT, 155,240)
		 Sleep(300)
		 MouseClick($MOUSE_CLICK_LEFT, 155,240)
		 Sleep(300)
		 Send("20")
		 MouseClick($MOUSE_CLICK_LEFT, 525, 370)
		 Sleep(300)
		 Send("{ESC}")
		 If $level = 80 Then
			; Mua Mana,ThucAn
			MouseClick($MOUSE_CLICK_LEFT, 15, 270)
			Sleep(5000)
			MouseClick($MOUSE_CLICK_LEFT, 150,260)
			Sleep(300)
			MouseClick($MOUSE_CLICK_LEFT, 270,250)
			Sleep(300)
			Send("82")
			MouseClick($MOUSE_CLICK_LEFT,525, 370)
			Sleep(300)
			MouseClick($MOUSE_CLICK_LEFT, 280,290)
			Sleep(300)
			Send("3")
			MouseClick($MOUSE_CLICK_LEFT,525, 370)
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
