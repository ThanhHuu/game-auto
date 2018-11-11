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
	  Send($code)
	  GraphicClick($confirmCode)
	  Return
   EndIf
   _FileWriteLogEx(StringFormat("%s not found LeQuan", $character))
EndFunc