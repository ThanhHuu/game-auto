#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         thanhhuupq@gmail.com

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once
#RequireAdmin

#include <SQLite.au3>

Func CreateTable()
   _SQLite_Open()

   _SQLite_Close()
EndFunc

Func DisconnectDatabase($hdb)
   _SQLite_Close($hdb)
EndFunc