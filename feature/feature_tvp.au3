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

Func BuildTVPUI($row)
   Local $marginTop = ($UI_ROW_HEIGHT + $UI_MARGIN_TOP) * $row
   $FEATURE_TVP = GUICtrlCreateCheckbox("Enable", $UI_MARGIN_LEFT, $marginTop, $UI_ROW_HEIGHT)
EndFunc

Func IsEnableTvp()
   Return GUICtrlRead($FEATURE_TVP) = $GUI_UNCHECKED
EndFunc

WinActivate($WINDOW_NKVS)
Local $pramTest = ObjCreate("Scripting.Dictionary")
$pramTest.Add($PARAM_LEVEL, 100)
RunTvp($pramTest)
Func RunTvp($paramDic)
   Local $featurePos = GetFeaturePos($paramDic)
   $paramDic.Add($PARAM_FEATURE_POS, $featurePos)
   Local $chainDic = ObjCreate("Scripting.Dictionary")
   $chainDic.Add("GoToHome", $paramDic)
   $chainDic.Add("AssistantAward", $paramDic)
   $chainDic.Add("AssistantFeature", $paramDic)
   Return ExecuteChain($chainDic)
EndFunc