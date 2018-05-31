#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#RequireAdmin
#include("lib\Initialization.au3")
#include("lib\Interaction.au3")
#include <File.au3>

DIM $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Local $AUTO_PATH = ""
Local $accountFiles = _FileListToArrayRec(@WorkingDir, "*.acc", 1 + 4, 1, 1);
Local $features = []
Local $AutoTemplate = ""

Func RunFeature($feature)
   Local $ignoreAccounts = ReadIgnoreAccount($featureName)
   For $i = 1 In $accountFiles[0]
	  Local $accountFile = $accountFiles[$i]
	  If $ignoreAccounts.Exists($accountFile) Then
		 ContinueLoop
	  EndIf
	  Local $accounts = ParseAccounts($accFile)
	  Local $accountsXml = GetAccountXml($accounts)
	  SettingAccountXml($accountsXml)
   Next

EndFunc

Func GetAccountXml($accounts)
   _FileCreate("Accounts.xml")
   Local $accountsXml = _PathFull("Accounts.xml")
   FileCopy($template, $accountsXml, 1)
   Local $count = 1
   For $item In $accounts
	  Local $accPattern = "{account" & $count & "}"
	  Local $charPattern = "{character" & $count & "}"
	  _ReplaceStringInFile($accountsXml, $accPattern, $item.Item("account"))
	  _ReplaceStringInFile($accountsXml, $charPattern, $item.Item("character"))
	  $count += 1
   Next
   Return $accountsXml
EndFunc

Func SettingAccountXml($accountsXml)
   Local $AutoHome = StringLeft($AUTO_PATH, StringInStr($AUTO_PATH, "\", 0, -1))
   Local $settingDir = $AutoHome & "Settings"
   Return FileMove($accountsXml, $settingDir, 1)
EndFunc


If $accountFiles <> "" And WinExists() Then
   While True
	  For $feature In $features

	  Next
   WEnd
EndIf


