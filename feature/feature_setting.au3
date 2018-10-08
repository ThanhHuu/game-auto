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
   Local $posObj = ObjCreate("Scripting.Dictionary")
   If GUICtrlRead($UI_FEATURE_HIDE_GRAPHIC) = $GUI_CHECKED Then
	  Local $pos1 = [334, 270]
	  Local $pos2 = [531, 270]
	  Local $pos3 = [705, 270]
	  $posObj.Add(1, $pos1)
	  $posObj.Add(2, $pos2)
	  $posObj.Add(3, $pos3)

	  Local $pos4 = [320, 350]
	  Local $pos5 = [500, 350]
	  Local $pos6 = [665, 350]
	  $posObj.Add(4, $pos4)
	  $posObj.Add(5, $pos5)
	  $posObj.Add(6, $pos6)

	  Local $pos7 = [351, 430]
	  Local $pos8 = [351, 460]
	  Local $pos9 = [351, 490]
	  Local $pos10 = [351, 520]
	  $posObj.Add(7, $pos7)
	  $posObj.Add(8, $pos8)
	  $posObj.Add(9, $pos9)
	  $posObj.Add(10, $pos10)

	  Local $pos11 = [550, 430]
	  Local $pos12 = [550, 460]
	  Local $pos13 = [550, 490]
	  $posObj.Add(11, $pos11)
	  $posObj.Add(12, $pos12)
	  $posObj.Add(13, $pos13)
	  GUICtrlSetState($UI_FEATURE_HIDE_GRAPHIC, $GUI_UNCHECKED)
   Else
	  Local $pos2 = [531, 270]
	  $posObj.Add(2, $pos2)
   EndIf

   If ClickNpcWithinTimeOut($SYSTEM_POPUP, $BUTTON_SYSTEM, 2000) Then
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
			   For $pos In $posObj.Items
				  MouseClick($MOUSE_CLICK_LEFT, $pos[0], $pos[1])
			   Next
			   Local $btConfirmPos = [569, 570]
			   ClickNpcWithinTimeOut($btConfirmPos, $btConfirmPos, 2000)
			EndIf
		 EndIf
	  EndIf
	  PressKeyWithinTimeOut($popUpPos, "{ESC}", 500)
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