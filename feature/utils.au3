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
#include <WinAPI.au3>

Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

HotKeySet("^e", "ForceExit")
Func ForceExit()
   Exit
EndFunc

Func LeftClick($baseCoord, $coord, $waitingTime, $numberClick = 1)
   Local $basePx = PixelGetColor($baseCoord[0], $baseCoord[1])
   MouseClick($MOUSE_CLICK_LEFT, $coord[0], $coord[1], $numberClick)
   Local $maxLoop = $waitingTime/100
   For $i = 0 To $maxLoop
	  Sleep(100)
	  If $basePx <> PixelGetColor($baseCoord[0], $baseCoord[1]) Then
		Return True
	  EndIf
   Next
   Return False
EndFunc

Func RightClick($popupCoord, $npcPos, $timeOut)
   Local $basePx = PixelGetColor($popupCoord[0], $popupCoord[1])
   MouseClick($MOUSE_CLICK_RIGHT, $npcPos[0], $npcPos[1])
   Local $maxLoop = $timeOut/100
   For $i = 0 To $maxLoop
	  Sleep(100)
	  If $basePx <> PixelGetColor($popupCoord[0], $popupCoord[1]) Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc

Func PressKey($popupCoord, $key, $timeOut)
   Local $basePx = PixelGetColor($popupCoord[0], $popupCoord[1])
   Send($key)
   Local $maxLoop = $timeOut/100
   For $i = 0 To $maxLoop
	  Sleep(100)
	  If $basePx <> PixelGetColor($popupCoord[0], $popupCoord[1]) Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc

Func ActiveWindow($hwnd, $waitingTime)
   Local $deplay = 100
   If WinExists($hwnd) Then
	  WinActivate($hwnd)
	  Local $maxLoop = $waitingTime/$deplay
	  For $i = 1 To $maxLoop
		 Sleep($deplay)
		 If WinActive($hwnd) Then
			Return True
		 EndIf
	  Next
	  Return False
   EndIf
   WriteLogDebug("utils", StringFormat("Not found window %s", $hwnd))
   Return False
EndFunc

Func WaitChangeMap($hwnd, $watingTime, $delay = 3000, $offset = 50)
   Local $winSize = WinGetClientSize($hwnd)
   Local $maxCount = $watingTime/$delay
   For $i = 1 To $maxCount
	  Local $topLeft = PixelGetColor($winSize[0] - $offset, $winSize[1] - $offset)
	  Local $topRight = PixelGetColor($winSize[0] + $offset, $winSize[1] - $offset)
	  Local $bottomRight = PixelGetColor($winSize[0] + $offset, $winSize[1] + $offset)
	  Local $bottomLeft = PixelGetColor($winSize[0] - $offset, $winSize[1] + $offset)
	  Sleep($delay)
	  Local $count = 0
	  If $topLeft = PixelGetColor($winSize[0] - $offset, $winSize[1] - $offset) Then
		 $count += 1
	  EndIf
	  If $topRight = PixelGetColor($winSize[0] + $offset, $winSize[1] - $offset) Then
		 $count += 1
	  EndIf
	  If $bottomRight = PixelGetColor($winSize[0] + $offset, $winSize[1] + $offset) Then
		 $count += 1
	  EndIf
	  If $bottomLeft = PixelGetColor($winSize[0] - $offset, $winSize[1] + $offset) Then
		 $count += 1
	  EndIf
	  If $count > 3 Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc

Func OpenDuongChauMap($timeOut)
   Local $btTab = [1002, 167]
   If LeftClick($btTab, $btTab, $timeOut) Then
	  Local $btWordMap = [74, 78]
	  If LeftClick($btWordMap, $btWordMap, $timeOut) Then
		 Local $duongChauPos = [782, 432]
		 If LeftClick($btWordMap, $duongChauPos, $timeOut) Then
			Return True
		 EndIf
	  EndIf
   EndIf
   Return False
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

Func IsMoved($hwnd, $waitingTime)
   Local $winSize = WinGetClientSize($hwnd)
   Local $offset = 50;
   Local $topLeft = PixelGetColor($winSize[0] - $offset, $winSize[1] - $offset)
   Local $topRight = PixelGetColor($winSize[0] + $offset, $winSize[1] - $offset)
   Local $bottomRight = PixelGetColor($winSize[0] + $offset, $winSize[1] + $offset)
   Local $bottomLeft = PixelGetColor($winSize[0] - $offset, $winSize[1] + $offset)
   Sleep($waitingTime)
   Local $count = 0
   If $topLeft <> PixelGetColor($winSize[0] - $offset, $winSize[1] - $offset) Then
	  $count += 1
   EndIf
   If $topRight <> PixelGetColor($winSize[0] + $offset, $winSize[1] - $offset) Then
	  $count += 1
   EndIf
   If $bottomRight <> PixelGetColor($winSize[0] + $offset, $winSize[1] + $offset) Then
	  $count += 1
   EndIf
   If $bottomLeft <> PixelGetColor($winSize[0] - $offset, $winSize[1] + $offset) Then
	  $count += 1
   EndIf
   Return $topLeft > 3
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

Func GetWinTitleWithinOrder($order)
   Local $result = $RUNTIME_NKVS_TITLE[$order]
   Return $result
EndFunc

Func IsFindOutNpcPos($character)
   Local $winTitle = GetWintitle($character)
   If ActiveWindow($winTitle, 3000) Then
	  Local $winSize = WinGetClientSize($winTitle)
	  Local $centerCoord = [$winSize[0]/2, $winSize[1]/2]
	  MouseMove(1, 1)
	  Sleep(300)
	  Local $cursor = _WinAPI_GetCursorInfo()[2]
	  If DoScanAroundCoord($cursor, $centerCoord, -40, 40) Then
		 Return True
	  ElseIf DoScanAroundCoord($cursor, $centerCoord, -40, -40) Then
		 Return True
	  ElseIf DoScanAroundCoord($cursor, $centerCoord, 40, 40) Then
		 Return True
	  ElseIf DoScanAroundCoord($cursor, $centerCoord, 40, -40) Then
		 Return True
	  Else
		 Local $result = [-1, -1]
		 Return False
	  EndIf
   EndIf
   Return False
EndFunc

Func DoScanAroundCoord($basicCursor, $coord, $stepX, $stepY)
   For $i = 0 To 5
	  For $j = 0 To 4
		 Local $aroundCoord = [$coord[0] + $i*$stepX, $coord[1] + $j*$stepY]
		 MouseMove($aroundCoord[0], $aroundCoord[1])
		 Sleep(100)
		 If $basicCursor <> _WinAPI_GetCursorInfo()[2] Then
			Return True
		 EndIf
	  Next
   Next
   Return False
EndFunc
