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

Func DoEnterCode($character, $code)
   If DoFindNpc($character) Then
	  Local $exitPopup = [371, 619]
	  GraphicClick(MouseGetPos(), "left", 1, $exitPopup)
	  Local $optCode = [126, 267]
	  Local $confirmCode = [561, 421]
	  GraphicClick($optCode, "left", 1, $confirmCode)
	  Local $mode = Opt("SendAttachMode", 1)
	  Sleep(1000)
	  Send($code)
	  Opt("SendAttachMode", $mode)
	  GraphicClick($confirmCode)
	  Local $finalConfirmCoord = [127, 237]
	  GraphicClick($finalConfirmCoord)
	  Sleep(1000)
	  GraphicClick($finalConfirmCoord)
	  Return
   EndIf
   _FileWriteLogEx(StringFormat("%s not found LeQuan", $character))
EndFunc

Func EnterCode($characterInfos)
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  If WinActivateEx($hwndCharacter) Then
		 DoMoveToNpcLeQuan($character)
		 Sleep(1000)
	  EndIf
   Next
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  If WinActivateEx($hwndCharacter) Then
		 DoMoveToNpcLeQuan($character)
		 Sleep(1000)
	  EndIf
   Next
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  Local $code = $characterInfo[3]
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  If WinActivateEx($hwndCharacter) Then
		 DoWaitChangeMap($hwndCharacter, 3*60*1000)
		 DoClosePopUp()
		 DoEnterCode($character, $code)
	  EndIf
   Next
EndFunc

Func JoinEvent($characterInfos)
   ; back Duong Chau
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  DoClickCharacter($character)
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  If WinActivateEx($hwndCharacter) Then
		 DoGoCentral()
		 Sleep(1000)
	  EndIf
   Next
   DoWaitGoToCentral($characterInfos)
   ; Click point map
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  If WinActivateEx($hwndCharacter) Then
		 DoMoveToPointCentralMap(510, 380)
		 Sleep(1000)
	  EndIf
   Next

   ; Recevice
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  If WinActivateEx($hwndCharacter) Then
		 DoWaitChangeMap($hwndCharacter, 20*1000)
		 DoClosePopUp()
		 DoReceiveEvent($character)
	  EndIf
   Next

   ; Recevice
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  If WinActivateEx($hwndCharacter) Then
		 For $i = 1 To 5
			DoReceiveEventAward($character)
		 Next
		 ExitLoop
	  EndIf
   Next

   ; Recevice
   For $characterInfo In $characterInfos
	  DoClickCharacter($character)
   Next
EndFunc

Func GoCentral($characterInfos)
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  If WinActivateEx($hwndCharacter) Then
		 DoGoCentral()
		 Sleep(1000)
	  EndIf
   Next
   DoWaitGoToCentral($characterInfos)
EndFunc

Func DoReceiveEvent($character)
   If DoFindNpc($character) Then
	  Local $exitPopup = [371, 619]
	  GraphicClick(MouseGetPos(), "left", 1, $exitPopup)
	  Local $optCode = [141, 286]
	  GraphicClick($optCode)
   EndIf
EndFunc

Func DoReceiveEventAward($character)
   If DoFindNpc($character) Then
	  Local $exitPopup = [371, 619]
	  GraphicClick(MouseGetPos(), "left", 1, $exitPopup)
	  MouseClickEx(141, 313, 1500)
	  MouseClickEx(130, 265, 500)
   EndIf
EndFunc

Func DoGoCentral()
   Local $exitPopupCoord = [366, 621]
   If GraphicSend("{0}", $exitPopupCoord) Then
	  Sleep(1000)
	  Local $goCentralCoord = [122, 262]
	  MouseClickEx($goCentralCoord[0], $goCentralCoord[1], 3000)
	  GraphicClick($goCentralCoord)
   EndIf
EndFunc

Func DoWaitGoToCentral($characterInfos)
   Local $sleeping = 20 - UBound($characterInfos) * 4
   Sleep($sleeping > 0 ? $sleeping * 1000 : 1000)
EndFunc

