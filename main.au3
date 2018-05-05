#RequireAdmin
#include-once
#include "lib\Scenarios.au3"

FileInstall("conf\Action.tm", "Action.tm")
FileInstall("conf\DieuDoi.tm", "DieuDoi.tm")
FileInstall("conf\NhanMonQuan.tm", "NhanMonQuan.tm")
FileInstall("conf\Features.fea", "Features.fea")
FileInstall("conf\Variables.cons", "Variables.cons")

Global $startDate
Global $features
Local $variables = ReadVariable("Variables.cons")
Global $APP_PATH = $variables.Item("$APP_PATH")
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
   Local $files = _FileListToArrayRec(@WorkingDir, "*.acc", 1 + 4, 1, 1)
   If $files <> "" Then
	  Local $ignoreAccounts = ReadIgnoreAccount($featureName)
	  For $i = 1 To $files[0]
		 Local $accFile = $files[$i]
		 If $ignoreAccounts.Exists($accFile) Then
			; Ingore this account
			ContinueLoop
		 EndIf

		 MarkIgnoreAccount($ignoreAccounts, $featureName, $accFile)

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
		 ThirdScenario($hwndAuto, $time*60)
		 FinalScenario($hwndAuto)

		 If _NowCalcDate() > $startDate Then
			Return -1
		 EndIf
	  Next
	  MarkFeatureDone($featureName)
   EndIf
   Return 1
EndFunc

While True
   $startDate = _NowCalcDate()
   $features = InitFeatures("Features.fea")
   Local $reset = False
   For $feature In $features
	  Local $enable = $feature.Item("enable")
	  Local $featureName = $feature.Item("feature")
	  If $enable = 0 Or CheckFeatureDone($featureName) Then
		 ; Skip feature
		 ContinueLoop
	  EndIf
	  If RunFeature($feature) = -1 Then
		 $reset = True
		 ExitLoop
	  EndIf
   Next
   If $reset Then
	  ResetBeforeInitialization()
	  ExitLoop
   EndIf
WEnd




