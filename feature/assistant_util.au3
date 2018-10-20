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
   Local $hwnd = GetWintitle($paramDic.Item($PARAM_CHAR))
   If ActiveWindow($hwnd, 3000) Then
	  If PressKey($MOVING_CHOICE_POPUP, "{0}", 3000) Then
		 Local $coord = [160,325]
		 If LeftClick($coord, $coord, 1000) Then
			Return WaitChangeMap($hwnd, 30000, 5000)
		 EndIf
	  EndIf
   EndIf
   Return False
EndFunc

Func AssistantAward($paramDic)
   If LeftClick($HOME_ASSISTANT_POPUP, $HOME_ASSISTANT_POS, 3000) Then
	  Local $closeAwardPopUp = [1002, 210]
	  Local $clickReceive = [469, 591]
	  If LeftClick($closeAwardPopUp, $clickReceive, 3000) Then
		 Local $closeOffExp = [1002, 558]
		 LeftClick($closeOffExp, $closeOffExp, 300)
		 Local $startReceive = [839, 540]
		 Local $px = PixelGetColor($closeAwardPopUp[0], $closeAwardPopUp[1])
		 LeftClick($closeAwardPopUp, $startReceive, 300)
		 Local $count = 0
		 While $count < 8
			$count += 1
			If $px <> PixelGetColor($closeAwardPopUp[0], $closeAwardPopUp[1]) Then
			   ExitLoop
			EndIf
			Sleep(500)
		 WEnd
		 #cs
		 LeftClick($startReceive, $startReceive, 500)
		 LeftClick($startReceive, $startReceive, 500)
		 Sleep(8000)
		 LeftClick($startReceive, $startReceive, 500)
		 #ce
		 LeftClick($closeAwardPopUp, $closeAwardPopUp, 1000)
	  EndIf
   EndIf
   PressKey($HOME_ASSISTANT_POPUP, "{ESC}", 3000)
   Return True
EndFunc

Func AssistantFeature($paramDic)
   Local $featurePos = $paramDic.Item($PARAM_FEATURE_POS)
   If LeftClick($HOME_ASSISTANT_POPUP, $HOME_ASSISTANT_POS, 3000) Then
	  If LeftClick($featurePos, $featurePos, 1000) Then
		 If $paramDic.Exists($PARAM_FEATURE_LEVEL_POS) Then
			Local $ChooseLevePopUp = [258, 140]
			Local $clickPos = [468, 594]
			If LeftClick($ChooseLevePopUp, $clickPos, 1000) Then
			   Local $levelPos = $paramDic.Item($PARAM_FEATURE_LEVEL_POS)
			   LeftClick($levelPos, $levelPos, 200)
			EndIf
		 Else
			Local $confirmPopUp = [577, 298]
			Local $clickPos = [468, 594]
			If LeftClick($confirmPopUp, $clickPos, 1000) Then
			   Local $acceptPos = [511, 467]
			   LeftClick($confirmPopUp, $acceptPos, 1000)
			EndIf
		 EndIf
	  EndIf
   EndIf
   PressKey($HOME_ASSISTANT_POPUP, "{ESC}", 3000)
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