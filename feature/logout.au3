#cs ----------------------------------------------------------------------------

AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#RequireAdmin
#include <Date.au3>
#include <File.au3>
Opt("MouseCoordMode", 2)
Opt("WinTitleMatchMode", 4)
Opt("PixelCoordMode", 2)
DllCall("User32.dll","bool","SetProcessDPIAware")

Local $LOG_FILE = StringReplace(_NowCalcDate(), "/","-") & "." & "log"
Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Local $WINDOW_GAME = "[REGEXPTITLE:Ngạo Kiếm Vô Song II]"

Func Logout($currentY)
   If WinExists($WINDOW_LOGIN) Then
	  If Not WinActive($WINDOW_LOGIN) Then
		 WinActivate($WINDOW_LOGIN)
		 Sleep(500)
	  EndIf
	  If WinActive($WINDOW_LOGIN) Then
		 If WinExists("Thông báo") Then
			ControlClick("Thông báo", "", "CLASS:Button;INSTANCE:1")
		 EndIf
		 Local $maxLoop = 5

		 ; Click thoat game
		 Local $basePx = PixelGetColor(50, $currentY + 15)
		 Local $count = 0
		 While $count < $maxLoop
			MouseClick($MOUSE_CLICK_RIGHT , 14, $currentY)
			Sleep(100)
			$count += 1
			If $basePx <> PixelGetColor(50, $currentY + 15) Then
			   ExitLoop
			EndIf
		 WEnd
		 Sleep(300)
		 $count = 0
		 While $count < $maxLoop
			MouseClick($MOUSE_CLICK_LEFT, 50, $currentY + 15)
			Sleep(100)
			$count += 1
			If $basePx <> PixelGetColor(50, $currentY + 15) Then
			   ExitLoop
			EndIf
		 WEnd
		 ProcessClose("ClientX86.exe")
		 Sleep(500)

		 ; click xoa khoi danh sach
		 $basePx = PixelGetColor(50, $currentY + 60)
		 $count = 0
		 While $count < $maxLoop
			MouseClick($MOUSE_CLICK_RIGHT , 14, $currentY)
			Sleep(100)
			$count += 1
			If $basePx <> PixelGetColor(50, $currentY + 60) Then
			   ExitLoop
			EndIf
		 WEnd
		 Sleep(300)
		 $count = 0
		 While $count < $maxLoop
			MouseClick($MOUSE_CLICK_LEFT, 50, $currentY + 60)
			Sleep(100)
			$count += 1
			If WinExists("[TITLE:Xác nhận;CLASS:#32770]") Then
			   ExitLoop
			EndIf
		 WEnd
		 ControlClick("[TITLE:Xác nhận;CLASS:#32770]","", "[CLASS:Button;INSTANCE:1]")
	  Else
		 Local $msg = StringFormat("%s - %s", "login", "Can not active window game")
		 _FileWriteLog($LOG_FILE, $msg)
	  EndIf
   Else
	  Local $msg = StringFormat("%s - %s", "login", "Not found window game")
		 _FileWriteLog($LOG_FILE, $msg)
   EndIf
EndFunc