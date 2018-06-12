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

Local $WINDOW_GAME = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

Func PressMap()
   If ActiveWindowWithinTimeOut($WINDOW_GAME, 1000) Then
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

Func WaitingMovingWithinTimeOut($offset, $timeOut)
   Local $pointerPos = WinGetClientSize($WINDOW_GAME)
   Local $pointerX = $pointerPos[0]/2
   Local $pointerY = $pointerPos[1]/2
   Local $maxCount = $timeOut/3000
   For $i = 0 To $maxCount
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
   Next
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

Func ClickNpcWithinTimeOut($winPos, $npcPos, $timeOut)
   Local $basePx = PixelGetColor($winPos[0], $winPos[1])
   MouseClick($MOUSE_CLICK_LEFT, $npcPos[0], $npcPos[1])
   Local $maxLoop = $timeOut/100
   For $i = 0 To $maxLoop
	  Sleep(100)
	  If $basePx <> PixelGetColor($winPos[0], $winPos[1]) Then
		 Return True
	  EndIf
   Next
   WriteLog("utils", StringFormat("Click [%d, %d] timeout after %d ms", $npcPos[0], $npcPos[1], $timeOut))
   Return False
EndFunc

Func PressKeyWithinTimeOut($winPos, $key, $timeOut)
   Local $basePx = PixelGetColor($winPos[0], $winPos[1])
   Send($key)
   Local $maxLoop = $timeOut/100
   For $i = 0 To $maxLoop
	  Sleep(100)
	  If $basePx <> PixelGetColor($winPos[0], $winPos[1]) Then
		 Return True
	  EndIf
   Next
   WriteLog("utils", StringFormat("Press %s timeout after %d ms", $key, $timeOut))
   Return False
EndFunc

Func KillDumpProcess($timeOut)
   Local $maxLoop = $timeOut/100
   For $i = 0 To $maxLoop
	  If ProcessExists("DumpReportX86.exe") Then
		 ProcessClose("DumpReportX86.exe")
		 Sleep(100)
	  Else
		 ExitLoop
	  EndIf
   Next
EndFunc

Func ActiveWindowWithinTimeOut($win, $timeOut)
   KillDumpProcess($timeOut)
   If WinExists($win) Then
	  If WinActive($win) Then
		 Return True
	  Else
		 WinActivate($win)
		 Local $maxLoop = $timeOut/100
		 For $i = 0 To $maxLoop
			Sleep(100)
			If WinActive($win) Then
			   Return True
			EndIf
		 Next
		 WriteLog("utils", StringFormat("Cannot active %s after %d ms", $win, $timeOut))
		 Return False
	  EndIf
   EndIf
EndFunc

Func ClickChangeMapWithinTimeOut($mapPos1, $mapPos2, $mapPos3, $npcPos, $timeOut)
   Local $basePx1 = PixelGetColor($mapPos1[0], $mapPos1[1])
   Local $basePx2 = PixelGetColor($mapPos2[0], $mapPos2[1])
   Local $basePx3 = PixelGetColor($mapPos3[0], $mapPos3[1])
   MouseClick($MOUSE_CLICK_LEFT, $npcPos[0], $npcPos[1])
   Local $maxLoop = $timeOut/1000
   For $i = 0 To $maxLoop
	  If $basePx1 <> PixelGetColor($mapPos1[0], $mapPos1[1]) And $basePx2 <> PixelGetColor($mapPos2[0], $mapPos2[1]) And $basePx3 <> PixelGetColor($mapPos3[0], $mapPos3[1]) Then
		 Return True
	  EndIf
	  Sleep(1000)
   Next
   WriteLog("utils", StringFormat("Clicked [%d, %d] but not change map after %d", $npcPos[0], $npcPos[1], $timeOut))
   Return False
EndFunc

Func AssistantAward()
   Local $assistantWinPos = [260, 141]
   Local $clickPos = [765, 370]
   If ClickNpcWithinTimeOut($assistantWinPos, $clickPos, 1000) Then
	  Local $awardWinPos = [938, 435]
	  $clickPos[0] = 469
	  $clickPos[1] = 591
	  If ClickNpcWithinTimeOut($awardWinPos, $clickPos, 1000) Then
		 Local $awardItemsWinPos = [1001, 212]
		 $clickPos[0] = 858
		 $clickPos[1] = 535
		 If ClickNpcWithinTimeOut($awardItemsWinPos, $clickPos, 1000) Then
			ClickNpcWithinTimeOut($awardItemsWinPos, $awardItemsWinPos, 1000)
		 EndIf
	  EndIf
	  PressKeyWithinTimeOut($assistantWinPos, "{ESC}", 1000)
   EndIf
EndFunc

Func AssistantFeature($featurePos)
   Local $assistantWinPos = [260, 141]
   Local $clickPos = [765, 370]
   ; Click dieu doi
   If ClickNpcWithinTimeOut($assistantWinPos, $clickPos, 1000) Then
	  ; Click chon tinh nang
	  If ClickNpcWithinTimeOut($featurePos, $featurePos, 1000) Then
		 Local $confirmWinPos = [577, 298]
		 $clickPos[0] = 468
		 $clickPos[1] = 594
		 ; Click dieu doi thuong
		 If ClickNpcWithinTimeOut($confirmWinPos, $clickPos, 1000) Then
			Local $acceptPos = [511, 467]
			; Click xac nhan
			ClickNpcWithinTimeOut($confirmWinPos, $acceptPos, 1000)
		 EndIf
	  EndIf
	  ; Press ESC
	  PressKeyWithinTimeOut($assistantWinPos, "{ESC}", 1000)
   EndIf
EndFunc

Func AssistantFeatureWithinLevel($featurePos, $level)
   Local $assistantWinPos = [260, 141]
   Local $clickPos = [765, 370]
   ; Click dieu doi
   If ClickNpcWithinTimeOut($assistantWinPos, $clickPos, 1000) Then
	  ; Click chon tinh nang
	  If ClickNpcWithinTimeOut($featurePos, $featurePos, 1000) Then
		 Local $chooseLevelWinPos = [258, 140]
		 $clickPos[0] = 468
		 $clickPos[1] = 594
		 ; Click dieu doi thuong
		 If ClickNpcWithinTimeOut($chooseLevelWinPos, $clickPos, 1000) Then
			Local $clickLevel = [175, 295]
			If $level >= 100 Then
			   $clickLevel[1] = 355
			ElseIf $level >= 80 Then
			   $clickLevel[1] = 325
			EndIf
			; click choose level
			ClickNpcWithinTimeOut($chooseLevelWinPos, $clickLevel, 1000)
		 EndIf
	  EndIf
	  ; Press ESC
	  PressKeyWithinTimeOut($assistantWinPos, "{ESC}", 1000)
   EndIf
EndFunc

Func OpenDuongChauMap($timeOut)
   Local $mapPos = [37, 47]
   ; Press TAB
   If PressKeyWithinTimeOut($mapPos, "{TAB}", $timeOut) Then
	  Local $duongChauPos = [782, 432]
	  Local $clickWordMap = [78, 78]
	  ; click ban do the gioi
	  If ClickNpcWithinTimeOut($duongChauPos, $clickWordMap, $timeOut) Then
		 ; Click duong chau
		 If ClickNpcWithinTimeOut($duongChauPos, $duongChauPos, $timeOut) Then
			Return True
		 EndIf
		 WriteLog("utils", StringFormat("%s - %s", "utils", "Error click DuongChau"))
		 Return False
	  EndIf
	  WriteLog("utils", StringFormat("%s - %s", "utils", "Error click BanDoTheGioi"))
	  Return False
   EndIf
   WriteLog("utils", StringFormat("%s - %s", "utils", "Error press Tab"))
   Return False
EndFunc

Func MovingToNpc($npcPos)
   MouseClick($MOUSE_CLICK_LEFT, $npcPos[0], $npcPos[1], 2)
   Sleep(2000)
   PressKeyWithinTimeOut($npcPos, "{ESC}", 1000)
   WaitingMoving(100)
EndFunc

Func MovingToNpcWithinTimeOut($npcPos, $timeOut)
   MouseClick($MOUSE_CLICK_LEFT, $npcPos[0], $npcPos[1], 2)
   Sleep(2000)
   PressKeyWithinTimeOut($npcPos, "{ESC}", 1000)
   WaitingMovingWithinTimeOut(100, $timeOut)
EndFunc

Func WriteLog($caller, $msg)
   Local $logFile = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
   _FileWriteLog($logFile, StringFormat("%s - %s", $caller, $msg))
EndFunc

Func IsMovedPosition($clickPos, $checkingPos1, $checkingPos2, $checkingPos3)
   Local $px1 = PixelGetColor($checkingPos1[0], $checkingPos1[1])
   Local $px2 = PixelGetColor($checkingPos2[0], $checkingPos2[1])
   Local $px3 = PixelGetColor($checkingPos3[0], $checkingPos3[1])
   MouseClick($MOUSE_CLICK_LEFT, $clickPos[0], $clickPos[1])
   Sleep(1000)
   If $px1 <> PixelGetColor($checkingPos1[0], $checkingPos1[1]) And $px2 <> PixelGetColor($checkingPos2[0], $checkingPos2[1]) And $px3 <> PixelGetColor($checkingPos3[0], $checkingPos3[1]) Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func IsChangeWhenMouseHover($hoverPos, $checkPos)
   Local $px = PixelGetColor($checkPos[0], $checkPos[1])
   MouseMove($hoverPos[0], $hoverPos[1])
   Sleep(1000)
   Return $px <> PixelGetColor($checkPos[0], $checkPos[1])
EndFunc
