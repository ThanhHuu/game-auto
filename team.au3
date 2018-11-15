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
#include <GUIConstantsEx.au3>

#include "extension.au3"
#include "character.au3"

Func DoSelectTeamTab()
   Local $hContrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:SysTabControl32; INSTANCE:1]")
   Local $tabLoginIndex = _GUICtrlTab_FindTab($hContrl, "Tổ đội", False, 0)
   _GUICtrlTab_ClickTab($hContrl, $tabLoginIndex)
EndFunc

Func DoSelectOptCaption()
   Local $ctrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:87]")
   _GUICtrlButton_Click($ctrl)
EndFunc

Func DoSelectOptMember()
   Local $ctrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:88]")
   _GUICtrlButton_Click($ctrl)
EndFunc

Func DoOpenInvitationList()
   Local $ctrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:SysLink; INSTANCE:4]")
   ControlClick($AUTO_HWND, "", $ctrl)
EndFunc

Func DoClearListMember()
   Local $listBoxCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:ListBox; INSTANCE:3]")
   Local $removeCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:120]")
   Local $total = _GUICtrlListBox_GetCount($listBoxCtrl)
   For $i = 0 To $total - 1
	  _GUICtrlListBox_SetCurSel($listBoxCtrl, $i)
	  _GUICtrlButton_Click($removeCtrl)
   Next
EndFunc

Func DoSpecifyCaptain($captian)
   Local $editCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Edit; INSTANCE:26]")
   Local $ctrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:95]")
   _GUICtrlButton_Click($ctrl)
   _GUICtrlEdit_SetText($editCtrl, $captian)
   _GUICtrlButton_Click($ctrl)
EndFunc

Func DoAddMember($member)
   Local $listBoxCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:ListBox; INSTANCE:3]")
   Local $refreshCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:118]")
   _GUICtrlButton_Click($refreshCtrl)
   Local $editCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:ComboBox; INSTANCE:12]")
   _GUICtrlComboBox_SelectString($editCtrl, $member)
   Local $addCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:119]")
   _GUICtrlButton_Click($addCtrl)
EndFunc

Func PrepareTeamTemplate($numberWindow)
   DoSelectTeamTab()
   For $i = 1 To $numberWindow - 1
	  DoSelectItem($i)
	  DoSelectOptMember()
	  ; enter captain
	  Local $editCtrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Edit; INSTANCE:26]")
	  _GUICtrlEdit_SetText($editCtrl, "captain")
	  ; check join team
	  Local $ctrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:100]")
	  _GUICtrlButton_Click($ctrl)
	  ; check out team
	  $ctrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:95]")
	  _GUICtrlButton_Click($ctrl)
   Next
EndFunc

Func DoBackFromInvitationView()
   Local $ctrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:Button; INSTANCE:116]")
   _GUICtrlButton_Click($ctrl)
EndFunc

Func OrganizeTeam($characterInfos)
   DoSelectTeamTab()
   ;For captain
   Local $captainInfo = $characterInfos[0]
   DoSelectItem(0)
   DoSelectOptCaption()
   DoOpenInvitationList()
   DoClearListMember()
   For $i = 1 To UBound($characterInfos) - 1
	  Local $characterInfo = $characterInfos[$i]
	  Local $member = $characterInfo[2]
	  DoAddMember($member)
   Next
   DoBackFromInvitationView()
   ; For members
   For $i = 1 To UBound($characterInfos) - 1
	  DoSelectItem($i)
	  DoSpecifyCaptain($captainInfo[2])
   Next
EndFunc