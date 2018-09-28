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
;OpenCard("")
Func OpenCard($paramDic)
   Local $luckyPos = [450,590]
   MouseClick($MOUSE_CLICK_LEFT, $luckyPos[0], $luckyPos[1])
   Sleep(1000)
   Local $luckyPointerPos = [390,260]
   For $i = 0 To 2
	  ClickNpcWithinTimeOut($luckyPointerPos, $luckyPointerPos, 200)
	  $luckyPointerPos[0] += 115
   Next
   $luckyPointerPos[0] -= 115
   For $j = 0 To 2
	  ClickNpcWithinTimeOut($luckyPointerPos, $luckyPointerPos, 200)
	  $luckyPointerPos[1] += 130
   Next
   Local $closePos = [711, 103]
   ClickNpcWithinTimeOut($luckyPointerPos, $closePos, 500)
   Local $onlineExpPos = [484, 364]
   PressKeyWithinTimeOut($onlineExpPos, "{TAB}", 500)
   PressKeyWithinTimeOut($onlineExpPos, "{ESC}", 500)
   Local $healPos = [498, 497]
   ClickNpcWithinTimeOut($onlineExpPos, $healPos, 700)
   Return True
EndFunc
