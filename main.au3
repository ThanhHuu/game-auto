#RequireAdmin
#include-once
#include "lib\Scenarios.au3"


FileInstall("conf\Variables.cons", "Variables.cons")
FileInstall("conf\Features.fea", "Features.fea")
FileInstall("scenario\guest\BackHome.sce", "BackHome.sce")
FileInstall("scenario\guest\SellItems.sce", "SellItems.sce")
FileInstall("scenario\guest\UseItems.sce", "UseItems.sce")
FileInstall("scenario\guest\LatThe.sce", "LatThe.sce")
FileInstall("scenario\guest\CauPhuc.sce", "CauPhuc.sce")
FileInstall("scenario\guest\NhanSoiNoi.sce", "NhanSoiNoi.sce")
FileInstall("scenario\guest\BuyItems.sce", "BuyItems.sce")
FileInstall("scenario\guest\ShowHide0.sce", "ShowHide0.sce")
FileInstall("scenario\guest\ShowHide1.sce", "ShowHide1.sce")
FileInstall("scenario\guest\ShowHide2.sce", "ShowHide2.sce")
FileInstall("scenario\guest\ShowHide3.sce", "ShowHide3.sce")
FileInstall("scenario\guest\ShowHide4.sce", "ShowHide4.sce")
FileInstall("tm\Action.tm", "Action.tm", 1)
FileInstall("tm\BiCanh1.tm", "BiCanh1.tm", 1)
FileInstall("tm\BiCanh2.tm", "BiCanh2.tm", 1)
FileInstall("tm\NguTrucDam1.tm", "NguTrucDam1.tm", 1)
FileInstall("tm\NguTrucDam2.tm", "NguTrucDam2.tm", 1)
FileInstall("tm\NhanMonQuan.tm", "NhanMonQuan.tm", 1)
FileInstall("tm\ThuVePhai.tm", "ThuVePhai.tm", 1)

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
   If $files <> "" Then
	  footLog("INFO", StringFormat("%s - Num of file %i", "Main", $files[0]))
	  Local $ignoreAccounts = ReadIgnoreAccount($featureName)
	  For $i = 1 To $files[0]

		 Local $accFile = $files[$i]
		 If $ignoreAccounts.Exists($accFile) Then
			; Ingore this account
			ContinueLoop
		 EndIf

		 Local $next = FirstScenario($template, $accFile)
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
			MarkIgnoreAccount($ignoreAccounts, $featureName, $accFile)

			If $feature.Exists("scenarios") Then
			   footLog("INFO", StringFormat("%s - Run scenario %s", "RunFeature", $feature.Item("scenarios")))
			   ApplyActionSteps($hwndAuto, $feature.Item("scenarios"))
			EndIf
			FinalScenario($hwndAuto)
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




