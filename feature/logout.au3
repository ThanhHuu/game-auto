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

Func Logout($paramDic)
   Local $order = $paramDic.Item($PARAM_ORDER)
   Local $hwnd = GetWinTitle($paramDic.Item($PARAM_CHAR))
   If ActiveWindow($hwnd, 3000) Then
	  ResetSystemButton()
	  For $i = 0 To 5
		 If LeftClick($BUTTON_SYSTEM, $BUTTON_SYSTEM, 2000) Then
			If LeftClick($SYSTEM_POPUP, $BUTTON_SYSTEM_RELOGIN, 2000) Then
			   LeftClick($BUTTON_SYSTEM_EXIT_YES, $BUTTON_SYSTEM_EXIT_YES, 2000)
			   Sleep(5000)
			   Return WinExists(GetWinTitleWithinOrder($order)) ? False : True
			EndIf
		 EndIf
		 WriteLogDebug("logout", "Do logout one more time")
	  Next
	  WriteLog("logout", "We must stop because can not login")
	  Exit
   EndIf
EndFunc

Func ResetSystemButton()
   While True
	  Local $buttonSysPx = PixelGetColor($BUTTON_SYSTEM[0], $BUTTON_SYSTEM[1])
	  MouseMove($BUTTON_SYSTEM[0], $BUTTON_SYSTEM[1])
	  Sleep(300)
	  If $buttonSysPx <> PixelGetColor($BUTTON_SYSTEM[0], $BUTTON_SYSTEM[1]) Then
		 ExitLoop
	  EndIf
	  MouseMove($BUTTON_SYSTEM[0] - 100, $BUTTON_SYSTEM[1])
	  Send("{ESC}")
	  Sleep(300)
   WEnd
EndFunc