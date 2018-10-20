#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#RequireAdmin
#include-once
#include "feature\features_bundle.au3"
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <GuiTab.au3>
#include <Date.au3>
#include <ColorConstants.au3>
#include <FontConstants.au3>
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

HotKeySet("^q", "Stop")

Func Stop()
   $isRunning = False
EndFunc

Local $UI, $BUTTON_RUN, $COUNT_DOWN, $CURRENT_CHARACTER, $VIRTUAL
Local $isRunning = False
Local $currentAccount
Local $accountIndex = 0
Local $LAST_RUN_DATE = @YDAY
Local $feature = "VanTieu"

Func BuidAutoUI()
   BuidUIAddAccount(1, 1)

   BuildOpenCardUI(2, 1)
   BuildOnlineExpUI(2, 2)

   BuildTurnOffGraphicUI(3, 1)
   BuildSrollCircleUI(3, 2)

   BuildBuyItemsUI(4, 1)
   BuidUITeam(4, 2)

   BuildTransportUI(5, 1)
   BuildCancelTransportUI(5, 2)

   BuildActionUI(6, 1)
EndFunc

$UI = GUICreate("Van Tieu",460, 200)
BuidAutoUI()
GUISetState(@SW_SHOW)
While True
   Start()
   $isRunning = False
   Switch GUIGetMsg()
   Case $GUI_EVENT_CLOSE
	  ExitLoop
   Case $UI_BUTTON_ADD_ACCOUNT
	  Local $dir = FileSelectFolder ("", @WindowsDir)
	  GUICtrlSetData($UI_INPUT_ACCOUNTS, $dir)
   Case $BUTTON_RUN
	  If WinList($WINDOW_NKVS)[0][0] < GUICtrlRead($UI_TEAM_MEMBER) Then
		 MsgBox(0, "Warning", StringFormat("Please open %i instance NKVS2", GUICtrlRead($UI_TEAM_MEMBER)))
		 ContinueLoop
	  EndIf
	  CoundDown(3)
	  WriteLog("main", "START at date " & $LAST_RUN_DATE)
	  BuildRuntimeAccounts()
	  BuildRuntimeIgnore()
	  LoadMapCharacter()
	  BuildHwndRuntime()
	  BuildRuntimeTransportColor()
	  $isRunning = True
	  $accountIndex = 0
   EndSwitch
WEnd

Func Start()
   While $isRunning And UBound($RUNTIME_ACCOUNTS) > 0
	  ; Reset for new day
	  If $LAST_RUN_DATE <> @YDAY Then
		 $LAST_RUN_DATE = @YDAY
		 $accountIndex = 0
		 BuildRuntimeIgnore()
		 WriteLog("main", "Reset for new date")
		 ContinueLoop
	  EndIf
	  If FileExists(GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & '.done') Then
		 ExitLoop
	  EndIf
	  Local $accountDics = ObjCreate("Scripting.Dictionary")
	  While True
		 Local $accountDic = $RUNTIME_ACCOUNTS[$accountIndex]
		 $accountIndex += 1
		 Local $character = $accountDic.Item($PARAM_CHAR)
		 If $RUNTIME_IGNORE_DIC.Exists($feature) And $RUNTIME_IGNORE_DIC.Item($feature).Exists($character) Then
			ContinueLoop
		 EndIf
		 $accountDics.Add($character, $accountDic)
		 If UBound($accountDics.Keys) = GUICtrlRead($UI_TEAM_MEMBER) Then
			ExitLoop
		 EndIf
	  WEnd
	  RunForTeam($accountDics)
	  If $accountIndex = UBound($RUNTIME_ACCOUNTS) Then
		 Local $ignoreFile = GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & '.ignore'
		 Local $doneFile = GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & '.done'
		 FileMove($ignoreFile, $doneFile)
	  EndIf
   WEnd
EndFunc

Func RunForOne($accountDic)
   Local $paramDic = ObjCreate("Scripting.Dictionary")
   For $key In $accountDic.Keys
	  $paramDic.Add($key, $accountDic.Item($key))
   Next
   Local $chainDic = ObjCreate("Scripting.Dictionary")
   $chainDic.Add("OnlineExp", $paramDic)
   $chainDic.Add("OfflineExp", $paramDic)
   $chainDic.Add("UseItems", $paramDic)
   $chainDic.Add("OpenCard", $paramDic)
   $chainDic.Add("TurnOffGraphic", $paramDic)
   $chainDic.Add("BuyItemGoHome", $paramDic)
   WriteLog("main", StringFormat("Run for %s - %s - %s", $paramDic.Item($PARAM_USR), $paramDic.Item($PARAM_CHAR), $feature))
   If ExecuteChain($chainDic) Then
	  Local $ignoreFile = GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & '.ignore'
	  FileWriteLine($ignoreFile, $paramDic.Item($PARAM_CHAR))
   EndIf
EndFunc

Func RunForTeam($accountDics)
   Local $order = 0
   For $accountDic In $accountDics.Items
	  $accountDic.Add($PARAM_ORDER, $order)
	  Login($accountDic)
	  $order += 1
   Next
   WriteLog("main", "Logged in for alls")
   For $accountDic In $accountDics.Items
	  RunForOne($accountDic)
   Next
   GUICtrlSetState($UI_FEATURE_HIDE_GRAPHIC, $GUI_UNCHECKED)
   WriteLog("main", "Ran single for alls")
   Local $paramDic = ObjCreate("Scripting.Dictionary")
   $paramDic.Add($PARAM_TEAM_MEMBER, $accountDics.Keys)
   TransportTeam($paramDic)
   WriteLog("main", "Done for team")
   For $accountDic In $accountDics.Items
	  Logout($accountDic)
   Next
EndFunc

Func BuildActionUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP * 2
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = 50
   $BUTTON_RUN = GUICtrlCreateButton("Bat Dau", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 70
   $UI_DEBUG_MODE = GUICtrlCreateCheckbox("Debug", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 70
   $VIRTUAL = GUICtrlCreateCheckbox("Virtual", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetState($VIRTUAL, $GUI_UNCHECKED)

   Local $uiSize = WinGetClientSize($UI)
   $marginLeft = $uiSize[0]/2 - $width/2
   $marginTop = $uiSize[1]/2 - ($width + 10)/2
   $COUNT_DOWN = GUICtrlCreateLabel("", $marginLeft , $marginTop, $width, $width + 10)
   GUICtrlSetColor($COUNT_DOWN, $COLOR_RED)
   GUICtrlSetFont($COUNT_DOWN, 50, $FW_MEDIUM)
   GUICtrlSetState($COUNT_DOWN, $GUI_ONTOP )
   GUICtrlSetBkColor($COUNT_DOWN, $GUI_BKCOLOR_TRANSPARENT)
EndFunc

Func CoundDown($seconds)
   While $seconds > 1
	  $seconds -= 1
	  GUICtrlSetData($COUNT_DOWN, "" & $seconds)
	  GUICtrlSetState($COUNT_DOWN, $GUI_SHOW)
	  Sleep(500)
	  GUICtrlSetState($COUNT_DOWN, $GUI_HIDE)
	  Sleep(500)
   WEnd
   GUICtrlSetState($COUNT_DOWN, $GUI_HIDE)
EndFunc

Func BuildRuntimeAccounts()
   Local $result = ObjCreate("Scripting.Dictionary")
   Local $directoryPath = GUICtrlRead($UI_INPUT_ACCOUNTS)
   Local $files = _FileListToArrayRec($directoryPath, "*.acc", 1 + 4, 1, 1, 2);
   If $files <> "" And $files[0] > 0 Then
	  Local $count = 0;
	  For $i = 1 To $files[0]
		 Local $file = $files[$i]
		 Local $lines = FileReadToArray($file)
		 For $line In $lines
			$count += 1
			Local $accountObj = ObjCreate("Scripting.Dictionary")
			Local $infomation = StringSplit($line, "=")
			$accountObj.Add($PARAM_USR, $infomation[1])
			$accountObj.Add($PARAM_CHAR, $infomation[2])
			$accountObj.Add($PARAM_PWD, 'Ngoc@nh91')
			$result.Add($count, $accountObj)
		 Next
	  Next
   EndIf
   $RUNTIME_ACCOUNTS = $result.Items
EndFunc

Func BuildRuntimeIgnore()
   $RUNTIME_IGNORE_DIC = ObjCreate("Scripting.Dictionary")
   Local $directoryPath = GUICtrlRead($UI_INPUT_ACCOUNTS)
   Local $files = _FileListToArrayRec($directoryPath, "*.ignore", 1 + 4, 0, 1, 2);
   If $files <> "" And $files[0] > 0 Then
	  For $i = 1 To $files[0]
		 Local $file = $files[$i]
		 Local $featureDic = ObjCreate("Scripting.Dictionary")
		 Local $lines = FileReadToArray($file)
		 For $line In $lines
			$featureDic.Add($line, True)
		 Next
		 Local $featureName = StringReplace(StringReplace($file, $directoryPath & '\', ''), '.ignore', '')
		 $RUNTIME_IGNORE_DIC.Add($featureName, $featureDic)
	  Next
   EndIf
EndFunc

Func LoadMapCharacter()
   $RUNTIME_MAP_CHARACTER = ObjCreate("Scripting.Dictionary")
   If FileExists($CHARACTER_INDEX_FILE) Then
	  Local $lines = FileReadToArray($CHARACTER_INDEX_FILE)
	  For $line In $lines
		 Local $infomation = StringSplit($line, "=")
		 $RUNTIME_MAP_CHARACTER.Add($infomation[1], $infomation[2])
	  Next
   EndIf
EndFunc

Func BuildHwndRuntime()
   Local $obj = ObjCreate("Scripting.Dictionary")
   Local $listHwnd = WinList($WINDOW_NKVS)
   For $i = 1 To $listHwnd[0][0]
	  Local $title = $listHwnd[$i][0]
	  Local $hwnd = $listHwnd[$i][1]
	  $obj.Add($title, $hwnd)
   Next
   $RUNTIME_NKVS_HWND = $obj.Items
   $RUNTIME_NKVS_TITLE = $obj.Keys
EndFunc

Func BuildRuntimeTransportColor()
   If GUICtrlRead($VIRTUAL) = $GUI_CHECKED Then
	  $TRANSPORT_DONE_COLOR = $TRANSPORT_DONE_COLOR_VIRTUAL
	  $TRANSPORT_OPTION = $TRANSPORT_OPTION_VIRTUAL
	  $TRANSPORT_TEXT_COLOR = $TRANSPORT_TEXT_COLOR_VIRTUAL
	  $TRANSPORT_COORD_COLOR = $TRANSPORT_COORD_COLOR_VIRTUAL
	  $TRANSPORT_START_COLOR = $TRANSPORT_START_COLOR_VIRTUAL
   Else
	  $TRANSPORT_DONE_COLOR = $TRANSPORT_DONE_COLOR_REAL
	  $TRANSPORT_OPTION = $TRANSPORT_OPTION_REAL
	  $TRANSPORT_TEXT_COLOR = $TRANSPORT_TEXT_COLOR_REAL
	  $TRANSPORT_COORD_COLOR = $TRANSPORT_COORD_COLOR_REAL
	  $TRANSPORT_START_COLOR = $TRANSPORT_START_COLOR_REAL
   EndIf
EndFunc