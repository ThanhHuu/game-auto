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

Func AssistantAward($paramDic)
   If ClickNpcWithinTimeOut($HOME_ASSISTANT_POPUP, $HOME_ASSISTANT_POS, 3000) Then
	  Local $awardPopUp = [938, 435]
	  Local $clickPos = [469, 591]
	  If ClickNpcWithinTimeOut($awardPopUp, $clickPos, 3000) Then
		 Local $awardItemsWinPos = [1001, 212]
		 $clickPos[0] = 858
		 $clickPos[1] = 530
		 If ClickNpcWithinTimeOut($awardItemsWinPos, $clickPos, 3000) Then
			If ClickNpcWithinTimeOut($clickPos, $clickPos, 1000) Then
			   If ClickNpcWithinTimeOut($clickPos, $clickPos, 1000) Then
				  Sleep(8000)
				  MouseClick($MOUSE_CLICK_LEFT, $clickPos[0], $clickPos[1])
			   EndIf
			   ClickNpcWithinTimeOut($awardItemsWinPos, $awardItemsWinPos, 500)
			EndIf
		 EndIf
	  EndIf
   EndIf
   Send("{TAB}")
   Sleep(200)
   Send("{ESC}")
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