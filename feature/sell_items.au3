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

Func SellItems()
   If WinExists($WindowGame) Then
	  If Not WinActive($WindowGame) Then
		 WinActivate($WindowGame)
		 Sleep(500)
	  EndIf
	  If WinActive($WindowGame) Then
		 Local $cellPointer = OpenSaleBag()
		 Local $countSaleCell = $cellPointer[2]/2
		 For $row = 0 To $countSaleCell
			Local $currentCellY = $cellPointer[1] + $row*$ITEM_CELL_HEIGHT
			For $column = 0 To 8
			   Local $currentCellX = $cellPointer[0] + $column*$ITEM_CELL_WIDTH
			   MouseClick($MOUSE_CLICK_LEFT, $currentCellX, $currentCellY)
			Next
		 Next
		 MouseClick($MOUSE_CLICK_LEFT, 525, 165)
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, 655, 500)
		 Sleep(100)
		 Send("{TAB}")
		 Send("{ESC}")
		 Sleep(1000)
	  Else
		 Local $msg = StringFormat("%s - %s", "sell_items", "Can not active window game")
		 WriteLog("sell_item", $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "sell_items", "Not found window game")
	  WriteLog("sell_item", $msg)
   EndIf
EndFunc

Func OpenSaleBag()
   MouseClick($MOUSE_CLICK_LEFT, 945, 696)
   Sleep(100)
   MouseClick($MOUSE_CLICK_LEFT, 863, 683)
   Sleep(100)
   Send("{TAB}")
   Send("{ESC}")
   Send("b")
   Sleep(1000)
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
   Send("b")
   Sleep(500)
   MouseClick($MOUSE_CLICK_LEFT, $endX - $ITEM_CELL_WIDTH * 3, $currentY)
   Sleep(100)
   MouseClick($MOUSE_CLICK_LEFT, $endX - $ITEM_CELL_WIDTH * 8, $currentY)
   Sleep(100)
   Local $topBag = [$endX - $ITEM_CELL_WIDTH * 8, $currentY - $countCell*$ITEM_CELL_HEIGHT]
   MouseClick($MOUSE_CLICK_LEFT, $topBag[0], $topBag[1])
   Sleep(100)
   Local $cellPointer = [$topBag[0], $topBag[1] + $ITEM_CELL_HEIGHT, $countCell]
   Return $cellPointer
EndFunc

