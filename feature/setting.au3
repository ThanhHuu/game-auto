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

Local $SETTING_BASE_PX = ""

;SetupFighting("ChuLamDoiA")
;SetupFighting("ChuLamDoiB")
Func SetupFighting($character, $basicObj)
   Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
   If ActiveWindowWithinTimeOut($winTitle, 3000) Then
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
   Return True
EndFunc

;TurnOffGraphic("ChuLamDoiA")
;TurnOffGraphic("ChuLamDoiB")
Func TurnOffGraphic($character, $basicObj)
   Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
   If ActiveWindowWithinTimeOut($winTitle, 3000) Then
	  Local $basePos = [508, 268]
	  PressKeyWithinTimeOut($basePos, "{TAB}", 500)
	  PressKeyWithinTimeOut($basePos, "{ESC}", 500)
	  Sleep(2000)
	  For $i = 0 To 1
		 If PressKeyWithinTimeOut($basePos, "{ESC}", 3000) Then
			Local $popUpPos = [250, 188]
			Local $clickSettingPos = [505, 315]
			If ClickNpcWithinTimeOut($popUpPos, $clickSettingPos, 2000) Then
			   WriteLog("setting", "Turnoff graphic")
			   MouseClick($MOUSE_CLICK_LEFT, 390, 225)
			   Sleep(200)
			   MouseClick($MOUSE_CLICK_LEFT, 340, 370)
			   Sleep(200)
			   Local $advanceBtPos = [439, 526]
			   Local $advanceOptPos = [339, 527]
			   If ClickNpcWithinTimeOut($advanceBtPos, $advanceOptPos, 2000) Then
				  If ClickNpcWithinTimeOut($advanceBtPos, $advanceBtPos, 2000) Then
					 MouseClick($MOUSE_CLICK_LEFT, 334, 270)
					 MouseClick($MOUSE_CLICK_LEFT, 531, 270)
					 MouseClick($MOUSE_CLICK_LEFT, 705, 270)

					 MouseClick($MOUSE_CLICK_LEFT, 320, 350)
					 MouseClick($MOUSE_CLICK_LEFT, 500, 350)
					 MouseClick($MOUSE_CLICK_LEFT, 665, 350)

					 MouseClick($MOUSE_CLICK_LEFT, 351, 430)
					 MouseClick($MOUSE_CLICK_LEFT, 351, 460)
					 MouseClick($MOUSE_CLICK_LEFT, 351, 490)
					 MouseClick($MOUSE_CLICK_LEFT, 351, 520)

					 MouseClick($MOUSE_CLICK_LEFT, 550, 430)
					 MouseClick($MOUSE_CLICK_LEFT, 550, 460)
					 MouseClick($MOUSE_CLICK_LEFT, 550, 490)

					 Local $btConfirmPos = [569, 570]
					 ClickNpcWithinTimeOut($btConfirmPos, $btConfirmPos, 2000)
				  EndIf
			   EndIf
			EndIf
			ExitLoop
		 EndIf
	  Next
	  PressKeyWithinTimeOut($popUpPos, "{TAB}", 500)
	  PressKeyWithinTimeOut($popUpPos, "{ESC}", 500)
   EndIf
   Return True
EndFunc

;TurnOnFighting("ChuLamDoiA")
;TurnOnFighting("ChuLamDoiB")
Func TurnOnFighting($character, $basicObj)
   Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
   If ActiveWindowWithinTimeOut($winTitle, 3000) Then
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
