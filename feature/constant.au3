#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once
; Script Start - Add your code below here
Local $WINDOW_LOGIN = "[REGEXPTITLE:Auto Ngạo Kiếm Vô Song 2]"
Local $BUTTON_ADD = [260, 220]
Local $BUTTON_EDIT = [260, 265]
Local $WINDOW_NKVS = "[REGEXPTITLE:Ngạo Kiếm Vô Song II.*]"
Local $FIRST_CHARACTER = [14, 35]
Local $BUTTON_SYSTEM = [1004, 733]
Local $BUTTON_SYSTEM_SETUP = [506, 316]
Local $BUTTON_SYSTEM_RELOGIN = [506, 380]
Local $BUTTON_SYSTEM_EXIT = [506, 417]
Local $BUTTON_SYSTEM_EXIT_YES = [602, 575]
Local $BUTTON_SYSTEM_EXIT_NO = [710, 575]
Local $UI_FEATURE_TVP
Local $UI_FEATURE_EVENT
Local $UI_FEATURE_BC
Local $UI_FEATURE_BC_LEVEL
Local $UI_FEATURE_NTD
Local $UI_ROW_HEIGHT = 20
Local $UI_MARGIN_LEFT = 20
Local $UI_MARGIN_TOP = 10
Local $UI_BUTTON_ADD_ACCOUNT
Local $UI_INPUT_ACCOUNTS
Local $UI_LABEL_WIDTH = 100
Local $UI_COLUMN_WIDTH = 200
Local $UI_FEATURE_OPEN_CARD
Local $UI_FEATURE_ONLINE_EX
Local $UI_FEATURE_HIDE_GRAPHIC
Local $UI_FEATURE_LUCKY_ROUND
Local $UI_FEATURE_USE_ITEM
Local $UI_DEBUG_MODE

Local $MOVING_CHOICE_POPUP = [205, 138]
Local $HOME_POS_FIRST = [262, 246]
Local $HOME_POS_SECOND = [776, 446]
Local $HOME_POS_THIRD = [553, 628]
Local $HOME_ASSISTANT_POPUP = [260, 141]
Local $HOME_ASSISTANT_POS = [765, 370]
Local $PARAM_FEATURE_POS = "Feature_Pos"
Local $PARAM_FEATURE_LEVEL_POS = "Feature_Level_Pos"
Local $PARAM_LEVEL = "Level"
Local $PARAM_USR = "Usr"
Local $PARAM_PWD = "Pwd"
Local $PARAM_CHAR = "Character"
Local $PARAM_FEATURE_NAME = "Feature_Name"
Local $BAG_POS = [796, 362]

Local $RUNTIME_IGNORE_DIC
Local $RUNTIME_FEATURE_TVP = "TVP"
Local $RUNTIME_FEATURE_NTD = "NTD"
Local $RUNTIME_FEATURE_BC = "BC"
Local $RUNTIME_FEATURES = [$RUNTIME_FEATURE_TVP, $RUNTIME_FEATURE_NTD, $RUNTIME_FEATURE_BC]
Local $RUNTIME_ACCOUNTS
Local $RUNTIME_FEATURE_ALLOW_FAIL = ObjCreate("Scripting.Dictionary")