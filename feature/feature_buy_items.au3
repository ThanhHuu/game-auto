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

Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

;Local $paramDic = ObjCreate("Scripting.Dictionary")
;$paramDic.Add($PARAM_CHAR, "VũPhươngDoiB")
;BuyItemGoHome($paramDic)
Func BuyItemGoHome($paramDic)
   Local $hwnd = GetWinTitle($paramDic.Item($PARAM_CHAR))
   If ActiveWindow($hwnd, 3000) Then
	  If Not PressKey($MOVING_CHOICE_POPUP, "{0}", 3000) Then
		 WriteLogDebug("feature_buy_items", "Need to buy item")
		 OpenDuongChauMap(3000)
		 Local $npcPos = [870,330]
		 LeftClick($npcPos, $npcPos, 1000, 2)
		 Sleep(5000)
		 If LeftClick($NKVS_BUTTON_CLOSE_MAP, $NKVS_BUTTON_CLOSE_MAP, 3000) Then
			WaitChangeMap($hwnd, 60000, 2000)
			If IsFindOutNpcPos($paramDic.Item($PARAM_CHAR)) Then
			   Local $shopOpt = [194, 243]
			   If LeftClick($shopOpt, MouseGetPos(), 5000) Then
				  Local $bagIcon = [1002, 406]
				  If LeftClick($bagIcon, $shopOpt, 2000) Then
					 Local $itemPos = [170,250]
					 Local $itemPopUp = [614, 310]
					 If LeftClick($itemPopUp, $itemPos, 5000) Then
						WriteLogDebug("buy-items", "Buy 60 phu hoi thanh")
						Send(60)
						Local $confirmBt1 = [520, 365]
						If Not LeftClick($itemPopUp, $confirmBt1, 1000) Then
						   Local $confirmBt2 = [520, 450]
						   LeftClick($itemPopUp, $confirmBt2, 300)
						EndIf
					 EndIf
				  EndIf
				  PressKey($shopOpt, "{ESC}", 3000)
			   EndIf
			EndIf
		 EndIf
	  Else
		 PressKey($MOVING_CHOICE_POPUP, "{ESC}", 3000)
	  EndIf
   EndIf
   Return True
EndFunc

Func BuildBuyItemsUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Mua Phu", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 30
   Local $buyItem = GUICtrlCreateCheckbox("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetState($buyItem, $GUI_DISABLE)
   GUICtrlSetState($buyItem, $GUI_CHECKED)
EndFunc
