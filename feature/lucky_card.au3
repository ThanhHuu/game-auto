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

;TryLuckyCard("ChuLamDoiB")
Func TryLuckyCard($character, $basicObj)
   Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
   If ActiveWindowWithinTimeOut($winTitle, 3000) Then
	  WriteLog("lucky_card", "Run lat the may man")
	  Local $luckyPos = [450,590]
	  MouseClick($MOUSE_CLICK_LEFT, $luckyPos[0], $luckyPos[1])
	  Sleep(1000)
	  Local $luckyPointerPos = [390,260]
	  For $i = 0 To 2
		 ClickNpcWithinTimeOut($luckyPointerPos, $luckyPointerPos, 300)
		 $luckyPointerPos[0] += 115
	  Next
	  $luckyPointerPos[0] -= 115
	  For $j = 0 To 2
		 ClickNpcWithinTimeOut($luckyPointerPos, $luckyPointerPos, 300)
		 $luckyPointerPos[1] += 130
	  Next
	  Local $closePos = [711, 103]
	  ClickNpcWithinTimeOut($luckyPointerPos, $closePos, 500)
	  Local $onlineExpPos = [484, 364]
	  PressKeyWithinTimeOut($onlineExpPos, "{TAB}", 1000)
	  PressKeyWithinTimeOut($onlineExpPos, "{ESC}", 1000)
	  Local $healPos = [498, 497]
	  ClickNpcWithinTimeOut($onlineExpPos, $healPos, 700)
   EndIf
EndFunc