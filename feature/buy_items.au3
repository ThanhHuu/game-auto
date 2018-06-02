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

Local $BUY_ITEMS_PX1 = "FE040B"
Local $BUY_ITEMS_PX2 = "FE040B"
Local $BUY_ITEMS_PX3 = "FE040B"
Local $BUY_ITEMS_PX4 = "FE040B"

Func BuyItems($level, $noGoHome, $noMana, $noFood)
   If WinExists($WindowGame) Then
	  If Not WinActive($WindowGame) Then
		 WinActivate($WindowGame)
		 Sleep(500)
	  EndIf
	  If WinActive($WindowGame) Then
		 If IsBuyGoHomeItem() Then
			Local $msg = StringFormat("%s - %s", "buy_items", "Go buy items")
			_FileWriteLog($LOG_FILE, $msg)
			BuyItemGoHome("" & $noGoHome)
			BuyItemManaAndFood($level, $noMana, $noFood)
			LearningPixel()
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

Func LearningPixel()
   Send("{0}")
   Sleep(1000)
   $BUY_ITEMS_PX1 = Hex(PixelGetColor (399,143), 6)
   $BUY_ITEMS_PX2 = Hex(PixelGetColor (122,265), 6)
   $BUY_ITEMS_PX3 = Hex(PixelGetColor (122,292), 6)
   $BUY_ITEMS_PX4 = Hex(PixelGetColor (394,619), 6)
   Send("{ESC}")
   Sleep(200)
EndFunc


Func IsBuyGoHomeItem()
   Send("{0}")
   Sleep(1000)
   Local $pxColor1 = Hex(PixelGetColor (399,143), 6)
   Local $pxColor2 = Hex(PixelGetColor (122,265), 6)
   Local $pxColor3 = Hex(PixelGetColor (122,292), 6)
   Local $pxColor4 = Hex(PixelGetColor (394,619), 6)
   Local $msg = StringFormat("px1 = %s, px2 = %s, px3 = %s, px4 = %s", $pxColor1, $pxColor2, $pxColor3, $pxColor4)
   _FileWriteLog($LOG_FILE, StringFormat("%s - %s", "buy_item",$msg))
   If $BUY_ITEMS_PX1 = $pxColor1 And $BUY_ITEMS_PX2 = $pxColor2 And $BUY_ITEMS_PX3 = $pxColor3 And $BUY_ITEMS_PX4 = $pxColor4 Then
	  Send("{ESC}")
	  Sleep(100)
	  Return False
   Else
	  Send("{TAB}")
	  Sleep(100)
	  Send("{ESC}")
	  Return True
   EndIf
EndFunc

Func BuyItemManaAndFood($level, $noMana, $noFood)
   Send("{TAB}")
   Sleep(300)
   MouseClick($MOUSE_CLICK_LEFT, 930,330, 2)
   Sleep(2000)
   Send("{ESC}")
   Local $firstPos = [242, 248]
   Local $offsize = ($level - 60)*2
   MouseClick($MOUSE_CLICK_LEFT, 15, 270)
   Sleep(5000)
   MouseClick($MOUSE_CLICK_LEFT, 150,260)
   Sleep(300)
   MouseClick($MOUSE_CLICK_LEFT, $firstPos[0] + $offsize ,$firstPos[1])
   Sleep(300)
   Send("" & $noMana)
   MouseClick($MOUSE_CLICK_LEFT,525, 450)
   Sleep(300)
   MouseClick($MOUSE_CLICK_LEFT, $firstPos[0] + $offsize , $firstPos[1] + 40)
   Sleep(300)
   Send("" & $noFood)
   MouseClick($MOUSE_CLICK_LEFT,525, 450)
   Send("{TAB}")
   Send("{ESC}")
   Sleep(500)
EndFunc

Func BuyItemGoHome($no)
   Send("{TAB}")
   Sleep(300)
   MouseClick($MOUSE_CLICK_LEFT, 82, 80)
   Sleep(300)
   MouseClick($MOUSE_CLICK_LEFT, 778, 431)
   Sleep(300)
   MouseClick($MOUSE_CLICK_LEFT, 930,330, 2)
   Sleep(1000)
   Send("{ESC}")
   Send("m")
   Sleep(1000)
   Send("m")
   Sleep(15000)
   Send("m")
   Sleep($TIME_TO_STORE - 16000)

   MouseClick($MOUSE_CLICK_LEFT, 500, 400)
   Sleep(300)
   MouseClick($MOUSE_CLICK_LEFT, 160,240)
   Sleep(300)
   MouseClick($MOUSE_CLICK_LEFT, 170,250)
   Sleep(300)
   Send($no)
   MouseClick($MOUSE_CLICK_LEFT, 520, 365)
   Sleep(100)
   MouseClick($MOUSE_CLICK_LEFT, 520, 450)
   Sleep(100)
   Send("{TAB}")
   Send("{ESC}")
   Sleep(300)
EndFunc

