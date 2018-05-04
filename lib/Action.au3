#include <AutoItConstants.au3>
#include "C:\Users\htra\Documents\nkvs2-script\lib\Util.au3"
Opt("MouseCoordMode", 1)
#RequireAdmin

Local $CLICK = "click"
Local $DOUBLE_CLICK = "db-click"
Local $PRESS = "press"

Func Implement($steps)
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
	  Case Else
		 ; Don't support action
	  EndSwitch
   Next

EndFunc

#cs
Build steps for cau phuc feature
return array object format
{action, key, pause}
or {double-click, x, y, pause}
or {click, x, y, pause}
#ce
Func BuildMuaMau($gamePos)
   Local $basePos = StringSplit($gamePos, ",")
   If $basePos[0] <> 2 Then
	  ; wrong format
	  Return 0
   EndIf
   Local $x = $basePos[1]
   Local $y = $basePos[2]
   Local $steps[10]
   ; Step 0: click chu "Vo" tren UI
   Local $step0 = ObjCreate("Scripting.Dictionary")
   $step0.ADD("action", $CLICK)
   $step0.ADD("x", $x)
   $step0.ADD("y", $y)
   $step0.ADD("pause", 500)
   $steps[0] = $step0

   ; Step 1: press TAB
   Local $step1 = ObjCreate("Scripting.Dictionary")
   $step1.ADD("action", $PRESS)
   $step1.ADD("key", "{TAB}")
   $step1.ADD("pause", 500)
   $steps[1] = $step1

   ; Step 2: double-click tiem duoc tren ban do
   Local $step2 = ObjCreate("Scripting.Dictionary")
   $step2.ADD("action", $DOUBLE_CLICK)
   $step2.ADD("x", $x + 622)
   $step2.ADD("y", $y + 186)
   $step2.ADD("pause", 15000)
   $steps[2] = $step2

   ; Step 3: press TAB
   Local $step3 = ObjCreate("Scripting.Dictionary")
   $step3.ADD("action", $PRESS)
   $step3.ADD("key", "{TAB}")
   $step3.ADD("pause", 500)
   $steps[3] = $step3

   ; Step 4: click NPC
   Local $step4 = ObjCreate("Scripting.Dictionary")
   $step4.ADD("action", $CLICK)
   $step4.ADD("x", $x + 349)
   $step4.ADD("y", $y + 265)
   $step4.ADD("pause", 500)
   $steps[4] = $step4

   ; Step 5: click Tiem duoc
   Local $step5 = ObjCreate("Scripting.Dictionary")
   $step5.ADD("action", $CLICK)
   $step5.ADD("x", $x + 44)
   $step5.ADD("y", $y + 202)
   $step5.ADD("pause", 500)
   $steps[5] = $step5

   ; Step 6: click chon mau cap 80
   Local $step6 = ObjCreate("Scripting.Dictionary")
   $step6.ADD("action", $CLICK)
   $step6.ADD("x", $x + 127)
   $step6.ADD("y", $y + 191)
   $step6.ADD("pause", 500)
   $steps[6] = $step6

   ; Step 7: press so luong
   Local $step7 = ObjCreate("Scripting.Dictionary")
   $step7.ADD("action", $PRESS)
   $step7.ADD("key", "80")
   $step7.ADD("pause", 500)
   $steps[7] = $step7

   ; Step 8: click xac nhan
   Local $step8 = ObjCreate("Scripting.Dictionary")
   $step8.ADD("action", $CLICK)
   $step8.ADD("x", $x + 348)
   $step8.ADD("y", $y + 322)
   $step8.ADD("pause", 500)
   $steps[8] = $step8

   ; Step 9: press ESC
   Local $step9 = ObjCreate("Scripting.Dictionary")
   $step9.ADD("action", $PRESS)
   $step9.ADD("key", "{ESC}")
   $step9.ADD("pause", 200)
   $steps[9] = $step9

   return $steps
EndFunc

Func BuildCauPhucSteps($gamePos)
   Local $basePos = StringSplit($gamePos, ",")
   If $basePos[0] <> 2 Then
	  ; wrong format
	  Return 0
   EndIf
   Local $x = $basePos[1]
   Local $y = $basePos[2]
   Local $steps[10]
   ; Step 0: click chu "Vo" tren UI
   Local $step0 = ObjCreate("Scripting.Dictionary")
   $step0.ADD("action", $CLICK)
   $step0.ADD("x", $x)
   $step0.ADD("y", $y)
   $step0.ADD("pause", 500)
   $steps[0] = $step0

   ; Step 1: press j
   Local $step1 = ObjCreate("Scripting.Dictionary")
   $step1.ADD("action", $PRESS)
   $step1.ADD("key", "j")
   $step1.ADD("pause", 500)
   $steps[1] = $step1

   ; Step 2: click cau phuc
   Local $step2 = ObjCreate("Scripting.Dictionary")
   $step2.ADD("action", $CLICK)
   $step2.ADD("x", $x + 545)
   $step2.ADD("y", $y + 305)
   $step2.ADD("pause", 500)
   $steps[2] = $step2

   ; Step 3: double-click cau phuc 1
   Local $step3 = ObjCreate("Scripting.Dictionary")
   $step3.ADD("action", $DOUBLE_CLICK)
   $step3.ADD("x", $x + 275)
   $step3.ADD("y", $y + 275)
   $step3.ADD("pause", 6000)
   $steps[3] = $step3

   ; Step 4: double-click cau phuc 2
   Local $step4 = ObjCreate("Scripting.Dictionary")
   $step4.ADD("action", $DOUBLE_CLICK)
   $step4.ADD("x", $x + 275)
   $step4.ADD("y", $y + 275)
   $step4.ADD("pause", 6000)
   $steps[4] = $step4

   ; Step 5: double-click cau phuc 3
   Local $step5 = ObjCreate("Scripting.Dictionary")
   $step5.ADD("action", $DOUBLE_CLICK)
   $step5.ADD("x", $x + 275)
   $step5.ADD("y", $y + 275)
   $step5.ADD("pause", 6000)
   $steps[5] = $step5

   ; Step 6: double-click cau phuc 4
   Local $step6 = ObjCreate("Scripting.Dictionary")
   $step6.ADD("action", $DOUBLE_CLICK)
   $step6.ADD("x", $x + 275)
   $step6.ADD("y", $y + 275)
   $step6.ADD("pause", 6000)
   $steps[6] = $step6

   ; Step 7: double-click cau phuc 5
   Local $step7 = ObjCreate("Scripting.Dictionary")
   $step7.ADD("action", $DOUBLE_CLICK)
   $step7.ADD("x", $x + 275)
   $step7.ADD("y", $y + 275)
   $step7.ADD("pause", 6000)
   $steps[7] = $step7

   ; Step 8: click nhan
   Local $step8 = ObjCreate("Scripting.Dictionary")
   $step8.ADD("action", $CLICK)
   $step8.ADD("x", $x + 475)
   $step8.ADD("y", $y + 375)
   $step8.ADD("pause", 500)
   $steps[8] = $step8

   ; Step 9: press ESC
   Local $step9 = ObjCreate("Scripting.Dictionary")
   $step9.ADD("action", $PRESS)
   $step9.ADD("key", "{ESC}")
   $step9.ADD("pause", 200)
   $steps[9] = $step9

   return $steps
EndFunc

Local $steps = BuildMuaMau("300,70")
;For $step In $steps
 ;  MsgBox(0, "", $step.Item("x") & "-" & $step.item("y"))
;Next

Implement($steps)



