#RequireAdmin
#include "C:\Users\htra\Documents\nkvs2-script\lib\Interaction.au3"

Dim $appPath = "C:\Users\htra\Downloads\Auto Ngao Kiem Vo Song 2\AutoUpdate.exe"
Local $hwnUpdate = StartStep($appPath)
If $hwnUpdate = -1 Then
   ; Error start auto
   MsgBox(0,"","error start auto")
   Exit
EndIf
Sleep(1000)
Local $hwndLogin = UpdateStep($hwnUpdate, 300)
If $hwndLogin = -1 Then
   ; error can not update
   MsgBox(0,"","error can not update")
   Exit
EndIf
Local $hwndAuto = LoginStep($hwndLogin, 5)
If $hwndAuto = -1 Then
   ; error login account
   MsgBox(0,"","error login account")
   Exit
EndIf
Sleep(10000)
Local $loggedOn = LogOnGameStep($hwndAuto, 5)
If $loggedOn = -1 Or $loggedOn = 0 Then
   ; error dang nhap tat ca
   MsgBox(0,"","error dang nhap tat ca")
Else
   ; bat dau chay hoat dong
   Sleep(60000)
   For $i = 0 To 4 Step 1
	  ApplyToCharacter($hwndAuto, $i)
   Next

EndIf


