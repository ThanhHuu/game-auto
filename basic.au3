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

Local $BASIC_TAB_TEXT = "Cơ bản"
Local $LIST_FEATURE = "[CLASS:SysListView32; INSTANCE:2]"
Local $COMBOBOX_CLASS = "[CLASS:ComboBox; INSTANCE:18]"
Local $BUTTON_APPLY_BASIC_ALL = "[CLASS:Button; INSTANCE:3]"

Func DoSelectBasicTab()
   Local $hContrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:SysTabControl32; INSTANCE:1]")
   Local $tabBasicIndex = _GUICtrlTab_FindTab($hContrl, $BASIC_TAB_TEXT, False, 0)
   _GUICtrlTab_ClickTab($hContrl, $tabBasicIndex)
EndFunc

Func DoSearchFeature($feature)
   Local $listCtrl = ControlGetHandle($AUTO_HWND, "", $LIST_FEATURE)
   Return _GUICtrlListView_FindInText($listCtrl, $feature)
EndFunc

DoSelectClass("")
Func DoSelectClass($className)
   If WinActivateEx($AUTO_HWND) Then
	  Local $cbCtrl = ControlGetHandle($AUTO_HWND, "", $COMBOBOX_CLASS)
	  Local $index = _GUICtrlComboBox_FindString($cbCtrl, $className)
	  Local $tRECT = _GUICtrlComboBox_GetDroppedControlRect($cbCtrl)
	  Local $firstItem = [$tRECT[0] + 20, $tRECT[1] + 10]
   EndIf
EndFunc


Func DoClickFeature($feature, $clicks = 1)
   If WinActivateEx($AUTO_HWND) Then
	  Local $index = DoSearchFeature("Truyện Ký")
	  Local $listCtrl = ControlGetHandle($AUTO_HWND, "", $LIST_FEATURE)
	  _GUICtrlListView_ClickItemEx($listCtrl, $index, $clicks)
   EndIf
EndFunc

Func ApplyBasicForAll()
   DoSelectBasicTab()
   Local $btCtrl = ControlGetHandle($AUTO_HWND, "", $BUTTON_APPLY_BASIC_ALL)
   _GUICtrlButton_Click($btCtrl)
EndFunc