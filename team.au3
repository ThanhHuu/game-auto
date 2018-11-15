#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include-once
#RequireAdmin

#include <GuiTab.au3>
#include <GuiComboBox.au3>
#include <GuiEdit.au3>
#include <GuiButton.au3>
#include <GuiListBox.au3>

#include "extension.au3"

DoSelectTeamTab()
DoSelectOptCaption()
DoOpenInvitationList()
DoClearListMember()
DoAddMember("htra")
DoAddMember("htra")
Func DoSelectTeamTab()
   Local $hContrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:SysTabControl32; INSTANCE:1]")
   Local $tabLoginIndex = _GUICtrlTab_FindTab($hContrl, "Tổ đội", False, 0)
   _GUICtrlTab_ClickTab($hContrl, $tabLoginIndex)
EndFunc

Func DoSelectOptCaption()
   Local $ctrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:87]")
   _GUICtrlButton_Click($ctrl)
EndFunc

Func DoOpenInvitationList()
   Local $ctrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:SysLink; INSTANCE:4]")
   ControlClick($AUTO_HWND, "", $ctrl)
EndFunc

Func DoClearListMember()
   Local $listBoxCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:ListBox; INSTANCE:3]")
   _GUICtrlListBox_ResetContent($listBoxCtrl)
   #cs
   Local $removeCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:120]")
   Local $total = _GUICtrlListBox_GetCount($listBoxCtrl)
   For $i = 0 To $total - 1
	  _GUICtrlListBox_SetCurSel($listBoxCtrl, $i)
	  _GUICtrlButton_Click($removeCtrl)
   Next
   #ce
EndFunc

Func DoAddMember($member)
   Local $listBoxCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:ListBox; INSTANCE:3]")
   Local $editCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:ComboBox; INSTANCE:12]")
   ControlSetText($AUTO_HWND, "", $editCtrl, $member)
   Local $addCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:119]")
   _GUICtrlButton_Click($addCtrl)
EndFunc
