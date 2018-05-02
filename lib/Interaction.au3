#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#RequireAdmin
#include "C:\Users\htra\Documents\nkvs2-script\lib\Util.au3"

; Script Start - Add your code below here

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
$waiting: wait for update in seconds
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
$hwndId: window update
$waiting: wait for update in seconds
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

$next = StartStep("C:\Users\htra\Downloads\Auto Ngao Kiem Vo Song 2\AutoUpdate.exe")
MsgBox (0, "", $next)



