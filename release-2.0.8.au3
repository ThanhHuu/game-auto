#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#RequireAdmin
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

Local $UI, $BUTTON_RUN, $COUNT_DOWN

Func BuidAutoUI()
   BuidUIAddAccount(1, 1)

   BuildOpenCardUI(2, 1)
   BuildOnlineExpUI(2, 2)

   BuildTurnOffGraphicUI(3, 1)
   BuildSrollCircleUI(3, 2)

   BuildBuyItemsUI(4, 1)
   BuildUseItemsUI(4, 2)

   BuildTvpUI(5, 1)
   BuildNtdUI(5, 2)
   BuildBcUI(6, 1)

   BuildActionUI(7, 1)
EndFunc

$UI = GUICreate("Auto Configuration",460, 240)
BuidAutoUI()

GUISetState(@SW_SHOW)
While True
   Switch GUIGetMsg()
   Case $GUI_EVENT_CLOSE
	  ExitLoop
   Case $UI_BUTTON_ADD_ACCOUNT
	  GUICtrlSetData($UI_INPUT_ACCOUNTS, FileSelectFolder ("", @WindowsDir))
   Case $BUTTON_RUN
	  CoundDown(10)
   EndSwitch
WEnd

Func BuildActionUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP * 2
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = 50
   $BUTTON_RUN = GUICtrlCreateButton("Bat Dau", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 60
   Local $uiSize = WinGetClientSize($UI)
   $marginLeft = $uiSize[0]/2 - $width/2
   $marginTop = $uiSize[1]/2 - ($width + 10)/2
   $COUNT_DOWN = GUICtrlCreateLabel("", $marginLeft , $marginTop, $width, $width + 10)
   GUICtrlSetColor($COUNT_DOWN, $COLOR_RED)
   GUICtrlSetFont($COUNT_DOWN, 50, $FW_MEDIUM)
   GUICtrlSetState($COUNT_DOWN, $GUI_ONTOP )
   GUICtrlSetBkColor($COUNT_DOWN, $GUI_BKCOLOR_TRANSPARENT)
EndFunc

Func CoundDown($seconds)
   While $seconds > 1
	  $seconds -= 1
	  GUICtrlSetData($COUNT_DOWN, "" & $seconds)
	  GUICtrlSetState($COUNT_DOWN, $GUI_SHOW)
	  Sleep(500)
	  GUICtrlSetState($COUNT_DOWN, $GUI_HIDE)
	  Sleep(500)
   WEnd
   GUICtrlSetState($COUNT_DOWN, $GUI_HIDE)
EndFunc