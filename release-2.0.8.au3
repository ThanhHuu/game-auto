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

Local $UI, $BUTTON_RUN, $COUNT_DOWN
Local $isRunning = False
Local $currentAccount, $currentFeature
Local $accountIndex = 0
Local $featureIndex = 0
Local $LAST_RUN_DATE = @YDAY

Func BuidAutoUI()
   BuidUIAddAccount(1, 1)

   BuildOpenCardUI(2, 1)
   BuildOnlineExpUI(2, 2)

   BuildTurnOffGraphicUI(3, 1)
   BuildSrollCircleUI(3, 2)

   BuildBuyItemsUI(4, 1)
   BuildUseItemsUI(4, 2)

   BuildTvpUI(5, 1)
   BuildNtdUI(5, 2)
   BuildBcUI(6, 1)

   BuildActionUI(7, 1)
EndFunc

$UI = GUICreate("Auto Configuration",460, 240)
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
	  If Not WinExists($WINDOW_LOGIN) Then
		 MsgBox(0, "Warning", "Please start nkvs auto")
		 ContinueLoop
	  EndIf
	  CoundDown(3)
	  BuildRuntimeAccounts()
	  BuildRuntimeIgnore()
	  $isRunning = True
   EndSwitch
WEnd

Func Start()
   While $isRunning And $featureIndex < UBound($RUNTIME_FEATURES) And UBound($RUNTIME_ACCOUNTS) > 0
	  ; Reset for new day
	  If $LAST_RUN_DATE <> @YDAY Then
		 $LAST_RUN_DATE = @YDAY
		 $featureIndex = 0
		 $accountIndex = 0
		 Local $directoryPath = GUICtrlRead($UI_INPUT_ACCOUNTS)
		 Local $files = _FileListToArrayRec($directoryPath, "*.ignore", 1 + 4, 0, 1, 2);
		 If $files <> "" And $files[0] > 0 Then
			For $i = 1 To $files[0]
			   FileDelete($files[$i])
			Next
		 EndIf
		 ContinueLoop
	  EndIf
	  Local $feature = $RUNTIME_FEATURES[$featureIndex]
	  If Not IsCheckFeature($feature) Then
		 $featureIndex += 1
		 $accountIndex = 0
		 ContinueLoop
	  EndIf
	  If FileExists(GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & '.done') Then
		 $featureIndex += 1
		 $accountIndex = 0
		 ContinueLoop
	  EndIf
	  Local $accountDic = $RUNTIME_ACCOUNTS[$accountIndex]
	  RunForOne($feature, $accountDic)
	  $accountIndex += 1
	  If $accountIndex = UBound($RUNTIME_ACCOUNTS) Then
		 Local $ignoreFile = GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & '.ignore'
		 Local $doneFile = GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & '.done'
		 FileMove($ignoreFile, $doneFile)
		 GUICtrlSetState($UI_FEATURE_USE_ITEM, $GUI_CHECKED)
		 ReduceNoFeature($feature)
		 $accountIndex = 0
	  EndIf
   WEnd
EndFunc

Func ReduceNoFeature($feature)
   If $feature = $RUNTIME_FEATURE_BC Then
	  Local $value = GUICtrlRead($UI_FEATURE_BC_NO)
	  Local $newValue = $value - 1
	  If $newValue > 0 Then
		 GUICtrlSetData($UI_FEATURE_BC_NO, $newValue)
		 Local $doneFile = GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & '.done'
		 Local $backupFile = GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & $value
		 FileMove($doneFile, $backupFile)
		 WriteLog("main", StringFormat("Backup for %s", $feature))
	  Else
		 GUICtrlSetState($UI_FEATURE_BC, $GUI_UNCHECKED + $GUI_DISABLE)
	  EndIf
   ElseIf $feature = $RUNTIME_FEATURE_NTD Then
	  Local $value = GUICtrlRead($UI_FEATURE_NTD_NO)
	  Local $newValue = $value - 1
	  If $newValue > 0 Then
		 GUICtrlSetData($UI_FEATURE_NTD_NO, $newValue)
		 Local $doneFile = GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & '.done'
		 Local $backupFile = GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & $value
		 FileMove($doneFile, $backupFile)
		 WriteLog("main", StringFormat("Backup for %s", $feature))
	  Else
		 GUICtrlSetState($UI_FEATURE_NTD, $GUI_UNCHECKED + $GUI_DISABLE)
	  EndIf
   EndIf
EndFunc

Func IsCheckFeature($feature)
   If $feature = $RUNTIME_FEATURE_TVP Then
	  Return GUICtrlRead($UI_FEATURE_TVP) = $GUI_CHECKED ? True : False
   EndIf
   If $feature = $RUNTIME_FEATURE_NTD Then
	  Return GUICtrlRead($UI_FEATURE_NTD) = $GUI_CHECKED ? True : False
   EndIf
   If $feature = $RUNTIME_FEATURE_BC Then
	  Return GUICtrlRead($UI_FEATURE_BC) = $GUI_CHECKED ? True : False
   EndIf
   Return False
EndFunc

Func RunForOne($feature, $accountDic)
   If $RUNTIME_IGNORE_DIC.Exists($feature) And $RUNTIME_IGNORE_DIC.Item($feature).Exists($accountDic.Item($PARAM_CHAR)) Then
	  Return
   EndIf
   $accountDic.Add($PARAM_LEVEL, GUICtrlRead($UI_FEATURE_BC_LEVEL))
   $accountDic.Add($PARAM_FEATURE_NAME, $feature)
   Local $chainDic = ObjCreate("Scripting.Dictionary")
   $chainDic.Add("AddAccount", $accountDic)
   $chainDic.Add("Login", $accountDic)
   $chainDic.Add("OnlineExp", $accountDic)
   $chainDic.Add("UseItems", $accountDic)
   $chainDic.Add("OpenCard", $accountDic)
   $chainDic.Add("TurnOffGraphic", $accountDic)
   $chainDic.Add("SrollCircle", $accountDic)
   $chainDic.Add("BuyItemGoHome", $accountDic)
   $chainDic.Add("RunTvp", $accountDic)
   $chainDic.Add("RunNtd", $accountDic)
   $chainDic.Add("RunBc", $accountDic)
   $chainDic.Add("GetActiveAward", $accountDic)
   $chainDic.Add("Logout", $accountDic)
   WriteLog("main", StringFormat("Run for %s - %s - %s", $accountDic.Item($PARAM_USR), $accountDic.Item($PARAM_CHAR), $feature))
   If ExecuteChain($chainDic) Then
	  Local $ignoreFile = GUICtrlRead($UI_INPUT_ACCOUNTS) & '\' & $feature & '.ignore'
	  FileWriteLine($ignoreFile, $accountDic.Item($PARAM_CHAR))
   EndIf
   Sleep(1000)
EndFunc

Func Stop()
   $isRunning = False
EndFunc

Func BuildActionUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP * 2
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = 50
   $BUTTON_RUN = GUICtrlCreateButton("Bat Dau", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   $UI_DEBUG_MODE = GUICtrlCreateCheckbox("Debug", $marginLeft + $width + 20, $marginTop, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 60
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