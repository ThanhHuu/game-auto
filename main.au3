#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <Array.au3>

#include "ui.au3"
#include "login.au3"
#include "character.au3"
#include "basic.au3"
#include "util.au3"
#include "code.au3"

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
		 Local $remaining = UBound($characters.Keys) - $i
		 Local $size = $remaining > $numberWindow ? $numberWindow : $remaining
		 Local $characterInfos[$size]
		 For $j = 0 To $size - 1
			Local $character = $characters.Keys[$i + $j]
			Local $characterInfo = $characters.Item($character)
			$characterInfos[$j] = $characterInfo
		 Next
		 EnterGame($characterInfos)
		 WaitThirdParty()
		 If IsEnableCodeKimBai() Then
			EnterCode($characterInfos)
		 EndIf
		 ExitGame($characterInfos)
	  Next
   EndSwitch
WEnd

Func EnterGame($characterInfos)
   For $i = 0 To UBound($characterInfos) - 1
	  Local $characterInfo = $characterInfos[$i]
	  Local $server = $characterInfo[0]
	  Local $usr = $characterInfo[1]
	  Local $character = $characterInfo[2]
	  ConfigureForCharacter($i, $server, $usr, $character)
	  DoClickCharacter($character)
	  GameWait($character)
	  _FileWriteLogEx(StringFormat("Logged in for %s", $character))
   Next
EndFunc

Func ExitGame($characterInfos)
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  WinActivateEx($character)
	  If Not ReLogin($character) Then
		 KillGame($character)
		 _FileWriteLogEx(StringFormat("Killed game for %s", $character))
		 Return
	  EndIf
	  _FileWriteLogEx(StringFormat("Re-logged in for %s", $character))
   Next
EndFunc

Func WaitThirdParty()
   Local $sleepingTime = GetTime()*60*1000
   Sleep($sleepingTime)
EndFunc

Func GetListCharacters($accountFiles)
   Local $characters = ObjCreate("Scripting.Dictionary")
   For $file In $accountFiles
	  Local $lines = FileReadToArray($file)
	  For $line In $lines
		 If $line <> "" Then
			Local $infomation = StringSplit($line, "=")
			If $infomation[0] < 3 Then
			   _FileWriteLogEx(StringFormat("File %s is wrong format", $file))
			   ExitLoop
			EndIf
			If Not IsIgnoredCharacter($infomation[3]) Then
			   Local $code = $infomation[0] > 3 ? $infomation[4] : ""
			   Local $characterInfo[4] = [$infomation[1], $infomation[2], $infomation[3], $code]
			   $characters.Add($infomation[3], $characterInfo)
			EndIf
		 EndIf
	  Next
   Next
   Return $characters
EndFunc

Func ConfigureForCharacter($index, $server, $usr, $character)
   DoSelectItem($index)
   DoSelectLoginTab()
   DoChooseServer($server)
   DoEnterAccount($usr, "Ngoc@nh91", $character)
   DoEdit()
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
   For $i = 2 To $number
	  AddNewCharacter($i, $i, $i)
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

Func IsEnableCodeKimBai()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:3]"))
   Return GUICtrlRead($cbCtrl) = $GUI_CHECKED
EndFunc

Func IsEnableNtd()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:3]"))
   Return GUICtrlRead($cbCtrl) > 0
EndFunc

Func IsEnableBc()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:4]"))
   Return GUICtrlRead($cbCtrl) > 0
EndFunc

Func IsEnableTvp()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:5]"))
   Return GUICtrlRead($cbCtrl) > 0
EndFunc