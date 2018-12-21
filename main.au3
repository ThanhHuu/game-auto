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
#include "team.au3"

Local $ui = CreateUi()
GUISetState(@SW_SHOW, $ui)
Local $btSelectId = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; TEXT:Chọn]"))
Local $inAccountId = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Edit; INSTANCE:1]"))
Local $btStartId = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; TEXT:Bắt đầu]"))
Local $btNextId = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; TEXT:Tiếp theo]"))

Local $cbbWindow = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:1]"))
Local $cbbTime = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:2]"))
Local $cbbTvp = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:3]"))
Local $cbbNtd = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:4]"))
Local $cbbBc = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:5]"))
Local $cbbVt = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:6]"))
Local $cbbLoop = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:ComboBox; INSTANCE:7]"))

Local $cbHideWindow = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:2]"))
Local $cbCode = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:3]"))
Local $cbDoneTvp = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:4]"))
Local $cbDoneNtd = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:5]"))
Local $cbDoneBc = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:6]"))
Local $cbDoneVt = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:7]"))
Local $cbTeam = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:8]"))
Local $cbHideNpc = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:9]"))
Local $cbExit = _WinAPI_GetDlgCtrlID (ControlGetHandle($ui, "", "[CLASS:Button; INSTANCE:10]"))

HotKeySet("^e", "ForceExit")

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
		 For $i = 0 To UBound($characters.Keys) - 1 Step $numberWindow
			Local $remaining = UBound($characters.Keys) - $i
			Local $size = $remaining > $numberWindow ? $numberWindow : $remaining
			Local $characterInfos[$size]
			For $j = 0 To $size - 1
			   Local $character = $characters.Keys[$i + $j]
			   Local $characterInfo = $characters.Item($character)
			   $characterInfos[$j] = $characterInfo
			Next
			ExecuteSession($characterInfos)
		 Next
		 ResetLoop()
	  Next
   Case $btNextId
	  If GUICtrlRead($inAccountId) = "" Then
		 MsgBox(16, "Warning", "Chọn thư mục tài khoản trước")
		 ContinueLoop
	  EndIf
	  Local $accountFiles = ListFileOfFolder(GUICtrlRead($inAccountId))
	  Local $numberWindow = GetNumberWindow()
	  Local $characterInfos = GetListCharacters($accountFiles, $numberWindow).Items
	  If UBound($characterInfos) > 0 Then
		 CloneCharacter($numberWindow)
		 ExecuteSession($characterInfos, False)
		 ResetFeatures($characterInfos)
	  EndIf
   EndSwitch
WEnd

Func ExecuteSession($characterInfos, $execute = True)
   ; Configure account info
   ConfigureLoginInfo($characterInfos)
   If $execute Then
	  EnterGame($characterInfos)

	  WaitThirdParty($characterInfos)

	  ; Join event
	  If IsEnableCodeKimBai() Then
		 JoinEvent($characterInfos)
	  EndIf

	  Local $runAssign = IsEnableTvp() Or IsEnableNtd() Or IsEnableBc()
	  ; Cau phuc
	  LuckyRound($characterInfos, IsHideAllNpc(), $runAssign)

	  ; Dieu doi
	  If $runAssign Then
		 DoWaitGoToHome($characterInfos)
		 RunAssign($characterInfos)
	  EndIf

	  ExitGame($characterInfos)
   EndIf
   ; Mark characters is ignored
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  DoIgnoreChatacter($character)
   Next
EndFunc

Func ResetLoop()
   _FileWriteLogEx("We have done one loop")
   DoResetIgnore()
   ReduceTvp()
   Local $done = IsDoneTvp()
   If Not $done Then
	  Return
   EndIf
   $done = IsDoneNtd()
   ReduceNtd($done ? GetNtdTimes() : 1)
   If Not $done Then
	  Return
   EndIf
   $done = IsDoneBc()
   ReduceBc($done ? GetBcTimes() : 1)
EndFunc

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
	  $done = IsDoneVt()
	  If IsEnableVt() Then
		 Local $times = GetVtTimes()
		 AssignVt($characterInfo, $times, $done)
		 _FileWriteLogEx(StringFormat("%s - Ran Vt", $character))
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

Func ConfigureLoginInfo($characterInfos)
   For $i = 0 To UBound($characterInfos) - 1
	  Local $characterInfo = $characterInfos[$i]
	  Local $server = $characterInfo[0]
	  Local $usr = $characterInfo[1]
	  Local $character = $characterInfo[2]
	  ConfigureForCharacter($i, $server, $usr, $character)
   Next
   If IsOrganizeTeam() Then
	  OrganizeTeam($characterInfos)
   EndIf
EndFunc

Func EnterGame($characterInfos)
   For $i = 0 To UBound($characterInfos) - 1
	  Local $characterInfo = $characterInfos[$i]
	  Local $server = $characterInfo[0]
	  Local $usr = $characterInfo[1]
	  Local $character = $characterInfo[2]
	  ConfigureForCharacter($i, $server, $usr, $character)
	  For $j = 1 To 10
		 Local $existsWindowGame =  WinList("[REGEXPTITLE:Ngạo Kiếm Vô Song II.*]")[0][0]
		 DoSelectCharacter($character)
		 DoClickCharacter($character)
		 If GameWait($character, $existsWindowGame >= UBound($characterInfos) ? 6 : 60) Then
			ExitLoop
		 EndIf
		 DoClickCharacter($character)
	  Next
	  If GameWait($character) Then
		 _FileWriteLogEx(StringFormat("Logged in for %s", $character))
	  Else
		 _FileWriteLogEx(StringFormat("Stucked at log in for %s", $character))
		 Exit
	  EndIf
   Next
EndFunc

Func ExitGame($characterInfos)
   For $characterInfo In $characterInfos
	  Local $character = $characterInfo[2]
	  DoIgnoreChatacter($character)
	  If IsExitWhenDone() Then
		 KillGame($character)
		 _FileWriteLogEx(StringFormat("Exited game for %s", $character))
		 ContinueLoop
	  EndIf
	  If Not ReLogin($character) Then
		 KillGame($character)
		 _FileWriteLogEx(StringFormat("Killed game for %s", $character))
		 ContinueLoop
	  EndIf
	  _FileWriteLogEx(StringFormat("Re-logged in for %s", $character))
   Next
   ResetFeatures($characterInfos)
   _FileWriteLogEx("Reseted feature state")
EndFunc

Func WaitThirdParty($characterInfos)
   Local $time = GetTime()
   While($time - 5 > 0)
	  Sleep(5 * 60000)
	  For $characterInfo In $characterInfos
		 Local $character = $characterInfo[2]
		 DoClickCharacter($character)
		 Sleep(3000)
		 DoClickCharacter($character)
	  Next
	  $time = $time - 5
   WEnd
   Sleep($time > 0 ? $time * 60000 : 30000)
EndFunc

Func GetListCharacters($accountFiles, $limit = 1000)
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
			   If UBound($characters.Keys) = $limit Then
				  ; Stop when reach limit size
				  Return $characters
			   EndIf
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

Func DoResetIgnore()
   If IsDeclared("IgnoreVar") Then
	  Assign("IgnoreVar", ObjCreate("Scripting.Dictionary"), 2)
   EndIf
   FileDelete("ignore")
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
	  If IsOrganizeTeam() Then
		 PrepareTeamTemplate($number)
		 _FileWriteLogEx("Configured team template")
	  EndIf
   EndIf
EndFunc

Func GameWait($character, $times = 60)
   Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
   For $i = 1 To $times
	  If WinExists($hwndCharacter) Then
		 Return True
	  EndIf
	  Sleep(500)
   Next
   Return False
EndFunc

Func KillGame($character)
   Local $hwndCharacter = StringFormat("[REGEXPTITLE:Ngạo Kiếm Vô Song II\(%s .*]", $character)
   Local $pid = WinGetProcess($hwndCharacter)
   ProcessClose($pid)
EndFunc

Func GetNumberWindow()
   Return GUICtrlRead($cbbWindow)
EndFunc

Func GetTime()
   Return GUICtrlRead($cbbTime)
EndFunc

Func IsHideGame()
   Return GUICtrlRead($cbHideWindow) = $GUI_CHECKED
EndFunc

Func IsEnableCodeKimBai()
   Return GUICtrlRead($cbCode) = $GUI_CHECKED
EndFunc

Func IsEnableNtd()
   Return GUICtrlRead($cbbNtd) > 0
EndFunc

Func IsEnableBc()
   Return GUICtrlRead($cbbBc) > 0
EndFunc

Func IsEnableTvp()
   Return GUICtrlRead($cbbTvp) > 0
EndFunc

Func IsEnableVt()
   Return GUICtrlRead($cbbVt) > 0
EndFunc

Func IsDoneTvp()
   Return GUICtrlRead($cbDoneTvp) = $GUI_CHECKED
EndFunc

Func IsDoneNtd()
   Return GUICtrlRead($cbDoneNtd) = $GUI_CHECKED
EndFunc

Func IsDoneBc()
   Return GUICtrlRead($cbDoneBc) = $GUI_CHECKED
EndFunc

Func IsDoneVt()
   Return GUICtrlRead($cbDoneVt) = $GUI_CHECKED
EndFunc

Func GetNtdTimes()
   Return GUICtrlRead($cbbNtd)
EndFunc

Func GetBcTimes()
   Return GUICtrlRead($cbbBc)
EndFunc

Func GetVtTimes()
   Return GUICtrlRead($cbbVt)
EndFunc

Func ReduceTvp()
   GUICtrlSetData($cbbTvp, 0)
EndFunc

Func ReduceNtd($times)
   Local $newTimes = GetNtdTimes() - $times
   GUICtrlSetData($cbbNtd, $newTimes < 0 ? 0 : $newTimes)
EndFunc

Func ReduceBc($times)
   Local $newTimes = GetNtdTimes() - $times
   GUICtrlSetData($cbbBc, $newTimes < 0 ? 0 : $newTimes)
EndFunc

Func ReduceVt($times)
   Local $newTimes = GetVtTimes() - $times
   GUICtrlSetData($cbbVt, $newTimes < 0 ? 0 : $newTimes)
EndFunc

Func GetLoopTimes()
 Return GUICtrlRead($cbbLoop)
EndFunc

Func IsOrganizeTeam()
   Return GUICtrlRead($cbTeam) = $GUI_CHECKED
EndFunc

Func IsHideAllNpc()
   Return GUICtrlRead($cbHideNpc) = $GUI_CHECKED
EndFunc

Func IsExitWhenDone()
   Return GUICtrlRead($cbExit) = $GUI_CHECKED
EndFunc

Func ForceExit()
   Exit
EndFunc