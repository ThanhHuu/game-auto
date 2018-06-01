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

Func BuyItems($level)
   If WinExists($WindowGame) Then
	  If Not WinActive($WindowGame) Then
		 WinActivate($WindowGame)
	  EndIf
	  If WinActive($WindowGame) Then
		 If IsBuyGoHomeItem() Then

			BuyItemGoHome("" & 1)
			If $level = 80 Then
			   Local $msg = StringFormat("%s - %s", "buy_items", "Go buy items")
			   _FileWriteLog($LOG_FILE, $msg)
			   ; Mua Mana,ThucAn
			   MouseClick($MOUSE_CLICK_LEFT, 15, 270)
			   Sleep(5000)
			   MouseClick($MOUSE_CLICK_LEFT, 150,260)
			   Sleep(300)
			   MouseClick($MOUSE_CLICK_LEFT, 270,250)
			   Sleep(300)
			   Send("82")
			   MouseClick($MOUSE_CLICK_LEFT,525, 450)
			   Sleep(300)
			   MouseClick($MOUSE_CLICK_LEFT, 280,290)
			   Sleep(300)
			   Send("3")
			   MouseClick($MOUSE_CLICK_LEFT,525, 450)
			   Send("{ESC}")
			EndIf
		 EndIf
	  Else
		 Local $msg = StringFormat("%s - %s", "buy_items", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "buy_items", "Not found window game")
	  _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc

Func IsBuyGoHomeItem()
   Send("{0}")
   Sleep(1000)
   Local $pxColor1 = Hex(PixelGetColor (399,143), 6)
   _FileWriteLog($LOG_FILE, StringFormat("%s - %s", "buy_item", "px1 = " & $pxColor1))
   Local $pxColor2 = Hex(PixelGetColor (122,265), 6)
   _FileWriteLog($LOG_FILE, StringFormat("%s - %s", "buy_item", "px2 = " & $pxColor2))
   Local $pxColor3 = Hex(PixelGetColor (122,292), 6)
   _FileWriteLog($LOG_FILE, StringFormat("%s - %s", "buy_item", "px3 = " & $pxColor3))
   Local $pxColor4 = Hex(PixelGetColor (394,619), 6)
   _FileWriteLog($LOG_FILE, StringFormat("%s - %s", "buy_item", "px4 = " & $pxColor4))
   If "FE040B" = $pxColor1 And "6F87B4" = $pxColor2 And "39578D" = $pxColor3 And "2C1009" = $pxColor4 Then
	  Send("{ESC}")
	  Return False
   Else
	  Return True
   EndIf
EndFunc

Func BuyItemGoHome($no)
   Send("{TAB}")
   ; Mua PhuHoiThanh
   MouseClick($MOUSE_CLICK_LEFT, 930,330, 2)
   Send("{ESC}")
   Send("m")
   Sleep(100)
   Send("m")
   Sleep(15000)
   Send("m")
   Sleep($TIME_TO_STORE - 10000)

   MouseClick($MOUSE_CLICK_LEFT, 500, 400)
   Sleep(300)
   MouseClick($MOUSE_CLICK_LEFT, 160,240)
   Sleep(300)
   MouseClick($MOUSE_CLICK_LEFT, 170,250)
   Sleep(300)
   Send($no)
   MouseClick($MOUSE_CLICK_LEFT, 520, 365)
   MouseClick($MOUSE_CLICK_LEFT, 520, 450)
   Sleep(300)
   Send("{ESC}")
EndFunc

