#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
Opt("WinTitleMatchMode", 4)

; Script Start - Add your code below here
Local $wins = WinList("[REGEXPTITLE:.* Oracle VM VirtualBox]")
If $wins[0][0] > 0 Then
   For $i = 1 To $wins[0][0]
	  Local $winHwnd = $wins[$i][1]
	  WinSetState($winHwnd, "", @SW_SHOW)
   Next
EndIf