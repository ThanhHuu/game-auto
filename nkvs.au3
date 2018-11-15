#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include-once
#RequireAdmin

#include "extension.au3"


;FindNpc("BoTreMeGame©")
Func DoOpenCityMap($character)
   Local $tabCoord = [1002, 167]
   If GraphicClick($tabCoord) Then
	  Local $btWordMap = [74, 78]
	  GraphicClick($btWordMap)
	  Local $cityCoord = [782, 432]
	  GraphicClick($cityCoord)
   EndIf
EndFunc

Func DoMoveToNpcLeQuan($character)
   DoOpenCityMap($character)
   Local $fromCoord = [996, 288]
   Local $toCoord = [997, 308]
   MouseClickDragEx($fromCoord, $toCoord)
   Local $npcCoord = [869, 366]
   GraphicClick($npcCoord, "left", 2)
   Sleep(2000)
   Local $closeMapCoord = [993, 45]
   GraphicClick($closeMapCoord)
EndFunc

Func DoScanAroundCoord($basicCursor, $coord, $stepX, $stepY)
   For $i = 0 To 5
	  For $j = 0 To 4
		 Local $aroundCoord = [$coord[0] + $i*$stepX, $coord[1] + $j*$stepY]
		 MouseMove($aroundCoord[0], $aroundCoord[1])
		 Sleep(100)
		 If $basicCursor <> _WinAPI_GetCursorInfo()[2] Then
			Return True
		 EndIf
	  Next
   Next
   Return False
EndFunc

Func DoFindNpc($character)
   Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
   Local $winSize = WinGetClientSize($hwndCharacter)
   Local $centerCoord = [$winSize[0]/2, $winSize[1]/2]
   MouseMove(1, 1)
   Sleep(300)
   Local $cursor = _WinAPI_GetCursorInfo()[2]
   If DoScanAroundCoord($cursor, $centerCoord, -40, 40) Then
	  Return True
   ElseIf DoScanAroundCoord($cursor, $centerCoord, -40, -40) Then
	  Return True
   ElseIf DoScanAroundCoord($cursor, $centerCoord, 40, 40) Then
	  Return True
   ElseIf DoScanAroundCoord($cursor, $centerCoord, 40, -40) Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func DoWaitChangeMap($hwnd, $watingTime, $delay = 3000, $offset = 50)
   Local $winSize = WinGetClientSize($hwnd)
   Local $maxCount = $watingTime/$delay
   For $i = 1 To $maxCount
	  Local $topLeft = PixelGetColor($winSize[0] - $offset, $winSize[1] - $offset)
	  Local $topRight = PixelGetColor($winSize[0] + $offset, $winSize[1] - $offset)
	  Local $bottomRight = PixelGetColor($winSize[0] + $offset, $winSize[1] + $offset)
	  Local $bottomLeft = PixelGetColor($winSize[0] - $offset, $winSize[1] + $offset)
	  Sleep($delay)
	  Local $count = 0
	  If $topLeft = PixelGetColor($winSize[0] - $offset, $winSize[1] - $offset) Then
		 $count += 1
	  EndIf
	  If $topRight = PixelGetColor($winSize[0] + $offset, $winSize[1] - $offset) Then
		 $count += 1
	  EndIf
	  If $bottomRight = PixelGetColor($winSize[0] + $offset, $winSize[1] + $offset) Then
		 $count += 1
	  EndIf
	  If $bottomLeft = PixelGetColor($winSize[0] - $offset, $winSize[1] + $offset) Then
		 $count += 1
	  EndIf
	  If $count > 3 Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc

Func DoClosePopUp()
   Local $sysCoord = [1002, 735]
   For $i = 1 To 10
	  Send("{ESC}")
	  Sleep(500)
	  Local $sysPx = PixelGetColor($sysCoord[0], $sysCoord[1])
	  MouseMove($sysCoord[0], $sysCoord[1])
	  Sleep(500)
	  If $sysPx = PixelGetColor($sysCoord[0], $sysCoord[1]) Then
		 GraphicClick($sysCoord)
		 ExitLoop
	  EndIf
	  MouseMove($sysCoord[0] - 100, $sysCoord[1])
   Next
EndFunc

Func DoHideAllNpc()
   MouseClickEx(800, 231)
   Local $sysCoord = [1002, 735]
   If GraphicClick($sysCoord) Then
	  Local $setupCoord = [506, 318]
	  If GraphicClick($setupCoord) Then
		 MouseClickEx(381, 230)
		 MouseClickEx(356, 524)
		 Local $advanceConfigureCoord = [434, 528]
		 If GraphicClick($advanceConfigureCoord) Then
			If ChangeHover(294, 269) Then
			   MouseClickEx(293, 266)
			   MouseClickEx(464, 266)
			   MouseClickEx(633, 266)

			   MouseClickEx(296, 350)
			   MouseClickEx(467, 350)
			   MouseClickEx(639, 350)

			   MouseClickEx(327, 424)
			   MouseClickEx(513, 424)

			   MouseClickEx(327, 456)
			   MouseClickEx(513, 456)

			   MouseClickEx(327, 486)
			   MouseClickEx(513, 486)

			   MouseClickEx(327, 519)
			Else
			   MouseClickEx(464, 266)
			EndIf
			Local $confirmCoord = [563, 571]
			GraphicClick($confirmCoord)
		 EndIf
		 Local $exitCoord = [722, 567]
		 GraphicClick($exitCoord)
	  EndIf
   EndIf
EndFunc

Func DoReceiveActivityAward()
   Local $receiveCoord = [253, 569]
   If GraphicSend("{F11}", $receiveCoord) Then
	  Local $awardTabCoord = [531, 128]
	  GraphicClick($awardTabCoord)
	  For $i = 1 To 5
		 MouseClickEx($receiveCoord[0], $receiveCoord[1], 400)
	  Next
	  GraphicSend("{ESC}", $receiveCoord)
   EndIf
EndFunc
