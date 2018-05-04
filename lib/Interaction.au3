#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#RequireAdmin
#include "C:\Users\htra\Documents\nkvs2-script\lib\Util.au3"
Opt("WinTitleMatchMode", 4)

; Script Start - Add your code below here

Dim $LOGON_OPTIONS[4] = ["Ẩn tất cả","Thoát tất cả", "Đăng nhập tất cả", "Ẩn auto xuống khay"]

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
	  Local $hwndId = "[TITLE:VIEAUTO.COM - Auto Update]"
	  footLog("DEBUG", StringFormat("Start %s success. Next to %s", $appPath, $hwndId))
	  Return $hwndId
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
		 Return "[TITLE:Tài khoản VIEAUTO.COM]"
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
	  Return "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
   EndIf
EndFunc

#cs
Step logon game
$hwndId: auto ui
$waiting: waiting for logon button
return -1: Deny next step because cannot select logon all
return 0: Deny next step because cannot click implement
return 1: Clicked implement
#ce
Func LogOnGameStep($hwndId, $waiting)
   Local $hwnd = WinWait($hwndId, "", 30)
   If $hwnd = 0 Then
	  Return 0
   EndIf
   Local $cbLogOn = FindComboboxContainOptions($hwnd, $LOGON_OPTIONS, $waiting);
   If $cbLogOn = -1 Or $cbLogOn = -2 Or Not SelectOption($hwnd, $cbLogOn, $LOGON_OPTIONS[2]) Then
	  Return -1
   EndIf
   Local $btLogOn = FindButtonWithText($hwnd, "Thực hiện", $waiting)
   If $btLogOn = -1 Or $btLogOn = -2 Then
	  Return 0
   Else
	  ClickButton($hwnd, $btLogOn)
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
	  Return 1
   EndIf
EndFunc

Dim $CHARACTER_HEADER_POSITION = 1
Dim $CHARACTER_HEADER_TEXT = "Tên nhân vật"
Dim $CHARACTER_STATUS_POSITION = 2

#cs
Check apply for character base on order
$hwndId: container
$chaOrder: order of character
return 0: Not found container
return -1: Not found character
return -2: Character is offline
return 1: checked
#ce
Func ApplyToCharacter($hwndId, $chaOrder)
   Local $hwnd = WinWait($hwndId, "", 30)
   If $hwnd = 0 Then
	  Return 0
   EndIf
   Local $lsCha = FindListView($hwnd, $CHARACTER_HEADER_POSITION, $CHARACTER_HEADER_TEXT, 30)
   If $lsCha = -1 Or $lsCha = -2 Then
	  Return -1
   EndIf
   Local $chaStatus = _GUICtrlListView_GetItemText($lsCha, $chaOrder, $CHARACTER_STATUS_POSITION)
   If StringStripWS ($chaStatus, 8) == "OFFLINE" Then
	  Return -2
   EndIf
   WinActivate($hwnd)
   CheckItemInList($lsCha, $chaOrder)
   Return 1
EndFunc



