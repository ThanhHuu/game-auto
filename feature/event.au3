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

Func receiveEvent($character, $basicObj)
   Local $hwnd = GetWinTitle($character)
   If ActiveWindow($hwnd, 3000) Then
	  If OpenDuongChauMap(3000) Then
		 MouseClickDrag($MOUSE_CLICK_LEFT, 996, 256, 996, 293)
		 Sleep(100)
		 Local $npcPos = [870, 270]
		 If LeftClick($npcPos, $npcPos, 3000, 2) Then
			If LeftClick($NKVS_BUTTON_CLOSE_MAP, $NKVS_BUTTON_CLOSE_MAP, 3000) Then
			   WaitChangeMap($hwnd, 60000, 3000)
			   MouseClick("left", 514, 406)
			   Sleep(300)
			   MouseClick("left", 171, 298)
			   Sleep(300)
			   MouseClick("left", 171, 240)
			   Sleep(1000)
			   MouseClick("left", 171, 240)
			EndIf
		 EndIf
	  EndIf
   EndIf
   Return True
EndFunc
