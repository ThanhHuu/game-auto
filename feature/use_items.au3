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
DIM $ITEM_CELL_WIDTH = 37
DIM $ITEM_CELL_HEIGHT = 40

;UseItems()
Func UseItems()
   If ActiveWindowWithinTimeOut($WindowGame, 2000) Then
	  Local $bagPos = [796, 362]
	  Local $cellPointer = OpenUseBag($bagPos)
	  If $cellPointer <> False Then
		 Local $countUseCell = $cellPointer[2]/2
		 Local $close1 = [710, 115]
		 Local $basePx1 = PixelGetColor(557, 485)
		 For $row = 0 To $countUseCell
			Local $currentCellY = $cellPointer[1] + $row*$ITEM_CELL_HEIGHT
			For $column = 0 To 8
			   Local $currentCellX = $cellPointer[0] + $column*$ITEM_CELL_WIDTH
			   MouseClick($MOUSE_CLICK_RIGHT, $currentCellX, $currentCellY)
			   If $basePx1 <> PixelGetColor(557, 485) Then
				  ClickNpcWithinTimeOut($close1, $close1, 1000)
				  ContinueLoop
			   Else
				  MouseClick($MOUSE_CLICK_RIGHT, $currentCellX, $currentCellY, 4)
			   EndIf
			Next
		 Next
		 PressKeyWithinTimeOut($bagPos, "{ESC}", 1000)
	  EndIf
   EndIf
EndFunc

Func OpenUseBag($bagPos)
   Local $offExpPos = [909, 706]
   Local $offExpPopUpPos = [260, 201]
   If ClickNpcWithinTimeOut($offExpPopUpPos, $offExpPos, 1000) Then
	  PressKeyWithinTimeOut($offExpPopUpPos, "{ESC}", 200)
   EndIf
   Local $assistantDonePos = [887, 688]
   ClickNpcWithinTimeOut($assistantDonePos, $assistantDonePos, 100)
   If PressKeyWithinTimeOut($bagPos, "b", 1000) Then
	  Local $y = WinGetClientSize($WindowGame)[1]
	  Local $x = WinGetClientSize($WindowGame)[0]
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
		 If PixelGetColor($endX, $midY) <> $midPx Then
			ExitLoop
		 Else
			MouseClick($MOUSE_CLICK_LEFT, $endX, $currentY)
		 EndIf
	  WEnd
	  If Not PressKeyWithinTimeOut($bagPos, "b", 1000) Then
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

