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
#include <WinAPIDiag.au3>

#include "extension.au3"
#include "character.au3"

Local $BASIC_TAB_TEXT = "Cơ bản"
Local $LIST_FEATURE = "[CLASS:SysListView32; INSTANCE:2]"
Local $COMBOBOX_CLASS = "[CLASS:ComboBox; INSTANCE:18]"

Func DoSelectBasicTab()
   Local $hContrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:SysTabControl32; INSTANCE:1]")
   Local $tabBasicIndex = _GUICtrlTab_FindTab($hContrl, $BASIC_TAB_TEXT, False, 0)
   _GUICtrlTab_ClickTab($hContrl, $tabBasicIndex)
EndFunc

Func ResetFeatures($characterInfos)
   If WinActivateEx($AUTO_HWND) Then
	  DoSelectBasicTab()
	  For $characterInfo In $characterInfos
		 Local $character = $characterInfo[2]
		 DoSelectCharacter($character)
		 Local $listCtrl = ControlGetHandle($AUTO_HWND, "", $LIST_FEATURE)
		 For $i = 0 To 9
			_GUICtrlListView_ClickItemEx($listCtrl, $i, 2, 2)
		 Next
	  Next
   EndIf
EndFunc

Func DoSearchFeature($feature)
   Local $listCtrl = ControlGetHandle($AUTO_HWND, "", $LIST_FEATURE)
   Return _GUICtrlListView_FindInText($listCtrl, $feature)
EndFunc

Func ApplyBasicForAll()
   DoSelectBasicTab()
   Local $btCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:3]")
   _GUICtrlButton_Click($btCtrl)
   $btCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:7]")
   _GUICtrlButton_Click($btCtrl)
EndFunc
