#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include-once
#RequireAdmin
#include <Date.au3>
#include <File.au3>
#include "utils.au3"
#include "logout.au3"
#include "constant.au3"
#include <GUIConstantsEx.au3>
#include <FontConstants.au3>
#include <EditConstants.au3>
#include "checksum.au3"
#include <WinAPIRes.au3>
#include <Array.au3>

Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

Local $TRANSPORT_IS_NEW = False
Local $UI_GO_TRANSPORT, $UI_CANCEL_EXIST_REQUEST

Local $TRANSPORT_DONE_COLOR = 0x22986F
Local $TRANSPORT_OPTION = 0xFAFAD1
Local $TRANSPORT_TEXT_COLOR = 0xFFFFFF
Local $TRANSPORT_COORD_COLOR = 0xFFFF00
Local $TRANSPORT_START_COLOR = 0xE3AA6E

Local $TRANSPORT_DONE_COLOR_REAL = 0x22986F
Local $TRANSPORT_OPTION_REAL = 0xFAFAD1
Local $TRANSPORT_TEXT_COLOR_REAL = 0xFFFFFF
Local $TRANSPORT_COORD_COLOR_REAL = 0xFFFF00
Local $TRANSPORT_START_COLOR_REAL = 0xE3AA6E

Local $TRANSPORT_DONE_COLOR_VIRTUAL = 0xCCFD87
Local $TRANSPORT_OPTION_VIRTUAL = 0xE1CF65
Local $TRANSPORT_TEXT_COLOR_VIRTUAL = 0xFDFDFD
Local $TRANSPORT_COORD_COLOR_VIRTUAL = 0xFDFD01
Local $TRANSPORT_START_COLOR_VIRTUAL = 0xE1A86D

Func AcceptProtect($character)
   If ActiveWindow(GetWinTitle($character), 3000) Then
	  If IsFindOutNpcPos($character) Then
		 Local $popUpBase = [361, 622]
		 If LeftClick($popUpBase, MouseGetPos(), 3000) Then
			While True
			   Local $firstOpt = PixelSearch(113, 242, 129, 345, $TRANSPORT_START_COLOR)
			   If @error <> 1 Then
				  WriteLogDebug("feature-transport", "Error click start")
				  LeftClick($popUpBase, $firstOpt, 3000)
				  Send("{DELETE}")
				  Return True
			   EndIf
			WEnd
		 EndIf
	  EndIf
	  Return False
   EndIf
EndFunc


Func ProtectInRoute($character)
   Local $hwnd = GetWinTitle($character)
   If ActiveWindow($hwnd, 3000) Then
	  Local $done = False
	  While Not $done
		 Local $npcCoord = PixelSearch(17, 639, 216, 719, $TRANSPORT_COORD_COLOR)
		 If @error <> 1 Then
			LeftClick($npcCoord, $npcCoord, 300)
			WaitChangeMap($hwnd, 20000, 500, 15)
			Send("{DELETE}")
			Local $meCoord = [515, 378]
			Local $avatar = [358, 62]
			If RightClick($avatar, $meCoord, 1000) Then
			   Local $optCoord2 = [376, 108]
			   If Not RightClick($optCoord2, $avatar, 1000) Then
				  Local $optCoord1 = [376, 80]
				  If LeftClick($optCoord1, $optCoord1, 3000) Then
					 If IsMoved($hwnd, 5000) Then
						ExitLoop
					 EndIf
				  EndIf
			   Else
				  WriteLogDebug("feature-transport", StringFormat("%s Follow failure", $character))
				  Local $bt = [117, 60]
				  LeftClick($optCoord2, $bt, 500)
			   EndIf
			EndIf
		 EndIf
	  WEnd
	  Local $avatarPx = PixelGetColor($avatar[0], $avatar[1])
	  While $avatarPx = PixelGetColor($avatar[0], $avatar[1])
		 Sleep(2000)
	  WEnd
   EndIf
EndFunc

Func ReceiveTransportAward($character)
   If ActiveWindow(GetWintitle($character), 3000) Then
	  If ClickNpcTransport($character) Then
		 If IsDoneTransport($character) Then
			WriteLogDebug("feature-transport", StringFormat("There is an award for %s", $character))
			DoReceiveAwardTransport($character)
			ClickNpcTransport($character)
		 ElseIf GUICtrlRead($UI_CANCEL_EXIST_REQUEST) = $GUI_CHECKED Then
			WriteLogDebug("feature-transport", StringFormat("Cancel exists transport for %s", $character))
			CancelExistsRequest($character)
		 EndIf
	  EndIf
   EndIf
EndFunc


Func CancelExistsRequest($character)
   If ActiveWindow(GetWintitle($character), 3000) Then
	  If IsReadyToStartTransport($character) Then
		 Local $coord = PixelSearch(122, 231, 129, 410, $TRANSPORT_OPTION)
		 If @error <> 1 Then
			PixelSearch(122, $coord[1] + 30 ,129, 438, $TRANSPORT_OPTION)
			Local $cancelCoord = [$coord[0], $coord[1] + 35]
			If LeftClick($cancelCoord, $cancelCoord, 3000) Then
			   WriteLogDebug("feature-transport", StringFormat("Canceled exists request for %s with coord %d - %d", $character, $cancelCoord[0], $cancelCoord[1]))
			   ClickNpcTransport($character)
			EndIf
		 EndIf
	  EndIf
   EndIf
EndFunc

Func ReceiveTransportRequest($character)
   $TRANSPORT_IS_NEW = False
   If ActiveWindow(GetWintitle($character), 3000) Then
	  If IsReadyToStartTransport($character) Then
		 WriteLogDebug("feature-transport", StringFormat("There is an exists request for %s", $character))
		 Return True
	  EndIf
	  If IsChooseModeAdvanceOrSimple($character) Then
		 WriteLogDebug("feature-transport", StringFormat("%s can choose advance mode", $character))
		 Local $coord = PixelSearch(122, 269, 129, 410, $TRANSPORT_OPTION)
		 LeftClick($coord, $coord, 3000)
	  EndIf
	  While True
		 Sleep(1000)
		 Local $coord = PixelSearch(124, 299, 129, 438, $TRANSPORT_OPTION)
		 If @error <> 1 Then
			Local $secondCoord = [$coord[0], $coord[1] + 35]
			If LeftClick($secondCoord, $secondCoord, 3000) Then
			   WriteLogDebug("feature-transport", StringFormat("%s get new request with coord %d - %d", $character, $secondCoord[0], $secondCoord[1]))
			   $TRANSPORT_IS_NEW = True
			   Return True
			EndIf
		 EndIf
	  WEnd
   EndIf
   Return False
EndFunc

Func IsCannotGetNewRequest($character)
   If ActiveWindow(GetWintitle($character), 3000) Then
	  Local $coord = PixelSearch(124, 231, 129, 438, $TRANSPORT_OPTION)
	  If @error <> 1 Then
		 PixelSearch(124, $coord[1] + 30 ,129, 438, $TRANSPORT_OPTION)
		 If @error = 1 Then
			WriteLogDebug("feature-transport", StringFormat("%s Team can not got more request", $character))
			Return True
		 EndIf
	  EndIf
   EndIf
   Return False
EndFunc

Func MoveToTransportMap($character)
   Local $hwnd = GetWintitle($character)
   If ActiveWindow($hwnd, 3000) Then
	  Local $firstOpt = PixelSearch(113, 254, 130, 474, $TRANSPORT_OPTION)
	  If LeftClick($firstOpt, $firstOpt, 3000) Then
		 Return WaitChangeMap($hwnd, 20000)
	  EndIf
   EndIf
EndFunc

Func ClickNpcTransport($character)
   If ActiveWindow(GetWintitle($character), 3000) Then
	  If IsFindOutNpcPos($character) Then
		 Local $popUpBase = [373, 619]
		 Return LeftClick($popUpBase, MouseGetPos(), 3000)
	  EndIf
   EndIf
   Return False
EndFunc

Func DoGoToTransportation($character)
   Local $hwnd = GetWintitle($character)
   If ActiveWindow($hwnd, 3000) Then
	  If OpenDuongChauMap(3000) Then
		 Local $btScroll = [997, 286]
		 Local $tagetScroll = [998, 414]
		 Local $targetPx = PixelGetColor($tagetScroll[0], $tagetScroll[1])
		 MouseClickDrag($MOUSE_CLICK_LEFT, $btScroll[0], $btScroll[1], $tagetScroll[0], $tagetScroll[1])
		 For $i = 1 To 10
			If $targetPx <> PixelGetColor($tagetScroll[0], $tagetScroll[1]) Then
			   ExitLoop
			EndIf
		 Next
		 Local $npcTransport = [870, 309]
		 If LeftClick($npcTransport, $npcTransport, 3000, 2) Then
			If LeftClick($NKVS_BUTTON_CLOSE_MAP, $NKVS_BUTTON_CLOSE_MAP, 3000) Then
			   WaitChangeMap($hwnd, 60000, 2000)
			   Return True
			EndIf
		 EndIf
	  EndIf
   EndIf
   WriteLogDebug("partner-team", "Error go to transportatation")
   Return False
EndFunc

Func IsDoneTransport($character)
   PixelSearch(103, 190, 127, 331, $TRANSPORT_DONE_COLOR)
   Return @error <> 1
EndFunc

Func DoReceiveAwardTransport($character)
   Local $coord = PixelSearch(103, 190, 127, 331, $TRANSPORT_DONE_COLOR)
   If LeftClick($coord, $coord, 3000) Then
	  Local $bt = [205, 621]
	  Local $btBase = [$bt[0]-40, $bt[1]]
	  If LeftClick($btBase, $bt, 3000) Then
		 Return True
	  EndIf
   EndIf
   WriteLogDebug("partner-team", "Error receive award transpot")
   Return False
EndFunc

Func IsChooseModeAdvanceOrSimple($character)
   If ActiveWindow(GetWintitle($character), 3000) Then
	  Local $firstOptCoord = PixelSearch(122, 269, 129, 410, $TRANSPORT_OPTION)
	  If @error <> 1 Then
		 Local $test = PixelSearch (228, $firstOptCoord[1] - 2, 240, $firstOptCoord[1] + 5, $TRANSPORT_TEXT_COLOR)
		 Return @error = 1
	  EndIf
   EndIf
   Return False
EndFunc

Func FindOptionTransportTeam($character)
   If ActiveWindow(GetWintitle($character), 3000) Then
	  Local $firstOpt = PixelSearch(224, 203, 130, 474, $TRANSPORT_OPTION)
	  Local $transportTeamOpt = [$firstOpt[0], $firstOpt[1] + 30]
	  Return $transportTeamOpt
   EndIf
EndFunc

Func IsReadyToStartTransport($character)
   If ActiveWindow(GetWintitle($character), 3000) Then
	  PixelSearch(92, 212, 139, 222, $TRANSPORT_TEXT_COLOR)
	  Return @error = 1
   EndIf
   Return False
EndFunc


Func BuildTransportUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Di van tieu", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 30
   $UI_GO_TRANSPORT = GUICtrlCreateCheckbox("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetState($UI_GO_TRANSPORT, $GUI_CHECKED)
EndFunc
Func BuildCancelTransportUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Huy nhiem vu cu", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 30
   $UI_CANCEL_EXIST_REQUEST = GUICtrlCreateCheckbox("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetState($UI_GO_TRANSPORT, $GUI_CHECKED)
EndFunc

