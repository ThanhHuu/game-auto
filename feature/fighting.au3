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

Local $fightingCounter = ObjCreate("Scripting.Dictionary")

;StartFighting()
Func StartFighting($character, $basicObj)
   WriteLogDebug("fighting", StringFormat("Start fighting in NhanMonQuan for %s", $character))
   MouseClick($MOUSE_CLICK_LEFT, 975, 305)
   Sleep(2000)
   Local $basePos = [212, 140]
   Local $clickPos = [168, 270]
   If ClickNpcWithinTimeOut($basePos, $clickPos, 1000) Then
	  TurnOnFighting($character, $basicObj)
   EndIf
   Return True
EndFunc

Func MoveBackCenterMap($character, $basicObj)
   WriteLogDebug("fighting", StringFormat("Move to center map in NhanMonQuan for %s", $character))
   Local $mapPos = [44, 50]
   If PressKeyWithinTimeOut($mapPos, "{TAB}", 1000) Then
	  Local $centerPos = [397, 405]
	  MovingToNpcWithinTimeOut($character, $centerPos, 10000)
   EndIf
   Return True
EndFunc

;MsgBox(0,"", EnterFightingMap("ChuLamDoiA"))
Func EnterFightingMap($character, $basicObj)
   Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
   If ActiveWindowWithinTimeOut($winTitle, 3000) Then
	  WriteLogDebug("fighting", StringFormat("Go to NhanMonQuan for %s", $character))
	  OpenDuongChauMap(1000)
	  MouseClickDrag($MOUSE_CLICK_LEFT,998,228, 998, 320)
	  Sleep(100)
	  Local $npcPos = [903, 420]
	  MovingToNpcWithinTimeOut($character, $npcPos, 60000)
	  Local $fightingPopUpPos = [286, 387]
	  Local $npcClickPos = [505, 400]
	  If ClickNpcWithinTimeOut($fightingPopUpPos, $npcClickPos, 2000) Then
		 Local $fightingPos1 = [35, 409]
		 Local $fightingPos2 = [708, 439]
		 Local $fightingPos3 = [545, 540]
		 Local $goFightingPos = [231, 288]
		 If ClickChangeMapWithinTimeOut($fightingPos1, $fightingPos2, $fightingPos3, $goFightingPos, 10000) Then
			Return True
		 Else
			WriteLogDebug("fighting", StringFormat("Seem like nhanmonquan done for %s", $character))
			Local $basePos = [181, 141]
			Local $clickPos = [171, 271]
			ClickNpcWithinTimeOut($basePos, $clickPos, 1000)
		 EndIf
	  EndIf
   EndIf
   Return False
EndFunc

;MsgBox(0,"", ContinueFighting("ChuLamDoiA"))
Func ContinueFighting($character, $basicObj)
   Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
   If ActiveWindowWithinTimeOut($winTitle, 3000) Then
	  MouseClick($MOUSE_CLICK_LEFT, 935, 444)
	  Sleep(500)
	  MouseClick($MOUSE_CLICK_LEFT, 832, 528)
	  Sleep(500)
	  If IsNeedMoveBackCenter($character) Then
		 WriteLogDebug("fighting", StringFormat("Back center map nhanmonquan for %s", $character))
		 MoveBackCenterMap($character, $basicObj)
	  EndIf
	  If TurnOnFighting($character, $basicObj) Then
		 Return False
	  EndIf
   EndIf
   WriteLog("fighting", StringFormat("Done NhanMonQuan for %s", $character))
   $fightingCounter.Remove($character)
   Return True
EndFunc

Func IsNeedMoveBackCenter($character)
   Local $currentCount = 0
   If $fightingCounter.Exists($character) Then
	  $currentCount = $fightingCounter.Item($character)
	  $fightingCounter.Remove($character)
   EndIf
   Local $result = $currentCount > 20
   if $currentCount > 20 Then
	  $currentCount = 0
   EndIf
   $fightingCounter.Add($character, $currentCount + 1)
   Return $result
EndFunc