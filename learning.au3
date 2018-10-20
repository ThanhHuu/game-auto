#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include-once
#include "feature\features_bundle.au3"
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <GuiTab.au3>
#include <Date.au3>
#include <ColorConstants.au3>
#include <FontConstants.au3>
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

Local $UI, $CHECKSUM_TYPE, $BUTTON_LEARNING, $IS_LEARNED
Local $CHECKSUM_DATA_MAP = LoadChecksumData()

Func BuildCheckSumUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Checksum", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 250
   $CHECKSUM_TYPE = GUICtrlCreateCombo("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetData($CHECKSUM_TYPE, "CHECKSUM_ASSISTANT_DONE|CHECKSUM_INVITATION_TEAM|CHECKSUM_IS_MEMBER_OF_TEAM|CHECKSUM_OFFLINE_EXP|CHECKSUM_TRANSPORT_DONE|CHECKSUM_TRANSPORT_CLICK|CHECKSUM_INVITATION_TEAM_BUTTON|CHECKSUM_FOLLOW_TEAM|CHECKSUM_TRANSPORT_BEFORE_START|CHECKSUM_TRANSPORT_BUTTON_RECEIVE")
EndFunc

Func BuildStatusUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Learned", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 30
   $IS_LEARNED = GUICtrlCreateCheckbox("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetState($IS_LEARNED, $GUI_DISABLE)
EndFunc

Func BuildActionUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = 50
   $BUTTON_LEARNING = GUICtrlCreateButton("Learn", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
EndFunc

$UI = GUICreate("Learning",460, 110)
BuildCheckSumUI(1, 1)
BuildStatusUI(2, 1)
BuildActionUI(3, 1)
GUISetState(@SW_SHOW)
While True
   Switch GUIGetMsg()
   Case $GUI_EVENT_CLOSE
	  ExitLoop
   Case $CHECKSUM_TYPE
	  Local $checksumName = GUICtrlRead($CHECKSUM_TYPE)
	  If $CHECKSUM_DATA_MAP.Exists($checksumName) Then
		 GUICtrlSetState($IS_LEARNED, $GUI_CHECKED)
	  Else
		 GUICtrlSetState($IS_LEARNED, $GUI_UNCHECKED)
	  EndIf
   Case $BUTTON_LEARNING
	  If Not GUICtrlRead($CHECKSUM_TYPE) <> "" Then
		 MsgBox(0, "", "Please choose checksum")
		 ContinueLoop
	  EndIf
	  If Not WinExists(GetWintitle(".*")) Then
		 MsgBox(0, "", "Login game to learning")
		 ContinueLoop
	  EndIf
	  LearnChecksum(GUICtrlRead($CHECKSUM_TYPE))
   EndSwitch
WEnd

Func LearnChecksum($checksumType)
   Local $checksumInfo = Eval($checksumType & "_INFO")
   Local $checksumValue = PixelChecksum($checksumInfo[0], $checksumInfo[1], $checksumInfo[2], $checksumInfo[3], 1, WinGetHandle(GetWintitle(".*")))
   If GUICtrlRead($IS_LEARNED) = $GUI_UNCHECKED Then
	  FileWriteLine($CHECKSUM_FILE, $checksumType & "=" & $checksumValue)
   Else
	  _FileWriteToLine($CHECKSUM_FILE, $CHECKSUM_DATA_MAP.Item($checksumType), $checksumType & "=" & $checksumValue, True)
   EndIf
EndFunc

Func LoadChecksumData()
   Local $dic = ObjCreate("Scripting.Dictionary")
   If FileExists($CHECKSUM_FILE) Then
	  Local $lines = FileReadToArray($CHECKSUM_FILE)
	  Local $count = 1
	  For $line In $lines
		 Local $infomation = StringSplit($line, "=")
		 $dic.Add($infomation[1], $count)
		 $count += 1
	  Next
   EndIf
   Return $dic
EndFunc