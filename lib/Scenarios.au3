#include-once
#RequireAdmin
#include "Util.au3"
#include "Interaction.au3"
#include "Initialization.au3"
#include "Action.au3"

Dim $APP_PATH = "C:\Users\htra\Downloads\Auto Ngao Kiem Vo Song 2\AutoUpdate.exe"

#cs
return 0: fail
return 1: success
Prepare account and start auto
#ce

Func FirstScenario($template, $accounts)
   CleanUpError()
   If FileExists($template) = 0 Or FileExists($template) = 0 Then
	  ; Missing param
	  Return 0
   EndIf
   ; Generate file
   Local $accountsFile = CreateAccountsFile($template, $accounts)
   If $accountsFile = -1 Then
	  ; Error generate file accounts
	  Return 0
   EndIf
   Local $next = PrepareAccountStep($APP_PATH, $accountsFile)
   If $next <> 1 Then
	  ; Error step move file to setting auto
	  Return 0
   EndIf
   ; Start Auto
   Return 1
EndFunc

#cs
Update and login
Return window auto
#ce
Func SecondScenario($pause)
   Local $hwnUpdate = StartStep($APP_PATH)
   If $hwnUpdate = -1 Then
	  ; Error start auto
	  Return -1
   EndIf
   Sleep(1000)
   Local $hwndLogin = UpdateStep($hwnUpdate, 300)
   If $hwndLogin = -1 Then
	  ; error can not update
	  Return -1
   EndIf
   Local $hwndAuto = LoginStep($hwndLogin, 5)
   If $hwndAuto = -1 Then
	  ; error login account
	  Return -1
   EndIf
   Sleep($pause*1000)
   Return $hwndAuto
EndFunc

#cs
Logon game and check all character
$pause: wait logon all character
#ce
Func ThirdScenario($hwndAuto, $pause)
   Local $loggedOn = LogOnGameStep($hwndAuto, 5)
   If $loggedOn = -1 Then
	  ; error dang nhap tat ca
	  footLog("ERROR", StringFormat("%s - Can not logon game", "ThirdScenario") )
	  Return -1
   Else
	  ; bat dau chay hoat dong
	  ApplyToAllCharacter($hwndAuto)
	  Sleep($pause*1000)
	  Return 1
   EndIf
EndFunc

#cs
logout and stop auto
#ce
Func FinalScenario($hwndAuto)
   LogOutGameStep($hwndAuto, 5)
   StopAutoStep($hwndAuto, 5)
EndFunc



