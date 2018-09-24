#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
Opt("WinTitleMatchMode", 4)

; Script Start - Add your code below here

hideAll("[REGEXPTITLE:.* Oracle VM VirtualBox]")
hideAll("[TITLE:NoxPlayer]")
hideAll("[TITLE:nox]")

Func hideAll($regexTitle)
   Local $wins = WinList($regexTitle)
   If @error <> 1 Then
	  For $i = 1 To $wins[0][0]
		 Local $winHwnd = $wins[$i][1]
		 WinSetState($winHwnd, "", @SW_HIDE)
	  Next
   EndIf
EndFunc