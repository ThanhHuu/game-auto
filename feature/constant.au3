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
Local $UI_FEATURE_NTD
Local $UI_ROW_HEIGHT = 20
Local $UI_MARGIN_LEFT = 20
Local $UI_MARGIN_TOP = 20
Local $MOVING_CHOICE_POPUP = [205, 138]
Local $HOME_POS_FIRST = [262, 246]
Local $HOME_POS_SECOND = [776, 446]
Local $HOME_POS_THIRD = [553, 628]
Local $HOME_ASSISTANT_POPUP = [260, 141]
Local $HOME_ASSISTANT_POS = [765, 370]
Local $PARAM_FEATURE_POS = "Feature_Pos"
Local $PARAM_FEATURE_LEVEL_POS = "Feature_Level_Pos"
Local $PARAM_LEVEL = "Level"
Local $BAG_POS = [796, 362]
