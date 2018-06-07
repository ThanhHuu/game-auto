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

;TryLuckyRound()
Func TryLuckyRound()
   If ActiveWindowWithinTimeOut($WindowGame, 1000) Then
	  Local $luckyRoundPos = [788, 164]
	  If PressKeyWithinTimeOut($luckyRoundPos, "j", 2000) Then
		 Local $winPos = [682, 161]
		 Local $npcPos = [820,420]
		 If ClickNpcWithinTimeOut($winPos, $npcPos, 10) Then
			Local $beforePx = PixelGetColor(688, 524)
			For $i = 0 To 4
			   MouseClick($MOUSE_CLICK_LEFT, 415,370, 2)
			   Sleep(5000)
			   If PixelGetColor(688, 524) <> $beforePx Then
				  ExitLoop
			   EndIf
			Next
			MouseClick($MOUSE_CLICK_LEFT, 715,525)
			Sleep(100)
		 EndIf
		 PressKeyWithinTimeOut($luckyRoundPos, "{ESC}", 1000)
	  EndIf
   EndIf
EndFunc
