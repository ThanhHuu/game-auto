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

Func BuildNtdUI($row, $column)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * ($row - 1) + $UI_MARGIN_TOP
   Local $marginLeft = ($column - 1) * $UI_COLUMN_WIDTH + $UI_MARGIN_LEFT
   Local $width = $UI_LABEL_WIDTH
   GUICtrlCreateLabel("Ngu Truc Dam", $marginLeft, $marginTop + 3, $width, $UI_ROW_HEIGHT)
   $marginLeft = $marginLeft + $width + $UI_MARGIN_LEFT
   $width = 30
   $UI_FEATURE_NTD = GUICtrlCreateCheckbox("", $marginLeft, $marginTop, $width, $UI_ROW_HEIGHT)
EndFunc

Func IsEnableNtd()
   Return GUICtrlRead($UI_FEATURE_NTD) = $GUI_UNCHECKED
EndFunc

;WinActivate($WINDOW_NKVS)
;Local $pramTest = ObjCreate("Scripting.Dictionary")
;RunTvp($pramTest)
Func RunNtd($paramDic)
   Local $featurePos = [365, 435]
   $paramDic.Add($PARAM_FEATURE_POS, $featurePos)
   Local $chainDic = ObjCreate("Scripting.Dictionary")
   $chainDic.Add("GoToHome", $paramDic)
   $chainDic.Add("AssistantAward", $paramDic)
   $chainDic.Add("AssistantFeature", $paramDic)
   Return ExecuteChain($chainDic)
EndFunc
