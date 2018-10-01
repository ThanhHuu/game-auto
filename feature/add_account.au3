#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#RequireAdmin
#include <Date.au3>
#include <File.au3>
#include "logout.au3"
#include "utils.au3"
#include "constant.au3"
#include <GuiListView.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstants.au3>
#include <FontConstants.au3>
#include <EditConstants.au3>
#include <File.au3>

Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

; AddAccount("a", "b", "c")
Func AddAccount($paramDic)
   Local $usr = $paramDic.Item($PARAM_USR)
   Local $pwd = $paramDic.Item($PARAM_PWD)
   Local $character = $paramDic.Item($PARAM_CHAR)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 2000) Then
	  EnterCharacter($usr, $pwd, $character)
	  If WinExists($WINDOW_NKVS) Then
		 ; Update character
		 MouseClick($MOUSE_CLICK_LEFT, $FIRST_CHARACTER[0], $FIRST_CHARACTER[1])
		 MouseClick($MOUSE_CLICK_LEFT, $BUTTON_EDIT[0], $BUTTON_EDIT[1])
	  Else
		 ; Add new character
		 MouseClick($MOUSE_CLICK_LEFT, $BUTTON_ADD[0], $BUTTON_ADD[1])
	  EndIf
	  For $i = 0 To 4
		 Sleep(100)
		 If WinExists("[TITLE:Thông báo;CLASS:#32770]") Then
			WriteLogDebug("add_account", StringFormat("Error adding account %s - %s",$usr, $character))
			ControlClick("[TITLE:Thông báo;CLASS:#32770]", "", "[CLASS:Button;INSTANCE:1]")
		 Else
			If FindIndex($character) <> -1 Then
			   WriteLogDebug("add_account", StringFormat("Added account %s - %s",$usr, $character))
			   Return True
			EndIf
		 EndIf
		 Sleep(3000)
	  Next
   EndIf
   Return False
EndFunc

Func EnterCharacter($usr, $pwd, $char)
   MouseClick($MOUSE_CLICK_LEFT, 160, 260)
   Sleep(100)
   Send("{BS 32}")
   Send("{DEL 32}")
   Sleep(100)
   Send($usr)
   Send("{TAB}")
   Sleep(100)
   Send($pwd)
   Send("{TAB}")
   Sleep(100)
   Send($char)
   Sleep(100)
EndFunc

Func BuidUIAddAccount($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Tai Khoan", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 200
   $UI_INPUT_ACCOUNTS = GUICtrlCreateInput("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT, $ES_READONLY)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 80
   $UI_BUTTON_ADD_ACCOUNT = GUICtrlCreateButton("Thu muc", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
EndFunc

; Return array objects
Func GetListAccounts()
   Local $result = ObjCreate("Scripting.Dictionary")
   Local $directoryPath = GUICtrlRead($UI_INPUT_ACCOUNTS)
   Local $files = _FileListToArrayRec($directoryPath, "*.acc", 1 + 4, 1, 1, 2);
   If $files <> "" And $files[0] > 0 Then
	  Local $count = 0;
	  For $i = 1 To $files[0]
		 Local $file = $files[$i]
		 Local $lines = FileReadToArray($file)
		 For $line In $lines
			$count += 1
			Local $accountObj = ObjCreate("Scripting.Dictionary")
			Local $infomation = StringSplit($line, "=")
			$accountObj.Add($PARAM_USR, $infomation[1])
			$accountObj.Add($PARAM_CHAR, $infomation[2])
			$accountObj.Add($PARAM_PWD, 'Ngoc@nh91')
			$result.Add($count, $accountObj)
		 Next
	  Next
   EndIf
   Return $result.Items
EndFunc

Func BuildIgnoreFeature()
   $RUNTIME_IGNORE_DIC = ObjCreate("Scripting.Dictionary")
   Local $directoryPath = GUICtrlRead($UI_INPUT_ACCOUNTS)
   Local $files = _FileListToArrayRec($directoryPath, "*.ignore", 1 + 4, 0, 1, 2);
   If $files <> "" And $files[0] > 0 Then
	  For $i = 1 To $files[0]
		 Local $file = $files[$i]
		 Local $featureDic = ObjCreate("Scripting.Dictionary")
		 Local $lines = FileReadToArray($file)
		 For $line In $lines
			$featureDic.Add($line, True)
		 Next
		 Local $featureName = StringReplace($file, $directoryPath & '\', '')
		 $RUNTIME_IGNORE_DIC.Add($featureName, $featureDic)
	  Next
   EndIf
EndFunc