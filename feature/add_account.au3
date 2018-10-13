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

