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
Func Logout($paramDic)
   If ClickNpcWithinTimeOut($SYSTEM_POPUP, $BUTTON_SYSTEM, 2000) Then
	  If ClickNpcWithinTimeOut($SYSTEM_POPUP, $BUTTON_SYSTEM_RELOGIN, 2000) Then
		 Return ClickNpcWithinTimeOut($BUTTON_SYSTEM_EXIT_YES, $BUTTON_SYSTEM_EXIT_YES, 2000)
	  EndIf
   EndIf
   Return False
EndFunc