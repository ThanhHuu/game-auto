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

Func IsBuyGoHomeItem()
   Local $basePx = PixelGetColor(205, 138)
   Send("{0}")
   Sleep(1000)
   If $basePx <> PixelGetColor(205, 138) Then
	  Send("{ESC}")
	  Sleep(500)
	  Return False
   Else
	  Send("{TAB}")
	  Sleep(100)
	  Send("{ESC}")
	  Sleep(400)
	  Return True
   EndIf
EndFunc

Func BuyItemManaAndFood($level, $noMana, $noFood)
   If WinExists($WindowGame) Then
	  If Not WinActive($WindowGame) Then
		 WinActivate($WindowGame)
		 Sleep(500)
	  EndIf
	  If WinActive($WindowGame) Then
		 Send("{TAB}")
		 Sleep(300)
		 MouseClickDrag($MOUSE_CLICK_LEFT, 996, 226, 996, 372)
		 Sleep(100)
		 MouseClick($MOUSE_CLICK_LEFT, 996, 325)
		 Sleep(200)
		 MouseClick($MOUSE_CLICK_LEFT, 920, 310, 2)
		 Sleep(1000)
		 Send("{ESC}")
		 Sleep(1000)
		 Local $pointer = [511, 326]
		 Moving($pointer, 100)

		 Local $firstPos = [242, 248]
		 Local $offsize = ($level - 60)*2
		 Local $basePx = PixelGetColor(115, 171)
		 While True
			Sleep(100)
			MouseClick($MOUSE_CLICK_LEFT, 490, 390)
			If $basePx <> PixelGetColor(115, 171) Then
			   ExitLoop
			EndIf
		 WEnd
		 $basePx = PixelGetColor(74, 247)
		 While True
			Sleep(100)
			MouseClick($MOUSE_CLICK_LEFT, 178, 264)
			If $basePx <> PixelGetColor(74, 247) Then
			   ExitLoop
			EndIf
		 WEnd
		 ; Buy mana
		 $basePx = PixelGetColor(519, 340)
		 While True
			Sleep(100)
			MouseClick($MOUSE_CLICK_LEFT, $firstPos[0] + $offsize ,$firstPos[1])
			If $basePx <> PixelGetColor(519, 340) Then
			   ExitLoop
			EndIf
		 WEnd
		 Send("" & $noMana)
		 $basePx = PixelGetColor(316, 200)
		 MouseClick($MOUSE_CLICK_LEFT, 520, 365)
		 If $basePx = PixelGetColor(316, 200) Then
			MouseClick($MOUSE_CLICK_LEFT, 520, 450)
		 EndIf
		 Sleep(500)

		 ; Buy food
		 $basePx = PixelGetColor(519, 340)
		 While True
			Sleep(100)
			MouseClick($MOUSE_CLICK_LEFT, $firstPos[0] + $offsize , $firstPos[1] + 40)
			If $basePx <> PixelGetColor(519, 340) Then
			   ExitLoop
			EndIf
		 WEnd
		 Send("" & $noFood)
		 $basePx = PixelGetColor(316, 200)
		 MouseClick($MOUSE_CLICK_LEFT, 520, 365)
		 If $basePx = PixelGetColor(316, 200) Then
			MouseClick($MOUSE_CLICK_LEFT, 520, 450)
		 EndIf
		 Send("{ESC}")
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

Func BuyItemGoHome($no)
   If WinExists($WindowGame) Then
	  If Not WinActive($WindowGame) Then
		 WinActivate($WindowGame)
		 Sleep(500)
	  EndIf
	  If WinActive($WindowGame) Then
		 If IsBuyGoHomeItem() Then
			Local $msg = StringFormat("%s - %s", "buy_items", "Go buy go home items")
			_FileWriteLog($LOG_FILE, $msg)
			; Go to NPC
			Local $basePx = PixelGetColor(172, 45)
			Send("{TAB}")
			While True
			   If $basePx <> PixelGetColor(172, 45) Then
				  ExitLoop
			   EndIf
			   Sleep(300)
			WEnd
			MouseClick($MOUSE_CLICK_LEFT, 82, 80)
			Sleep(500)
			MouseClick($MOUSE_CLICK_LEFT, 778, 431)
			Sleep(500)
			MouseClick($MOUSE_CLICK_LEFT, 930,330, 2)
			Sleep(1000)
			Send("{ESC}")
			Sleep(1000)
			Local $pointer = [511, 326]
			Moving($pointer, 100)
			; Buy items
			Local $basePx = PixelGetColor(209, 140)
			While True
			   Sleep(100)
			   MouseClick($MOUSE_CLICK_LEFT, 500, 400)
			   If $basePx <> PixelGetColor(209, 140) Then
				  ExitLoop
			   EndIf
			WEnd
			$basePx = PixelGetColor(77, 268)
			While True
			   Sleep(100)
			   MouseClick($MOUSE_CLICK_LEFT, 160,240)
			   If $basePx <> PixelGetColor(77, 268) Then
				  ExitLoop
			   EndIf
			WEnd
			$basePx = PixelGetColor(502, 334)
			While True
			   Sleep(100)
			   MouseClick($MOUSE_CLICK_LEFT, 170,250)
			   If $basePx <> PixelGetColor(502, 334) Then
				  ExitLoop
			   EndIf
			WEnd
			Send($no)
			$basePx = PixelGetColor(316, 200)
			MouseClick($MOUSE_CLICK_LEFT, 520, 365)
			If $basePx = PixelGetColor(316, 200) Then
			   MouseClick($MOUSE_CLICK_LEFT, 520, 450)
			EndIf
			Send("{ESC}")
		 EndIf
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

Func Moving($pointerPos, $offset)
   Local $pointerX = $pointerPos[0]
   Local $pointerY = $pointerPos[1]
   While True
	  Local $preTopPx = PixelGetColor($pointerX - $offset, $pointerY - $offset)
	  Local $preRightPx = PixelGetColor($pointerX + $offset,$pointerY - $offset)
	  Local $preBottomtPx = PixelGetColor($pointerX + $offset,$pointerY + $offset)
	  Local $preLeftPx = PixelGetColor($pointerX - $offset,$pointerY + $offset)
	  Sleep(3000)
	  Local $nextTopPx = PixelGetColor($pointerX - $offset,$pointerY - $offset)
	  Local $nextRightPx = PixelGetColor($pointerX + $offset,$pointerY - $offset)
	  Local $nextBottomtPx = PixelGetColor($pointerX + $offset,$pointerY + $offset)
	  Local $nextLeftPx = PixelGetColor($pointerX - $offset,$pointerY + $offset)
	  If $preTopPx = $nextTopPx And $preRightPx = $nextRightPx And $preBottomtPx = $nextBottomtPx And $preLeftPx = $nextLeftPx Then
		 ExitLoop
	  EndIf
   WEnd
EndFunc

