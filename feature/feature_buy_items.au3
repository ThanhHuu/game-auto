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

Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

;WinActivate($WINDOW_NKVS)
;BuyItemGoHome(10)
Func BuyItemGoHome($paramDic)
   If Not PressKeyWithinTimeOut($MOVING_CHOICE_POPUP, "{0}", 3000) Then
	  OpenDuongChauMap(1000)
	  Local $npcPos = [930,330]
	  MovingToNpcWithinTimeOut($npcPos, 60000)
	  Local $askShopPos = [209, 140]
	  Local $askShopClickPos = [500, 400]
	  If ClickNpcWithinTimeOut($askShopPos, $askShopClickPos, 5000) Then
		 Local $shopPos = [77, 268]
		 Local $openShopPos = [160,240]
		 If ClickNpcWithinTimeOut($shopPos, $openShopPos, 2000) Then
			Local $itemPos = [170,250]
			Local $itemPopUp = [502, 334]
			If ClickNpcWithinTimeOut($itemPopUp, $itemPos, 5000) Then
			   Send(60)
			   Local $confirmBt1 = [520, 365]
			   ClickNpcWithinTimeOut($confirmBt1, $confirmBt1, 300)
			   Local $confirmBt2 = [520, 450]
			   ClickNpcWithinTimeOut($confirmBt1, $confirmBt2, 300)
			EndIf
		 EndIf
	  EndIf
   EndIf
   Send("{TAB}")
   Sleep(300)
   Send("{ESC}")
   Return True
EndFunc

Func BuildBuyItemsUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Mua Phu", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 30
   GUICtrlCreateCheckbox("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
EndFunc
