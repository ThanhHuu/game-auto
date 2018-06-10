#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#RequireAdmin
#include-once
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <GuiTab.au3>
#include <Date.au3>
#include <ColorConstants.au3>
#include <FontConstants.au3>
#include "feature\utils.au3"
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"
DIM $ITEM_CELL_WIDTH = 37
DIM $ITEM_CELL_HEIGHT = 40

Local $obj = ObjCreate("Scripting.Dictionary")

While(True)
   Local $listGame = WinList ("[REGEXPTITLE:Ngạo Kiếm Vô Song II.*]")
   For $i = 1 To $listGame[0][0]
	  Local $game = $listGame[$i][1]
	  OpenMultipleExp($game)
	  Sleep(2000)
   Next
   Sleep(2*60*60*1000)
WEnd

;OpenMultipleExp($WindowGame)
Func OpenMultipleExp($game)
   If ActiveWindowWithinTimeOut($game, 2000) Then
	  Local $bagPos = [796, 362]
	  Local $expPopPos = [365, 619]
	  Local $cellPointer
	  If $obj.Exists(WinGetTitle($game)) Then
		 $cellPointer = $obj.Item(WinGetTitle($game))
		 PressKeyWithinTimeOut($bagPos, "b", 3000)
	  Else
		 $cellPointer = OpenUseBag($bagPos)
		 $obj.Add(WinGetTitle($game), $cellPointer)
	  EndIf
	  Send("f")
	  Sleep(1000)
	  If $cellPointer <> False Then
		 Local $lastOptPos = [160, 575]
		 If RightClickPosWithinTimeOut($lastOptPos, $cellPointer, 3000) Then
			WriteLog("training-tool", "Start Open multiple exp")
			For $i = 0 To 5
			   If ClickNpcWithinTimeOut($expPopPos, $lastOptPos, 500) Then
				  ExitLoop
			   EndIf
			   $lastOptPos[1] -= 30
			Next
			PressKeyWithinTimeOut($bagPos, "{ESC}", 1000)
		 EndIf
	  EndIf
	  Send("f")
	  Sleep(1000)
	  WinSetState($game, "", @SW_MINIMIZE)
   EndIf
EndFunc

Func RightClickPosWithinTimeOut($winPos, $npcPos, $timeOut)
   Local $basePx = PixelGetColor($winPos[0], $winPos[1])
   MouseClick($MOUSE_CLICK_RIGHT, $npcPos[0], $npcPos[1])
   Local $maxLoop = $timeOut/100
   For $i = 0 To $maxLoop
	  Sleep(100)
	  If $basePx <> PixelGetColor($winPos[0], $winPos[1]) Then
		 Return True
	  EndIf
   Next
   WriteLog("training-tool", StringFormat("Right-Click [%d, %d] timeout after %d ms", $npcPos[0], $npcPos[1], $timeOut))
   Return False
EndFunc

Func OpenUseBag($bagPos)
   Local $offExpPos = [909, 706]
   Local $offExpPopUpPos = [260, 201]
   If ClickNpcWithinTimeOut($offExpPopUpPos, $offExpPos, 1000) Then
	  PressKeyWithinTimeOut($offExpPopUpPos, "{TAB}", 200)
	  PressKeyWithinTimeOut($offExpPopUpPos, "{ESC}", 200)
   EndIf
   Local $assistantDonePos = [887, 688]
   ClickNpcWithinTimeOut($assistantDonePos, $assistantDonePos, 1000)
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
		 If PixelGetColor($endX, $midY) <> $midPx And ($currentY - $midY) > 40 Then
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