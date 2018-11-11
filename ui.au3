#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         thanhhuupq@gmail.com

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once
#RequireAdmin

#include <GUIConstantsEx.au3>

Local $ROW_HEIGHT = 20
Local $MARGIN_TOP = 20
Local $MARGIN_LEFT = 20
Local $COLUMN_WIDTH = [100, 200, 100]
Local $SERVER_LIST = ["Thiên Vương", "Kim Kiếm", "Cái Bang"]

Func CreateUi()
   Local $ui = GUICreate("Ho tro", 460, 260);
   Local $row = 1
   CreateElement("Label", "Tài khoản", $row, 1)
   CreateElement("Input", "", $row, 2)
   CreateElement("Button", "Chọn", $row, 3, 50)

   $row += 1
   CreateElement("Label", "Máy chủ", $row, 1, 50)
   Local $cbServer = CreateElement("Combobox", "", $row, 2, 100)
   Local $server = ""
   For $i = 0 To UBound($SERVER_LIST) - 2
	  $server &= $SERVER_LIST[$i] & "|"
   Next
   $server &= $SERVER_LIST[$i]
   GUICtrlSetData($cbServer, $server, $SERVER_LIST[0])

   $row += 1
   CreateElement("Label", "Số cửa sổ", $row, 1, 50)
   Local $cbNumGame = CreateElement("Combobox", "", $row, 2, 100)
   GUICtrlSetData($cbNumGame, "1|2|3|4|5", 1)

   $row += 1
   CreateElement("Label", "Ẩn cửa sổ", $row, 1, 80)
   CreateElement("Checkbox", "", $row, 2, 80)

   $row += 1
   CreateElement("Label", "Thời gian", $row, 1, 80)
   Local $cbTime = CreateElement("Combobox", "", $row, 2, 100)
   GUICtrlSetData($cbTime, "1|5|10|15|20|25|30|35|40", 10)

   $row += 1
   CreateElement("Button", "Bắt đầu", $row, 1, 50)

   Return $ui
EndFunc

Func CreateElement($type, $text, $row, $col, $width = -1, $height = $ROW_HEIGHT)
   Local $left = $MARGIN_LEFT
   For $i = 1 To $col - 1
	  $left += $MARGIN_LEFT
	  $left += $COLUMN_WIDTH[$i - 1]
   Next
   Local $top = ($ROW_HEIGHT + $MARGIN_TOP) * ($row - 1) + $MARGIN_TOP
   Switch $type
   Case "Label"
	  Return GUICtrlCreateLabel($text, $left, $top + 3, $width = -1 ? $COLUMN_WIDTH[$col - 1] : $width, $height)
   Case "Input"
	  Return GUICtrlCreateInput($text, $left, $top, $width = -1 ? $COLUMN_WIDTH[$col - 1] : $width, $height)
   Case "Button"
	  Return GUICtrlCreateButton($text, $left, $top, $width = -1 ? $COLUMN_WIDTH[$col - 1] : $width, $height)
   Case "Combobox"
	  Return GUICtrlCreateCombo($text, $left, $top, $width = -1 ? $COLUMN_WIDTH[$col - 1] : $width, $height)
   Case "Checkbox"
	  Return GUICtrlCreateCheckbox($text, $left, $top, $width = -1 ? $COLUMN_WIDTH[$col - 1] : $width, $height)
   EndSwitch
EndFunc