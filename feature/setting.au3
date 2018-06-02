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
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

DIM $TIME_TO_STORE=20000
DIM $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

Local $SETTING_BASE_PX = ""

Func Setting()
   If WinExists($WindowGame) Then
	  If Not WinActive($WindowGame) Then
		 WinActivate($WindowGame)
		 Sleep(500)
	  EndIf
	  If WinActive($WindowGame) Then
		 TurnOffGraphic()
		 SetupFighting()
	  Else
		 Local $msg = StringFormat("%s - %s", "setting", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "setting", "Not found window game")
	  _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc

Func SetupFighting()
   Send("^f")
   Sleep(1000)
   MouseClick($MOUSE_CLICK_LEFT, 295,298)
   If $SETTING_BASE_PX = "" Then
	  MouseMove(40,360)
	  Sleep(200)
	  $SETTING_BASE_PX = Hex(PixelGetColor (40,360), 6)
   EndIf
   MouseMove(41,344)
   Sleep(100)
   If Hex(PixelGetColor (41,344), 6) = $SETTING_BASE_PX Then
	  MouseClick($MOUSE_CLICK_LEFT, 40, 341)
	  Sleep(100)
   EndIf
   MouseMove(40,382)
   Sleep(100)
   If Hex(PixelGetColor (40,382), 6) = $SETTING_BASE_PX Then
	  MouseClick($MOUSE_CLICK_LEFT, 41, 379)
	  Sleep(100)
   EndIf
   MouseMove(40,410)
   Sleep(100)
   If Hex(PixelGetColor (40,410), 6) = $SETTING_BASE_PX Then
	  MouseClick($MOUSE_CLICK_LEFT, 41, 411)
	  Sleep(100)
   EndIf

   MouseClickDrag($MOUSE_CLICK_LEFT, 73,481,177, 481)
   Sleep(100)
   Send("{TAB}")
   Send("{ESC}")
   Sleep(1000)
EndFunc

Func TurnOffGraphic()
   Send("{ESC}")
   Sleep(1000)
   MouseClick($MOUSE_CLICK_LEFT, 505, 315)
   Sleep(100)
   MouseClick($MOUSE_CLICK_LEFT, 390, 225)
   Sleep(100)
   MouseClick($MOUSE_CLICK_LEFT, 309, 369)
   Sleep(100)
   Send("{TAB}")
   Send("{ESC}")
   Sleep(200)
EndFunc

Func TurnOnFighting()
   Send("^f")
   Sleep(1000)
   If $SETTING_BASE_PX = "" Then
	  MouseMove(40,360)
	  Sleep(200)
	  $SETTING_BASE_PX = Hex(PixelGetColor (40,360), 6)
   EndIf
   MouseMove(41,192)
   Sleep(100)
   If Hex(PixelGetColor (41,192), 6) = $SETTING_BASE_PX Then
	  MouseClick($MOUSE_CLICK_LEFT, 40, 192)
	  Sleep(100)
   EndIf
   Send("{TAB}")
   Send("{ESC}")
   Sleep(500)
EndFunc
