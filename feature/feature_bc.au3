#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include-once
#RequireAdmin
#include "utils.au3"
#include "constant.au3"
#include <GUIConstantsEx.au3>
#include "assistant_util.au3"

Opt("WinTitleMatchMode", 4)
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

Func BuildBcUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Bi Canh", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 30
   $UI_FEATURE_BC = GUICtrlCreateCheckbox("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)

   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT + 30
   $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Cap Do", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)

   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 40
   $UI_FEATURE_BC_LEVEL = GUICtrlCreateCombo("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetData($UI_FEATURE_BC_LEVEL, "60|80|100", "80")

   $width = 30
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $UI_FEATURE_BC_NO = GUICtrlCreateCombo("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
   GUICtrlSetData($UI_FEATURE_BC_NO, "1|2", "2")
EndFunc


;WinActivate($WINDOW_NKVS)
;Local $pramTest = ObjCreate("Scripting.Dictionary")
;$pramTest.Add($PARAM_LEVEL, 60)
;RunTvp($pramTest)
Func RunBc($paramDic)
   If $paramDic.Item($PARAM_FEATURE_NAME) = $RUNTIME_FEATURE_BC And GUICtrlRead($UI_FEATURE_BC) = $GUI_CHECKED Then
	  WriteLog("feature_bc", "Run BC")
	  Local $featurePos = [370, 375]
	  Local $featureLevelPos = GetFeaturePos($paramDic)
	  $paramDic.Add($PARAM_FEATURE_POS, $featurePos)
	  $paramDic.Add($PARAM_FEATURE_LEVEL_POS, $featureLevelPos)
	  Local $chainDic = ObjCreate("Scripting.Dictionary")
	  $chainDic.Add("GoToHome", $paramDic)
	  $chainDic.Add("AssistantAward", $paramDic)
	  $chainDic.Add("AssistantFeature", $paramDic)
	  If Not ExecuteChain($chainDic) Then
		 WriteLog("feature_bc", "Fail BC")
	  EndIf
   EndIf
   Return True
EndFunc
