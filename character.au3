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

#include "extension.au3"

Local $LIST_CHARACTER = "[CLASS:SysListView32; INSTANCE:1]"

Func DoSearchCharacter($character)
   Local $listCtrl = ControlGetHandle($AUTO_HWND, "", $LIST_CHARACTER)
   Return _GUICtrlListView_FindInText($listCtrl, $character)
EndFunc

Func DoSelectCharacter($character)
   Local $listCtrl = ControlGetHandle($AUTO_HWND, "", $LIST_CHARACTER)
   Local $index = DoSearchCharacter($character)
   DoSelectItem($index)
EndFunc

Func DoSelectItem($index)
   Local $listCtrl = ControlGetHandle($AUTO_HWND, "", $LIST_CHARACTER)
   _GUICtrlListView_SetItemSelected($listCtrl, $index, true, true)
EndFunc


Func DoClickCharacterEx($iRow, $iCol)
   If WinActivateEx($AUTO_HWND) Then
	  Local $listCtrl = ControlGetHandle($AUTO_HWND, "", $LIST_CHARACTER)
	  _GUICtrlListView_ClickItemEx($listCtrl, $iRow, $iCol)
   EndIf
EndFunc

Func DoClickCharacter($character)
   If WinActivateEx($AUTO_HWND) Then
	  Local $listCtrl = ControlGetHandle($AUTO_HWND, "", $LIST_CHARACTER)
	  Local $index = DoSearchCharacter($character)
	  _GUICtrlListView_ClickItem($listCtrl, $index)
   EndIf
EndFunc

Func DoClickItem($index)
   If WinActivateEx($AUTO_HWND) Then
	  Local $listCtrl = ControlGetHandle($AUTO_HWND, "", $LIST_CHARACTER)
	  _GUICtrlListView_ClickItem($listCtrl, $index)
   EndIf
EndFunc

Func DoCountCharacter()
   Local $listCtrl = ControlGetHandle($AUTO_HWND, "", $LIST_CHARACTER)
   Return _GUICtrlListView_GetItemCount($listCtrl)
EndFunc