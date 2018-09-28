#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once
#RequireAdmin
#include <AutoItConstants.au3>
#include <File.au3>
#include <Date.au3>
#include "utils.au3"
#include "constant.au3"

;WinActivate($WINDOW_NKVS)
;SrollCircle("")
Func SrollCircle($paramDic)
   Local $luckyRoundPos = [788, 164]
   If PressKeyWithinTimeOut($luckyRoundPos, "j", 2000) Then
	  Local $winPos = [682, 181]
	  Local $npcPos = [820,420]
	  If ClickNpcWithinTimeOut($winPos, $npcPos, 1000) Then
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
	  PressKeyWithinTimeOut($luckyRoundPos, "{TAB}", 1000)
	  PressKeyWithinTimeOut($luckyRoundPos, "{ESC}", 1000)
   EndIf
   Return True
EndFunc
