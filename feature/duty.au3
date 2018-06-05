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


Local $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Local $WINDOW_GAME = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

;SkipDuty()
Func SkipDuty()
   If WinExists($WINDOW_GAME) Then
	  If Not WinActive($WINDOW_GAME) Then
		 WinActivate($WINDOW_GAME)
		 Sleep(500)
	  EndIf
	  If WinActive($WINDOW_GAME) Then
		 OpenDuty()
		 For $i = 0 To 2
			MouseClick($MOUSE_CLICK_LEFT, 627, 621)
			Sleep(100)
			; Start remove for each
			Local $count = 0
			Local $offset = 20
			Local $lastRow = 590
			While $lastRow > 210 And $count < 50
			   $count += 1
			   Local $currentPx = PixelGetColor(340, $lastRow)
			   Local $nextPx = PixelGetColor(340, $lastRow + $offset)
			   MouseClick($MOUSE_CLICK_LEFT, 326, $lastRow)
			   Sleep(100)
			   ; skip pointer duty
			   If $currentPx <> PixelGetColor(340, $lastRow) Then
				  MouseClick($MOUSE_CLICK_LEFT, 627, 621)
				  Sleep(100)
			   EndIf
			   If $nextPx <> PixelGetColor(340, $lastRow + $offset) Then
				  MouseClick($MOUSE_CLICK_LEFT, 326, $lastRow)
			   EndIf
			   $lastRow -= $offset
			WEnd
			Local $lastPx = PixelGetColor(340, 590)
			MouseClick($MOUSE_CLICK_LEFT, 326, 590)
			Sleep(100)
			If $lastPx = PixelGetColor(340, 590) Then
			   ExitLoop
			EndIf
		 Next
		 CloseDuty()
	  Else
		 Local $msg = StringFormat("%s - %s", "duty", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "duty", "Not found window game")
	  _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc

Func OpenDuty()
   Local $basePx = PixelGetColor(508, 620)
   Local $maxCount = 10
   Local $count = 0
   Send("{F4}")
   While $count < $maxCount
	  Sleep(100)
	  If $basePx <> PixelGetColor(508, 620) Then
		 ExitLoop
	  EndIf
   WEnd
   Sleep(1000)
EndFunc

Func CloseDuty()
   Local $basePx = PixelGetColor(508, 620)
   Local $maxCount = 10
   Local $count = 0
   Send("{TAB}")
   Send("{ESC}")
   While $count < $maxCount
	  Sleep(100)
	  If $basePx <> PixelGetColor(508, 620) Then
		 ExitLoop
	  EndIf
   WEnd
   Sleep(1000)
EndFunc

;FollowDuty()
Func FollowDuty()
   If WinExists($WINDOW_GAME) Then
	  If Not WinActive($WINDOW_GAME) Then
		 WinActivate($WINDOW_GAME)
		 Sleep(500)
	  EndIf
	  If WinActive($WINDOW_GAME) Then
		 OpenDuty()
		 Local $count = 0
		 Local $offset = 20
		 Local $currentPointer = 590
		 While $currentPointer > 210 And $count < 50
			$count += 1
			Local $currentPx = PixelGetColor(340, $currentPointer)
			MouseClick($MOUSE_CLICK_LEFT, 326, $currentPointer)
			Sleep(100)
			; follow pointer duty
			If $currentPx <> PixelGetColor(340, $currentPointer) Then
			   MouseClick($MOUSE_CLICK_LEFT, 257, 618)
			   Sleep(100)
			EndIf
			$currentPointer -= $offset
		 WEnd
		 CloseDuty()
	  Else
		 Local $msg = StringFormat("%s - %s", "duty", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "duty", "Not found window game")
	  _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc

;UnfollowDuty()
Func UnfollowDuty()
   If WinExists($WINDOW_GAME) Then
	  If Not WinActive($WINDOW_GAME) Then
		 WinActivate($WINDOW_GAME)
		 Sleep(500)
	  EndIf
	  If WinActive($WINDOW_GAME) Then
		 Local $count = 0
		 Local $offset = 10
		 Local $dutyPx = PixelGetColor(512, 622)

		 Local $topDutyIcon = 255
		 Local $basePx = PixelGetColor(919, 296)
		 MouseMove(945, 255)
		 Sleep(300)
		 If $basePx = PixelGetColor(919, 296) Then
			$topDutyIcon = 350
		 EndIf
		 While $count < 10
			$count += 1
			MouseClick($MOUSE_CLICK_LEFT, 945, $topDutyIcon)
			Sleep(100)
			; follow pointer duty
			If $dutyPx <> PixelGetColor(512, 622) Then
			   MouseClick($MOUSE_CLICK_LEFT, 257, 618)
			   Sleep(500)
			   CloseDuty()
			EndIf
			; Re check top
			$basePx = PixelGetColor(919, 296)
			MouseMove(945, 255)
			Sleep(300)
			If $basePx <> PixelGetColor(919, 296) Then
			   $topDutyIcon = 255
			Else
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
IsHasDailyDuty()
Func IsHasDailyDuty()
   If WinExists($WINDOW_GAME) Then
	  If Not WinActive($WINDOW_GAME) Then
		 WinActivate($WINDOW_GAME)
		 Sleep(500)
	  EndIf
	  If WinActive($WINDOW_GAME) Then
		 PressMap()
		 MouseClick($MOUSE_CLICK_LEFT, 72, 75)
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, 777, 434)
		 Sleep(100)
		 MouseClickDrag($MOUSE_CLICK_LEFT, 998, 236, 998, 430)
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, 923, 242, 2)
		 Sleep(1500)
		 PressMap()
		 WaitingMoving(100)
		 Local $winPos = [250, 536]
		 Local $npcPos = [517, 388]
		 ClickNpc($winPos, $npcPos)
		 Local $offset = 30, $basePx1 = PixelGetColor(800, 430), $basePx2=PixelGetColor($winPos[0],$winPos[1]), $lastRow=540
		 For $i = 0 To 10
			MouseClick($MOUSE_CLICK_LEFT, 165, $lastRow)
			$lastRow -= $offset
			If $basePx1 = PixelGetColor(800, 430) Then
			   For $j = 0 To 20
				  Sleep(100)
				  If $basePx2<>PixelGetColor($winPos[0],$winPos[1]) Then
					 ExitLoop
				  Else
					 ExitLoop
				  EndIf
			   Next
			EndIf
		 Next
	  Else
		 Local $msg = StringFormat("%s - %s", "duty", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "duty", "Not found window game")
	  _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc
