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


DIM $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
DIM $DEFAULT_PWD = "Ngoc@nh91"
Global $WAIT_LOAD = 15000

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


Local $tvp1, $tvp2, $tvp3, $tvp4, $tvp5, $tvp6, $tvp7
Local $tvpLogoutWhenDone, $tvpReceiveAward
Func BuildTabTvp($position)
   $tvpTab = GUICtrlCreateTabItem("ThuVePhai")
   $tvp1 = GUICtrlCreateCheckbox (_DateDayOfWeek (1), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp1, $GUI_DISABLE + $GUI_CHECKED)

   $tvpLogoutWhenDone = GUICtrlCreateCheckbox ("Logout When Done", 150, $position + 10, 120, $rowHeight)
   GUICtrlSetState($tvpLogoutWhenDone, $GUI_DISABLE + $GUI_CHECKED)

   $position+= 20
   $tvp2 = GUICtrlCreateCheckbox (_DateDayOfWeek (2), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp2, $GUI_DISABLE + $GUI_CHECKED)
   $tvpReceiveAward = GUICtrlCreateCheckbox("Receive Actitive Award", 150, $position + 10, 150, $rowHeight)
   GUICtrlSetState($tvpReceiveAward, $GUI_CHECKED)

   $position+= 20
   $tvp3 = GUICtrlCreateCheckbox (_DateDayOfWeek (3), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp3, $GUI_DISABLE + $GUI_CHECKED)

   $position+= 20
   $tvp4 = GUICtrlCreateCheckbox (_DateDayOfWeek (4), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp4, $GUI_DISABLE + $GUI_CHECKED)

   $position+= 20
   $tvp5 = GUICtrlCreateCheckbox (_DateDayOfWeek (5), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp5, $GUI_DISABLE + $GUI_CHECKED)

   $position+= 20
   $tvp6 = GUICtrlCreateCheckbox (_DateDayOfWeek (6), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp6, $GUI_DISABLE + $GUI_CHECKED)

   $position+= 20
   $tvp7 = GUICtrlCreateCheckbox (_DateDayOfWeek (7), 30, $position, 90, $rowHeight)
   GUICtrlSetState($tvp7, $GUI_DISABLE + $GUI_CHECKED)

EndFunc

Local $bc1, $bc2, $bc3, $bc4, $bc5, $bc6, $bc7
Local $bcNo
Local $bcReceiveAward
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
   GUICtrlSetState($bcLogoutWhenDone, $GUI_DISABLE + $GUI_CHECKED)


   $position+= 20
   $bc3 = GUICtrlCreateCheckbox (_DateDayOfWeek (3), 30, $position, 90, $rowHeight)
   GUICtrlSetState($bc3, $GUI_CHECKED)
   $bcReceiveAward = GUICtrlCreateCheckbox("Receive Actitive Award", 150, $position + 10, 150, $rowHeight)
   GUICtrlSetState($bcReceiveAward, $GUI_CHECKED)

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
Local $ntdReceiveAward
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
   GUICtrlSetState($ntdLogoutWhenDone, $GUI_DISABLE + $GUI_CHECKED)

   $position += 20
   $ntd3 = GUICtrlCreateCheckbox (_DateDayOfWeek (3), 30, $position, 90, $rowHeight)
   GUICtrlSetState($ntd3, $GUI_CHECKED)
   $ntdReceiveAward = GUICtrlCreateCheckbox("Receive Actitive Award", 150, $position + 10, 150, $rowHeight)
   GUICtrlSetState($ntdReceiveAward,$GUI_CHECKED)

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

Local $cbBuyItem, $cbSellItem, $cbUseItem
Local $cbNoBackHomeItem, $cbNoManaItem, $cbNoFoodItem
Func BuildTabCb($position)
   GUICtrlCreateTabItem("CanBan")
   $cbBuyItem = GUICtrlCreateCheckbox ("BuyItems", 30, $position, 60, $rowHeight)
   GUICtrlSetState($cbBuyItem, $GUI_DISABLE + $GUI_CHECKED)

   GUICtrlCreateLabel ("Phu", 110, $position + 3, 30, $rowHeight)
   $cbNoBackHomeItem = GUICtrlCreateCombo("", 140, $position, 40, $rowHeight)
   GUICtrlSetData($cbNoBackHomeItem, "10|20|30|40|50|60", "20")

   GUICtrlCreateLabel ("Mau", 210, $position + 3, 30, $rowHeight)
   $cbNoManaItem = GUICtrlCreateCombo("", 240, $position, 40, $rowHeight)
   GUICtrlSetData($cbNoManaItem, "40|60|80", "80")

   GUICtrlCreateLabel ("ThucAn", 300, $position + 3, 40, $rowHeight)
   $cbNoFoodItem = GUICtrlCreateCombo("", 350, $position, 40, $rowHeight)
   GUICtrlSetData($cbNoFoodItem, "10|20|30|40|50|60", "20")

   $position += 30
   $cbSellItem = GUICtrlCreateCheckbox ("SellItems", 30, $position, 60, $rowHeight)
   GUICtrlSetState($cbSellItem, $GUI_DISABLE + $GUI_CHECKED)

   $position += 30
   $cbUseItem = GUICtrlCreateCheckbox ("UseItems", 30, $position, 60, $rowHeight)
   GUICtrlSetState($cbUseItem, $GUI_DISABLE + $GUI_CHECKED)
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
   GUICtrlSetData($comboLevel, "70|80|100", "70")
   GUICtrlCreateLabel("Loading Time", 220, 69, 70, $rowHeight)
   Local $cbLoadingTime = GUICtrlCreateCombo ("", 300, 65, 40, $rowHeight)
   GUICtrlSetData($cbLoadingTime, "10|15|20|25|30", "15")
   GUICtrlCreateLabel("seconds", 350, 69, 70, $rowHeight)

   ; View for row 4
   Local $featureTab = GUICtrlCreateTab(20, 105, 400, 180)
   Local $buttonRun = GUICtrlCreateButton("Run", 340, 300, 80, $rowHeight)
   Local $buttonStop = GUICtrlCreateButton("Stop", 250, 300, 80, $rowHeight)
   Local $countDown = GUICtrlCreateLabel("ds", 30, 290, 40, 40)
   GUICtrlSetState($countDown, $GUI_HIDE )
   GUICtrlSetColor($countDown, $COLOR_RED)
   GUICtrlSetFont($countDown, 20, $FW_MEDIUM)
   GUICtrlSetState($buttonRun, $GUI_DISABLE)
   GUICtrlSetState($buttonStop, $GUI_DISABLE)

   BuildTabCb(145)
   BuildTabTvp(140)
   BuildTabBc(140)
   BuildTabNtd(140)


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
			If GUICtrlRead($comboLevel) = 70 Then
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

			Local $basicObj = ObjCreate("Scripting.Dictionary")
			$basicObj.Add("level", GUICtrlRead($comboLevel))
			$basicObj.Add("noGoHome", GUICtrlRead($cbNoBackHomeItem))
			$basicObj.Add("noMana", GUICtrlRead($cbNoManaItem))
			$basicObj.Add("notFood", GUICtrlRead($cbNoFoodItem))

			; Feature thu ve phai
			Local $tvpInWeek = [$tvp1, $tvp2, $tvp3, $tvp4, $tvp5, $tvp6, $tvp7]
			Local $tvpSchedule = GetFeatureScheduler($tvpInWeek)

			Local $tvpFeature = ObjCreate("Scripting.Dictionary")
			$tvpFeature.Add("Basic", $basicObj)
			$tvpFeature.Add("Scheduler", $tvpSchedule)
			If GUICtrlRead($tvpReceiveAward) = $GUI_CHECKED Then
			   Local $tvpFuncs = ['AssignPrevention', 'GetActiveAward']
			   $tvpFeature.Add("Functions", $tvpFuncs)
			Else
			  Local $tvpFuncs = ['AssignPrevention']
			   $tvpFeature.Add("Functions", $tvpFuncs)
			EndIf
			If GUICtrlRead($tvpLogoutWhenDone) = $GUI_CHECKED Then
			   $tvpFeature.Add("Logout", True)
			EndIf
			If $tvpSchedule.Item(_DateDayOfWeek(@WDAY)) Then
			    $featuresObj.Add("ThuVePhai", $tvpFeature)
			EndIf


			; Feature BC
			Local $bcFeature = ObjCreate("Scripting.Dictionary")
			$bcFeature.Add("Basic", $basicObj)
			Local $bcInWeek = [$bc1, $bc2, $bc3, $bc4, $bc5, $bc6, $bc7]
			Local $bcSchedule = GetFeatureScheduler($bcInWeek)
			$bcFeature.Add("Scheduler", $bcSchedule)
			If GUICtrlRead($bcReceiveAward) = $GUI_CHECKED Then
			   Local $bcFuncs = ['AssignStory', 'GetActiveAward']
			   $bcFeature.Add("Functions", $bcFuncs)
			Else
			   Local $bcFuncs = ['AssignStory']
			   $bcFeature.Add("Functions", $bcFuncs)
			EndIf
			If GUICtrlRead($bcLogoutWhenDone) = $GUI_CHECKED Then
			   $bcFeature.Add("Logout", True)
			EndIf
			If $bcSchedule.Item(_DateDayOfWeek(@WDAY)) Then
			   For $i = 1 To GUICtrlRead($bcNo)
				  $featuresObj.Add("BiCanh" & $i, $bcFeature)
			   Next
			EndIf


			; Feature Ngu truc dam
			Local $ntdFeature = ObjCreate("Scripting.Dictionary")
			$ntdFeature.Add("Basic", $basicObj)
			Local $ntdInWeek = [$ntd1, $ntd2, $ntd3, $ntd4, $ntd5, $ntd6, $ntd7]
			Local $ntdSchedule = GetFeatureScheduler($ntdInWeek)
			$ntdFeature.Add("Scheduler", $ntdSchedule)
			If GUICtrlRead($ntdReceiveAward) = $GUI_CHECKED Then
			   Local $ntdFuncs = ['AssignChallenge', 'GetActiveAward']
			   $ntdFeature.Add("Functions", $ntdFuncs)
			Else
			   Local $ntdFuncs = ['AssignChallenge']
			   $ntdFeature.Add("Functions", $ntdFuncs)
			EndIf
			If GUICtrlRead($ntdLogoutWhenDone) = $GUI_CHECKED Then
			   $ntdFeature.Add("Logout", True)
			EndIf
			If $ntdSchedule.Item(_DateDayOfWeek(@WDAY)) Then
			   Local $msg = StringFormat("NguTrucDam is disable on %s", _DateDayOfWeek(@WDAY))
			   _FileWriteLog($LOG_FILE, StringFormat("%s - %s", "release-2.0", $msg))
			   For $j = 1 To GUICtrlRead($ntdNo)
				  $featuresObj.Add("NguTrucDam" & $j, $ntdFeature)
			   Next
			EndIf

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

Func RunFeature($featuresObj)
   For $featureName In $featuresObj.Keys
	  Local $featureObj = $featuresObj.Item($featureName)
	  If FileExists($featureName & ".done") Then
		 Local $msg = StringFormat("Feature %s is done", $featureName)
		 _FileWriteLog($LOG_FILE, StringFormat("%s - %s", "release-2.0", $msg))
		 ContinueLoop
	  EndIf
	  Local $basicObj = $featureObj.Item("Basic")
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
			BuyItems($basicObj.Item("level"), $basicObj.Item("noGoHome"), $basicObj.Item("noMana"), $basicObj.Item("noFood"))
			Setting()

			Local $functions = $featureObj.Item("Functions")
			For $function In $functions
			   Call($function, $basicObj.Item("level"))
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
