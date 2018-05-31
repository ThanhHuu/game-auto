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

Func AssignTransporter()
   If WinExists($WindowGame) Then
	  WinActivate($WindowGame)
	  If WinActive($WindowGame) Then
		 Send("{0}")
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 195,485)
		 Sleep(8000)
		 ; Nhan thuong
		 MouseClick($MOUSE_CLICK_LEFT, 1150,550)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 700, 880)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 1250, 800)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 1500,300)
		 Sleep(500)

		 ; Dieu doi VanTieu
		 MouseClick($MOUSE_CLICK_LEFT, 1150,550)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 850, 550)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 720, 890)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT,760, 700)

		 Send("{ESC}")
	  Else
		 Local $msg = StringFormat("%s - %s", "assitant_2", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "assitant_2", "Not found window game")
		 _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc
