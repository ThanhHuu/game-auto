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
#include <GuiListView.au3>
Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"

Func AddAccount($usr, $pwd, $character)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 2000) Then
	  WriteLog("add_account", StringFormat("Add account %s - %s",$usr, $character))
	  For $i = 0 To 4
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
		 Send($character)
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, 260, 220)
		 Sleep(100)
		 If WinExists("[TITLE:Thông báo;CLASS:#32770]") Then
			WriteLogDebug("add_account", StringFormat("Error adding account %s - %s",$usr, $character))
			ControlClick("[TITLE:Thông báo;CLASS:#32770]", "", "[CLASS:Button;INSTANCE:1]")
			Logout($character)
		 Else
			If ExistsCharacter($character) Then
			   WriteLogDebug("add_account", StringFormat("Added account %s - %s",$usr, $character))
			   Return True
			EndIf
		 EndIf
		 Sleep(3000)
	  Next
	  Return False
   EndIf
EndFunc

Func ExistsCharacter($character)
   Local $listView = ControlGetHandle($WINDOW_LOGIN, "", "[CLASS:SysListView32;INSTANCE:1]")
   Local $total = _GUICtrlListView_GetItemCount($listView)
   For $i = 0 To $total - 1
	  Local $nameItem = _GUICtrlListView_GetItem($listView, $i, 1)
	  Local $name = StringStripWS($nameItem[3], $STR_STRIPLEADING + $STR_STRIPTRAILING)
	  If $name = $character Then
		 Return True
	  EndIf
   Next
   Return False
EndFunc
