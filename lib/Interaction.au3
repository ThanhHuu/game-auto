#RequireAdmin
#include-once
#include "Util.au3"
#include "Action.au3"
Opt("WinTitleMatchMode", 4)

Dim $LOGON_OPTIONS[4] = ["Ẩn tất cả","Thoát tất cả", "Đăng nhập tất cả", "Ẩn auto xuống khay"]
Dim $CHARACTER_STATUS_POSITION = 2
Dim $CHARACTER_LIST_VIEW = "[CLASS:SysListView32;INSTANCE:1]"
Dim $PROCESS_OF_GAME = "ClientX86.exe"
Dim $PROCESS_OF_DUMP = "DumpReportX86.exe"
Dim $SHOW_HIDE_SCENARIO_PATTERN = "ShowHide{}.sce"
Dim $WINDOW_UPDATE = "[TITLE:VIEAUTO.COM - Auto Update]"
Dim $WINDOW_LOGIN = "[TITLE:Tài khoản VIEAUTO.COM]"
Dim $WINDOW_AUTO = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Dim $WINDOW_ERROR[2] = ["[TITLE:nkvsAuto]", "[TITLE:ClienX86.exe]"]

Func CleanUpError()
   For $hwndError In $WINDOW_ERROR
	  If WinExists($hwndError) Then
		 footLog("DEBUG", StringFormat("$s - Exists error %s", "CleanUpError", $hwndError))
		 If WinKill($hwndError) Then
			footLog("DEBUG", StringFormat("$s - Closed error %s", "CleanUpError", $hwndError))
		 Else
			footLog("ERROR", StringFormat("$s - Can not close error %s", "CleanUpError", $hwndError))
		 EndIf
	  EndIf
   Next
   KillProcess($PROCESS_OF_GAME)
EndFunc


#cs
Copy file account to auto before Run
return -1: file not exists
return 0: move file fail
return 1: success
#ce
Func PrepareAccountStep($appPath, $accFile)
   If FileExists($appPath) = 0 Then
	  ; not found app
	  Return -1
   EndIf
   If FileExists($accFile) = 0 Then
	  ; not found Accounts.xml
	  Return -1
   EndIf
   footLog("DEBUG", StringFormat("%s - Prepare for acc %s", "PrepareAccountStep", $accFile))
   Local $parentDir = StringLeft($appPath, StringInStr($appPath, "\", 0, -1))
   Local $settingDir = $parentDir & "Settings"
   Return FileMove($accFile, $settingDir, 1)
EndFunc


#cs
Start Step
$appPath: absolute path to executing file
return -1: Deny next step
return hwndId: Ready for next step
#ce
Func StartStep($appPath)
   If Run($appPath) = 0 Then
	  Return -1;
   Else
	  footLog("DEBUG", StringFormat("%s success return %s", "StartStep", $WINDOW_UPDATE))
	  Return $WINDOW_UPDATE
   EndIf
EndFunc

#cs
Step Update
$hwndId: window update
$waiting: wait for button next in seconds
return -1: Can not update
return hwndLogin: Ready for next step
#ce
Func UpdateStep($hwndId, $waiting)
   Local $hwnd = WinWait($hwndId, "", 30)
   If $hwnd = 0 Then
	  ; cannot active window
	  Return -1
   EndIf
   Local $count = 0
   While $count <= 3
	  $count += 1
	  Local $hbtBegin = FindButtonWithText($hwnd, "Bắt đầu", $waiting)
	  If $hbtBegin = -1 Then
		 ; not found button bat dau
		 Return -1
	  ElseIf $hbtBegin = -2 Then
		 Local $hbtRetry = FindButtonWithText($hwnd, "Thử lại", 1)
		 ClickButton($hwnd, $hbtRetry)
		 ContinueLoop
	  Else
		 ClickButton($hwnd, $hbtBegin)
		 footLog("DEBUG", StringFormat("%s - Update success return %s", "UpdateStep", $WINDOW_LOGIN))
		 Return $WINDOW_LOGIN
	  EndIf
   WEnd
   ; try 3 times still failure
   Return -1
EndFunc

#cs
Step Login
$hwndId: window login
$waiting: wait for button login in seconds
return -1: Can not active window
return hwndAuto: Ready for next step
#ce
Func LoginStep($hwndId, $waiting)
   Local $hwnd = WinWait($hwndId, "", 30)
   If $hwnd = 0 Then
	  Return -1
   EndIf
   Local $hbtLogin = FindButtonWithInstance($hwnd, 1, $waiting)
   If $hbtLogin = -1 Or $hbtLogin = -2 Then
	  ; not found button login
	  Return -1
   Else
	  ClickButton($hwnd, $hbtLogin)
	  footLog("DEBUG", StringFormat("%s - Clicked login success return %s", "LoginStep", $WINDOW_AUTO))
	  Return $WINDOW_AUTO
   EndIf
EndFunc

#cs
Step logon game
$hwndId: auto ui
$waiting: waiting for logon button
return -1: Deny next step because cannot select logon all
return 1: Clicked implement
#ce
Func LogOnGameStep($hwndId, $waiting)
   Local $hwnd = WinWait($hwndId, "", 30)
   If $hwnd = 0 Then
	  footLog("DEBUG", StringFormat("%s - Not found window auto", "LogOnGameStep"))
	  Return -1
   EndIf
   Local $cbLogOn = FindComboboxContainOptions($hwnd, $LOGON_OPTIONS, $waiting);
   If $cbLogOn = -1 Or $cbLogOn = -2 Or Not SelectOption($hwnd, $cbLogOn, $LOGON_OPTIONS[2]) Then
	  Return -1
   EndIf
   Local $btLogOn = FindButtonWithText($hwnd, "Thực hiện", $waiting)
   If $btLogOn = -1 Or $btLogOn = -2 Then
	  Return -1
   Else
	  ClickButton($hwnd, $btLogOn)
	  Local $listView = ControlGetHandle($hwnd, "", $CHARACTER_LIST_VIEW)
	  Local $noCharacter = _GUICtrlListView_GetItemCount($listView)
	  footLog("DEBUG", StringFormat("%s - For %s characters", "LogOnGameStep", $noCharacter))
	  Sleep($noCharacter*20000)
	  Return 1
   EndIf
EndFunc

#cs
Step logout to game
$hwndId: auto ui
$waiting: waiting for logout button
return -1: Deny next step because cannot select logon all
return 0: Deny next step because cannot click implement
return 1: Clicked implement
#ce
Func LogOutGameStep($hwndId, $waiting)
   Local $hwnd = WinWait($hwndId, "", 30)
   If $hwnd = 0 Then
	  Return 0
   EndIf
   Local $cbLogOut = FindComboboxContainOptions($hwnd, $LOGON_OPTIONS, $waiting);
   If $cbLogOut = -1 Or $cbLogOut = -2 Or Not SelectOption($hwnd, $cbLogOut, $LOGON_OPTIONS[1]) Then
	  Return -1
   EndIf
   Local $btLogOut = FindButtonWithText($hwnd, "Thực hiện", $waiting)
   If $btLogOut = -1 Or $btLogOut = -2 Then
	  Return 0
   Else
	  ClickButton($hwnd, $btLogOut)
	  footLog("DEBUG", StringFormat("%s - Logout before close", "LogOutGameStep"))
	  Return 1
   EndIf
EndFunc

#cs
Check apply for character base on order
$hwndId: container
$chaOrder: order of character
return 0: Not found container
return -1: Not found character
return -2: Character is offline
return 1: checked
#ce
Func ApplyToAllCharacter($hwnd)
   Local $listView = ControlGetHandle($hwnd, "", $CHARACTER_LIST_VIEW)
   Local $noCharacter = _GUICtrlListView_GetItemCount($listView)
   WinActivate($hwnd)
   For $i = 0 To $noCharacter - 1
	  Local $chaStatus = _GUICtrlListView_GetItemText($listView, $i, $CHARACTER_STATUS_POSITION)
	  If StringStripWS ($chaStatus, 8) == "OFFLINE" Then
		 footLog("DEBUG", StringFormat("%s - Character %i still OFFLINE", "ApplyToAllCharacter", $i))
		 ContinueLoop
	  EndIf
	  CheckItemInList($listView, $i)
	  Sleep(300)
   Next
   Return 1
EndFunc

#cs
Function generate file
return -1: error
return generated file
#ce
Func CreateAccountsFile($template, $accountInfos)
   If _FileCreate("Accounts.xml") = 0 Then
	  ;Error create file
	  Return -1
   EndIf
   Local $accFile = _PathFull("Accounts.xml")
   If FileCopy($template, $accFile, 1) = 0 Then
	  ; error clone file template
	  Return -1
   EndIf
   Local $count = 1
   For $item In $accountInfos
	  Local $accPattern = "{account" & $count & "}"
	  Local $charPattern = "{character" & $count & "}"
	  _ReplaceStringInFile($accFile, $accPattern, $item.Item("account"))
	  _ReplaceStringInFile($accFile, $charPattern, $item.Item("character"))
	  $count += 1
   Next
   Return $accFile
EndFunc

#cs
Close auto
return -1: auto is not running
return -2: can not confirm yes
return -3: error kill process
return 1: success
#ce
Func StopAutoStep($hwndId, $waiting)
   If WinExists($hwndId) = 0 Then
	  Return -1
   EndIf
   Local $hwnd = WinActivate($hwndId)
   WinClose($hwnd)
   Local $hwndConfirm = "[TITLE:Thông báo!]"
   If WinExists($hwndConfirm) = 1 Then
	  ; Confirm close
	  Local $btYes = FindButtonWithInstance($hwndConfirm, 1, $waiting)
	  If $btYes = -1 Or $btYes = -2 Then
		 ; not found button yes
		 Return -2
	  EndIf
	  ClickButton($hwndConfirm, $btYes)
   EndIf
   Sleep(500)
   KillProcess($PROCESS_OF_GAME)
   Sleep(500)
   KillProcess($PROCESS_OF_DUMP)
   Return 1
EndFunc

Func KillProcess($processName)
   Local $try = 0
   While $try < 100
	  $try += 1
	  If ProcessExists($processName) <> 0 Then
		 footLog("DEBUG", StringFormat("%s - Still exists process %s", "StopAutoStep", $processName))
		 Local $count = 0;
		 While $count < 100
			$count += 1
			If ProcessClose($processName) = 1 Then
			   footLog("DEBUG", StringFormat("%s - Killed process %s", "StopAutoStep", $processName))
			   ExitLoop
			EndIf
			Sleep(100)
		 WEnd
		 If $count = 100 Then
			footLog("ERROR", StringFormat("%s - Can not exit exists process %s", "StopAutoStep", $processName))
			Return -1
		 EndIf
	  Else
		 ExitLoop
	  EndIf
   WEnd
   Return 1
EndFunc



Func ApplyActionSteps($hwnd, $scenario)
   Local $listView = ControlGetHandle($hwnd, "", $CHARACTER_LIST_VIEW)
   Local $noCharacter = _GUICtrlListView_GetItemCount($listView)

   For $i = 0 To $noCharacter - 1
	  Local $showHideSce = StringReplace($SHOW_HIDE_SCENARIO_PATTERN, "{}", $i)
	  Local $showHideSteps = BuildActionSteps($showHideSce)

	  ; Show game
	  ImplementAction($showHideSteps)
	  footLog("DEBUG", StringFormat("%s - Run scenario %s", "ApplyActionSteps", $scenario))
	  Local $actionSteps = BuildActionSteps($scenario)
	  ImplementAction($actionSteps)
	  ; Hide game
	  ImplementAction($showHideSteps)
   Next
EndFunc


