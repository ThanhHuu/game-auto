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
#include <GuiListView.au3>
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

Local $allowDebug = True
Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"

Func PressMap($character)
   Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
   If ActiveWindowWithinTimeOut($winTitle, 3000) Then
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

Func WaitingMovingWithinTimeOut($character, $offset, $timeOut)
   Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
   Local $pointerPos = WinGetClientSize($winTitle)
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
		 WriteLogDebug("utils", StringFormat("%s moved to specific point", $character))
		 Return
	  EndIf
   Next
   WriteLogDebug("utils", StringFormat("Timeout moving %s to specific point", $character))
   Return False
EndFunc

Func ClickNpcWithinTimeOut($winPos, $npcPos, $timeOut)
   Local $basePx = PixelGetColor($winPos[0], $winPos[1])
   MouseClick($MOUSE_CLICK_LEFT, $npcPos[0], $npcPos[1])
   Local $maxLoop = $timeOut/100
   For $i = 0 To $maxLoop
	  Sleep(100)
	  If $basePx <> PixelGetColor($winPos[0], $winPos[1]) Then
		 WriteLogDebug("utils", StringFormat("Clicked [%d, %d]", $npcPos[0], $npcPos[1]))
		 Return True
	  EndIf
   Next
   WriteLogDebug("utils", StringFormat("Timeout clicking [%d, %d] after %d ms", $npcPos[0], $npcPos[1], $timeOut))
   Return False
EndFunc

Func RightClickNpcWithinTimeOut($winPos, $npcPos, $timeOut)
   Local $basePx = PixelGetColor($winPos[0], $winPos[1])
   MouseClick($MOUSE_CLICK_RIGHT, $npcPos[0], $npcPos[1])
   Local $maxLoop = $timeOut/100
   For $i = 0 To $maxLoop
	  Sleep(100)
	  If $basePx <> PixelGetColor($winPos[0], $winPos[1]) Then
		 WriteLogDebug("utils", StringFormat("Right clicked [%d, %d]", $npcPos[0], $npcPos[1]))
		 Return True
	  EndIf
   Next
   WriteLogDebug("utils", StringFormat("Timeout right clicking [%d, %d] after %d ms", $npcPos[0], $npcPos[1], $timeOut))
   Return False
EndFunc

Func PressKeyWithinTimeOut($winPos, $key, $timeOut)
   Local $basePx = PixelGetColor($winPos[0], $winPos[1])
   Send($key)
   Local $maxLoop = $timeOut/100
   For $i = 0 To $maxLoop
	  Sleep(100)
	  If $basePx <> PixelGetColor($winPos[0], $winPos[1]) Then
		 WriteLogDebug("utils", StringFormat("Pressed %s", $key, $timeOut))
		 Return True
	  EndIf
   Next
   WriteLogDebug("utils", StringFormat("Timeout press %s after %d ms", $key, $timeOut))
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
			   WriteLogDebug("utils", StringFormat("Actived window %s", $win))
			   Return True
			EndIf
		 Next
		 WriteLogDebug("utils", StringFormat("Timeout activation window %s after %d ms", $win, $timeOut))
		 Return False
	  EndIf
   EndIf
   WriteLogDebug("utils", StringFormat("Not found window %s", $win))
   Return False
EndFunc

Func ClickChangeMapWithinTimeOut($mapPos1, $mapPos2, $mapPos3, $npcPos, $timeOut)
   Local $basePx1 = PixelGetColor($mapPos1[0], $mapPos1[1])
   Local $basePx2 = PixelGetColor($mapPos2[0], $mapPos2[1])
   Local $basePx3 = PixelGetColor($mapPos3[0], $mapPos3[1])
   MouseClick($MOUSE_CLICK_LEFT, $npcPos[0], $npcPos[1])
   Local $maxLoop = $timeOut/1000
   For $i = 0 To $maxLoop
	  Sleep(1000)
	  If $basePx1 <> PixelGetColor($mapPos1[0], $mapPos1[1]) And $basePx2 <> PixelGetColor($mapPos2[0], $mapPos2[1]) And $basePx3 <> PixelGetColor($mapPos3[0], $mapPos3[1]) Then
		 WriteLogDebug("utils", StringFormat("Changed map when clicking [%d, %d]", $npcPos[0], $npcPos[1]))
		 Return True
	  EndIf
   Next
   WriteLogDebug("utils", StringFormat("Timeout changing map when clicking [%d, %d] after %d", $npcPos[0], $npcPos[1], $timeOut))
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
	  PressKeyWithinTimeOut($assistantWinPos, "{TAB}", 1000)
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
	  PressKeyWithinTimeOut($assistantWinPos, "{TAB}", 1000)
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
	  PressKeyWithinTimeOut($assistantWinPos, "{TAB}", 1000)
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
	  EndIf
   EndIf
   Return False
EndFunc

Func MovingToNpcWithinTimeOut($character, $npcPos, $timeOut)
   MouseClick($MOUSE_CLICK_LEFT, $npcPos[0], $npcPos[1], 2)
   Sleep(2000)
   PressKeyWithinTimeOut($npcPos, "{ESC}", 1000)
   WaitingMovingWithinTimeOut($character, 100, $timeOut)
   Sleep(5000)
EndFunc

Func WriteLog($caller, $msg)
   Local $logFile = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
   _FileWriteLog($logFile, StringFormat("%s - %s", $caller, $msg))
EndFunc

Func WriteLogDebug($caller, $msg)
   If $allowDebug Then
	  Local $logFile = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
	  _FileWriteLog($logFile, StringFormat("%s- DEBUG - %s", $caller, $msg))
   EndIf
EndFunc

Func IsMovedPosition($clickPos, $checkingPos1, $checkingPos2, $checkingPos3)
   Local $px1 = PixelGetColor($checkingPos1[0], $checkingPos1[1])
   Local $px2 = PixelGetColor($checkingPos2[0], $checkingPos2[1])
   Local $px3 = PixelGetColor($checkingPos3[0], $checkingPos3[1])
   MouseClick($MOUSE_CLICK_LEFT, $clickPos[0], $clickPos[1])
   Sleep(1000)
   If $px1 <> PixelGetColor($checkingPos1[0], $checkingPos1[1]) And $px2 <> PixelGetColor($checkingPos2[0], $checkingPos2[1]) And $px3 <> PixelGetColor($checkingPos3[0], $checkingPos3[1]) Then
	  WriteLogDebug("utils", StringFormat("Moved after click [%d, %d]", $clickPos[0], $clickPos[1]))
	  Return True
   Else
	  WriteLogDebug("utils", StringFormat("Did not move after click [%d, %d]", $clickPos[0], $clickPos[1]))
	  Return False
   EndIf
EndFunc

Func IsChangeWhenMouseHover($hoverPos, $checkPos)
   Local $px = PixelGetColor($checkPos[0], $checkPos[1])
   MouseMove($hoverPos[0], $hoverPos[1])
   Sleep(1000)
   Return $px <> PixelGetColor($checkPos[0], $checkPos[1])
EndFunc

Func FindIndex($character)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 10000) Then
	  Local $listView = ControlGetHandle($WINDOW_LOGIN, "", "[CLASS:SysListView32;INSTANCE:1]")
	  Local $count = 0
	  While $count < 5
		 If _GUICtrlListView_GetItemCount($listView) = 0 Then
			Exit
		 EndIf
		 Local $itemInfo = _GUICtrlListView_GetItem($listView, $count, 1)
		 If StringStripWS($itemInfo[3], $STR_STRIPLEADING + $STR_STRIPTRAILING) = $character Then
			WriteLogDebug("add_account", StringFormat("Find out %s at index %d", $character, $count))
			Return $count
		 EndIf
		 $count += 1
	  WEnd
   EndIf
   WriteLogDebug("add_account", StringFormat("Not found %s after over %d index", $character, $count))
   Exit
EndFunc