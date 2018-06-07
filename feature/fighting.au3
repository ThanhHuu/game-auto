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
#include "setting.au3"
#include "utils.au3"
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

;Fighting()
Func Fighting()
   If ActiveWindowWithinTimeOut($WindowGame, 2000) Then
	  OpenDuongChauMap(1000)
	  MouseClickDrag($MOUSE_CLICK_LEFT,998,228, 998, 320)
	  Sleep(100)
	  Local $npcPos = [903, 420]
	  MovingToNpc($npcPos)
	  Local $fightingPopUpPos = [286, 387]
	  Local $npcClickPos = [505, 400]
	  If ClickNpcWithinTimeOut($fightingPopUpPos, $npcClickPos, 2000) Then
		 Local $fightingPos1 = [35, 409]
		 Local $fightingPos2 = [708, 439]
		 Local $fightingPos3 = [545, 540]
		 Local $goFightingPos = [231, 288]
		 If ClickChangeMapWithinTimeOut($fightingPos1, $fightingPos2, $fightingPos3, $goFightingPos, 10000) Then
			StartFighting()
		 Else
			WriteLog("fighting", StringFormat("%s - %s", "fighting", "Seem like that nhanmonquan is done"))
			Local $basePos = [181, 141]
			Local $clickPos = [171, 271]
			ClickNpcWithinTimeOut($basePos, $clickPos, 1000)
		 EndIf
	  Else
		 WriteLog("fighting", StringFormat("%s - %s", "fighting", "Error click nhanmonquan"))
	  EndIf
   EndIf
EndFunc

;StartFighting()
Func StartFighting()
   MouseClick($MOUSE_CLICK_LEFT, 975, 305)
   Sleep(2000)
   Local $basePos = [212, 140]
   Local $clickPos = [168, 270]
   If ClickNpcWithinTimeOut($basePos, $clickPos, 1000) Then
	  Local $count = 0
	  While True
		 $count += 1
		 If $count = 50 Then
			$count = 0
			Local $mapPos = [44, 50]
			If PressKeyWithinTimeOut($mapPos, "{TAB}", 1000) Then
			   Local $centerPos = [397, 405]
			   MovingToNpc($centerPos)
			EndIf
		 EndIf
		 Sleep(1000)
		 If Not TurnOnFighting() Then
			Send("m")
			Sleep(1000)
			ExitLoop
		 EndIf
		 Sleep(5000)
		 MouseClick($MOUSE_CLICK_LEFT, 935, 444)
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, 832, 528)
		 Sleep(200)
	  WEnd
   EndIf
EndFunc


