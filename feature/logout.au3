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
#include <Process.au3>
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Local $FIRST_Y = 35


Func Logout($character)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 60000) Then
	  Local $index
	  While True
		 $index = FindIndex($character)
		 If $index < 6 Then
			ExitLoop
		 EndIf
		 LogoutForIndex(0)
	  WEnd
	  If $index <> -1 Then
		 WriteLogDebug("logout", StringFormat("Logout for %s", $character))
		 Return LogoutForIndex($index)
	  EndIf
	  Return False
   EndIf
EndFunc

Func LogoutForIndex($index)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 60000) Then
	  If WinExists("Thông báo") Then
		 ControlClick("Thông báo", "", "CLASS:Button;INSTANCE:1")
	  EndIf
	  If ExitGame($index) Then
		 RemoveOfflineCharacter()
		 Return True
	  EndIf
	  Return False
   EndIf
EndFunc

;ExitGame(1)
Func ExitGame($index)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 60000) Then
	  Local $listView = ControlGetHandle($WINDOW_LOGIN, "", "[CLASS:SysListView32;INSTANCE:1]")
	  Local $statusItem = _GUICtrlListView_GetItem($listView, $index, 2)
	  Local $status = StringStripWS($statusItem[3], $STR_STRIPLEADING + $STR_STRIPTRAILING)
	  If $status <> "OFFLINE" Then
		 WriteLogDebug("logout", StringFormat("Status current of index %d is %s", $index, $status))
		 Local $indexY = $FIRST_Y + $index*17
		 Local $indexPos = [14, $indexY]
		 If $status = "Online" Then
			Local $popupPos = [50, $indexY + 15]
			If RightClickNpcWithinTimeOut($popupPos, $indexPos, 5000) Then
			   MouseClick($MOUSE_CLICK_LEFT, $popupPos[0], $popupPos[1])
			EndIf
		 Else
			MouseClick($MOUSE_CLICK_LEFT, $indexPos[0], $indexPos[1])
			ProcessGarbageCollector()
		 EndIf
		 For $j = 0 To 100
			$statusItem = _GUICtrlListView_GetItem($listView, $index, 2)
			$status = StringStripWS($statusItem[3], $STR_STRIPLEADING + $STR_STRIPTRAILING)
			If $status = "OFFLINE" Then
			   WriteLogDebug("logout", StringFormat("Exited game at index %d", $index))
			   Return True
			EndIf
			Sleep(100)
		 Next
		 Return False
	  EndIf
	  Return True
   EndIf
   Exit
EndFunc

;ProcessGarbageCollector()
Func ProcessGarbageCollector()
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 60000) Then
	  Local $listView = ControlGetHandle($WINDOW_LOGIN, "", "[CLASS:SysListView32;INSTANCE:1]")
	  Local $total = _GUICtrlListView_GetItemCount($listView)
	  Local $validProcess = ObjCreate("Scripting.Dictionary")
	  For $i = 0 To $total - 1
		 If FindStatus($i) = "Online" Then
			Local $character = FindCharacterName($i)
			Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
			If WinExists($winTitle) Then
			   Local $pid = WinGetProcess($winTitle)
			   $validProcess.Add($pid, $character)
			EndIf
		 EndIf
	  Next
	  Local $processList = ProcessList("ClientX86.exe")
	  For $j = 1 To $processList[0][0]
		 Local $pid = $processList[$j][1]
		 If Not $validProcess.Exists($pid) Then
			ProcessClose($pid)
			WriteLogDebug("logout", "Close an invalid process")
		 EndIf
	  Next
   EndIf
EndFunc

Func RemoveOfflineCharacter()
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 60000) Then
	  Local $count = 0
	  Local $listView = ControlGetHandle($WINDOW_LOGIN, "", "[CLASS:SysListView32;INSTANCE:1]")
	  While ($count < 5)
		 If $count >= _GUICtrlListView_GetItemCount($listView) Then
			ExitLoop
		 EndIf
		 If FindStatus($count) = "OFFLINE" Then
			Local $name = FindCharacterName($count)
			Local $indexPos = [14, $FIRST_Y + $count*17]
			Local $popupPos = [50, $indexPos[1] + 55]
			If RightClickNpcWithinTimeOut($popupPos, $indexPos, 10000) Then
			   MouseClick($MOUSE_CLICK_LEFT, $popupPos[0], $popupPos[1])
			   WriteLogDebug("logout", StringFormat("Clicked remove game at index %d", $count))
			   If WaitConfirm() Then
				  ContinueLoop
			   EndIf
			EndIf
		 Else
			$count += 1
		 EndIf
	  WEnd
   Else
	  Exit
   EndIf
EndFunc

Func FindCharacterName($index)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 60000) Then
	  Local $listView = ControlGetHandle($WINDOW_LOGIN, "", "[CLASS:SysListView32;INSTANCE:1]")
	  Local $item = _GUICtrlListView_GetItem($listView, $index, 1)
	  Return StringStripWS($item[3], $STR_STRIPLEADING + $STR_STRIPTRAILING)
   EndIf
   Exit
EndFunc

Func FindStatus($index)
   If ActiveWindowWithinTimeOut($WINDOW_LOGIN, 60000) Then
	  Local $listView = ControlGetHandle($WINDOW_LOGIN, "", "[CLASS:SysListView32;INSTANCE:1]")
	  Local $item = _GUICtrlListView_GetItem($listView, $index, 2)
	  Return StringStripWS($item[3], $STR_STRIPLEADING + $STR_STRIPTRAILING)
   EndIf
   Exit
EndFunc

Func WaitConfirm()
   For $j = 0 To 1000
	  If WinExists("[TITLE:Xác nhận;CLASS:#32770]") Then
		 For $i = 0 To 100
			WinActivate("[TITLE:Xác nhận;CLASS:#32770]")
			ControlClick("[TITLE:Xác nhận;CLASS:#32770]","", "[CLASS:Button;INSTANCE:1]")
			If Not WinExists("[TITLE:Xác nhận;CLASS:#32770]") Then
			   WriteLogDebug("logout", "Confirmed")
			   Return True
			EndIf
			WriteLogDebug("logout", StringFormat("Fail confirm at time %d", $i))
			Sleep(200)
		 Next
	  EndIf
	  Sleep(100)
   Next
   Return False
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