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

;receiveEvent("BoTreMeGame©")
Func receiveEvent($character, $basicObj)
   Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
   If ActiveWindowWithinTimeOut($winTitle, 3000) Then
	  OpenDuongChauMap(1000)
	  MouseClickDrag($MOUSE_CLICK_LEFT, 996, 256, 996, 293)
	  Sleep(100)
	  Local $npcPos = [920, 270]
	  MovingToNpcWithinTimeOut($character, $npcPos, 60000)
	  MouseClick("left", 514, 406)
	  Sleep(300)
	  MouseClick("left", 171, 298)
	  Sleep(300)
	  MouseClick("left", 171, 240)
	  Sleep(1000)
	  MouseClick("left", 171, 240)
   EndIf
   Return True
EndFunc
