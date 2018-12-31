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

Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", "ĐịchThiênDoiA")
WinActivateEx($hwndCharacter)
DoReceiveOnlineEvent("ĐịchThiênDoiA", 3)

Func DoReceiveOnlineEvent($character, $awardOrder)
   If DoFindNpc($character) Then
	  Local $exitPopup = [371, 619]
	  GraphicClick(MouseGetPos(), "left", 1, $exitPopup)

	  Local $optEvent = [126, 295]
	  MouseClickEx($optEvent[0], $optEvent[1], 1000)

	  Local $firstAward = [126, 238]
	  MouseClickEx($firstAward[0], $firstAward[1] + $awardOrder * 30, 1000)

	  Local $finalConfirmCoord = [127, 248]
	  GraphicClick($finalConfirmCoord)

	  Return
   EndIf
   _FileWriteLogEx(StringFormat("%s not found LeQuan", $character))
EndFunc

Func OnlineEvent($characterInfos)
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
		 DoReceiveOnlineEvent($character, $code)
	  EndIf
   Next
EndFunc


