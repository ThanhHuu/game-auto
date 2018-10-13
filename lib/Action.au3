#include <AutoItConstants.au3>
#include "Util.au3"
#include-once
Opt("MouseCoordMode", 1)
#RequireAdmin

Local $CLICK = "click"
Local $RIGHT_CLICK = "right-click"
Local $DOUBLE_CLICK = "double-click"
Local $PRESS = "press"
Local $CALL = "call"
Local $DRAG = "drag"

Func ImplementAction($steps)
   For $step In $steps
	  Local $action = $step.Item("action")
	  Switch $action
	  Case $PRESS
		 Local $key = $step.Item("key")
		 Local $pause = $step.Item("pause")
		 Send($key)
		 Sleep($pause)
	  Case $DOUBLE_CLICK
		 Local $x = $step.Item("x")
		 Local $y = $step.Item("y")
		 MouseClick($MOUSE_CLICK_LEFT, $x, $y, 2)
		 Local $pause = $step.Item("pause")
		 Sleep($pause)
	  Case $CLICK
		 Local $x = $step.Item("x")
		 Local $y = $step.Item("y")
		 MouseClick($MOUSE_CLICK_LEFT, $x, $y)
		 Local $pause = $step.Item("pause")
		 Sleep($pause)
	  Case $RIGHT_CLICK
		 Local $x = $step.Item("x")
		 Local $y = $step.Item("y")
		 MouseClick($MOUSE_CLICK_RIGHT, $x, $y)
		 Local $pause = $step.Item("pause")
		 Sleep($pause)
	  Case $CALL
		 Local $funcName = $step.Item("func")
		 Local $hwnd = $step.Item("hwnd")
		 Call($funcName, $hwnd)
		 Local $pause = $step.Item("pause")
		 Sleep($pause)
	  Case $DRAG
		 Local $x = $step.Item("x")
		 Local $y = $step.Item("y")
		 Local $z = $step.Item("z")
		 MouseClickDrag("left",$x,$y,$z,$y)
		 Local $pause = $step.Item("pause")
		 Sleep($pause)
	  Case Else
		 ; Don't support action
	  EndSwitch
   Next
EndFunc

#cs
$stepInfo: action=click; x=305; y=73; pause=500
#ce
Func ParseStep($stepInfo)
   Local $infos = StringSplit($stepInfo, ";")
   If $infos[0] < 3 Then
	  footLog("DEBUG", StringFormat("%s - stepInfo %s wrong format", "ParseStep", $stepInfo))
	  Return -1
   EndIf
   Local $step = ObjCreate("Scripting.Dictionary")
   For $i = 1 To $infos[0]
	  Local $info = StringSplit($infos[$i], "=")
	  If $info[0] <> 2 Then
		 footLog("DEBUG", StringFormat("%s - info %s wrong format", "ParseStep", $info))
		 Return -1
	  EndIf
	  $step.ADD($info[1], $info[2])
   Next
   Return $step
EndFunc


Func BuildActionSteps($scenario)
   If FileExists($scenario) = 0 Then
	  footLog("DEBUG", StringFormat("%s - Not found %s", "BuildScenarioSteps", $scenario))
	  Return -1
   EndIf
   Local $steps = ObjCreate("Scripting.Dictionary")
   Local $opened = FileOpen($scenario)
   Local $line = 0
   While True
	  $line += 1
	  Local $stepInfo = FileReadLine($opened, $line)
	  If @error <> 0 Then
		 ExitLoop
	  EndIf
	  Local $step = ParseStep($stepInfo)
	  $steps.Add($line, $step)
   WEnd
   FileClose($opened)
   return $steps.Items
EndFunc



