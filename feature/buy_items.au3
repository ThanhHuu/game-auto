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

Func IsBuyGoHomeItem()
   Local $basePx = [222, 496]
   If PressKeyWithinTimeOut($basePx, "{0}", 1000) Then
	  PressKeyWithinTimeOut($basePx, "{ESC}", 1000)
	  WriteLogDebug("buy_items", "We don't need buy PhuHoiThanh")
	  Return False
   Else
	  WriteLogDebug("buy_items", "We need buy PhuHoiThanh")
	  Return True
   EndIf
EndFunc

;BuyItemManaAndFood(90, 10, 10)
Func BuyItemManaAndFood($character, $basicObj)
   Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
   Local $level = $basicObj.Item("level")
   Local $noMana = $basicObj.Item("noMana")
   Local $noFood = $basicObj.Item("noFood")
   If ActiveWindowWithinTimeOut($winTitle, 3000) Then
	  WriteLog("buy_items", "Go buy food and mana")
	  OpenDuongChauMap(1000)
	  MouseClickDrag($MOUSE_CLICK_LEFT, 996, 226, 996, 372)
	  Sleep(100)
	  Local $npcPos = [920, 310]
	  MovingToNpcWithinTimeOut($character, $npcPos, 60000)
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

			PressKeyWithinTimeOut($shopPos, "{TAB}", 1000)
			PressKeyWithinTimeOut($shopPos, "{ESC}", 1000)
		 Else
			WriteLog("buy_item", StringFormat("%s - %s", "buy_item", "Error click to open shop"))
		 EndIf
	  Else
		 WriteLog("buy_item", StringFormat("%s - %s", "buy_item", "Error click to tiemduoc"))
	  EndIf
   EndIf
   Return True
EndFunc

;BuyItemGoHome(10)
Func BuyItemGoHome($character, $basicObj)
   Local $winTitle = "[REGEXPTITLE:Ngạo Kiếm Vô Song II\(" & $character & ".*]"
   Local $no = $basicObj.Item("noGoHome")
   If ActiveWindowWithinTimeOut($winTitle, 3000) Then
	  WriteLog("buy_item", "Go buy PhuHoiThanh")
	  If IsBuyGoHomeItem() Then
		 OpenDuongChauMap(1000)
		 Local $npcPos = [930,330]
		 MovingToNpcWithinTimeOut($character, $npcPos, 60000)
		 Local $askShopPos = [209, 140]
		 Local $askShopClickPos = [500, 400]
		 If ClickNpcWithinTimeOut($askShopPos, $askShopClickPos, 5000) Then
			Local $shopPos = [77, 268]
			Local $openShopPos = [160,240]
			If ClickNpcWithinTimeOut($shopPos, $openShopPos, 2000) Then
			   Local $itemPos = [170,250]
			   BuyItem($itemPos, $no)

			   PressKeyWithinTimeOut($shopPos, "{TAB}", 1000)
			   PressKeyWithinTimeOut($shopPos, "{ESC}", 1000)
			EndIf
		 EndIf
	  EndIf
   EndIf
   Return True
EndFunc

Func BuyItem($itemPos, $no)
   Local $itemPopUpPos = [502, 334]
   If ClickNpcWithinTimeOut($itemPopUpPos, $itemPos, 5000) Then
	  Send($no)
	  Local $confirmBt1 = [520, 365]
	  ClickNpcWithinTimeOut($confirmBt1, $confirmBt1, 500)
	  Local $confirmBt2 = [520, 450]
	  ClickNpcWithinTimeOut($confirmBt1, $confirmBt2, 500)
   Else
	  WriteLogDebug("buy_item", StringFormat("Error click item [%d, %d]", $itemPos[0], $itemPos[1]))
   EndIf
EndFunc

