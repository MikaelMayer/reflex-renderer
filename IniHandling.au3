#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mika�l

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once

Global $ini_file = @ScriptDir&'\ReflexRenderer.ini'
Global $ini_file_session = 'Session'
Global $ini_file_default = 'Default'
Global Const $options_line_string = "@Options:"

Func LoadParameter($type, $name, $control)
  $w = IniRead($ini_file, $type, $name, '')
  If $w <> '' Then GUICtrlSetData($control, $w)
EndFunc
Func LoadCheckBox($type, $name, $control)
  $w = IniRead($ini_file, $type, $name, '')
  If $w <> '' Then GUICtrlSetState($control, _Iif($w=='TRUE', $GUI_CHECKED, $GUI_UNCHECKED))
EndFunc
Func SaveParameter($type, $name, $control)
  IniWrite($ini_file, $type, $name, GUICtrlRead($control))
EndFunc
Func SaveCheckBox($type, $name, $control)
  IniWrite($ini_file, $type, $name, _Iif(BitAnd(GUICtrlRead($control),$GUI_CHECKED), 'TRUE', 'FALSE'))
EndFunc

Func LoadSessionParameter($name, $control)
  LoadParameter($ini_file_session, $name, $control)
EndFunc
Func LoadDefaultParameter($name, $control)
  LoadParameter($ini_file_default, $name, $control)
EndFunc
Func LoadSessionCheckBox($name, $control)
  LoadCheckBox($ini_file_session, $name, $control)
EndFunc
Func LoadDefaultCheckBox($name, $control)
  LoadCheckBox($ini_file_default, $name, $control)
EndFunc

Func SaveSessionParameter($name, $control)
  SaveParameter($ini_file_session, $name, $control)
EndFunc
Func SaveDefaultParameter($name, $control)
  SaveParameter($ini_file_default, $name, $control)
EndFunc
Func SaveSessionCheckBox($name, $control)
  SaveCheckBox($ini_file_session, $name, $control)
EndFunc
Func SaveDefaultCheckBox($name, $control)
  SaveCheckBox($ini_file_default, $name, $control)
EndFunc

Func LoadSaveboxParameter($name, $control)
  LoadParameter('Savebox', $name, $control)
EndFunc
Func LoadSaveboxCheckBox($name, $control)
  LoadCheckBox('Savebox', $name, $control)
EndFunc
Func SaveSaveboxParameter($name, $control)
  SaveParameter('Savebox', $name, $control)
EndFunc
Func SaveSaveboxCheckBox($name, $control)
  SaveCheckBox('Savebox', $name, $control)
EndFunc