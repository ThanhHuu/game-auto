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