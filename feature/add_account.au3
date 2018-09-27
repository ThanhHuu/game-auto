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
Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

; AddAccount("a", "b", "c")
Func AddAccount($usr, $pwd, $character)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 2000) Then
	  WriteLog("add_account", StringFormat("Add account %s - %s",$usr, $character))
	  EnterCharacter($usr, $pwd, $character)
	  If WinExists($WINDOW_NKVS) Then
		 ; Update character
		 MouseClick($MOUSE_CLICK_LEFT, $BUTTON_EDIT[0], $BUTTON_EDIT[1])
	  Else
		 ; Add new character
		 MouseClick($MOUSE_CLICK_LEFT, $BUTTON_ADD[0], $BUTTON_ADD[1])
	  EndIf
	  For $i = 0 To 4
		 Sleep(100)
		 If WinExists("[TITLE:Thông báo;CLASS:#32770]") Then
			WriteLogDebug("add_account", StringFormat("Error adding account %s - %s",$usr, $character))
			ControlClick("[TITLE:Thông báo;CLASS:#32770]", "", "[CLASS:Button;INSTANCE:1]")
		 Else
			If FindIndex($character) <> -1 Then
			   WriteLogDebug("add_account", StringFormat("Added account %s - %s",$usr, $character))
			   Return True
			EndIf
		 EndIf
		 Sleep(3000)
	  Next
	  Return False
   EndIf
EndFunc

Func EnterCharacter($usr, $pwd, $char)
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
   Send($char)
   Sleep(100)
EndFunc