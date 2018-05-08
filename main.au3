#RequireAdmin
#include-once
#include "lib\Scenarios.au3"


FileInstall("conf\Variables.cons", "Variables.cons")
FileInstall("conf\Features.fea", "Features.fea")
FileInstall("scenario\guest\ChuyenDo\ShowHide0.sce", "ShowHide0.sce")
FileInstall("scenario\guest\ChuyenDo\ShowHide1.sce", "ShowHide1.sce")
FileInstall("scenario\guest\ChuyenDo\ChonItem.sce", "ChonItem.sce")
FileInstall("scenario\guest\ChuyenDo\DenDiemGD0.sce", "DenDiemGD0.sce")
FileInstall("scenario\guest\ChuyenDo\DenDiemGD1.sce", "DenDiemGD1.sce")
FileInstall("scenario\guest\ChuyenDo\DiemGD1.sce", "DiemGD1.sce")
FileInstall("scenario\guest\ChuyenDo\HoanTatGD.sce", "HoanTatGD.sce")
FileInstall("scenario\guest\ChuyenDo\MoiGD.sce", "MoiGD.sce")
FileInstall("scenario\guest\ChuyenDo\MuaVoHon.sce", "MuaVoHon.sce")
FileInstall("scenario\guest\ChuyenDo\NhanGD.sce", "NhanGD.sce")
FileInstall("scenario\guest\ChuyenDo\LoVoHon.sce", "LoVoHon.sce")
FileInstall("tm\ChuyenDo.tm", "ChuyenDo.tm", 1)

Global $startDate
Global $features
Local $variables = ReadVariable("Variables.cons")
Global $APP_PATH = $variables.Item("$APP_PATH")
Global $LOG_LEVEL = $variables.Item("$LOG_LEVEL")
If $APP_PATH = "{}" Then
   MsgBox(16, "Error Load Variable", "Confiure variables in Variables.cons before")
   Exit
EndIf

#cs
return -1: reset all
return 1: next feature
#ce
Func RunFeature($feature)
   Local $featureName = $feature.Item("feature")
   Local $time = $feature.Item("time")
   Local $template = $featureName & ".tm"
   footLog("INFO", StringFormat("%s - Run feature %s", "Main", $featureName))
   Local $files = _FileListToArrayRec(@WorkingDir, "*.acc", 1 + 4, 1, 1)
   Local $count = 0
   If $files <> "" Then
	  footLog("INFO", StringFormat("%s - Num of file %i", "Main", $files[0]))
	  Local $ignoreAccounts = ReadIgnoreAccount($featureName)
	  For $i = 1 To $files[0]

		 Local $accFile = $files[$i]
		 If $ignoreAccounts.Exists($accFile) Then
			; Ingore this account
			ContinueLoop
		 EndIf
		 Local $targetAccount = ObjCreate("Scripting.Dictionary")
		 $targetAccount.Add("account", "thanhhuupq5")
		 $targetAccount.Add("character", "Sao•Hỏa")

		 Local $accounts = ParseAccounts($accFile)
		 For $account In $accounts
			$count += 1
			Local $newAccounts[2] = [$account, $targetAccount]
			Local $next = FirstScenario($template, $newAccounts)
			If $next = 0 Then
			   ; Error step move file Accounts.xml
			   ContinueLoop
			EndIf
			Local $hwndAuto = SecondScenario(5)
			If $hwndAuto = -1 Then
			   ; Error login to window auto
			   Exit
			EndIf
			Local $logonGame = ThirdScenario($hwndAuto, $time*60)
			If $logonGame = -1 Then
			   footLog("ERROR", StringFormat("$s - Error run for %s", "RunFeature", $accFile))
			Else
			   ApplyActionStepsForChar($hwndAuto, "MuaVoHon.sce", 0)
			   ApplyActionStepsForChar($hwndAuto, "DenDiemGD0.sce", 0)
			   If $count = 1 Then
				  ApplyActionStepsForChar($hwndAuto, "DenDiemGD1.sce", 1)
			   Else
				  ApplyActionStepsForChar($hwndAuto, "DiemGD1.sce", 1)
			   EndIf
			   ApplyActionStepsForChar($hwndAuto, "MoiGD.sce", 0)
			   ApplyActionStepsForChar($hwndAuto, "NhanGD.sce", 1)
			   ApplyActionStepsForChar($hwndAuto, "ChonItem.sce", 0)
			   ApplyActionStepsForChar($hwndAuto, "HoanTatGD.sce", 1)

			   FinalScenario($hwndAuto)
			EndIf
		 Next
		 MarkIgnoreAccount($ignoreAccounts, $featureName, $accFile)
		 If $count = 45 Then
			footLog("DEBUG", StringFormat("%s - Done chuyen do cho %i character", "RunFeature", $count))
			$count = 0
			ApplyActionStepsForChar($hwndAuto, "LoVoHon.sce", 1)
		 EndIf

		 If _NowCalcDate() > $startDate Then
			Return -1
		 EndIf
	  Next
	  footLog("INFO", StringFormat("%s - Done feature %s", "RunFeature", $featureName))
	  MarkFeatureDone($featureName)
   EndIf
   Return 1
EndFunc

While True
   $startDate = _NowCalcDate()
   $features = InitFeatures("Features.fea")
   Local $reset = False
   For $feature In $features
	  Local $featureName = $feature.Item("feature")
	  If CheckFeatureIsIgnore($feature) Then
		 footLog("INFO", StringFormat("%s - Ignore feature %s", "Main", $featureName))
		 ContinueLoop
	  EndIf

	  If RunFeature($feature) = -1 Then
		 $reset = True
		 ExitLoop
	  EndIf
   Next
   If $reset Then
	  footLog("INFO", StringFormat("%s - Reset for date %s", "Main", _NowCalcDate()))
	  ResetBeforeInitialization()
	  ExitLoop
   Else
	  While True
		 Sleep(120000)
		 If _NowCalcDate() > $startDate Then
			footLog("INFO", StringFormat("%s - Reset for date %s", "Main", _NowCalcDate()))
			ResetBeforeInitialization()
			ExitLoop
		 EndIf
	  WEnd
   EndIf
WEnd




