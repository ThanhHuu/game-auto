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
	  If Not WinActive($WindowGame) Then
		 WinActivate($WindowGame)
		 Sleep(500)
	  EndIf
	  If WinActive($WindowGame) Then
		 Send("{0}")
		 Sleep(1000)
		 MouseClick($MOUSE_CLICK_LEFT,160,325)
		 Sleep(8000)
		 ; Nhan thuong
		 MouseClick($MOUSE_CLICK_LEFT, 765, 370)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 470, 590)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 865, 530)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 1000,210)
		 Sleep(100)
		 Send("{ESC}")

		 ; Dieu doi VanTieu
		 MouseClick($MOUSE_CLICK_LEFT, 765, 370)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 570, 375)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT, 470, 590)
		 Sleep(500)
		 MouseClick($MOUSE_CLICK_LEFT,515, 465)
		 Sleep(100)

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
