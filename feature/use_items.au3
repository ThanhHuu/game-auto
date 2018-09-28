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

DIM $ITEM_CELL_WIDTH = 37
DIM $ITEM_CELL_HEIGHT = 40

;WinActivate($WINDOW_NKVS)
;UseItems("")
Func UseItems($paramDic)
   Local $cellPointer = OpenUseBag($paramDic)
   If $cellPointer <> False Then
	  Local $countUseCell = $cellPointer[2]/2
	  Local $close1 = [710, 115]
	  Local $basePx1 = PixelGetColor(714, 116)
	  For $row = 0 To $countUseCell
		 Local $currentCellY = $cellPointer[1] + $row*$ITEM_CELL_HEIGHT
		 For $column = 0 To 8
			Local $currentCellX = $cellPointer[0] + $column*$ITEM_CELL_WIDTH
			MouseMove($currentCellX, $currentCellY)
			MouseClick($MOUSE_CLICK_RIGHT, $currentCellX, $currentCellY, 5)
			If $basePx1 <> PixelGetColor(714, 116) Then
			   ClickNpcWithinTimeOut($close1, $close1, 1000)
			   ContinueLoop
			EndIf
		 Next
	  Next
	  PressKeyWithinTimeOut($BAG_POS, "{TAB}", 200)
	  PressKeyWithinTimeOut($BAG_POS, "{ESC}", 200)
   EndIf
   Return True
EndFunc

Func OpenUseBag($paramDic)
   Local $offExpPos = [909, 706]
   Local $offExpPopUpPos = [260, 201]
   If ClickNpcWithinTimeOut($offExpPopUpPos, $offExpPos, 1000) Then
	  PressKeyWithinTimeOut($offExpPopUpPos, "{TAB}", 200)
	  PressKeyWithinTimeOut($offExpPopUpPos, "{ESC}", 200)
   EndIf
   Local $assistantDonePos = [887, 688]
   ClickNpcWithinTimeOut($assistantDonePos, $assistantDonePos, 100)
   If PressKeyWithinTimeOut($BAG_POS, "b", 1000) Then
	  Local $y = WinGetClientSize($WINDOW_NKVS)[1]
	  Local $x = WinGetClientSize($WINDOW_NKVS)[0]
	  Local $midY = $y/2
	  Local $endX = $x - 80
	  MouseMove($endX, $midY)
	  Sleep(500)
	  Local $midPx = PixelGetColor($endX, $midY)
	  Local $currentY = $midY
	  Local $countCell = 0
	  While $midY < $y
		 $countCell += 1
		 $currentY += 20
		 MouseClick($MOUSE_CLICK_LEFT, $endX, $currentY)
		 Sleep(500)
		 If PixelGetColor($endX, $midY) <> $midPx And ($currentY - $midY) > 40 Then
			ExitLoop
		 Else
			MouseClick($MOUSE_CLICK_LEFT, $endX, $currentY)
		 EndIf
	  WEnd
	  If Not PressKeyWithinTimeOut($BAG_POS, "b", 1000) Then
		 Return False
	  EndIf
	  MouseClick($MOUSE_CLICK_LEFT, $endX - $ITEM_CELL_WIDTH * 3, $currentY)
	  Sleep(100)
	  Local $topBag = [$endX - $ITEM_CELL_WIDTH * 8, $currentY - $countCell*$ITEM_CELL_HEIGHT]
	  MouseClick($MOUSE_CLICK_LEFT, $topBag[0], $topBag[1])
	  Sleep(100)
	  Local $cellPointer = [$topBag[0], $topBag[1] + $ITEM_CELL_HEIGHT, $countCell]
	  Return $cellPointer
   EndIf
   Return False
EndFunc

