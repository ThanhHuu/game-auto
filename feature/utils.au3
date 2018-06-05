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
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")
Local $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Local $WINDOW_GAME = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

Func PressMap()
   If WinExists($WINDOW_GAME) Then
	  If Not WinActive($WINDOW_GAME) Then
		 WinActivate($WINDOW_GAME)
		 Sleep(500)
	  EndIf
	  If WinActive($WINDOW_GAME) Then
		 Local $basePx = PixelGetColor(27, 48)
		 Local $count = 0;
		 Local $maxLoop = 30
		 Send("{TAB}")
		 While $count  < $maxLoop
			$count += 1
			Sleep(100)
			If $basePx <> PixelGetColor(27, 48) Then
			   ExitLoop
			EndIf
		 WEnd
	  Else
		 Local $msg = StringFormat("%s - %s", "duty", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "duty", "Not found window game")
	  _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc

Func WaitingMoving($offset)
   Local $pointerPos = WinGetClientSize($WINDOW_GAME)
   Local $pointerX = $pointerPos[0]/2
   Local $pointerY = $pointerPos[1]/2
   While True
	  Local $preTopPx = PixelGetColor($pointerX - $offset, $pointerY - $offset)
	  Local $preRightPx = PixelGetColor($pointerX + $offset,$pointerY - $offset)
	  Local $preBottomtPx = PixelGetColor($pointerX + $offset,$pointerY + $offset)
	  Local $preLeftPx = PixelGetColor($pointerX - $offset,$pointerY + $offset)
	  Sleep(3000)
	  Local $nextTopPx = PixelGetColor($pointerX - $offset,$pointerY - $offset)
	  Local $nextRightPx = PixelGetColor($pointerX + $offset,$pointerY - $offset)
	  Local $nextBottomtPx = PixelGetColor($pointerX + $offset,$pointerY + $offset)
	  Local $nextLeftPx = PixelGetColor($pointerX - $offset,$pointerY + $offset)
	  If $preTopPx = $nextTopPx And $preRightPx = $nextRightPx And $preBottomtPx = $nextBottomtPx And $preLeftPx = $nextLeftPx Then
		 ExitLoop
	  EndIf
   WEnd
EndFunc

Func ClickNpc($winPos, $npcPos)
   Local $basePx = PixelGetColor($winPos[0], $winPos[1])
   MouseClick($MOUSE_CLICK_LEFT, $npcPos[0], $npcPos[1])
   Local $count = 0, $maxCount = 20
   While $count < $maxCount
	  $count += 1
	  Sleep(100)
	  If $basePx <> PixelGetColor($winPos[0], $winPos[1]) Then
		 ExitLoop
	  EndIf
   WEnd
EndFunc

