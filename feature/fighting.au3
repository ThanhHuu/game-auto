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
#include "setting.au3"
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

DIM $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

Func Fighting()
   If WinExists($WindowGame) Then
	  If Not WinActive($WindowGame) Then
		 WinActivate($WindowGame)
		 Sleep(500)
	  EndIf
	  If WinActive($WindowGame) Then
		 Local $basePx = PixelGetColor(172, 45)
		 Send("{TAB}")
		 While True
			If $basePx <> PixelGetColor(172, 45) Then
			   ExitLoop
			EndIf
			Sleep(300)
		 WEnd
		 MouseClick($MOUSE_CLICK_LEFT, 82, 80)
		 Sleep(1000)
		 MouseClick($MOUSE_CLICK_LEFT, 778, 431)
		 Sleep(1000)
		 MouseClickDrag($MOUSE_CLICK_LEFT,998,228, 998, 320)
		 Sleep(200)
		 MouseClick($MOUSE_CLICK_LEFT, 998, 420)
		 Sleep(200)
		 MouseClick($MOUSE_CLICK_LEFT, 903, 420, 2)
		 Sleep(2000)
		 Send("{ESC}")
		 Local $pointer = [511, 326]
		 Moving($pointer, 100)

		 $basePx = PixelGetColor(286, 387)
		 While True
			Sleep(100)
			MouseClick($MOUSE_CLICK_LEFT, 505, 400)
			If $basePx <> PixelGetColor(286, 387) Then
			   ExitLoop
			EndIf
		 WEnd
		 MouseClick($MOUSE_CLICK_LEFT, 231, 288)
		 Sleep(200)
		 MouseClick($MOUSE_CLICK_LEFT, 165, 270)
		 Sleep(200)
		 StartFighting()
		 Sleep(1000)
	  Else
		 Local $msg = StringFormat("%s - %s", "buy_items", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "buy_items", "Not found window game")
	  _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc

Func StartFighting()
   Sleep(10000)
   MouseClick($MOUSE_CLICK_LEFT, 975, 305)
   Sleep(1000)
   MouseClick($MOUSE_CLICK_LEFT, 168, 270)
   Local $count = 0
   While True
	  $count += 1
	  If $count = 50 Then
		 $count = 0
		 Send("{TAB}")
		 Sleep(1000)
		 MouseClick($MOUSE_CLICK_LEFT, 397, 405, 2)
		 Sleep(500)
		 Send("{ESC}")
	  EndIf

	  Sleep(1000)
	  If Not TurnOnFighting() Then
		 Send("m")
		 Sleep(1000)
		 ExitLoop
	  EndIf
	  Sleep(5000)
	  MouseClick($MOUSE_CLICK_LEFT, 935, 444)
	  Sleep(100)
	  MouseClick($MOUSE_CLICK_LEFT, 832, 528)
	  Sleep(200)
   WEnd
EndFunc


