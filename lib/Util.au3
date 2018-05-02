#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#RequireAdmin
#include <MsgBoxConstants.au3>
#include <GuiListView.au3>
#include <Array.au3>

#cs
This function help to find button with provided text
$hwnd: Window (container) contain button
$text: Text value
return -1: not found
return - 2: disable control
return controlId
#ce
Func FindButtonWithText($hwnd, $text)
   Local $bwnd = "[CLASS:Button; TEXT:" & $text & "]"
   If ControlGetHandle($hwnd, "", $bwnd) <> 0 Then
	  If IsDisableControl($hwnd, $bwnd) Then
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
#ce
Func IsDisableControl($hwnd, $controlID)
   Local $count = 0;
   While $count < 600*1000
	  If ControlCommand($hwnd, "", $controlID, "IsEnabled", "") = 1 Then
		 Return False
	  EndIf
	  $count += 1000
	  Sleep(1000)
   WEnd
   Return True
EndFunc


#cs
Get controlId of combobox from array options
$hwnd: Container
$options: array options
return -1: not found
return -2: disable control
return controlId
#ce
Func FindComboboxContainOptions($hwnd, $options)
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
			If IsDisableControl($hwnd, $cwnd) Then
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
Function get list view has header at $headerPosition equal $headerText
$hwnd: container
$headerPosition: header position
$headerText: header text
return -1: not found
return -2: disable list view
return handler
#ce
Func FindListView($hwnd, $headerPosition, $headerText)
   Local $count = 0;
   While $count < 50
	  Local $lvWnd = ControlGetHandle($hwnd, "", "[CLASS:SysListView32;INSTANCE:" & $count & "]")
	  If $lvWnd <> 0 And ControlCommand($lvWnd, "", _GUICtrlListView_GetHeader($lvWnd), "IsVisible", "") <> 0 Then
		 If _GUICtrlListView_GetColumn ($lvWnd, $headerPosition)[5] == $headerText Then
			If IsDisableControl($hwnd, $lvWnd) Then
			   Return -2
			Else
			   Return $lvWnd
			EndIf
		 EndIf
	  EndIf
	  $count += 1
   WEnd
   Return -1
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
	  return -1
   EndIf
   _GUICtrlListView_ClickItem($lvWnd, $index, "left", 1)
   return 1
EndFunc


$winhandler = WinActivate("Auto Ngạo Kiếm Vô Song 2 - v1.0.5.3")

$ListView =  FindListView($winhandler, 1, "Tên nhân vật")
MsgBox($MB_SYSTEMMODAL, "", $ListView)

CheckItemInList($ListView, 0)
$count = _GUICtrlListView_GetHeader($ListView)

#cs

$count = _GUICtrlListView_ClickItem( $ListView, 1, "left", 1)

_GUICtrlListView_ClickItem( $ListView, 2, "left", 1)
_GUICtrlListView_ClickItem( $ListView, 3, "left", 1)
#ce