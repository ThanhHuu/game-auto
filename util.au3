#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         thanhhuupq@gmail.com

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once
#RequireAdmin

#include <GuiListView.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <GuiTab.au3>
#include <GuiButton.au3>

#include "extension.au3"

Local $UTIL_TAB_TEXT = "Tiện ích"
Local $COMBOBOX_ONLINE_EXP = "[CLASS:ComboBox; INSTANCE:7]"
Local $BUTTON_ONLINE_EXP = "[CLASS:Button; INSTANCE:56]"
Local $BUTTON_OFFLINE_EXP = "[CLASS:Button; INSTANCE:73]"
Local $BUTTON_OPEN_CARD = "[CLASS:Button; INSTANCE:60]"
Local $BUTTON_LUCKY_ITEM = "[CLASS:Button; INSTANCE:50]"
Local $BUTTON_LUCKY_ROUND = "[CLASS:Button; INSTANCE:55]"
Local $BUTTON_APPLY_UTIL_ALL = "[CLASS:Button; INSTANCE:58]"

Func DoSelectUtilTab()
   Local $hContrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:SysTabControl32; INSTANCE:1]")
   Local $tabUtilIndex = _GUICtrlTab_FindTab($hContrl, $UTIL_TAB_TEXT, False, 0)
   _GUICtrlTab_ClickTab($hContrl, $tabUtilIndex)
EndFunc

Func DoClickUtilButton($hbt)
   Local $btCtrl = ControlGetHandle($AUTO_HWND, "", $hbt)
   _GUICtrlButton_Click($btCtrl)
EndFunc

Func DoSelectOnlineExp($value)
   Local $cbCtrl = ControlGetHandle($AUTO_HWND, "", $COMBOBOX_ONLINE_EXP)
   _GUICtrlComboBox_SelectString($cbCtrl, $value)
EndFunc

Func ApplyUtilForAll()
   DoSelectUtilTab()
   DoClickUtilButton($BUTTON_APPLY_UTIL_ALL)
EndFunc
