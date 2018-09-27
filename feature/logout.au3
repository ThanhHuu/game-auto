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
#include "utils.au3"
#include <GuiListView.au3>
#include <Process.au3>
#include "constant.au3"

Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

;Logout("PhanSanDoiA")
Func Logout($character)
   If ActiveWindowWithinTimeOut(GetWintitle($character), 3000) Then
	  Send("{TAB}")
	  Send("{ESC}")
	  MouseClick($MOUSE_CLICK_LEFT, $BUTTON_SYSTEM[0], $BUTTON_SYSTEM[1])
	  Sleep(1000)
	  MouseClick($MOUSE_CLICK_LEFT, $BUTTON_SYSTEM_RELOGIN[0], $BUTTON_SYSTEM_RELOGIN[1])
	  Sleep(1000)
	  MouseClick($MOUSE_CLICK_LEFT, $BUTTON_SYSTEM_EXIT_YES[0], $BUTTON_SYSTEM_EXIT_YES[1])
	  Return True
   EndIf
   Return False
EndFunc