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
DllCall("User32.dll","bool","SetProcessDPIAware")

Dim $WindowGame = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

;AssignChallenge()
Func AssignChallenge()
   If ActiveWindowWithinTimeOut($WindowGame, 2000) Then
	  WriteLog("Assistant", StringFormat("Dieu doi %s", "NguTrucDam"))
	  Local $goHomeItemPos = [205, 138]
	  ; Chon ve noi o
	  If PressKeyWithinTimeOut($goHomeItemPos, "{0}", 2000) Then
		 Local $assistantHomePos1 = [262, 246]
		 Local $assistantHomePos2 = [776, 446]
		 Local $assistantHomePos3 = [553, 628]
		 Local $goAssistantHomePos = [160,325]
		 If ClickChangeMapWithinTimeOut($assistantHomePos1, $assistantHomePos2, $assistantHomePos3, $goAssistantHomePos, 10000) Then
			AssistantAward()
			Local $featurePos = [370, 435]
			AssistantFeature($featurePos)
		 EndIf
	  EndIf
   EndIf
EndFunc
