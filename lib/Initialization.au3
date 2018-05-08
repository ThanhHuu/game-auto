#include-once
#include "Util.au3"

#cs
Initialize feature from file configuration
$confFile: file path
return -1: Error
return array object feature
#ce
Func InitFeatures($confFile)
   Local $objFea = ObjCreate("Scripting.Dictionary")
   If FileExists($confFile) = 0 Then
	  ; File not exit
	  Return -1
   EndIf
   Local $openedFile = FileOpen($confFile)
   If $openedFile = -1 Then
	  ; Error open file
	  Return -1
   EndIf
   Local $line = 0;
   While True
	  $line += 1
	  Local $strConfig = FileReadLine($openedFile, $line)
	  If @error = -1 Then
		 ; End file
		 ExitLoop
	  EndIf
	  If @error = 1 Then
		 ; Error read file
		 FileClose($openedFile)
		 Return -1
	  EndIf
	  Local $objFeature = ParseFeature($strConfig)
	  If $objFeature = 0 Then
		 ; Error format
		 ContinueLoop
	  EndIf
	  $objFea.ADD($line, $objFeature)
   WEnd
   FileClose($openedFile)
   Return $objFea.Items
EndFunc

#cs
parse feature into dictionary object
$strConfig: feature=DieuDoi;enable=0;time=3
return 0: format is incorrect
return object with key:	feature - value
						enable - value
						time - value
#ce
Func ParseFeature($strConfig)
   Local $obj = ObjCreate("Scripting.Dictionary")
   Local $arInfo = StringSplit($strConfig, ";")
   If $arInfo[0] < 3 Then
	  Return 0
   EndIf
   For $i = 1 to $arInfo[0]
	  Local $arItem = StringSplit($arInfo[$i], "=")
	  If $arItem[0] < 2 Then
		 Return 0
	  EndIf
	  $obj.ADD($arItem[1], $arItem[2])
   Next
   Return $obj
EndFunc

#cs
Parse array accounts from file
return -1: error file
return -2: wrong format
return array account
#ce
Func ParseAccounts($accFile)
   If FileExists($accFile) = 0 Then
	  ; file not Exit
	  Return -1
   EndIf
   Local $openedFile = FileOpen($accFile)
   If $openedFile = -1 Then
	  ; error open file
	  Return -1
   EndIf
   Local $line = 0
   Local $objAccounts = ObjCreate("Scripting.Dictionary")
   While True
	  $line += 1
	  Local $accInfo = FileReadLine($openedFile, $line)
	  If @error = -1 Then
		 ; End file
		 ExitLoop
	  EndIf
	  If @error = 1 Then
		 ; error read file
		 FileClose($openedFile)
		 Return -1
	  EndIf
	  Local $infos = StringSplit($accInfo, "=")
	  If $infos[0] <> 2 Then
		 ; wrong format
		 Return -2
	  EndIf
	  Local $obj = ObjCreate("Scripting.Dictionary")
	  $obj.Add("account", $infos[1])
	  $obj.Add("character", $infos[2])
	  $objAccounts.Add($line, $obj)
   WEnd
   FileClose($openedFile)
   Return $objAccounts.Items
EndFunc

Func ReadVariable($varFile)
   If FileExists($varFile) = 0 Then
	  ; file not Exit
	  Return -1
   EndIf
   Local $openedFile = FileOpen($varFile)
   If $openedFile = -1 Then
	  ; error open file
	  Return -1
   EndIf
   Local $line = 0
   Local $obj = ObjCreate("Scripting.Dictionary")
   While True
	  $line += 1
	  Local $varInfo = FileReadLine($openedFile, $line)
	  If @error = -1 Then
		 ; End file
		 ExitLoop
	  EndIf
	  If @error = 1 Then
		 ; error read file
		 FileClose($openedFile)
		 Return -1
	  EndIf
	  Local $var = StringSplit($varInfo, "=")
	  If $var[0] <> 2 Then
		 ; wrong format
		 Return -2
	  EndIf
	  $obj.Add($var[1], $var[2])
   WEnd
   FileClose($openedFile)
   Return $obj
EndFunc

Func ReadIgnoreAccount($featureName)
   Local $ignoreAcc = $featureName & ".ig"
   Local $obj = ObjCreate("Scripting.Dictionary")
   If Not FileExists($ignoreAcc) Then
	  _FileCreate($ignoreAcc)
   EndIf
   Local $openedFile = FileOpen($ignoreAcc)
   If $openedFile <> -1 Then
	  ; error open file
	  Local $line = 0
	  While True
		 $line += 1
		 Local $acc = FileReadLine($openedFile, $line)
		 If @error = -1 Or @error = 1 Then
			; End file
			ExitLoop
		 EndIf
		 $obj.Add($acc, True)
	  WEnd
	  FileClose($openedFile)
   EndIf
   Return $obj
EndFunc

Func MarkIgnoreAccount($ignoreAccounts, $featureName, $accFile)
   $ignoreAccounts.Add($accFile, True)
   Local $ignoreAcc = $featureName & ".ig"
   If Not FileExists($ignoreAcc) Then
	  _FileCreate($ignoreAcc)
   EndIf
   FileWriteLine($ignoreAcc, $accFile)
EndFunc

Func MarkFeatureDone($featureName)
   Local $ignoreAcc = $featureName & ".ig"
   Local $done = $featureName & ".done"
   If Not FileExists($ignoreAcc) Then
	  _FileCreate($ignoreAcc)
   EndIf
   FileMove($ignoreAcc, $done)
EndFunc

Func CheckFeatureIsIgnore($feature)
   Local $enable = $feature.Item("enable")
   If $enable = 0 Then
	  Return True
   EndIf

   If $feature.Exists("scheduler") Then
	  Local $toDay = _DateDayOfWeek(@WDAY, $DMW_SHORTNAME)
	  Local $scheduler = $feature.Item("scheduler")
	  If StringInStr($scheduler, $toDay) = 0 Then
		 Return True
	  EndIf
   EndIf

   Local $featureName = $feature.Item("feature")
   Local $done = $featureName & ".done"
   Return FileExists($done)
EndFunc

Func ResetBeforeInitialization()
   Local $dones = _FileListToArrayRec(@WorkingDir, "*.done", 1)
   For $i = 1 To $dones[0]
	  FileDelete($done[$i])
   Next
   Local $ignores = _FileListToArrayRec(@WorkingDir, "*.ig", 1)
   For $j To $ignores[0]
	  FileDelete($ignores[$j])
   Next
EndFunc



