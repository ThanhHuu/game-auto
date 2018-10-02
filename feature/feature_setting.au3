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
#include "constant.au3"
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>

Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

;WinActivate($WINDOW_NKVS)
;TurnOffGraphic("")
Func TurnOffGraphic($paramDic)
   If GUICtrlRead($UI_FEATURE_HIDE_GRAPHIC) = $GUI_CHECKED Then
	  Local $basePos = [508, 268]
	  For $i = 0 To 1
		 If ClickNpcWithinTimeOut($basePos, $BUTTON_SYSTEM, 2000) Then
			Local $popUpPos = [250, 188]
			If ClickNpcWithinTimeOut($popUpPos, $BUTTON_SYSTEM_SETUP, 2000) Then
			   MouseClick($MOUSE_CLICK_LEFT, 390, 225)
			   Sleep(200)
			   MouseClick($MOUSE_CLICK_LEFT, 340, 370)
			   Sleep(200)
			   Local $advanceBtPos = [439, 526]
			   Local $advanceOptPos = [339, 527]
			   If ClickNpcWithinTimeOut($advanceBtPos, $advanceOptPos, 2000) Then
				  If ClickNpcWithinTimeOut($advanceBtPos, $advanceBtPos, 2000) Then
					 MouseClick($MOUSE_CLICK_LEFT, 334, 270)
					 MouseClick($MOUSE_CLICK_LEFT, 531, 270)
					 MouseClick($MOUSE_CLICK_LEFT, 705, 270)

					 MouseClick($MOUSE_CLICK_LEFT, 320, 350)
					 MouseClick($MOUSE_CLICK_LEFT, 500, 350)
					 MouseClick($MOUSE_CLICK_LEFT, 665, 350)

					 MouseClick($MOUSE_CLICK_LEFT, 351, 430)
					 MouseClick($MOUSE_CLICK_LEFT, 351, 460)
					 MouseClick($MOUSE_CLICK_LEFT, 351, 490)
					 MouseClick($MOUSE_CLICK_LEFT, 351, 520)

					 MouseClick($MOUSE_CLICK_LEFT, 550, 430)
					 MouseClick($MOUSE_CLICK_LEFT, 550, 460)
					 MouseClick($MOUSE_CLICK_LEFT, 550, 490)

					 Local $btConfirmPos = [569, 570]
					 ClickNpcWithinTimeOut($btConfirmPos, $btConfirmPos, 2000)
				  EndIf
			   EndIf
			EndIf
			PressKeyWithinTimeOut($popUpPos, "{ESC}", 500)
			ExitLoop
		 EndIf
	  Next
   EndIf
   Return True
EndFunc

Func BuildTurnOffGraphicUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("An Giao Dien", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 30
   $UI_FEATURE_HIDE_GRAPHIC = GUICtrlCreateCheckbox("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetState($UI_FEATURE_HIDE_GRAPHIC, $GUI_CHECKED)
   GUICtrlSetState($UI_FEATURE_HIDE_GRAPHIC, $GUI_DISABLE)
EndFunc