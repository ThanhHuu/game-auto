#RequireAdmin
#include-once
#include <MsgBoxConstants.au3>
#include <GuiListView.au3>
#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include <AutoItConstants.au3>
Opt("MouseCoordMode", 1)

Dim $LOG_LEVEL = "INFO"
Dim $LOG_FILE = "log"

#cs
This function help to find button with provided text
$hwnd: Window (container) contain button
$text: Text value
$waitingTime: wait in second
return -1: not found
return - 2: disable control
return controlId
#ce
Func FindButtonWithText($hwnd, $text, $waitingTime)
   Local $bwnd = "[CLASS:Button; TEXT:" & $text & "]"
   If ControlGetHandle($hwnd, "", $bwnd) <> 0 Then
	  If IsDisableControl($hwnd, $bwnd, $waitingTime) Then
		 Return -2
	  Else
		 Return $bwnd
	  EndIf
   EndIf
   Return -1
EndFunc

#cs
Function try click button in 10 second
$hwnd: container
$btControlId: button
return True: success
return False: failure
#ce
Func ClickButton($hwnd, $btControlId)
   Local $count = 0;
   While $count < 10
	  $count += 1
	  If ControlClick($hwnd, "", $btControlId) = 1 Then
		 Return True
	  EndIf
	  Sleep(1000)
   WEnd
   footLog("ERROR", StringFormat("Failure clicj %s", $btControlId))
   Return False
EndFunc


#cs
This function help to find button with provided text
$hwnd: Window (container) contain button
$order: instance number
$waitingTime: wait in second
return -1: not found
return - 2: disable control
return controlId
#ce
Func FindButtonWithInstance($hwnd, $order, $waitingTime)
   Local $bwnd = "[CLASS:Button; INSTANCE:" & $order & "]"
   If ControlGetHandle($hwnd, "", $bwnd) <> 0 Then
	  If IsDisableControl($hwnd, $bwnd, $waitingTime) Then
		 Return -2
	  Else
		 Return $bwnd
	  EndIf
   EndIf
   Return -1
EndFunc

#cs
This function help to check controlID is disable or not
$hwnd: Container
$controlID: ControlID
$waitingTime: waiting in seconds
#ce
Func IsDisableControl($hwnd, $controlID, $waitingTime)
   Local $count = 0;
   While $count < $waitingTime*1000
	  If ControlCommand($hwnd, "", $controlID, "IsEnabled", "") = 1 Then
		 Return False
	  EndIf
	  $count += 1
	  Sleep(1000)
   WEnd
   Return True
EndFunc


#cs
Get controlId of combobox from array options
$hwnd: Container
$options: array options
$waitingTime: wait in seconds
return -1: not found
return -2: disable control
return controlId
#ce
Func FindComboboxContainOptions($hwnd, $options, $waitingTime)
   Local $count = 0;
   While $count < 500
	  Local $cwnd = "[CLASS:ComboBox;INSTANCE:" & $count & "]"
	  If ControlGetHandle($hwnd, "", $cwnd) <> 0 Then
		 Local $findOut = True
		 Local $index = 0;
		 For $option in $options
			If $index <> ControlCommand($hwnd, "", $cwnd, "FindString", $option) Then
			   $findOut = False
			   ExitLoop
			EndIf
			$index += 1
		 Next
		 If $findOut Then
			If IsDisableControl($hwnd, $cwnd, $waitingTime) Then
			   Return -2
			Else
			   Return $cwnd
			EndIf
		 EndIf
	  EndIf
	  $count += 1;
   WEnd
   Return -1
EndFunc

#cs
Try select option for combobox in 10 seconds
$hwnd: container
$cbControlId: comboboxId
$option: expected option
return True if sucess and otherwise
#ce
Func SelectOption($hwnd, $cbControlId, $option)
   Local $count = 0;
   While $count < 10
	  $count += 1
	  ControlCommand($hwnd, "", $cbControlId, "SelectString", $option)
	  Local $currentSelection = ControlCommand($hwnd, "", $cbControlId, "GetCurrentSelection")
	  If $currentSelection == $option Then
		 Return True
	  EndIf
	  Sleep(1000)
   WEnd
   footLog("ERROR", StringFormat("Failure select %s for %s", $option,$cbControlId))
   Return False
EndFunc


#cs
Function help to left mouse click item in list view
$lvWnd: list view
$index: index need to left click
return -1: invalid index
return 1: clicked
#ce
Func CheckItemInList($lvWnd, $index)
   Local $total = _GUICtrlListView_GetItemCount ($lvWnd)
   If $index >= $total Then
	  footLog("DEBUG", StringFormat("%s - Num of character = %s", "CheckItemInList", $total))
	  return -1
   EndIf
   _GUICtrlListView_ClickItem($lvWnd, $index, "left")
   return 1
EndFunc

#cs
Function write log to file define at LOG_FILE
$logFile: absolute path to file Log
$level: log level need to log depend on LOG_LEVEL
   DEBUG > INFO > ERROR
#ce
Func footLog($level, $msg)
   Local $allowLog = False

   Switch $LOG_LEVEL
   Case "DEBUG"
	  If $level == "DEBUG" Or $level == "INFO" Or $level == "ERROR" Then
		 $allowLog = True
	  EndIf
   Case "INFO"
	  If $level == "INFO" Or $level == "ERROR" Then
		 $allowLog = True
	  EndIf
   Case "ERROR"
	  If $level == "ERROR" Then
		 $allowLog = True
	  EndIf
   EndSwitch
   If $allowLog Then
	  Local $logFileName = $LOG_FILE & "." & StringReplace(_NowCalcDate(), "/","-")
	  _FileWriteLog($logFileName, @TAB & $level & @TAB & $msg)
   EndIf
EndFunc

