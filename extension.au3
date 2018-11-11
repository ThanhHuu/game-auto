#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         thanhhuupq@gmail.com

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once
#RequireAdmin

#include <WindowsConstants.au3>
#include <File.au3>
#include <Date.au3>
#include <GuiListView.au3>
Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)

Global $AUTO_HWND = "Auto Ngạo Kiếm Vô Song 2 - v2.0.1.3"
Local $MK_LBUTTON = 0x0001
Local $MK_RBUTTON = 0x0002

Func MouseClickAdvance($hwnd, $x, $y, $button = "left" , $clicks = 1)
   Local $bt, $btDown, $btUp
   Select
	  Case $button = "left"
		 $bt = $MK_LBUTTON
		 $btDown = $WM_LBUTTONDOWN
		 $btUp = $WM_LBUTTONUP
	  Case $button = "right"
		 $bt = $MK_RBUTTON
		 $btDown = $WM_RBUTTONDOWN
		 $btUp = $WM_RBUTTONUP
   EndSelect
   For $i = 1 To $clicks
	  DllCall("user32.dll", "int", "SendMessage", "hwnd", $hwnd, "int", $WM_MOUSEMOVE, "int", 0, "long", _MakeLong($x, $y))
	  DllCall("user32.dll", "int", "SendMessage", "hwnd", $hwnd, "int", $btDown, "int", $bt, "long", _MakeLong($x, $y))
	  DllCall("user32.dll", "int", "SendMessage", "hwnd", $hwnd, "int", $btUp, "int", $bt, "long", _MakeLong($x, $y))
   Next
EndFunc

Func _MakeLong($LoWord, $HiWord)
   Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc

Func GraphicClick($point, $button = "left", $clicks = 1, $checkingPoint = "")
   Local $beforeClick = $checkingPoint = "" ? PixelGetColor($point[0], $point[1]) : PixelGetColor($point[0], $point[1])
   MouseClick($button, $point[0], $point[1], $clicks)
   For $i = 1 To 30
	  Sleep(100)
	  Local $afterClick = $checkingPoint = "" ? PixelGetColor($point[0], $point[1]) : PixelGetColor($point[0], $point[1])
	  If $beforeClick <> $afterClick Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc

Func WinActivateEx($hwnd)
   WinActivate($hwnd)
   For $i = 1 To 30
	  Sleep(100)
	  If WinActive($hwnd) Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc

Func WinExistsEx($hwnd)
   For $i = 1 To 30
	  Sleep(100)
	  If WinExists($hwnd) Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc

Func ListFileOfFolder($folder, $filter = "*.acc", $excludeHidden = True, $recur = True)
   Local $files = _FileListToArrayRec($folder, $filter, $excludeHidden ? 1 + 4 : 1, $recur ? 1 : 0, 1, 2);
   Local $result = ObjCreate("Scripting.Dictionary")
   If $files <> "" Then
	  For $i = 1 To $files[0]
		 $result.Add($i, $files[$i])
	  Next
   EndIf
   Return $result.Items
EndFunc

Func _FileWriteLogEx($msg)
   Local $logFile = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
   _FileWriteLog($logFile, $msg)
EndFunc

Func _GUICtrlListView_ClickItemEx($hWnd, $iRow, $iCol = 0, $iClicks = 1, $sButton = "left", $fMove = False,  $iSpeed = 1)
   Local $tRECT = _GUICtrlListView_GetItemRect($hWnd, $iRow)
   Local $colWidth = 0
   For $i = 0 To $iCol - 1
	  $colWidth += _GUICtrlListView_GetColumnWidth($hWnd, $i)
   Next
   $colWidth += _GUICtrlListView_GetColumnWidth($hWnd, $iCol)/2
   Local $tPoint = DllStructCreate("int X;int Y")
   DllStructSetData($tPoint, "X", $tRECT[0] + $colWidth)
   DllStructSetData($tPoint, "Y", ($tRECT[1] + $tRECT[3])/2)
   $tPoint = _WinAPI_ClientToScreen($hWnd, $tPoint)
   Local $iX, $iY
   _WinAPI_GetXYFromPoint($tPoint, $iX, $iY)
   Local $iMode = Opt("MouseCoordMode", 1)
   If Not $fMove Then
	  Local $aPos = MouseGetPos()
	  _WinAPI_ShowCursor(False)
	  MouseClick($sButton, $iX, $iY, $iClicks, $iSpeed)
	  MouseMove($aPos[0], $aPos[1], 0)
	  _WinAPI_ShowCursor(True)
   Else
	  MouseClick($sButton, $iX, $iY, $iClicks, $iSpeed)
   EndIf
   Opt("MouseCoordMode", $iMode)
EndFunc

Func MouseClickDragEx($fromCoord, $toCoord, $button = "left")
   Local $targetPx = PixelGetColor($toCoord[0], $toCoord[1])
   MouseClickDrag($button, $fromCoord[0], $fromCoord[1], $toCoord[0], $toCoord[1])
   For $i = 1 To 30
	  Sleep(100)
	  If $targetPx <> PixelGetColor($toCoord[0], $toCoord[1]) Then
		 ExitLoop
	  EndIf
   Next
EndFunc