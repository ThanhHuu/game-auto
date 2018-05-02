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

Local $LOGON_OPTIONS[4] = ["Ẩn tất cả","Thoát tất cả", "Đăng nhập tất cả", "Ẩn auto xuống khay"]

#cs
Start Step
$appPath: absolute path to executing file
return 0: Deny next step
return hwndId: Ready for next step
#ce
Func StartStep($appPath)
   If Run($appPath) = 0 Then
	  Return 0;
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
return 0: Can not active window
return -1: Deny next step
return -2: Can not load update
return controlIdGoNext: Ready for next step
#ce
Func UpdateStep($hwndId, $waiting)
   Local $hwnd = WinWait($hwndId, "", 30)
   If $hwnd = 0 Then
	  Return 0
   EndIf
   Local $count = 0
   While $count <= 3
	  $count += 1
	  Local $hbtBegin = FindButtonWithText($hwnd, "Bắt đầu", $waiting)
	  If $hbtBegin = -1 Then
		 Return -1
	  ElseIf $hbtBegin = -2 Then
		 Local $hbtRetry = FindButtonWithText($hwnd, "Thử lại", 1)
		 ControlClick($hwnd, "", $hbtRetry)
		 ContinueLoop
	  Else
		 Return $hbtBegin
	  EndIf
   WEnd
   Return -2
EndFunc

#cs
Step Login
$hwndId: window login
$waiting: wait for button login in seconds
return 0: Can not active window
return -1: Deny next step
return controlIdGoNext: Ready for next step
#ce
Func LoginStep($hwndId, $waiting)
   Local $hwnd = WinWait($hwndId, "", 30)
   If $hwnd = 0 Then
	  Return 0
   EndIf
   Local $hbtLogin = FindButtonWithInstance($hwnd, 1, $waiting)
   If $hbtLogin = -1 Or $hbtLogin = -2 Then
	  Return -1
   Else
	  Return $hbtLogin
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
	  ControlClick($hwnd, "", $btLogOn)
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
	  ControlClick($hwnd, "", $btLogOut)
	  Return 1
   EndIf
EndFunc

$next = LogOutGameStep("[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]", 30)
MsgBox (0, "", $next)



