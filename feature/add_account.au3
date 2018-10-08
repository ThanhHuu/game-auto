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
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 3000) Then
	  MouseClick($MOUSE_CLICK_LEFT, $FIRST_CHARACTER[0] + 40, $FIRST_CHARACTER[1])
	  ActiveWindowWithinTimeOut($WINDOW_LOGIN, 3000)
	  EnterCharacter($usr, $pwd, $character)
	  If ExistCharacter() Then
		 ; Update character
		 MouseClick($MOUSE_CLICK_LEFT, $BUTTON_EDIT[0], $BUTTON_EDIT[1])
		 Sleep(500)
	  Else
		 ; Add new character
		 MouseClick($MOUSE_CLICK_LEFT, $BUTTON_ADD[0], $BUTTON_ADD[1])
		 Sleep(500)
	  EndIf
	  Return IsAddedAccount($character)
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

Func ExistCharacter()
   Local $listView = ControlGetHandle($WINDOW_LOGIN, "", "[CLASS:SysListView32;INSTANCE:1]")
   Return _GUICtrlListView_GetItemCount($listView) > 0 ? True : False
EndFunc

Func IsAddedAccount($character)
   Local $listView = ControlGetHandle($WINDOW_LOGIN, "", "[CLASS:SysListView32;INSTANCE:1]")
	  If _GUICtrlListView_GetItemCount($listView) > 0 Then
	  Local $firstItem = _GUICtrlListView_GetItem($listView, 0, 1)
	  Local $name = StringStripWS($firstItem[3], $STR_STRIPLEADING + $STR_STRIPTRAILING)
	  Return $name = $character ? True : False
   EndIf
   Return False
EndFunc

