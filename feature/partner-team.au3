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
#include <GUIConstantsEx.au3>
#include <FontConstants.au3>
#include <EditConstants.au3>
#include <WinAPIRes.au3>
#include <Array.au3>
#include "utils.au3"
#include "constant.au3"
#include "feature-transport.au3"

Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

Func TransportTeam($paramDic)
   Local $teamMembers = $paramDic.Item($PARAM_TEAM_MEMBER)
   TeamGoToPoint($paramDic)
   OrganizeTeam($paramDic)
   MoveTeamToTransportation($paramDic)
   For $member In $teamMembers
	  WriteLogDebug("team", "Receive exists award for team")
	  ReceiveTransportAward($member)
	  Sleep(500)
   Next
   If Not IsCannotGetNewRequest($teamMembers[0]) Then
	  ReceiveTransportRequest($teamMembers[0])
	  If GUICtrlRead($UI_GO_TRANSPORT) = $GUI_CHECKED Then
		 For $member In $teamMembers
			MoveToTransportMap($member)
			Sleep(500)
		 Next
		 For $i = 1 To 3
			If Not AcceptProtect($teamMembers[0]) Then
			   ExitLoop
			EndIf
			ProtectInRoute($teamMembers[0])
		 Next
		 BreakTeam($paramDic)
	  EndIf
   EndIf
EndFunc

;Local $paramDic = ObjCreate("Scripting.Dictionary")
;Local $test = ["TyThúyDoiB", "TyThúyDoiC", "TyThúyDoiD"]
;$paramDic.Add($PARAM_TEAM_MEMBER, $test)
;BreakTeam($paramDic)
Func BreakTeam($paramDic)
   Local $teamMembers = $paramDic.Item($PARAM_TEAM_MEMBER)
   If ActiveWindow(GetWintitle($teamMembers[0]), 3000) Then
	  If PressKey($MOVING_CHOICE_POPUP, "{0}", 3000) Then
		 Local $btBackVilage = [162, 271]
		 MouseClick($MOUSE_CLICK_LEFT, $btBackVilage[0], $btBackVilage[1])
		 Sleep(1000)
		 LeftClick($btBackVilage, $btBackVilage, 2000)
		 WaitChangeMap(GetWintitle($teamMembers[0]), 20000, 5000, 20)
		 Sleep(10000)
	  EndIf
   EndIf
   Local $btLeave = [57, 187]
   For $i = 1 To UBound($teamMembers) - 1
	  Local $hwnd = GetWintitle($teamMembers[$i])
	  If ActiveWindow($hwnd, 3000) Then
		 LeftClick($btLeave, $btLeave, 3000)
	  EndIf
   Next
   For $i = 1 To UBound($teamMembers) - 1
	  Local $hwnd = GetWintitle($teamMembers[$i])
	  If ActiveWindow($hwnd, 3000) Then
		 WaitChangeMap($hwnd, 10000, 1000)
		 If PressKey($MOVING_CHOICE_POPUP, "{0}", 3000) Then
			Local $btBackVilage = [162, 271]
			MouseClick($MOUSE_CLICK_LEFT, $btBackVilage[0], $btBackVilage[1])
			Sleep(1000)
			LeftClick($btBackVilage, $btBackVilage, 2000)
		 EndIf
	  EndIf
   Next
   For $i = 1 To UBound($teamMembers) - 1
	  Local $hwnd = GetWintitle($teamMembers[$i])
	  If ActiveWindow($hwnd, 3000) Then
		 WaitChangeMap(GetWintitle($teamMembers[0]), 20000, 5000, 20)
	  EndIf
   Next
EndFunc

Func MoveTeamToTransportation($paramDic)
   Local $teamMembers = $paramDic.Item($PARAM_TEAM_MEMBER)
   DoGoToTransportation($teamMembers[0])
   For $i = 1 To UBound($teamMembers)-1
	  Local $hwnd = GetWintitle($teamMembers[$i])
	  If ActiveWindow($hwnd, 3000) Then
		 WaitChangeMap($hwnd, 10000, 1000)
	  EndIf
   Next
EndFunc

Func OrganizeTeam($paramDic)
   Local $teamMembers = $paramDic.Item($PARAM_TEAM_MEMBER)
   Local $host = $teamMembers[0]
   If ActiveWindow(GetWintitle($host), 3000) Then
	  Local $btClose = [944, 140]
	  Local $btInvite = [906, 574]
	  If PressKey($btClose, "p", 3000) Then
		 Local $firstLineY = 423
		 For $i = 2 To UBound($teamMembers)
			Local $firstLine = [639, $firstLineY]
			LeftClick($firstLine, $firstLine, 1000)
			LeftClick($btInvite, $btInvite, 500)
			$firstLineY += 25
		 Next
		 LeftClick($btClose, $btClose, 3000)
	  EndIf
   EndIf
   For $member In $teamMembers
	  If $member = $host Then
		 ContinueLoop
	  EndIf
	  If ActiveWindow(GetWintitle($member), 3000) Then
		 Local $avatarMem = [39, 230]
		 Local $px = PixelGetColor($avatarMem[0], $avatarMem[1])
		 Local $btAccept = [881, 688]
		 While $px = PixelGetColor($avatarMem[0], $avatarMem[1])
			LeftClick($btAccept, $btAccept, 300)
		 WEnd
		 Local $optFollow = [18, 285]
		 if RightClick($optFollow, $avatarMem, 3000) Then
			LeftClick($optFollow, $optFollow, 1000)
		 EndIf
	  EndIf
   Next
   WriteLogDebug("partner-team", "Organize team success")
EndFunc

Func TeamGoToPoint($paramDic)
   Local $teamMembers = $paramDic.Item($PARAM_TEAM_MEMBER)
   Local $btCloseMap = [993, 45]
   For $member In $teamMembers
	  Local $hwnd = GetWintitle($member)
	  If ActiveWindow($hwnd, 3000) Then
		 If OpenDuongChauMap( 3000) Then
			Local $shopCoord = [832, 328]
			LeftClick($shopCoord, $shopCoord, 1000, 2)
			Sleep(500)
			LeftClick($btCloseMap, $btCloseMap, 1000)
		 EndIf
	  EndIf
   Next
   For $member In $teamMembers
	  Local $hwnd = GetWintitle($member)
	  If ActiveWindow($hwnd, 3000) Then
		 WaitChangeMap($hwnd, 120000, 1000)
		 Local $btTab = [1002, 167]
		 If LeftClick($btTab, $btTab, 3000) Then
			Local $targetCoord = [290, 236]
			LeftClick($targetCoord, $targetCoord, 1000)
			Sleep(500)
			LeftClick($btCloseMap, $btCloseMap, 1000)
		 EndIf
	  EndIf
   Next
   For $member In $teamMembers
	  Local $hwnd = GetWintitle($member)
	  If ActiveWindow($hwnd, 3000) Then
		 WaitChangeMap($hwnd, 60000, 1000)
	  EndIf
   Next
EndFunc

Func BuidUITeam($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("To Doi", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 30
   $UI_TEAM_MEMBER = GUICtrlCreateCombo("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetData($UI_TEAM_MEMBER, "3|4|5|6", "3")
EndFunc

