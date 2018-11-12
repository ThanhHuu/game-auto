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

Local $hwndGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II.*]"
WinActivateEx($hwndGame)
DoReceiveAssistantAward()
DoAssignNtd()

Func AssignFeature($characterInfos)
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  If WinActivateEx($hwndCharacter) Then
		 DoGoToHome()
	  EndIf
   Next
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  If WinActivateEx($hwndCharacter) Then
		 DoWaitGoToHome()
		 DoReceiveAssistantAward()
	  EndIf
   Next
EndFunc

Func DoGoToHome()
   Local $exitPopupCoord = [366, 621]
   If GraphicSend("{0}", $exitPopupCoord) Then
	  Local $goHomeCoord = [122, 323]
	  GraphicClick($goHomeCoord)
   EndIf
EndFunc

Func DoWaitGoToHome()
   Sleep(10*1000)
EndFunc

Func DoAssignNtd()
   Local $featureCoord = [355, 408]
   DoAssign($featureCoord)
EndFunc

Func DoAssignBc()
   Local $featureCoord = [326, 350]
   DoAssign($featureCoord)
EndFunc

Func DoReceiveAssistantAward()
   Local $assistantCoord = [742, 372]
   If GraphicClick($assistantCoord) Then
	  Local $receiveCoord = [451, 597]
	  Local $startReceiveCoord = [865, 536]
	  If GraphicClick($receiveCoord, "left", 1, $startReceiveCoord) Then
		 Local $closePopupCoord = [1002, 209]
		 If GraphicClick($startReceiveCoord) Then
			Sleep(2000)
			GraphicClick($closePopupCoord)
		 EndIf
	  EndIf
	  GraphicSend("{ESC}", $receiveCoord)
   EndIf
EndFunc

Func DoAssign($featureCoord)
   Local $assistantCoord = [742, 372]
   If GraphicClick($assistantCoord) Then
	  If GraphicClick($featureCoord) Then
		 Local $lastOpt = [127, 351]
		 Local $assignCoord = [449, 592]
		 Local $confirmCoord = [543, 474]
		 If GraphicClick($assignCoord, "left", 1, $lastOpt) Then
			For $i = 0 To 2
			   $lastOpt[1] -= $i * 30
			   If GraphicClick($lastOpt) Then
				  ExitLoop
			   EndIf
			Next
		 Else
			GraphicClick($confirmCoord)
		 EndIf
	  EndIf
	  GraphicSend("{ESC}", $assistantCoord)
   EndIf
EndFunc

Func DoQuickDone()
   Local $assistantCoord = [742, 372]
   If GraphicClick($assistantCoord) Then
	  Local $doneCoord = [449, 594]
	  GraphicClick($doneCoord)
	  GraphicSend("{ESC}", $assistantCoord)
   EndIf
EndFunc
