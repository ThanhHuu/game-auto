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

Local $WINDOW_GAME = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

;SkipDuty()
Func SkipDuty()
   If ActiveWindowWithinTimeOut($WINDOW_GAME, 2000) Then
	  Local $dutyPopPos = [508, 620]
	  If PressKeyWithinTimeOut($dutyPopPos, "{F4}", 1000) Then
		 For $i = 0 To 2
			Local $skipBtPos = [627, 621]
			MouseClick($MOUSE_CLICK_LEFT, $skipBtPos[0], $skipBtPos[1])
			Sleep(100)
			; Start remove for each
			Local $count = 0
			Local $offset = 20
			Local $lastRow = 590
			While $lastRow > 210 And $count < 50
			   $count += 1
			   Local $currentPos = [340, $lastRow]
			   Local $nextPos = [$currentPos[0], $currentPos[1] + $offset]
			   Local $nextPx = PixelGetColor($nextPos[0], $nextPos[1])
			   If ClickNpcWithinTimeOut($currentPos, $currentPos, 500) Then
				  ; skip pointer duty
				  If Not ClickNpcWithinTimeOut($currentPos, $skipBtPos, 200) Then
					 $lastRow -= $offset
				  EndIf
				  If $nextPx <> PixelGetColor($nextPos[0], $nextPos[1]) Then
					 ClickNpcWithinTimeOut($nextPos, $currentPos, 200)
				  EndIf
			   Else
				  $lastRow -= $offset
			   EndIf
			WEnd
			Local $lastPx = [340, 590]
			If Not ClickNpcWithinTimeOut($lastPx, $lastPx, 200) Then
			   ExitLoop
			EndIf
		 Next
		 PressKeyWithinTimeOut($dutyPopPos, "{F4}", 1000)
	  EndIf
   EndIf
EndFunc

;FollowDuty()
Func FollowDuty()
   If ActiveWindowWithinTimeOut($WINDOW_GAME, 2000) Then
	  Local $dutyPopPos = [508, 620]
	  If PressKeyWithinTimeOut($dutyPopPos, "{F4}", 1000) Then
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
		 PressKeyWithinTimeOut($dutyPopPos, "{F4}", 1000)
	  EndIf
   EndIf
EndFunc

;UnfollowDuty()
Func UnfollowDuty()
   If ActiveWindowWithinTimeOut($WINDOW_GAME, 2000) Then
	  Local $dutyPopPos = [508, 620]
	  Local $checkPos1 = [551, 672]
	  Local $checkPos2 = [651, 693]
	  Local $checkPos3 = [85, 458]
	  Local $count = 0
	  Local $offset = 10
	  Local $dutyPx = PixelGetColor(512, 622)

	  Local $topDutyIcon = [945, 255]
	  Local $basePx = PixelGetColor(919, 296)
	  If IsMovedPosition($topDutyIcon, $checkPos1, $checkPos2, $checkPos3) Then
		 $topDutyIcon[1] = 350
	  ElseIf $dutyPx = PixelGetColor(512, 622) Then
		 $topDutyIcon[1] = 350
	  EndIf
	  While $count < 5
		 $count += 1
		 If IsMovedPosition($topDutyIcon, $checkPos1, $checkPos2, $checkPos3) Then
			ExitLoop
		 ElseIf $dutyPx <> PixelGetColor(512, 622) Then
			; follow pointer duty
			MouseClick($MOUSE_CLICK_LEFT, 257, 618)
			Sleep(100)
			PressKeyWithinTimeOut($dutyPopPos, "{F4}", 1000)
		 EndIf
		 $topDutyIcon[1] = 255
	  WEnd
   EndIf
EndFunc

;MsgBox(0,"", IsHasDailyDuty())
Func IsHasDailyDuty()
   If ActiveWindowWithinTimeOut($WINDOW_GAME, 2000) Then
	  Local $dutyPopPos = [508, 620]
	  Local $topDutyIcon = [945, 255]
	  If PressKeyWithinTimeOut($dutyPopPos, "{F4}", 1000) Then
		 MouseClick($MOUSE_CLICK_LEFT, 274, 176)
		 Sleep(100)
		 Local $firstPos = [280, 210]
		 Local $secondPos = [280, 235]
		 Local $thirdPos = [280, 260]
		 Local $fourPos = [280, 285]
		 Local $fifthPos = [280, 310]
		 Local $sixPos = [280, 335]
		 If ClickNpcWithinTimeOut($secondPos, $firstPos, 500) Then
			If ClickNpcWithinTimeOut($thirdPos, $secondPos, 500) Then
			   If ClickNpcWithinTimeOut($fourPos, $thirdPos, 500) Then
				  If ClickNpcWithinTimeOut($fifthPos, $fourPos, 500) Then
					 If ClickNpcWithinTimeOut($fourPos, $thirdPos, 500) Then
						$fifthPos[1] = 305
						$sixPos[1] = 330
						If ClickNpcWithinTimeOut($sixPos, $fifthPos, 500) Then
						   $fourPos[1] = 280
						   MouseClick($MOUSE_CLICK_LEFT, $fourPos[0], $fourPos[1])
						   Sleep(100)
						   MouseClick($MOUSE_CLICK_LEFT, 257, 618)
						   Sleep(100)
						   Local $checkPos = [919, 296]
						   Local $result = IsChangeWhenMouseHover($topDutyIcon, $checkPos)
						   If Not $result Then
							  MouseClick($MOUSE_CLICK_LEFT, 257, 618)
							  Sleep(100)
						   EndIf
						   PressKeyWithinTimeOut($dutyPopPos, "{F4}", 1000)
						   Return $result
						Else
						   MouseClick($MOUSE_CLICK_LEFT, 257, 618)
						   Sleep(100)
						   PressKeyWithinTimeOut($dutyPopPos, "{F4}", 1000)
						   Return True
						EndIf
					 EndIf
				  Else
					 Return False
				  EndIf
			   EndIf
			EndIf
		 EndIf
		 PressKeyWithinTimeOut($dutyPopPos, "{F4}", 1000)
	  EndIf
   EndIf
   Return False
EndFunc
