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
#include "utils.au3"
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")


Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"
Func GoHome()
   If WinExists($WindowGame) Then
	  If Not WinActive($WindowGame) Then
		 WinActivate($WindowGame)
		 Sleep(500)
	  EndIf
	  If WinActive($WindowGame) Then
		 Send("{0}")
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, 140,265)
		 Sleep(1000)
		 MouseClick($MOUSE_CLICK_LEFT, 140,265)
		 Sleep(15000)
		 Send("{ESC}")
	  Else
		 Local $msg = StringFormat("%s - %s", "go_home", "Can not active window game")
		 WriteLog("go_home", $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "go_home", "Not found window game")
		 WriteLog("go_home", $msg)
   EndIf
EndFunc
