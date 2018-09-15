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
#include <ColorConstants.au3>
#include <FontConstants.au3>
Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")


DIM $DEFAULT_PWD = "Ngoc@nh91"

Local $rowHeight = 20;
Local $accountFiles
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

Local $runEvent
Local $eventLogoutWhenDone
Func BuildTabEvent($position)
   Local $evenTab = GUICtrlCreateTabItem("Event")
   $runEvent = GUICtrlCreateCheckbox ("Run event", 30, $position, 90, $rowHeight)
   $position+= 20
   $eventLogoutWhenDone = GUICtrlCreateCheckbox ("Logout When Done", 30, $position + 10, 120, $rowHeight)
EndFunc

Local $tvp1, $tvp2, $tvp3, $tvp4, $tvp5, $tvp6, $tvp7
Local $tvpLogoutWhenDone
Func BuildTabTvp($position)
   $tvpTab = GUICtrlCreateTabItem("ThuVePhai")
   $tvp1 = GUICtrlCreateCheckbox (_DateDayOfWeek (1), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp1, $GUI_CHECKED)

   $tvpLogoutWhenDone = GUICtrlCreateCheckbox ("Logout When Done", 150, $position + 10, 120, $rowHeight)
   GUICtrlSetState($tvpLogoutWhenDone, $GUI_CHECKED)

   $position+= 20
   $tvp2 = GUICtrlCreateCheckbox (_DateDayOfWeek (2), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp2, $GUI_CHECKED)

   $position+= 20
   $tvp3 = GUICtrlCreateCheckbox (_DateDayOfWeek (3), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp3, $GUI_CHECKED)

   $position+= 20
   $tvp4 = GUICtrlCreateCheckbox (_DateDayOfWeek (4), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp4, $GUI_CHECKED)

   $position+= 20
   $tvp5 = GUICtrlCreateCheckbox (_DateDayOfWeek (5), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp5, $GUI_CHECKED)

   $position+= 20
   $tvp6 = GUICtrlCreateCheckbox (_DateDayOfWeek (6), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp6, $GUI_CHECKED)

   $position+= 20
   $tvp7 = GUICtrlCreateCheckbox (_DateDayOfWeek (7), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp7, $GUI_CHECKED)

EndFunc

Local $bc1, $bc2, $bc3, $bc4, $bc5, $bc6, $bc7
Local $bcNo
Local $bcLogoutWhenDone
Func BuildTabBc($position)
   GUICtrlCreateTabItem("BiCanh")
   $bc1 = GUICtrlCreateCheckbox (_DateDayOfWeek (1), 30, $position, 90, $rowHeight)
   GUICtrlSetState($bc1, $GUI_CHECKED)
   GUICtrlCreateLabel("SoLan", 150, $position + 3, 50, $rowHeight)
   $bcNo = GUICtrlCreateCombo("", 200, $position, 40, $rowHeight)
   GUICtrlSetData($bcNo, "0|1|2", "2")

   $position+= 20
   $bc2 = GUICtrlCreateCheckbox (_DateDayOfWeek (2), 30, $position, 90, $rowHeight)
   GUICtrlSetState($bc2, $GUI_CHECKED)
   $bcLogoutWhenDone = GUICtrlCreateCheckbox ("Logout When Done", 150, $position + 10, 120, $rowHeight)
   GUICtrlSetState($bcLogoutWhenDone, $GUI_CHECKED)


   $position+= 20
   $bc3 = GUICtrlCreateCheckbox (_DateDayOfWeek (3), 30, $position, 90, $rowHeight)
   GUICtrlSetState($bc3, $GUI_CHECKED)

   $position+= 20
   $bc4 = GUICtrlCreateCheckbox (_DateDayOfWeek (4), 30, $position, 90, $rowHeight)
   GUICtrlSetState($bc4, $GUI_CHECKED)

   $position+= 20
   $bc5 = GUICtrlCreateCheckbox (_DateDayOfWeek (5), 30, $position, 90, $rowHeight)
   GUICtrlSetState($bc5, $GUI_CHECKED)

   $position+= 20
   $bc6 = GUICtrlCreateCheckbox (_DateDayOfWeek (6), 30, $position, 90, $rowHeight)
   GUICtrlSetState($bc6, $GUI_CHECKED)

   $position+= 20
   $bc7 = GUICtrlCreateCheckbox (_DateDayOfWeek (7), 30, $position, 90, $rowHeight)
   GUICtrlSetState($bc7, $GUI_CHECKED)

EndFunc

Local $ntd1, $ntd2, $ntd3, $ntd4, $ntd5, $ntd6, $ntd7
Local $ntdNo
Local $ntdLogoutWhenDone
Func BuildTabNtd($position)
   GUICtrlCreateTabItem("NguTrucDam")
   $ntd1 = GUICtrlCreateCheckbox (_DateDayOfWeek (1), 30, $position, 90, $rowHeight)
   GUICtrlSetState($ntd1, $GUI_CHECKED)
   GUICtrlCreateLabel("SoLan", 150, $position + 3, 50, $rowHeight)
   $ntdNo = GUICtrlCreateCombo("", 200, $position, 40, $rowHeight)
   GUICtrlSetData($ntdNo, "0|1|2|3|4|5", "2")

   $position += 20
   $ntd2 = GUICtrlCreateCheckbox (_DateDayOfWeek (2), 30, $position, 90, $rowHeight)
   GUICtrlSetState($ntd2, $GUI_CHECKED)
   $ntdLogoutWhenDone = GUICtrlCreateCheckbox ("Logout When Done", 150, $position + 10, 120, $rowHeight)
   GUICtrlSetState($ntdLogoutWhenDone, $GUI_CHECKED)

   $position += 20
   $ntd3 = GUICtrlCreateCheckbox (_DateDayOfWeek (3), 30, $position, 90, $rowHeight)
   GUICtrlSetState($ntd3, $GUI_CHECKED)

   $position += 20
   $ntd4 = GUICtrlCreateCheckbox (_DateDayOfWeek (4), 30, $position, 90, $rowHeight)
   GUICtrlSetState($ntd4, $GUI_CHECKED)

   $position += 20
   $ntd5 = GUICtrlCreateCheckbox (_DateDayOfWeek (5), 30, $position, 90, $rowHeight)
   GUICtrlSetState($ntd5, $GUI_CHECKED)

   $position += 20
   $ntd6 = GUICtrlCreateCheckbox (_DateDayOfWeek (6), 30, $position, 90, $rowHeight)
   GUICtrlSetState($ntd6, $GUI_CHECKED)

   $position += 20
   $ntd7 = GUICtrlCreateCheckbox (_DateDayOfWeek (7), 30, $position, 90, $rowHeight)
   GUICtrlSetState($ntd7, $GUI_CHECKED)

EndFunc

Local $cbBuyItem, $cbSellItem, $cbUseItem, $cbOnlineExp
Local $cbNoBackHomeItem, $cbNoManaItem, $cbNoFoodItem, $cbSetting
Func BuildTabCb($position)
   GUICtrlCreateTabItem("CanBan")
   $cbBuyItem = GUICtrlCreateCheckbox ("BuyItems", 30, $position, 60, $rowHeight)
   GUICtrlSetState($cbBuyItem, $GUI_CHECKED)

   GUICtrlCreateLabel ("Phu", 110, $position + 3, 30, $rowHeight)
   $cbNoBackHomeItem = GUICtrlCreateCombo("", 140, $position, 40, $rowHeight)
   GUICtrlSetData($cbNoBackHomeItem, "10|20|30|40|50|60", "30")

   GUICtrlCreateLabel ("Mau", 210, $position + 3, 30, $rowHeight)
   $cbNoManaItem = GUICtrlCreateCombo("", 240, $position, 40, $rowHeight)
   GUICtrlSetData($cbNoManaItem, "40|60|80", "80")

   GUICtrlCreateLabel ("ThucAn", 300, $position + 3, 40, $rowHeight)
   $cbNoFoodItem = GUICtrlCreateCombo("", 350, $position, 40, $rowHeight)
   GUICtrlSetData($cbNoFoodItem, "1|5|10|20|30|40|50|60", "1")

   $position += 25
   $cbSellItem = GUICtrlCreateCheckbox ("SellItems", 30, $position, 60, $rowHeight)

   $position += 25
   $cbUseItem = GUICtrlCreateCheckbox ("UseItems", 30, $position, 60, $rowHeight)

   $position += 25
   $cbSetting = GUICtrlCreateCheckbox ("Setting", 30, $position, 60, $rowHeight)

   $position += 25
   $cbOnlineExp = GUICtrlCreateCheckbox ("Online Exp", 30, $position, 80, $rowHeight)
EndFunc

Local $nmq1, $nmq2, $nmq3, $nmq4, $nmq5, $nmq6, $nmq7
Local $nmqLogoutWhenDone, $nmqParallel, $nmqLimitParallel
Func BuildTabNmq($position)
   GUICtrlCreateTabItem("NhanMonQuan")
   $nmq1 = GUICtrlCreateCheckbox (_DateDayOfWeek (1), 30, $position, 90, $rowHeight)
   GUICtrlSetState($nmq1, $GUI_UNCHECKED)

   $nmqLogoutWhenDone = GUICtrlCreateCheckbox ("Logout When Done", 150, $position + 10, 120, $rowHeight)
   GUICtrlSetState($nmqLogoutWhenDone, $GUI_CHECKED)

   $position+= 20
   $nmq2 = GUICtrlCreateCheckbox (_DateDayOfWeek (2), 30, $position, 90, $rowHeight)
   GUICtrlSetState($nmq2, $GUI_UNCHECKED)

   $nmqParallel = GUICtrlCreateCheckbox ("Parallel", 150, $position + 10, 60, $rowHeight)

   $position+= 20
   $nmq3 = GUICtrlCreateCheckbox (_DateDayOfWeek (3), 30, $position, 90, $rowHeight)
   GUICtrlSetState($nmq3, $GUI_UNCHECKED)

   GUICtrlCreateLabel("Limit parallel", 150, $position + 15, 90, $rowHeight)
   $nmqLimitParallel = GUICtrlCreateCombo("", 250, $position + 10, 30, $rowHeight)
   GUICtrlSetData($nmqLimitParallel, "2|3|4|5", "2")

   $position+= 20
   $nmq4 = GUICtrlCreateCheckbox (_DateDayOfWeek (4), 30, $position, 90, $rowHeight)
   GUICtrlSetState($nmq4, $GUI_UNCHECKED)

   $position+= 20
   $nmq5 = GUICtrlCreateCheckbox (_DateDayOfWeek (5), 30, $position, 90, $rowHeight)
   GUICtrlSetState($nmq5, $GUI_UNCHECKED)

   $position+= 20
   $nmq6 = GUICtrlCreateCheckbox (_DateDayOfWeek (6), 30, $position, 90, $rowHeight)
   GUICtrlSetState($nmq6, $GUI_UNCHECKED)

   $position+= 20
   $nmq7 = GUICtrlCreateCheckbox (_DateDayOfWeek (7), 30, $position, 90, $rowHeight)
   GUICtrlSetState($nmq7, $GUI_UNCHECKED)
EndFunc


BuildUI()

Local $comboLevel
Func BuildUI()
   Local $hGUI = GUICreate("Auto Configuration",440, 330)

   ; View for row 1
   Local $lable1 = GUICtrlCreateLabel("Accounts", 20, 28, 70, $rowHeight)
   Local $input1 = GUICtrlCreateInput("", 110, 25, 200, $rowHeight, $ES_READONLY)
   Local $buton1 = GUICtrlCreateButton("Browse", 320, 25, 80, $rowHeight)

   ; View for row 2
   GUICtrlCreateLabel("Level", 20, 69, 70, $rowHeight)
   $comboLevel = GUICtrlCreateCombo ("", 110, 65, 100, $rowHeight)
   GUICtrlSetData($comboLevel, "60|80|100", "60")
   GUICtrlCreateLabel("Loading Time", 220, 69, 70, $rowHeight)
   Local $cbLoadingTime = GUICtrlCreateCombo ("", 300, 65, 40, $rowHeight)
   GUICtrlSetData($cbLoadingTime, "10|15|20|25|30", "15")
   GUICtrlCreateLabel("seconds", 350, 69, 70, $rowHeight)

   ; View for row 4
   Local $featureTab = GUICtrlCreateTab(20, 105, 400, 180)
   Local $buttonRun = GUICtrlCreateButton("Run", 340, 300, 80, $rowHeight)
   Local $countDown = GUICtrlCreateLabel("ds", 30, 290, 40, 40)
   GUICtrlSetState($countDown, $GUI_HIDE )
   GUICtrlSetColor($countDown, $COLOR_RED)
   GUICtrlSetFont($countDown, 20, $FW_MEDIUM)
   GUICtrlSetState($buttonRun, $GUI_DISABLE)

   BuildTabEvent(140)
   BuildTabCb(145)
   BuildTabTvp(140)
   BuildTabBc(140)
   BuildTabNtd(140)
   BuildTabNmq(140)


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
		 Case $comboLevel
			If GUICtrlRead($comboLevel) < 80 Then
			   GUICtrlSetState ($tvp1, $GUI_CHECKED )
			   GUICtrlSetState ($tvp2, $GUI_CHECKED )
			   GUICtrlSetState ($tvp3, $GUI_CHECKED )
			   GUICtrlSetState ($tvp4, $GUI_CHECKED )
			   GUICtrlSetState ($tvp5, $GUI_CHECKED )
			   GUICtrlSetState ($tvp6, $GUI_CHECKED )
			   GUICtrlSetState ($tvp7, $GUI_CHECKED )
			   GUICtrlSetState ($nmq1, $GUI_UNCHECKED)
			   GUICtrlSetState ($nmq2, $GUI_UNCHECKED)
			   GUICtrlSetState ($nmq4, $GUI_UNCHECKED)
			   GUICtrlSetState ($nmq6, $GUI_UNCHECKED)
			Else
			   GUICtrlSetState ($tvp1, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp2, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp3, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp4, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp5, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp6, $GUI_UNCHECKED)
			   GUICtrlSetState ($tvp7, $GUI_UNCHECKED)
			   GUICtrlSetState ($nmq1, $GUI_CHECKED )
			   GUICtrlSetState ($nmq2, $GUI_CHECKED )
			   GUICtrlSetState ($nmq4, $GUI_CHECKED )
			   GUICtrlSetState ($nmq6, $GUI_CHECKED )
			EndIf
		 Case $buttonRun
			If Not WinExists($WINDOW_AUTO) Then
			   MsgBox(0, "Warning", "Please start auto before")
			   ContinueLoop
			EndIf
			$stop = False
			GUICtrlSetState($buttonRun, $GUI_DISABLE)
			GUICtrlSetState($buton1, $GUI_DISABLE)

			$WAIT_LOAD = GUICtrlRead($cbLoadingTime) * 1000

			Local $featuresObj = ObjCreate("Scripting.Dictionary")

			; Basic obj
			Local $basicObj = ObjCreate("Scripting.Dictionary")
			$basicObj.Add("level", GUICtrlRead($comboLevel))
			$basicObj.Add("noGoHome", GUICtrlRead($cbNoBackHomeItem))
			$basicObj.Add("noMana", GUICtrlRead($cbNoManaItem))
			$basicObj.Add("noFood", GUICtrlRead($cbNoFoodItem))
			; Util
			Local $utilObj = ObjCreate("Scripting.Dictionary")
			If GUICtrlRead($cbSellItem) = $GUI_CHECKED Then
			   $utilObj.Add("sellItem", True)
			EndIf
			If GUICtrlRead($cbUseItem) = $GUI_CHECKED Then
			   $utilObj.Add("useItem", True)
			EndIf
			If GUICtrlRead($cbOnlineExp) = $GUI_CHECKED Then
			   $utilObj.Add("onlineExp", True)
			EndIf

			; Feature Event
			Local $eventFeature = ObjCreate("Scripting.Dictionary")
			Local $eventSchedule = ObjCreate("Scripting.Dictionary")
			$eventSchedule.Add(_DateDayOfWeek(@WDAY), True)
			$eventFeature.Add("Scheduler", $eventSchedule)
			Local $eventRequireTask = ['TryLuckyCard', 'TurnOffGraphic']
			$eventFeature.Add("RequireTasks", $eventRequireTask)
			Local $eventMainTask = ['receiveEvent']
			$eventFeature.Add("MainTasks", $eventMainTask)
			If GUICtrlRead($runEvent) = $GUI_CHECKED Then
			   $featuresObj.Add("Event", $eventFeature)
			EndIf

			; Feature NhanMonQuan
			Local $nmqFeature = ObjCreate("Scripting.Dictionary")
			Local $nmqInWeek = [$nmq1, $nmq2, $nmq3, $nmq4, $nmq5, $nmq6, $nmq7]
			Local $nmqSchedule = GetFeatureScheduler($nmqInWeek)
			$nmqFeature.Add("Scheduler", $nmqSchedule)
			Local $nmqRequireTask = ['TryLuckyCard', 'TurnOffGraphic', 'SetupFighting' , 'TryLuckyRound', 'BuyItemManaAndFood', 'EnterFightingMap', 'StartFighting']
			$nmqFeature.Add("RequireTasks", $nmqRequireTask)
			Local $nmqMainTask = ['ContinueFighting']
			$nmqFeature.Add("MainTasks", $nmqMainTask)
			If GUICtrlRead($nmqParallel) = $GUI_CHECKED Then
			   $nmqFeature.Add("parallel", GUICtrlRead($nmqLimitParallel))
			EndIf
			$featuresObj.Add("NhanMonQuan", $nmqFeature)

			; Feature thu ve phai
			Local $tvpFeature = ObjCreate("Scripting.Dictionary")
			Local $tvpInWeek = [$tvp1, $tvp2, $tvp3, $tvp4, $tvp5, $tvp6, $tvp7]
			Local $tvpSchedule = GetFeatureScheduler($tvpInWeek)
			$tvpFeature.Add("Scheduler", $tvpSchedule)
			Local $tvpRequireTask = [ 'TryLuckyCard', 'TurnOffGraphic','TryLuckyRound', 'BuyItemGoHome']
			$tvpFeature.Add("RequireTasks", $tvpRequireTask)
			Local $tvpMainTask = ['AssignPrevention', 'GetActiveAward']
			$tvpFeature.Add("MainTasks", $tvpMainTask)
			$featuresObj.Add("ThuVePhai", $tvpFeature)


			; Feature Bi Canh
			Local $bcFeature = ObjCreate("Scripting.Dictionary")
			Local $bcInWeek = [$bc1, $bc2, $bc3, $bc4, $bc5, $bc6, $bc7]
			Local $bcSchedule = GetFeatureScheduler($bcInWeek)
			$bcFeature.Add("Scheduler", $bcSchedule)
			Local $bcRequireTask = [ 'TryLuckyCard', 'TurnOffGraphic','TryLuckyRound', 'BuyItemGoHome']
			$bcFeature.Add("RequireTasks", $bcRequireTask)
			Local $bcMainTask = ['AssignStory', 'GetActiveAward']
			$bcFeature.Add("MainTasks", $bcMainTask)
			For $i = 1 To GUICtrlRead($bcNo)
			   $featuresObj.Add("BiCanh" & $i, $bcFeature)
			Next


			; Feature Ngu truc dam
			Local $ntdFeature = ObjCreate("Scripting.Dictionary")
			Local $ntdInWeek = [$ntd1, $ntd2, $ntd3, $ntd4, $ntd5, $ntd6, $ntd7]
			Local $ntdSchedule = GetFeatureScheduler($ntdInWeek)
			$ntdFeature.Add("Scheduler", $ntdSchedule)
			Local $ntdRequireTask = [ 'TryLuckyCard', 'TurnOffGraphic','TryLuckyRound', 'BuyItemGoHome']
			$ntdFeature.Add("RequireTasks", $ntdRequireTask)
			Local $ntdMainTask = ['AssignChallenge', 'GetActiveAward']
			$ntdFeature.Add("MainTasks", $ntdMainTask)
			For $j = 1 To GUICtrlRead($ntdNo)
			   $featuresObj.Add("NguTrucDam" & $j, $ntdFeature)
			Next

			Local $count = 10;
			While True
			   If $count = 0 Then
				  ExitLoop
			   EndIf
			   GUICtrlSetData($countDown, "" & $count)
			   GUICtrlSetState($countDown, $GUI_SHOW)
			   Sleep(500)
			   GUICtrlSetState($countDown, $GUI_HIDE )
			   $count -= 1
			WEnd
			RunFeature($featuresObj, $basicObj, $utilObj)
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

Func BuildFeatureFile($featureName, $level)
   Return $featureName & "_" & $level
EndFunc

Func GetIgnoreAccount($featureName, $level)
   Local $ignoreAccountObj = ObjCreate("Scripting.Dictionary")
   Local $ignoreAcc = BuildFeatureFile($featureName, $level) & ".ig"
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

Func IsIngoredFeature($featureName, $scheduler, $basicObj)
   If Not $scheduler.Item(_DateDayOfWeek(@WDAY)) Then
	  Return True
   EndIf
   If FileExists(BuildFeatureFile($featureName, $basicObj.Item("level")) & ".done") Then
	  Return True
   EndIf
   Return False
EndFunc

Func RunFeature($featuresObj, $basicObj, $utilObj)
   Local $startDate = _NowCalcDate()
   Local $isNewDate = False
   While True
	  If $isNewDate Then
		 WriteLog("release-2.0", "Reset all for new date")
		 FileDelete("*.ig")
		 FileDelete("*.done")
		 $isNewDate = False
	  EndIf
	  Local $ranUtil = True
	  For $featureName In $featuresObj.Keys
		 LogoutAll()
		 Local $featureObj = $featuresObj.Item($featureName)
		 If IsIngoredFeature($featureName, $featureObj.Item("Scheduler"), $basicObj) Then
			WriteLog("release-2.0", StringFormat("Ignore feature %s", $featureName))
			ContinueLoop
		 EndIf
		 WriteLog("release-2.0", StringFormat("Run feature %s", $featureName))
		 Local $ignoreAccountObj = GetIgnoreAccount($featureName, $basicObj.Item("level"))
		 Local $charactersObj = ObjCreate("Scripting.Dictionary")
		 For $i = 1 To $accountFiles[0]
			Local $accountFile = $accountFiles[$i]
			Local $accounts = ParseAccounts($accountFile)

			For $account In $accounts
			   Local $character = $account.Item("character")
			   If $ignoreAccountObj.Item($character) Then
				  ; write log ignore
				  WriteLog("release-2.0", StringFormat("Feature %s is ignored for account %s", $featureName, $character))
				  ContinueLoop
			   EndIf
			   ; Enter Game
			   Local $character = $account.Item("character")
			   Local $usr = $account.Item("account")
			   AddAccount($usr, $DEFAULT_PWD, $character)
			   If Not Login($character) Then
				  WriteLog("release", StringFormat("Skip %s because login fail", $character))
				  ContinueLoop
			   EndIf
			   Sleep(10000)
			   ; Run util task
			   If $ranUtil And $utilObj.Exists("onlineExp") Then
				  OnlineExp($character, $basicObj)
			   EndIf
			   If $ranUtil And $utilObj.Exists("useItem") Then
				  UseItems($character, $basicObj)
			   EndIf
			   For $requireTask In $featureObj.Item("RequireTasks")
				  WriteLog("release", StringFormat("Run task %s", $requireTask))
				  Call($requireTask, $character, $basicObj)
			   Next
			   ; Run main task
			   If $featureObj.Exists("parallel") Then
				  Local $characterObj = ObjCreate("Scripting.Dictionary")
				  $characterObj.Add("featureName", $featureName)
				  $characterObj.Add("featureObj", $featureObj)
				  $charactersObj.Add($character, $characterObj)
				  ParallelRunning($basicObj, $charactersObj, False)
			   Else
				  For $mainTask In $featureObj.Item("MainTasks")
					 WriteLog("release", StringFormat("Run task %s", $mainTask))
					 While True
						Local $done = Call($mainTask, $character, $basicObj)
						If $done Then
						   ExitLoop
						EndIf
					 WEnd
				  Next
				  Logout($character)
				  FileWriteLine($featureName & "_" & $basicObj.Item("level") & ".ig", $character)
			   EndIf
			   If _NowCalcDate() > $startDate Then
				  ExitLoop
			   EndIf
			Next
			If _NowCalcDate() > $startDate Then
			   ExitLoop
			EndIf
		 Next
		 If $featureObj.Exists("parallel") And $charactersObj.Count() > 0 Then
			ParallelRunning($basicObj, $charactersObj, True)
		 EndIf
		 If _NowCalcDate() > $startDate Then
			ExitLoop
		 EndIf
		 FileMove(BuildFeatureFile($featureName, $basicObj.Item("level")) & ".ig", BuildFeatureFile($featureName, $basicObj.Item("level")) & ".done")
		 $ranUtil = False
	  Next
	  While True
		 Sleep(60000)
		 If _NowCalcDate() > $startDate Then
			$startDate = _NowCalcDate()
			$isNewDate = True
			ExitLoop
		 EndIf
	  WEnd
   WEnd
EndFunc

Func ParallelRunning($basicObj, $charactersObj, $finalRunning)
   While True
	  For $character in $charactersObj.Keys
		 Local $featureObj = $charactersObj.Item($character).Item("featureObj")
		 Local $done = True
		 For $mainTask In $featureObj.Item("MainTasks")
			WriteLogDebug("release", StringFormat("Run task %s for %s", $mainTask, $character))
			$done = Call($mainTask, $character, $basicObj)
		 Next
		 If $done Then
			DoneCharacterInParallel($character, $charactersObj, $basicObj)
			ExitLoop
		 EndIf
		 Sleep(1000)
	  Next
	  If $finalRunning Then
		 If $charactersObj.Count() = 0 Then
			WriteLogDebug("release", "Done all characters in parallel")
			ExitLoop
		 Else
			WriteLogDebug("release", StringFormat("Still exit %d in parallel characters", $charactersObj.Count()))
			ContinueLoop
		 EndIf
	  ElseIf $charactersObj.Count() < $featureObj.Item("parallel") Then
		 WriteLogDebug("release", "Exit parallel to add one more")
		 ExitLoop
	  EndIf
   WEnd
EndFunc

Func DoneCharacterInParallel($character, $charactersObj, $basicObj)
   Local $featureName = $charactersObj.Item($character).Item("featureName")
   WriteLogDebug("release", StringFormat("Done feature %s for %s", $featureName, $character))
   $charactersObj.Remove($character)
   Logout($character)
   FileWriteLine($featureName & "_" & $basicObj.Item("level") & ".ig", $character)
EndFunc
