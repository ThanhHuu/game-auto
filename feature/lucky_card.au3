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

Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

TryLuckyCard()
Func TryLuckyCard()
   If ActiveWindowWithinTimeOut($WindowGame, 2000) Then
	  Local $luckyPos = [450,590]
	  Local $px1 = PixelGetColor(370, 29), $px2 = PixelGetColor(400, 29), $px3 = PixelGetColor(430, 29)
	  MouseClick($MOUSE_CLICK_LEFT, $luckyPos[0], $luckyPos[1])
	  Sleep(1000)
	  If $px1 = PixelGetColor(370, 29) And $px2 = PixelGetColor(400, 29) And $px3 = PixelGetColor(430, 29) Then
		 Local $luckyPointerPos = [390,260]
		 For $i = 0 To 2
			ClickNpcWithinTimeOut($luckyPointerPos, $luckyPointerPos, 500)
			$luckyPointerPos[0] += 115
		 Next
		 $luckyPointerPos[0] -= 115
		 For $j = 0 To 2
			ClickNpcWithinTimeOut($luckyPointerPos, $luckyPointerPos, 500)
			$luckyPointerPos[1] += 130
		 Next
		 Local $closePos = [711, 103]
		 ClickNpcWithinTimeOut($luckyPointerPos, $closePos, 500)
		 Local $onlineExpPos = [484, 364]
		 PressKeyWithinTimeOut($onlineExpPos, "{ESC}", 1000)
	  EndIf
   EndIf
EndFunc