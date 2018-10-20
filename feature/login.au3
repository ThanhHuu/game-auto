#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#RequireAdmin
#include <Date.au3>
#include <File.au3>
#include "utils.au3"
#include "logout.au3"
#include "constant.au3"

Opt("PixelCoordMode", 2)
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
DllCall("User32.dll","bool","SetProcessDPIAware")

Local $FIRST_CHARACTER = [230, 350]
Local $CHARACTER_INDEX_FILE = "MapCharacter"
Local $RUNTIME_MAP_CHARACTER = ObjCreate("Scripting.Dictionary")
Local $BUTTON_PRE_PAGE = [409, 629]
Local $BUTTON_NEXT_PAGE = [601, 631]
Local $CHARACTER_PAGE_SIZE = 3

Func Login($paramDic)
   Local $usr = $paramDic.Item($PARAM_USR)
   Local $pwd = $paramDic.Item($PARAM_PWD)
   Local $character = $paramDic.Item($PARAM_CHAR)
   Local $characterIndex = $RUNTIME_MAP_CHARACTER.Exists($character) ? $RUNTIME_MAP_CHARACTER.Item($character) : 0
   Local $order = $paramDic.Item($PARAM_ORDER)

   If ActiveWindow(GetWinTitleWithinOrder($order), 3000) Then
	  For $i = 1 To 5
		 ChooseServer($order)
		 EnterCharacter($usr, $pwd, $order)
		 LoggedIn($characterIndex, $order)
		 If WinExists(GetWintitle($character)) Then
			If Not $RUNTIME_MAP_CHARACTER.Exists($character) Then
			   FileWriteLine($CHARACTER_INDEX_FILE, $character & '=' & $characterIndex)
			   $RUNTIME_MAP_CHARACTER.Add($character, $characterIndex)
			EndIf
			Return True
		 EndIf
		 $characterIndex += 1
		 If GetWinTitleWithinOrder($order) <> WinGetTitle($RUNTIME_NKVS_HWND[$order]) Then
			If Not Logout($paramDic) Then
			   Exit
			EndIf
		 Else
			Local $btReturn = [35, 702]
			Local $btReturnPx = [$btReturn[0]-20, $btReturn[1]]
			LeftClick($btReturnPx, $btReturn, 1000)
			Sleep(3000)
		 EndIf
	  Next
	  WriteLogDebug("login", "Not found character")
   EndIf
   Return False
EndFunc

Func EnterCharacter($usr, $pwd, $order)
   Local $checksum = PixelChecksum(0, 0, 20, 20, WinGetHandle(GetWinTitleWithinOrder($order)))
   While True
	  MouseClick($MOUSE_CLICK_LEFT, 446, 305)
	  Sleep(100)
	  Send("{BS 32}")
	  Send("{DEL 32}")
	  Sleep(100)
	  Send($usr)
	  Send("{TAB}")
	  Sleep(100)
	  Send($pwd)
	  Sleep(100)
	  Local $btBack = [513, 468]
	  Local $btBackBase = [$btBack[0] - 50, $btBack[1]]
	  Local $btBackPx = PixelGetColor($btBackBase[0], $btBackBase[1])
	  Send("{ENTER}")
	  Local $done = False
	  For $i = 1 To 10
		 Sleep(2000)
		 If $checksum <> PixelChecksum(0, 0, 20, 20, WinGetHandle(GetWinTitleWithinOrder($order))) Then
			$done = True
			ExitLoop
		 EndIf
	  Next
	  If $done Then
		 ExitLoop
	  EndIf
	  If $btBackPx <> PixelGetColor($btBackBase[0], $btBackBase[1]) Then
		 LeftClick($btBackBase, $btBack, 1000)
	  EndIf
   WEnd
EndFunc

Func ChooseServer($order)
   Local $checkSum = PixelChecksum(351, 296, 417, 310, WinGetHandle(GetWinTitleWithinOrder($order)))
   Local $changeServer = [625, 393]
   LeftClick($changeServer, $changeServer, 5000)
   LeftClick($NKVS_SERVER_KIMKIEM, $NKVS_SERVER_KIMKIEM, 1000)
   Local $btConfirm = [644, 575]
   Local $btConfirmPx = PixelGetColor($btConfirm[0] - 50, $btConfirm[1])
   Local $btRetry = [507, 470]
   Local $btRetryPx = PixelGetColor($btRetry[0], $btRetry[1])
   Local $btRetryPxPos = [$btRetry[0] - 50, $btRetry[1]]
   MouseClick($MOUSE_CLICK_LEFT, $btConfirm[0], $btConfirm[1])
   For $j = 1 To 10
	  Sleep(500)
	  If $btConfirmPx <> PixelGetColor($btConfirm[0] - 50, $btConfirm[1]) Then
		 WriteLogDebug("login", "Done choose server")
		 ExitLoop
	  EndIf
	  If $btRetryPx <> PixelGetColor($btRetry[0], $btRetry[1]) Then
		 WriteLogDebug("login", "Retry connect server")
		 LeftClick($btRetryPxPos, $btRetry, 1000)
	  EndIf
   Next
   For $i = 1 To 10
	  Sleep(500)
	  If $checksum = PixelChecksum(351, 296, 417, 310, WinGetHandle(GetWinTitleWithinOrder($order))) Then
		 ExitLoop
	  EndIf
   Next
EndFunc

Func LoggedIn($characterIndex, $order)
   BackToFirstPage($order)
   Local $page = $characterIndex/$CHARACTER_PAGE_SIZE
   For $i = 1 To $page
	  GoToNextPage($order)
   Next
   Local $indexOfPage = Mod($characterIndex, $CHARACTER_PAGE_SIZE)
   Local $charaterPos = [$FIRST_CHARACTER[0] + $indexOfPage*270, $FIRST_CHARACTER[1]]
   Local $characterPx = PixelGetColor($charaterPos[0], $charaterPos[1])
   While True
	  Sleep(100)
	  If $characterPx = PixelGetColor($charaterPos[0], $charaterPos[1]) Then
		 ExitLoop
	  Else
		 LeftClick($charaterPos, $charaterPos, 1000)
		 $characterPx = PixelGetColor($charaterPos[0], $charaterPos[1])
	  EndIf
   WEnd
   MouseClick($MOUSE_CLICK_LEFT, $charaterPos[0], $charaterPos[1], 2)
   For $j = 1 To 3
	  Sleep(5000)
	  If GetWinTitleWithinOrder($order) <> WinGetTitle($RUNTIME_NKVS_HWND[$order]) Then
		 ExitLoop
	  EndIf
   Next
   WriteLogDebug("login", "Done login")
EndFunc

Func BackToFirstPage($order)
   Local $i, $beforeCheckSum, $afterCheckSum
   For $i = 1 To 5
	  $beforeCheckSum = PixelChecksum(187, 500, 338, 511, WinGetHandle(GetWinTitleWithinOrder($order)))
	  LeftClick($BUTTON_PRE_PAGE, $BUTTON_PRE_PAGE, 1000)
	  $afterCheckSum = PixelChecksum(187, 500, 338, 511, WinGetHandle(GetWinTitleWithinOrder($order)))
	  If $beforeCheckSum = $afterCheckSum Then
		 ExitLoop
	  EndIf
	  $beforeCheckSum = $afterCheckSum
   Next
EndFunc

Func GoToNextPage($order)
   Local $beforeCheckSum = PixelChecksum(187, 500, 338, 511, WinGetHandle(GetWinTitleWithinOrder($order)))
   LeftClick($BUTTON_NEXT_PAGE, $BUTTON_NEXT_PAGE, 1000)
   For $i = 1 To 10
	  Sleep(300)
	  $afterCheckSum = PixelChecksum(187, 500, 338, 511, WinGetHandle(GetWinTitleWithinOrder($order)))
	  If $beforeCheckSum <> PixelChecksum(187, 500, 338, 511, WinGetHandle(GetWinTitleWithinOrder($order))) Then
		 ExitLoop
	  EndIf
   Next
EndFunc
