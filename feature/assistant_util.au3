#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#RequireAdmin
#include "utils.au3"
#include "constant.au3"
#include <GUIConstantsEx.au3>

Func GoToHome($paramDic)
   If PressKeyWithinTimeOut($MOVING_CHOICE_POPUP, "{0}", 3000) Then
	  Local $lickPos = [160,325]
	  Return ClickChangeMapWithinTimeOut($HOME_POS_FIRST, $HOME_POS_SECOND, $HOME_POS_THIRD, $lickPos, 10000)
   EndIf
   Return False
EndFunc

;WinActivate("Ngạo Kiếm Vô Song II(TrangPhóDoiB Cụm 1 Kim Kiếm) Version: 0.127")
;AssistantAward("")
Func AssistantAward($paramDic)
   If ClickNpcWithinTimeOut($HOME_ASSISTANT_POPUP, $HOME_ASSISTANT_POS, 3000) Then
	  Local $closeAwardPopUp = [1002, 210]
	  Local $clickReceive = [469, 591]
	  If ClickNpcWithinTimeOut($closeAwardPopUp, $clickReceive, 3000) Then
		 Local $closeOffExp = [1002, 558]
		 ClickNpcWithinTimeOut($closeOffExp, $closeOffExp, 300)
		 Local $startReceive = [839, 540]
		 Local $px = PixelGetColor($closeAwardPopUp[0], $closeAwardPopUp[1])
		 ClickNpcWithinTimeOut($closeAwardPopUp, $startReceive, 300)
		 Local $count = 0
		 While $count < 8
			$count += 1
			If $px <> PixelGetColor($closeAwardPopUp[0], $closeAwardPopUp[1]) Then
			   ExitLoop
			EndIf
			Sleep(500)
		 WEnd
		 #cs
		 ClickNpcWithinTimeOut($startReceive, $startReceive, 500)
		 ClickNpcWithinTimeOut($startReceive, $startReceive, 500)
		 Sleep(8000)
		 ClickNpcWithinTimeOut($startReceive, $startReceive, 500)
		 #ce
		 ClickNpcWithinTimeOut($closeAwardPopUp, $closeAwardPopUp, 1000)
	  EndIf
   EndIf
   Send("{TAB}")
   Sleep(300)
   Send("{ESC}")
   Sleep(300)
   Return True
EndFunc

Func AssistantFeature($paramDic)
   Local $featurePos = $paramDic.Item($PARAM_FEATURE_POS)
   If ClickNpcWithinTimeOut($HOME_ASSISTANT_POPUP, $HOME_ASSISTANT_POS, 3000) Then
	  If ClickNpcWithinTimeOut($featurePos, $featurePos, 1000) Then
		 If $paramDic.Exists($PARAM_FEATURE_LEVEL_POS) Then
			Local $ChooseLevePopUp = [258, 140]
			Local $clickPos = [468, 594]
			If ClickNpcWithinTimeOut($ChooseLevePopUp, $clickPos, 1000) Then
			   Local $levelPos = $paramDic.Item($PARAM_FEATURE_LEVEL_POS)
			   ClickNpcWithinTimeOut($levelPos, $levelPos, 200)
			EndIf
		 Else
			Local $confirmPopUp = [577, 298]
			Local $clickPos = [468, 594]
			If ClickNpcWithinTimeOut($confirmPopUp, $clickPos, 1000) Then
			   Local $acceptPos = [511, 467]
			   ClickNpcWithinTimeOut($confirmPopUp, $acceptPos, 1000)
			EndIf
		 EndIf
	  EndIf
   EndIf
   Send("{TAB}")
   Sleep(200)
   Send("{ESC}")
   Return True
EndFunc

Func GetFeaturePos($paramDic)
   Local $level = $paramDic.Item($PARAM_LEVEL)
   Local $featurePos = [175, 295]
   If $level >= 100 Then
	  $featurePos[1] = 355
   ElseIf $level >= 80 Then
	  $featurePos[1] = 325
   EndIf
   Return $featurePos
EndFunc