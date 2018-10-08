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
#include "constant.au3"
#include <GUIConstantsEx.au3>

Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

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

Func WaitingMovingWithinTimeOut($offset, $timeOut)
   Local $pointerPos = WinGetClientSize($WINDOW_NKVS)
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
		 Return True
	  EndIf
   Next
   Return False
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
   Return False
EndFunc

Func RightClickNpcWithinTimeOut($winPos, $npcPos, $timeOut)
   Local $basePx = PixelGetColor($winPos[0], $winPos[1])
   MouseClick($MOUSE_CLICK_RIGHT, $npcPos[0], $npcPos[1])
   Local $maxLoop = $timeOut/100
   For $i = 0 To $maxLoop
	  Sleep(100)
	  If $basePx <> PixelGetColor($winPos[0], $winPos[1]) Then
		 Return True
	  EndIf
   Next
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
   WriteLogDebug("utils", StringFormat("Timeout when press %s", $key))
   Return False
EndFunc

Func ActiveWindowWithinTimeOut($win, $timeOut)
   If WinExists($win) Then
	  WinActivate($win)
	  Local $maxLoop = $timeOut/100
	  For $i = 0 To $maxLoop
		 If WinActive($win) Then
			WriteLogDebug("utils", StringFormat("Actived window %s", $win))
			Return True
		 EndIf
		 Sleep(100)
	  Next
	  WriteLogDebug("utils", StringFormat("Timeout activation window %s after %d ms", $win, $timeOut))
	  Return False
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
		 Return True
	  EndIf
   Next
   WriteLogDebug("utils", StringFormat("Timeout changing map when clicking [%d, %d] after %d", $npcPos[0], $npcPos[1], $timeOut))
   Return False
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

Func MovingToNpcWithinTimeOut($npcPos, $timeOut)
   MouseClick($MOUSE_CLICK_LEFT, $npcPos[0], $npcPos[1], 2)
   Sleep(2000)
   PressKeyWithinTimeOut($npcPos, "{ESC}", 1000)
   WaitingMovingWithinTimeOut(100, $timeOut)
   Sleep(2000)
EndFunc

Func WriteLog($caller, $msg)
   Local $logFile = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
   _FileWriteLog($logFile, StringFormat("INFO - %s - %s", $caller, $msg))
EndFunc

Func WriteLogDebug($caller, $msg)
   If GUICtrlRead($UI_DEBUG_MODE) = $GUI_CHECKED Then
	  Local $logFile = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
	  _FileWriteLog($logFile, StringFormat("DEBUG - %s - %s", $caller, $msg))
   EndIf
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

Func GetWintitle($character)
   Return "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & "]"
EndFunc

Func ExecuteChain($chainDic)
   For $func In $chainDic.Keys
	  Local $paramDic = $chainDic.Item($func)
	  Local $character = $paramDic.Item($PARAM_CHAR)
	  WinActivate(GetWintitle($character))
	  If Call($func, $paramDic) Then
		 WriteLogDebug("utils", StringFormat("Ran function %s", $func))
	  Else
		 WriteLogDebug("utils", StringFormat("Stuck at function %s", $func))
		 Return False
	  EndIf
   Next
   Return True
EndFunc