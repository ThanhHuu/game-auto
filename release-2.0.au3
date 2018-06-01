#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#RequireAdmin
#include-once
#include "feature\features_bundle.au3"
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <GuiTab.au3>
#include <Date.au3>
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")


DIM $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
DIM $DEFAULT_PWD = "Ngoc@nh91"
Global $WAIT_LOAD = 15000

Local $accountFiles
Local $level = 70
Local $ckGoHome
Local $ckBuyItems
Local $ckSellItems
Local $ckUseItems
Local $stop = False
Local $WINDOW_AUTO = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"

Func ParseAccounts($accountFile)
   Local $lines = FileReadToArray($accountFile)
   Local $result = ObjCreate("Scripting.Dictionary")
   Local $count = 0;
   For $line In $lines
	  $count += 1
	  Local $accountObj = ObjCreate("Scripting.Dictionary")
	  Local $infomation = StringSplit($line, "=")
	  $accountObj.Add("account", $infomation[1])
	  $accountObj.Add("character", $infomation[2])
	  $result.Add($count, $accountObj)
   Next
   Return $result.Items
EndFunc

Func RunFeature($featuresObj)
   For $featureName In $featuresObj.Keys
	  Local $featureObj = $featuresObj.Item($featureName)
	  Local $todate = _DateDayOfWeek(@WDAY)
	  If Not $featureObj.Item("Scheduler").Item($todate) Then
		 Local $msg = StringFormat("Feature %s is disable on %s", $featureName, $todate)
		 _FileWriteLog($LOG_FILE, StringFormat("%s - %s", "release-2.0", $msg))
		 ContinueLoop
	  EndIf
	  If FileExists($featureName & ".done") Then
		 Local $msg = StringFormat("Feature %s is done", $featureName)
		 _FileWriteLog($LOG_FILE, StringFormat("%s - %s", "release-2.0", $msg))
		 ContinueLoop
	  EndIf
	  Local $ignoreAccountObj = GetIgnoreAccountFile($featureName)
	  For $i = 1 To $accountFiles[0]
		 Local $accountFile = $accountFiles[$i]
		 If $ignoreAccountObj.Item($accountFile) Then
			Local $msg = StringFormat("Feature %s is done for account %s", $featureName, $accountFile)
			_FileWriteLog($LOG_FILE, StringFormat("%s - %s", "release-2.0", $msg))
			ContinueLoop
		 EndIf
		 Local $accounts = ParseAccounts($accountFile)
		 For $account In $accounts
			Local $usr = $account.Item("account")
			Local $character = $account.Item("character")
			Local $currentY = $FIRST_Y
			AddAccount($usr, $DEFAULT_PWD, $character)
			Login($currentY)
			TryLuckyCard()
			TryLuckyRound()
			If GUICtrlRead($ckGoHome) = $GUI_CHECKED Then
			   GoHome()
			EndIf
			If GUICtrlRead($ckBuyItems) = $GUI_CHECKED Then
			   BuyItems($level)
			EndIf

			Local $functions = $featureObj.Item("Functions")
			For $function In $functions
			   Call($function, $level)
			Next
			If $featureObj.Item("Logout") Then
			   Logout($currentY)
			EndIf
		 Next
		 FileWriteLine($featureName & ".ig", $accountFile)
		 If $stop Then
			ExitLoop
		 EndIf
	  Next
	  If $stop Then
		 ExitLoop
	  EndIf
	  FileMove($featureName & ".ig", $featureName & ".done")
   Next
EndFunc

BuildUI()

Func BuildUI()
   Local $hGUI = GUICreate("Auto Configuration",440, 370)
   Local $rowHeight = 20;
   ; View for row 1
   Local $lable1 = GUICtrlCreateLabel("Accounts", 20, 28, 70, $rowHeight)
   Local $input1 = GUICtrlCreateInput("", 110, 25, 200, $rowHeight, $ES_READONLY)
   Local $buton1 = GUICtrlCreateButton("Browse", 320, 25, 80, $rowHeight)

   ; View for row 2
   GUICtrlCreateLabel("Level", 20, 69, 70, $rowHeight)
   Local $combo2 = GUICtrlCreateCombo ("", 110, 65, 100, $rowHeight)
   GUICtrlSetData($combo2, "70|80|100", "70")
   GUICtrlCreateLabel("Loading Time", 220, 69, 70, $rowHeight)
   Local $cbLoadingTime = GUICtrlCreateCombo ("", 300, 65, 40, $rowHeight)
   GUICtrlSetData($cbLoadingTime, "10|15|20|25|30", "15")
   GUICtrlCreateLabel("seconds", 350, 69, 70, $rowHeight)

   ; View for row 3
   $ckGoHome = GUICtrlCreateCheckbox ("Go Home", 20, 105, 60, $rowHeight)
   $ckBuyItems = GUICtrlCreateCheckbox ("BuyItems", 100, 105, 60, $rowHeight)
   $ckSellItems = GUICtrlCreateCheckbox ("SellItems", 180, 105, 60, $rowHeight)
   $ckUseItems = GUICtrlCreateCheckbox ("UseItems", 260, 105, 60, $rowHeight)

   ; View for row 4
   Local $featureTab = GUICtrlCreateTab(20, 145, 400, 180)
   Local $buttonRun = GUICtrlCreateButton("Run", 340, 340, 80, $rowHeight)
   Local $buttonStop = GUICtrlCreateButton("Stop", 250, 340, 80, $rowHeight)
   GUICtrlSetState($buttonRun, $GUI_DISABLE)
   GUICtrlSetState($buttonStop, $GUI_DISABLE)

   ; Tab TVP
   Local $tvpTab = GUICtrlCreateTabItem("ThuVePhai")
   Local $tvp1 = GUICtrlCreateCheckbox (_DateDayOfWeek (1), 30, 175, 90, $rowHeight)
   Local $tvp2 = GUICtrlCreateCheckbox (_DateDayOfWeek (2), 30, 195, 90, $rowHeight)
   Local $tvp3 = GUICtrlCreateCheckbox (_DateDayOfWeek (3), 30, 215, 90, $rowHeight)
   Local $tvp4 = GUICtrlCreateCheckbox (_DateDayOfWeek (4), 30, 235, 90, $rowHeight)
   Local $tvp5 = GUICtrlCreateCheckbox (_DateDayOfWeek (5), 30, 255, 90, $rowHeight)
   Local $tvp6 = GUICtrlCreateCheckbox (_DateDayOfWeek (6), 30, 275, 90, $rowHeight)
   Local $tvp7 = GUICtrlCreateCheckbox (_DateDayOfWeek (7), 30, 295, 90, $rowHeight)
   GUICtrlSetState($tvp1, $GUI_DISABLE + $GUI_CHECKED)
   GUICtrlSetState($tvp2, $GUI_DISABLE + $GUI_CHECKED)
   GUICtrlSetState($tvp3, $GUI_DISABLE + $GUI_CHECKED)
   GUICtrlSetState($tvp4, $GUI_DISABLE + $GUI_CHECKED)
   GUICtrlSetState($tvp5, $GUI_DISABLE + $GUI_CHECKED)
   GUICtrlSetState($tvp6, $GUI_DISABLE + $GUI_CHECKED)
   GUICtrlSetState($tvp7, $GUI_DISABLE + $GUI_CHECKED)
   Local $tvpLogoutWhenDone = GUICtrlCreateCheckbox ("Logout When Done", 150, 175, 120, $rowHeight)
   GUICtrlSetState($tvpLogoutWhenDone, $GUI_DISABLE + $GUI_CHECKED)

   GUICtrlCreateTabItem("BiCanh")
   Local $bc1 = GUICtrlCreateCheckbox (_DateDayOfWeek (1), 30, 175, 90, $rowHeight)
   Local $bc2 = GUICtrlCreateCheckbox (_DateDayOfWeek (2), 30, 195, 90, $rowHeight)
   Local $bc3 = GUICtrlCreateCheckbox (_DateDayOfWeek (3), 30, 215, 90, $rowHeight)
   Local $bc4 = GUICtrlCreateCheckbox (_DateDayOfWeek (4), 30, 235, 90, $rowHeight)
   Local $bc5 = GUICtrlCreateCheckbox (_DateDayOfWeek (5), 30, 255, 90, $rowHeight)
   Local $bc6 = GUICtrlCreateCheckbox (_DateDayOfWeek (6), 30, 275, 90, $rowHeight)
   Local $bc7 = GUICtrlCreateCheckbox (_DateDayOfWeek (7), 30, 295, 90, $rowHeight)
   GUICtrlSetState($bc1, $GUI_CHECKED)
   GUICtrlSetState($bc2, $GUI_CHECKED)
   GUICtrlSetState($bc3, $GUI_CHECKED)
   GUICtrlSetState($bc4, $GUI_CHECKED)
   GUICtrlSetState($bc5, $GUI_CHECKED)
   GUICtrlSetState($bc6, $GUI_CHECKED)
   GUICtrlSetState($bc7, $GUI_CHECKED)
   GUICtrlCreateLabel("No", 150, 178, 30, $rowHeight)
   Local $bcNo = GUICtrlCreateCombo("", 180, 175, 40, $rowHeight)
   GUICtrlSetData($bcNo, "1|2", "2")
   Local $receiveAward1 = GUICtrlCreateCheckbox("Receive Actitive Award", 240, 175, 150, $rowHeight)
   Local $bcLogoutWhenDone = GUICtrlCreateCheckbox ("Logout When Done", 240, 195, 120, $rowHeight)
   GUICtrlSetState($bcLogoutWhenDone, $GUI_DISABLE + $GUI_CHECKED)

   GUICtrlCreateTabItem("NguTrucDam")
   Local $ntd1 = GUICtrlCreateCheckbox (_DateDayOfWeek (1), 30, 175, 90, $rowHeight)
   Local $ntd2 = GUICtrlCreateCheckbox (_DateDayOfWeek (2), 30, 195, 90, $rowHeight)
   Local $ntd3 = GUICtrlCreateCheckbox (_DateDayOfWeek (3), 30, 215, 90, $rowHeight)
   Local $ntd4 = GUICtrlCreateCheckbox (_DateDayOfWeek (4), 30, 235, 90, $rowHeight)
   Local $ntd5 = GUICtrlCreateCheckbox (_DateDayOfWeek (5), 30, 255, 90, $rowHeight)
   Local $ntd6 = GUICtrlCreateCheckbox (_DateDayOfWeek (6), 30, 275, 90, $rowHeight)
   Local $ntd7 = GUICtrlCreateCheckbox (_DateDayOfWeek (7), 30, 295, 90, $rowHeight)
   GUICtrlSetState($ntd1, $GUI_CHECKED)
   GUICtrlSetState($ntd2, $GUI_CHECKED)
   GUICtrlSetState($ntd3, $GUI_CHECKED)
   GUICtrlSetState($ntd4, $GUI_CHECKED)
   GUICtrlSetState($ntd5, $GUI_CHECKED)
   GUICtrlSetState($ntd6, $GUI_CHECKED)
   GUICtrlSetState($ntd7, $GUI_CHECKED)

   GUICtrlCreateLabel("No", 150, 178, 30, $rowHeight)
   Local $ntdNo = GUICtrlCreateCombo("", 180, 175, 40, $rowHeight)
   GUICtrlSetData($ntdNo, "1|2|3|4|5|6|7|8|9", "2")
   Local $receiveAward2 = GUICtrlCreateCheckbox("Receive Actitive Award", 240, 175, 150, $rowHeight)
   GUICtrlSetState($receiveAward2,$GUI_CHECKED)
   Local $ntdLogoutWhenDone = GUICtrlCreateCheckbox ("Logout When Done", 240, 195, 120, $rowHeight)
   GUICtrlSetState($ntdLogoutWhenDone, $GUI_DISABLE + $GUI_CHECKED)

   GUISetState(@SW_SHOW)
   While True
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE
			ExitLoop
		 Case $buton1
			Local $accountDirectory = FileSelectFolder ("Choose file", @WindowsDir)
			GUICtrlSetData($input1, $accountDirectory)
			$accountFiles = _FileListToArrayRec($accountDirectory, "*.acc", 1 + 4, 1, 1, 2);
			If $accountFiles <> "" And $accountFiles[0] > 0 Then
			   GUICtrlSetState($buttonRun, $GUI_ENABLE)
			Else
			   MsgBox(0, "Warning", "Please choose dir contain file *.acc")
			   ContinueLoop
			EndIf
		 Case $combo2
			$level = GUICtrlRead($combo2)
			If $level = 70 Then
			   GUICtrlSetState ($tvp1, $GUI_CHECKED )
			   GUICtrlSetState ($tvp2, $GUI_CHECKED )
			   GUICtrlSetState ($tvp3, $GUI_CHECKED )
			   GUICtrlSetState ($tvp4, $GUI_CHECKED )
			   GUICtrlSetState ($tvp5, $GUI_CHECKED )
			   GUICtrlSetState ($tvp6, $GUI_CHECKED )
			   GUICtrlSetState ($tvp7, $GUI_CHECKED )
			Else
			   GUICtrlSetState ($tvp1, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp2, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp3, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp4, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp5, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp6, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp7, $GUI_UNCHECKED)
			EndIf
		 Case $buttonRun
			If Not WinExists($WINDOW_AUTO) Then
			   MsgBox(0, "Warning", "Please start auto before")
			   ContinueLoop
			EndIf
			$stop = False
			GUICtrlSetState($buttonRun, $GUI_DISABLE)
			GUICtrlSetState($buton1, $GUI_DISABLE)
			GUICtrlSetState($buttonStop, $GUI_ENABLE)

			$WAIT_LOAD = GUICtrlRead($cbLoadingTime) * 1000

			Local $featuresObj = ObjCreate("Scripting.Dictionary")

			; Feature thu ve phai
			Local $tvpInWeek = [$tvp1, $tvp2, $tvp3, $tvp4, $tvp5, $tvp6, $tvp7]
			Local $tvpSchedule = GetFeatureScheduler($tvpInWeek)
			Local $tvpFuncs = ['AssignPrevention']
			Local $tvpFeature = ObjCreate("Scripting.Dictionary")
			$tvpFeature.Add("Functions", $tvpFuncs)
			$tvpFeature.Add("Scheduler", $tvpSchedule)
			If GUICtrlRead($tvpLogoutWhenDone) = $GUI_CHECKED Then
			   $tvpFeature.Add("Logout", True)
			EndIf
			$featuresObj.Add("ThuVePhai", $tvpFeature)

			; Feature BC
			Local $bcFeature = ObjCreate("Scripting.Dictionary")
			Local $bcInWeek = [$bc1, $bc2, $bc3, $bc4, $bc5, $bc6, $bc7]
			Local $bcSchedule = GetFeatureScheduler($bcInWeek)
			$bcFeature.Add("Scheduler", $bcSchedule)
			If GUICtrlRead($receiveAward1) = $GUI_CHECKED Then
			   Local $bcFuncs = ['AssignStory', 'GetActiveAeard']
			   $bcFeature.Add("Functions", $bcFuncs)
			Else
			   Local $bcFuncs = ['AssignStory']
			   $bcFeature.Add("Functions", $bcFuncs)
			EndIf
			If GUICtrlRead($bcLogoutWhenDone) = $GUI_CHECKED Then
			   $bcFeature.Add("Logout", True)
			EndIf
			For $i = 1 To GUICtrlRead($bcNo)
			   $featuresObj.Add("BiCanh" & $i, $bcFeature)
			Next

			; Feature Ngu truc dam
			Local $ntdFeature = ObjCreate("Scripting.Dictionary")
			Local $ntdInWeek = [$ntd1, $ntd2, $ntd3, $ntd4, $ntd5, $ntd6, $ntd7]
			Local $ntdSchedule = GetFeatureScheduler($ntdInWeek)
			$ntdFeature.Add("Scheduler", $ntdSchedule)
			If GUICtrlRead($receiveAward1) = $GUI_CHECKED Then
			   Local $ntdFuncs = ['AssignChallenge', 'GetActiveAeard']
			   $ntdFeature.Add("Functions", $ntdFuncs)
			Else
			   Local $ntdFuncs = ['AssignChallenge']
			   $ntdFeature.Add("Functions", $ntdFuncs)
			EndIf
			If GUICtrlRead($ntdLogoutWhenDone) = $GUI_CHECKED Then
			   $ntdFeature.Add("Logout", True)
			EndIf
			For $j = 1 To GUICtrlRead($ntdNo)
			   $featuresObj.Add("NguTrucDam" & $j, $ntdFeature)
			Next
			RunFeature($featuresObj)
		 Case $buttonStop
			$stop = True
			GUICtrlSetState($buttonRun, $GUI_ENABLE)
			GUICtrlSetState($buton1, $GUI_ENABLE)
			GUICtrlSetState($buttonStop, $GUI_DISABLE)
	  EndSwitch
   WEnd

   GUIDelete($hGUI)
EndFunc

Func GetFeatureScheduler($dateInWeek)
   Local $scheduler = ObjCreate("Scripting.Dictionary")
   For $date In $dateInWeek
	  Local $name = GUICtrlRead($date, 1)
	  If GUICtrlRead($date) = $GUI_CHECKED Then
		 $scheduler.Add($name, True)
	  Else
		 $scheduler.Add($name, False)
	  EndIf
   Next
   Return $scheduler
EndFunc

Func GetIgnoreAccountFile($featureName)
   Local $ignoreAccountObj = ObjCreate("Scripting.Dictionary")
   Local $ignoreAcc = $featureName & ".ig"
   If Not FileExists($ignoreAcc) Then
	  _FileCreate($ignoreAcc)
   Else
	  Local $lines = FileReadToArray($ignoreAcc)
	  If @error = 0 Then
		 For $line In $lines
			$ignoreAccountObj.Add($line, True)
		 Next
	  EndIf
   EndIf
   Return $ignoreAccountObj
EndFunc
