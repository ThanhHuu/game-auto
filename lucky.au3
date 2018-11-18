#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once
#RequireAdmin

#include "extension.au3"
#include "nkvs.au3"
#include "character.au3"
#include "assistant.au3"

Func DoLuckyRound()
   Local $luckyCoord = [790,420]
   If GraphicSend("j", $luckyCoord) Then
	  Sleep(2000)
	  Local $receiveCoord = [715, 525]
	  If GraphicClick($luckyCoord, "left", 1, $receiveCoord) Then
		 Local $beforePx = PixelGetColor($receiveCoord[0], $receiveCoord[1])
		 For $i = 1 To 5
			MouseClickEx(415, 370, 5000, "left", 2)
			Local $afterPx = PixelGetColor($receiveCoord[0], $receiveCoord[1])
			If $afterPx <> $beforePx Then
			   GraphicClick($receiveCoord)
			   ExitLoop
			EndIf
		 Next
	  EndIf
	  GraphicSend("{ESC}", $luckyCoord)
   EndIf
EndFunc

Func LuckyRound($characterInfos, $hideNpc = True, $goHome = False)
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  DoClickCharacter($character)
	  If WinActivateEx($hwndCharacter) Then
		 DoLuckyRound()
		 If $hideNpc Then
			DoHideAllNpc()
		 EndIf
		 If $goHome Then
			DoGoToHome()
		 EndIf
	  EndIf
   Next
EndFunc
