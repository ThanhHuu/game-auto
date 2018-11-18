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

Func GoToHome($characterInfos)
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
	  If WinActivateEx($hwndCharacter) Then
		 DoHideAllNpc()
		 DoGoToHome()
	  EndIf
   Next
   DoWaitGoToHome($characterInfos)
   _FileWriteLogEx("Moved to home")
EndFunc

Func AssignTvp($characterInfo, $times = 1, $done = True)
   Local $character = $characterInfo[2]
   Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
   If WinActivateEx($hwndCharacter) Then
	  For $i = 1 To $times
		 DoReceiveAssistantAward()
		 DoAssignTvp()
		 If $done Then
			DoQuickDone()
		 Else
			ExitLoop
		 EndIf
	  Next
   EndIf
EndFunc

Func AssignNtd($characterInfo, $times = 1, $done = True)
   Local $character = $characterInfo[2]
   Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
   If WinActivateEx($hwndCharacter) Then
	  For $i = 1 To $times
		 DoReceiveAssistantAward()
		 DoAssignNtd()
		 If $done Then
			DoQuickDone()
		 Else
			ExitLoop
		 EndIf
	  Next
   EndIf
EndFunc

Func AssignBc($characterInfo, $times = 1, $done = True)
   Local $character = $characterInfo[2]
   Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
   If WinActivateEx($hwndCharacter) Then
	  For $i = 1 To $times
		 DoReceiveAssistantAward()
		 DoAssignBc()
		 If $done Then
			DoQuickDone()
		 Else
			ExitLoop
		 EndIf
	  Next
   EndIf
EndFunc

Func DoGoToHome()
   Local $exitPopupCoord = [366, 621]
   If GraphicSend("{0}", $exitPopupCoord) Then
	  Local $goHomeCoord = [122, 323]
	  GraphicClick($goHomeCoord)
   EndIf
EndFunc

Func DoWaitGoToHome($characterInfos)
   Local $sleeping = 20 - UBound($characterInfos) * 4
   Sleep($sleeping > 0 ? $sleeping * 1000 : 1000)
EndFunc

Func DoAssignNtd()
   Local $featureCoord = [355, 408]
   DoAssign($featureCoord)
EndFunc

Func DoAssignBc()
   Local $featureCoord = [326, 350]
   DoAssign($featureCoord)
EndFunc

Func DoAssignTvp()
   Local $featureCoord = [326, 470]
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

Func DoAssign($featureCoord, $lastOptY = 351)
   Local $assistantCoord = [742, 372]
   If GraphicClick($assistantCoord) Then
	  If GraphicClick($featureCoord) Then
		 If $lastOptY < 261 Then
			Return
		 EndIf
		 Local $lastOpt = [127, $lastOptY]
		 Local $assignCoord = [449, 592]
		 Local $confirmCoord = [543, 474]
		 If GraphicClick($assignCoord, "left", 1, $lastOpt) Then
			Local $assignSuccessCoord = [700, 548]
			If GraphicClick($lastOpt, "left", 1, $assignSuccessCoord) Then
			   Return
			Else
			   GraphicSend("{ESC}", $assistantCoord)
			   DoAssign($featureCoord, $lastOptY - 30)
			EndIf
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
