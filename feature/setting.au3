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
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

Local $SETTING_BASE_PX = ""

;SetupFighting()
Func SetupFighting()
   If ActiveWindowWithinTimeOut($WindowGame, 2000) Then
	  Local $fightSettingPopUpPos = [41, 148]
	  If PressKeyWithinTimeOut($fightSettingPopUpPos, "^f", 3000) Then
		 WriteLog("setting", "Setting fighting")
		 MouseClick($MOUSE_CLICK_LEFT, 295,298)
		 Sleep(100)
		 Local $useFoodPos = [41,344]
		 CheckAnOptionFighting($useFoodPos)
		 Local $getItemPos = [40,382]
		 CheckAnOptionFighting($getItemPos)
		 Local $useManaPos = [40,410]
		 CheckAnOptionFighting($useManaPos)
		 MouseClickDrag($MOUSE_CLICK_LEFT, 73,481,177, 481)
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, $fightSettingPopUpPos[0], $fightSettingPopUpPos[1])
		 Sleep(100)
		 PressKeyWithinTimeOut($fightSettingPopUpPos, "{ESC}", 1000)
	  EndIf
   EndIf
EndFunc

;TurnOffGraphic()
Func TurnOffGraphic()
   If ActiveWindowWithinTimeOut($WindowGame, 2000) Then
	  Local $basePos = [508, 369]
	  For $i = 0 To 1
		 If PressKeyWithinTimeOut($basePos, "{ESC}", 3000) Then
			WriteLog("setting", "Turnoff graphic")
			Local $popUpPos = [250, 188]
			Local $clickSettingPos = [505, 315]
			If ClickNpcWithinTimeOut($popUpPos, $clickSettingPos, 2000) Then
			   MouseClick($MOUSE_CLICK_LEFT, 390, 225)
			   Sleep(100)
			   MouseClick($MOUSE_CLICK_LEFT, 309, 369)
			   Sleep(100)
			EndIf
			PressKeyWithinTimeOut($popUpPos, "{ESC}", 1000)
			ExitLoop
		 EndIf
	  Next
   EndIf
EndFunc

;TurnOnFighting()
Func TurnOnFighting()
   If ActiveWindowWithinTimeOut($WindowGame, 2000) Then
	  Local $fightSettingPopUpPos = [41, 148]
	  If PressKeyWithinTimeOut($fightSettingPopUpPos, "^f", 1000) Then
		 Local $enabelPos = [41,192]
		 CheckAnOptionFighting($enabelPos)
		 Sleep(500)
		 Local $enabled = Hex(PixelGetColor (41,192), 6) <> $SETTING_BASE_PX
		 PressKeyWithinTimeOut($fightSettingPopUpPos, "^f", 1000)
		 Return $enabled
	  EndIf
   EndIf
   Return False
EndFunc

Func CheckAnOptionFighting($optionPos)
   ; Get default px uncheck
   If $SETTING_BASE_PX = "" Then
	  MouseMove(40,360)
	  Sleep(200)
	  $SETTING_BASE_PX = Hex(PixelGetColor (40,360), 6)
   EndIf

   ; Check an option if current is uncheck
   MouseMove($optionPos[0], $optionPos[1])
   Sleep(200)
   If Hex(PixelGetColor (41,192), 6) = $SETTING_BASE_PX Then
	  MouseClick($MOUSE_CLICK_LEFT, 40, 192)
	  Sleep(100)
   EndIf
EndFunc
