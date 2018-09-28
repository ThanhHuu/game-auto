#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
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
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

Func OnlineExp($paramDic)
   Local $pwdClose = [800, 231]
   MouseClick($MOUSE_CLICK_LEFT, $pwdClose[0], $pwdClose[1])
   Sleep(300)
   Local $receiveBt = [582, 521]
   MouseClick($MOUSE_CLICK_LEFT, $receiveBt[0], $receiveBt[1])
   Return True
EndFunc