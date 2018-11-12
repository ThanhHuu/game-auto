#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         thanhhuupq@gmail.com

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once
#RequireAdmin

#include <GuiTab.au3>
#include <GuiComboBox.au3>
#include <GuiEdit.au3>
#include <GuiButton.au3>
#include "extension.au3"

Local $LOGIN_TAB_TEXT = "Đăng nhập"
Local $SERVER_COMBOBOX = "[CLASS:ComboBox; INSTANCE:9]"
Local $USR_INPUT = "[CLASS:Edit; INSTANCE:27]"
Local $PWD_INPUT = "[CLASS:Edit; INSTANCE:28]"
Local $CHARACTER_INPUT = "[CLASS:Edit; INSTANCE:29]"
Local $ADD_BUTTON = "[CLASS:Button; INSTANCE:102]"
Local $EDIT_BUTTON = "[CLASS:Button; INSTANCE:104]"
Local $REMOVE_BUTTON = "[CLASS:Button; INSTANCE:103]"

Func DoSelectLoginTab()
   Local $hContrl = ControlGetHandle($AUTO_HWND, "", "[CLASS:SysTabControl32; INSTANCE:1]")
   Local $tabLoginIndex = _GUICtrlTab_FindTab($hContrl, $LOGIN_TAB_TEXT, False, 0)
   _GUICtrlTab_ClickTab($hContrl, $tabLoginIndex)
EndFunc

Func DoChooseServer($serverName)
   Local $serverContrl = ControlGetHandle($AUTO_HWND, "", $SERVER_COMBOBOX)
   _GUICtrlComboBox_SelectString($serverContrl, $serverName)
EndFunc

Func DoEnterAccount($usr, $pwd, $character)
   Local $usrContrl = ControlGetHandle($AUTO_HWND, "", $USR_INPUT)
   _GUICtrlEdit_SetText($usrContrl, $usr)

   Local $pwdContrl = ControlGetHandle($AUTO_HWND, "", $PWD_INPUT)
   _GUICtrlEdit_SetText($pwdContrl, $pwd)

   Local $characterContrl = ControlGetHandle($AUTO_HWND, "", $CHARACTER_INPUT)
   _GUICtrlEdit_SetText($characterContrl, $character)
EndFunc

Func DoAddNew()
   Local $addContrl = ControlGetHandle($AUTO_HWND, "", $ADD_BUTTON)
   _GUICtrlButton_Click($addContrl)
EndFunc

Func DoEdit()
   Local $editContrl = ControlGetHandle($AUTO_HWND, "", $EDIT_BUTTON)
   _GUICtrlButton_Click($editContrl)
EndFunc

Func ReLogin($character)
   Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
   If WinActivateEx($hwndCharacter) Then
	  Local $systemPoint = [1000, 732]
	  If GraphicClick($systemPoint) Then
		 Local $reloginPoint = [468, 380]
		 If GraphicClick($reloginPoint) Then
			Local $rightNowPoint = [641, 578]
			GraphicClick($rightNowPoint)
			Sleep(1000)
			If WinExists($hwndCharacter) Then
			   GraphicClick($rightNowPoint)
			EndIf
		 EndIf
	  EndIf
   EndIf
   Sleep(5000)
   Return Not WinExists($hwndCharacter)
EndFunc

Func DoRemove()
   If WinActivateEx($AUTO_HWND) Then
	  Local $btRemoveCtrl = ControlGetHandle($AUTO_HWND, "", $REMOVE_BUTTON)
	  _GUICtrlButton_Click($btRemoveCtrl)
	  WinWait("Xác nhận")
	  ControlClick("Xác nhận", "&Yes", "[CLASS:Button; INSTANCE:1]")
   EndIf
EndFunc

Func AddNewCharacter($serverName, $usr, $pwd, $character)
   DoSelectLoginTab()
   DoChooseServer($serverName)
   DoEnterAccount($usr, $pwd, $character)
   DoAddNew()
EndFunc
