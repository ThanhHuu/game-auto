#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#RequireAdmin
#include <AutoItConstants.au3>
#include <File.au3>
#include <Date.au3>
#include "utils.au3"
#include <GUIConstantsEx.au3>

Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

Func OfflineExp($paramDic)
   Local $bt = [909, 705]
   Local $btBase = [$bt[0] - 20, $bt[1]]
   If LeftClick($btBase, $bt, 3000) Then
	  If GUICtrlRead($UI_FEATURE_ONLINE_EX) = $GUI_CHECKED Then
		 Local $btReceive = [360, 467]
		 If LeftClick($btReceive, $btReceive, 3000) Then
			Local $btConfirm = [507, 468]
			LeftClick($btConfirm, $btConfirm, 3000)
		 EndIf
	  Else
		 Local $btClose = [828, 233]
		 LeftClick($btReceive, $btReceive, 3000)
	  EndIf
   EndIf
   Return True
EndFunc