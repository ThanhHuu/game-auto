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

DIM $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

;TryLuckyCard()
Func TryLuckyCard()
   If ActiveWindowWithinTimeOut($WindowGame, 2000) Then
	  Local $luckyPos = [450,590]
	  Local $count = 0
	  For $i = 0 To 10
		 Local $currentPx = PixelGetColor($luckyPos[0], $luckyPos[1])
		 Sleep(100)
		 If $currentPx <> PixelGetColor($luckyPos[0], $luckyPos[1]) Then
			$count += 1
		 EndIf
	  Next
	  If $count > 4 Then
		 Local $luckyPointerPos = [390,260]
		 If ClickNpcWithinTimeOut($luckyPointerPos, $luckyPos, 1000) Then
			For $i = 0 To 2
			   ClickNpcWithinTimeOut($luckyPointerPos, $luckyPointerPos, 500)
			   $luckyPointerPos[0] += 115
			Next
			$luckyPointerPos[0] -= 115
			For $j = 0 To 2
			   ClickNpcWithinTimeOut($luckyPointerPos, $luckyPointerPos, 500)
			   $luckyPointerPos[1] += 130
			Next
			PressKeyWithinTimeOut($luckyPointerPos, "{ESC}", 1000)
		 EndIf
	  EndIf
   EndIf
EndFunc