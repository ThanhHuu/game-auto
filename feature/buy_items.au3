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

Func IsBuyGoHomeItem()
   Local $basePx = [222, 496]
   If PressKeyWithinTimeOut($basePx, "{0}", 1000) Then
	  PressKeyWithinTimeOut($basePx, "{ESC}", 1000)
	  Return False
   Else
	  Return True
   EndIf
EndFunc

;BuyItemManaAndFood(90, 10, 10)
Func BuyItemManaAndFood($level, $noMana, $noFood)
   If ActiveWindowWithinTimeOut($WindowGame, 2000) Then
	  WriteLog("buy_items", "Mua mana va thuc an")
	  OpenDuongChauMap(1000)
	  MouseClickDrag($MOUSE_CLICK_LEFT, 996, 226, 996, 372)
	  Sleep(100)
	  Local $npcPos = [920, 310]
	  MovingToNpc($npcPos)
	  Local $askShopPos = [115, 171]
	  Local $askShopClickPos = [490, 390]
	  If ClickNpcWithinTimeOut($askShopPos, $askShopClickPos, 5000) Then
		 Local $shopPos = [74, 247]
		 Local $openShopPos = [178, 264]
		 If ClickNpcWithinTimeOut($shopPos, $openShopPos, 2000) Then
			Local $firstPos = [242, 248]
			Local $offsize = 0
			If $level >= 100 Then
			   $offsize = 80
			ElseIf $level >= 80 Then
			   $offsize = 40
			EndIf
			; Buy mana
			Local $itemManaPos = [242 + $offsize, 248]
			BuyItem($itemManaPos, $noMana)
			; Buy food
			Local $itemFoodPos = [242 + $offsize, 248 + 40]
			BuyItem($itemFoodPos, $noFood)
		 Else
			WriteLog("buy_item", StringFormat("%s - %s", "buy_item", "Error click to open shop"))
		 EndIf
	  Else
		 WriteLog("buy_item", StringFormat("%s - %s", "buy_item", "Error click to tiemduoc"))
	  EndIf
   EndIf
EndFunc

;BuyItemGoHome(10)
Func BuyItemGoHome($no)
   If ActiveWindowWithinTimeOut($WindowGame, 2000) Then
	  If IsBuyGoHomeItem() Then
		 WriteLog("buy_item", "Mua phu hoi thanh")
		 OpenDuongChauMap(1000)
		 Local $npcPos = [930,330]
		 MovingToNpc($npcPos)
		 Local $askShopPos = [209, 140]
		 Local $askShopClickPos = [500, 400]
		 If ClickNpcWithinTimeOut($askShopPos, $askShopClickPos, 5000) Then
			Local $shopPos = [77, 268]
			Local $openShopPos = [160,240]
			If ClickNpcWithinTimeOut($shopPos, $openShopPos, 2000) Then
			   Local $itemPos = [170,250]
			   BuyItem($itemPos, $no)
			Else
			   WriteLog("buy_item", StringFormat("%s - %s", "buy_item", "Error click to open shop"))
			EndIf
		 Else
			WriteLog("buy_item", StringFormat("%s - %s", "buy_item", "Error click to tiemtaphoa"))
		 EndIf
	  EndIf
   EndIf
EndFunc

Func BuyItem($itemPos, $no)
   Local $itemPopUpPos = [502, 334]
   If ClickNpcWithinTimeOut($itemPopUpPos, $itemPos, 5000) Then
	  Send($no)
	  Local $confirmBt1 = [520, 365]
	  ClickNpcWithinTimeOut($confirmBt1, $confirmBt1, 500)
	  Local $confirmBt2 = [520, 450]
	  ClickNpcWithinTimeOut($confirmBt1, $confirmBt2, 500)
	  PressKeyWithinTimeOut($itemPopUpPos, "{TAB}", 1000)
	  PressKeyWithinTimeOut($itemPopUpPos, "{ESC}", 1000)
   Else
	  WriteLog("buy_item", StringFormat("%s - %s", "buy_item", "Error click item"))
   EndIf
EndFunc

