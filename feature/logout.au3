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
#include "utils.au3"
#include <GuiListView.au3>
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Local $FIRST_Y = 35

Func Logout($character)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 60000) Then
	  Local $index = FindIndex($character)
	  WriteLogDebug("logout", StringFormat("Logout for %s", $character))
	  Return LogoutForIndex($index)
   EndIf
EndFunc

Func LogoutForIndex($index)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 60000) Then
	  If WinExists("Thông báo") Then
		 ControlClick("Thông báo", "", "CLASS:Button;INSTANCE:1")
	  EndIf
	  Local $maxLoop = 5
	  ; Click thoat game
	  Local $currentY = $FIRST_Y + $index*17
	  Local $indexPos = [14,$currentY]
	  Local $popupPos =[50, $currentY+15]
	  Local $listView = ControlGetHandle($WINDOW_LOGIN, "", "[CLASS:SysListView32;INSTANCE:1]")
	  Local $info = _GUICtrlListView_GetItem($listView, $index, 1)
	  Local $currentChar = $info[3]
	  if RightClickNpcWithinTimeOut($popupPos, $indexPos, 5000) Then
		 MouseClick($MOUSE_CLICK_LEFT, $popupPos[0], $popupPos[1])
		 For $j = 0 To 100
			$info = _GUICtrlListView_GetItem($listView, $index, 2)
			If StringStripWS($info[3], $STR_STRIPLEADING + $STR_STRIPTRAILING) = "OFFLINE" Then
			   WriteLogDebug("logout", StringFormat("Exited game at index %d", $index))
			   ProcessClose("ClientX86.exe")
			   Sleep(1000)
			   If RightClickNpcWithinTimeOut($popupPos, $indexPos, 5000) Then
				  Local $removePos = [50, $currentY + 55]
				  MouseClick($MOUSE_CLICK_LEFT, $removePos[0], $removePos[1])
				  For $i = 0 To 100
					 If WinExists("[TITLE:Xác nhận;CLASS:#32770]") Then
						WriteLogDebug("logout", StringFormat("Clicked remove game at index %d", $index))
						ControlClick("[TITLE:Xác nhận;CLASS:#32770]","", "[CLASS:Button;INSTANCE:1]")
						For $c = 0 To 100
						   $info = _GUICtrlListView_GetItem($listView, $index, 1)
						   If StringStripWS($info[3], $STR_STRIPLEADING + $STR_STRIPTRAILING) <> $currentChar Then
							  WriteLogDebug("logout", StringFormat("Removed character at index %d", $index))
							  Return True
						   EndIf
						   Sleep(100)
						Next
					 EndIf
					 Sleep(100)
				  Next
				  ExitLoop
			   EndIf
			EndIf
			Sleep(100)
		 Next
	  EndIf
	  Return False
   EndIf
EndFunc

Func LogoutAll()
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 60000) Then
	  Local $listView = ControlGetHandle($WINDOW_LOGIN, "", "[CLASS:SysListView32;INSTANCE:1]")
	  Local $total = _GUICtrlListView_GetItemCount($listView)
	  If $total > 0 Then
		 For $i = $total To 1 Step -1
			LogoutForIndex($i - 1)
		 Next
		 WriteLogDebug("logout", StringFormat("Logout for total %d", $total))
	  EndIf
   EndIf
EndFunc