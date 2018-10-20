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
;OpenCard("")
Func OpenCard($paramDic)
   Local $hwnd = GetWinTitle($paramDic.Item($PARAM_CHAR))
   If ActiveWindow($hwnd, 3000) Then
	  If GUICtrlRead($UI_FEATURE_OPEN_CARD) = $GUI_CHECKED Then
		 Local $luckyPos = [450,590]
		 MouseClick($MOUSE_CLICK_LEFT, $luckyPos[0], $luckyPos[1])
		 Sleep(1000)
		 Local $luckyPointerPos = [390,260]
		 For $i = 0 To 2
			LeftClick($luckyPointerPos, $luckyPointerPos, 200)
			$luckyPointerPos[0] += 115
		 Next
		 $luckyPointerPos[0] -= 115
		 For $j = 0 To 2
			LeftClick($luckyPointerPos, $luckyPointerPos, 200)
			$luckyPointerPos[1] += 130
		 Next
		 Local $closePos = [711, 103]
		 LeftClick($luckyPointerPos, $closePos, 500)
		 Local $onlineExpPos = [484, 364]
		 Local $healPos = [498, 497]
		 LeftClick($onlineExpPos, $healPos, 700)
	  EndIf
   EndIf
   Return True
EndFunc

Func BuildOpenCardUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Mo the", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 30
   $UI_FEATURE_OPEN_CARD = GUICtrlCreateCheckbox("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetState($UI_FEATURE_OPEN_CARD, $GUI_CHECKED)
EndFunc
