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
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>

;WinActivate($WINDOW_NKVS)
;SrollCircle("")
Func SrollCircle($paramDic)
   If GUICtrlRead($UI_FEATURE_LUCKY_ROUND) = $GUI_CHECKED Then
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
   EndIf
   Return True
EndFunc

Func BuildSrollCircleUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Cau Phuc", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 30
   $UI_FEATURE_LUCKY_ROUND = GUICtrlCreateCheckbox("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetState($UI_FEATURE_LUCKY_ROUND, $GUI_CHECKED)
EndFunc