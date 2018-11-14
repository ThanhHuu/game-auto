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
#include "assistant.au3"
#include "lucky.au3"

Local $ui = CreateUi()
GUISetState(@SW_SHOW, $ui)
Local $btSelectId = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; TEXT:Chọn]"))
Local $inAccountId = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Edit; INSTANCE:1]"))
Local $btStartId = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; TEXT:Bắt đầu]"))

HotKeySet("^q", "ForceExit")

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
	  Local $loopTimes = GetLoopTimes()
	  For $loop = 1 To $loopTimes
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
			WaitThirdParty($characterInfos)

			; Cau phuc
			LuckyRound($characterInfos)
			; Nhap code KimBai
			If IsEnableCodeKimBai() Then
			   EnterCode($characterInfos)
			EndIf
			; Dieu doi
			If IsEnableTvp() Or IsEnableNtd() Or IsEnableBc() Then
			   GoToHome($characterInfos)
			   RunAssign($characterInfos)
			EndIf

			ExitGame($characterInfos)
		 Next
	  Next
   EndSwitch
WEnd

Func RunAssign($characterInfos)
   For $i = 0 To UBound($characterInfos) - 1
	  If $i > 0 Then
		 DoClickItem($i - 1)
	  EndIf
	  Local $characterInfo = $characterInfos[$i]
	  Local $done = IsDoneTvp()
	  Local $character = $characterInfo[2]
	  If IsEnableTvp() Then
		 AssignTvp($characterInfo, 1, $done)
		 _FileWriteLogEx(StringFormat("%s - Ran Tvp", $character))
		 If Not $done Then
			ContinueLoop
		 EndIf
	  EndIf
	  $done = IsDoneNtd()
	  If IsEnableNtd() Then
		 Local $times = GetNtdTimes()
		 AssignNtd($characterInfo, $times, $done)
		 _FileWriteLogEx(StringFormat("%s - Ran Ntd", $character))
		 If Not $done Then
			ContinueLoop
		 EndIf
	  EndIf
	  $done = IsDoneBc()
	  If IsEnableBc() Then
		 Local $times = GetBcTimes()
		 AssignBc($characterInfo, $times, $done)
		 _FileWriteLogEx(StringFormat("%s - Ran Bc", $character))
		 If Not $done Then
			ContinueLoop
		 EndIf
	  EndIf
   Next
   DoClickItem($i - 1)
   For $i = 0 To UBound($characterInfos) - 1
	  DoClickItem($i)
   Next
EndFunc

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
	  DoIgnoreChatacter($character)
	  If Not ReLogin($character) Then
		 KillGame($character)
		 _FileWriteLogEx(StringFormat("Killed game for %s", $character))
		 ContinueLoop
	  EndIf
	  _FileWriteLogEx(StringFormat("Re-logged in for %s", $character))
   Next
EndFunc

Func WaitThirdParty($characterInfos)
   Local $time = GetTime()
   Sleep($time * 60000)
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
   Local $count = DoCountCharacter()
   If $count < $number Then
	  For $i = $count + 1 To $number
		 AddNewCharacter($i, $i, $i)
	  Next
	  DoSelectItem(0)
	  ApplyUtilForAll()
	  ApplyBasicForAll()
	  _FileWriteLogEx("Cloned character")
   EndIf
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
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:1]"))
   Return GUICtrlRead($cbCtrl)
EndFunc

Func GetTime()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:2]"))
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
   Return GetNtdTimes() > 0
EndFunc

Func IsEnableBc()
   Return GetBcTimes() > 0
EndFunc

Func IsEnableTvp()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:3]"))
   Return GUICtrlRead($cbCtrl) > 0
EndFunc

Func IsDoneTvp()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:4]"))
   Return GUICtrlRead($cbCtrl) = $GUI_CHECKED
EndFunc

Func IsDoneNtd()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:5]"))
   Return GUICtrlRead($cbCtrl) = $GUI_CHECKED
EndFunc

Func IsDoneBc()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:6]"))
   Return GUICtrlRead($cbCtrl) = $GUI_CHECKED
EndFunc

Func GetNtdTimes()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:4]"))
   Return GUICtrlRead($cbCtrl)
EndFunc

Func GetBcTimes()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:5]"))
   Return GUICtrlRead($cbCtrl)
EndFunc

Func ReduceTvp()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:3]"))
   GUICtrlSetData($cbCtrl, 0)
EndFunc

Func ReduceNtd($times)
   Local $newTimes = GetNtdTimes() - $times
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:4]"))
   GUICtrlSetData($cbCtrl, $newTimes < 0 ? 0 : $newTimes)
EndFunc

Func ReduceBc($times)
   Local $newTimes = GetNtdTimes() - $times
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:5]"))
   GUICtrlSetData($cbCtrl, $newTimes < 0 ? 0 : $newTimes)
EndFunc

Func GetLoopTimes()
   Local $cbCtrl = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:6]"))
   Return GUICtrlRead($cbCtrl)
EndFunc

Func ForceExit()
   Exit
EndFunc