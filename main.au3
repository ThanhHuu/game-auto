#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <WinAPI.au3>

#include "ui.au3"
#include "login.au3"
#include "character.au3"
#include "basic.au3"
#include "util.au3"

Local $ui = CreateUi()
GUISetState(@SW_SHOW, $ui)
Local $btSelectId = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; TEXT:Chọn]"))
Local $inAccountId = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Edit; INSTANCE:1]"))
Local $btStartId = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; TEXT:Bắt đầu]"))

While True
   Switch GUIGetMsg()
   Case $GUI_EVENT_CLOSE
	  ExitLoop
   Case $btSelectId
	  Local $folder = FileSelectFolder ("Chọn thư mục", "")
	  GUICtrlSetData($inAccountId, $folder)
   Case $btStartId
	  If GUICtrlRead($inAccountId) = "" Then
		 MsgBox(16, "Warning", "Chọn thư mục tài khoản trước")
		 ContinueLoop
	  EndIf
	  Local $accountFiles = ListFileOfFolder(GUICtrlRead($inAccountId))
	  Local $characters = GetListCharacters($accountFiles)
	  Local $numberWindow = GetNumberWindow()
	  CloneCharacter($numberWindow)
	  For $i = 0 To UBound($characters.Keys) Step $numberWindow
		 For $j = 0 To $numberWindow - 1
			If IsHideGame() Then
			   DoClickCharacterEx($j, 3)
			EndIf
			Local $character = $characters.Keys[$i + $j]
			Local $usr = $characters.Item($character)
			ConfigureForCharacter($usr, $character, $j)
			DoClickCharacter($character)
			GameWait($character)
			DoIgnoreChatacter($character)
			_FileWriteLogEx(StringFormat("Logged in for %s", $character))
		 Next
		 Sleep(GetTime()*60*1000)
		 For $j = 0 To $numberWindow - 1
			If IsHideGame() Then
			   DoClickCharacterEx($j, 3)
			EndIf
			Local $character = $characters.Keys[$i + $j]
			DoClickCharacter($character)
			Sleep(5000)
			If Not ReLogin($character) Then
			   KillGame($character)
			   _FileWriteLogEx(StringFormat("Killed game for %s", $character))
			EndIf
			_FileWriteLogEx(StringFormat("Re-logged in for %s", $character))
		 Next
	  Next
   EndSwitch
WEnd

Func GetListCharacters($accountFiles)
   Local $characters = ObjCreate("Scripting.Dictionary")
   For $file In $accountFiles
	  Local $lines = FileReadToArray($file)
	  For $line In $lines
		 Local $infomation = StringSplit($line, "=")
		 If Not IsIgnoredCharacter($infomation[2]) Then
			$characters.Add($infomation[2], $infomation[1])
		 EndIf
	  Next
   Next
   Return $characters
EndFunc

Func ConfigureForCharacter($usr, $character, $index)
   DoSelectItem($index)
   DoSelectLoginTab()
   DoEnterAccount($usr, "Ngoc@nh91", $character)
   DoEdit()
   ;Local $className = GetClassForCharacter($character)
   ;DoSelectBasicTab()
   ;SelectClass($className)
EndFunc

Func DoIgnoreChatacter($character)
   If Not IsDeclared("IgnoreVar") Then
	  Assign("IgnoreVar", ObjCreate("Scripting.Dictionary"), 2)
   EndIf
   Local $temp = Eval("IgnoreVar")
   If Not $temp.Exists($character) Then
	  $temp.Add($character, True)
	  Assign("IgnoreVar", $temp, 2)
	  FileWriteLine("ignore", $character)
   EndIf
EndFunc

Func IsIgnoredCharacter($character)
   If Not IsDeclared("IgnoreVar") Then
	  Local $temp = ObjCreate("Scripting.Dictionary")
	  If FileExists("ignore") Then
		 Local $lines = FileReadToArray("ignore")
		 For $line In $lines
			$temp.Add($line, True)
		 Next
	  EndIf
	  Assign("IgnoreVar", $temp, 2)
   EndIf
   Local $temp = Eval("IgnoreVar")
   Return $temp.Exists($character)
EndFunc

Func CloneCharacter($number)
   Local $serverName = GetServer()
   For $i = 2 To $number
	  AddNewCharacter($serverName, $i, $i, $i)
   Next
   DoSelectItem(0)
   ApplyUtilForAll()
   ApplyBasicForAll()
   _FileWriteLogEx("Cloned character")
EndFunc

Func GameWait($character)
   Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
   While True
	  Sleep(500)
	  If WinExists($hwndCharacter) Then
		 ExitLoop
	  EndIf
   WEnd
EndFunc

Func KillGame($character)
   Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
   Local $pid = WinGetProcess($hwndCharacter)
   ProcessClose($pid)
EndFunc

Func GetClassForCharacter($character)
   Switch StringRight($character, 4)
   Case "DoiA"
	  Return "Thiên Vương"
   Case "DoiB"
	  Return "Nga My"
   Case Default
	  Return "Cái Bang"
   EndSwitch
EndFunc

Func GetServer()
   Local $cbServer = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:1]"))
   Return GUICtrlRead($cbServer)
EndFunc

Func GetNumberWindow()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:2]"))
   Return GUICtrlRead($cbCtrl)
EndFunc

Func GetTime()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:3]"))
   Return GUICtrlRead($cbCtrl)
EndFunc

Func IsHideGame()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:2]"))
   Return GUICtrlRead($cbCtrl) = $GUI_CHECKED
EndFunc