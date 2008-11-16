#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mikaël

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include-once
#include <GUIConstants.au3>
#include <Misc.au3>

Global $ini_file = @ScriptDir&'\ReflexRenderer.ini'
Global $ini_file_session = 'Session'
Global $ini_file_default = 'Default'
Global $ini_file_windows = 'Windows'
Global Const $options_line_string = '@Options:'

Func LoadParameter($type, $name, $control, $default='')
  $w = IniRead($ini_file, $type, $name, $default)
  If $w <> '' Then GUICtrlSetData($control, $w)
EndFunc
Func LoadCheckBox($type, $name, $control, $default='')
  $w = IniRead($ini_file, $type, $name, $default)
  If $w <> '' Then GUICtrlSetState($control, _Iif($w=='TRUE', $GUI_CHECKED, $GUI_UNCHECKED))
EndFunc
Func SaveParameter($type, $name, $control)
  IniWrite($ini_file, $type, $name, GUICtrlRead($control))
EndFunc
Func SaveCheckBox($type, $name, $control)
  IniWrite($ini_file, $type, $name, _Iif(BitAnd(GUICtrlRead($control),$GUI_CHECKED), 'TRUE', 'FALSE'))
EndFunc

Func LoadSessionParameter($name, $control, $default)
  LoadParameter($ini_file_session, $name, $control, $default)
EndFunc
Func LoadDefaultParameter($name, $control)
  LoadParameter($ini_file_default, $name, $control)
EndFunc
Func LoadSessionCheckBox($name, $control, $default)
  LoadCheckBox($ini_file_session, $name, $control, $default)
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

Func LoadSaveboxParameter($name, $control, $default)
  LoadParameter('Savebox', $name, $control, $default)
EndFunc
Func LoadSaveboxCheckBox($name, $control, $default)
  LoadCheckBox('Savebox', $name, $control, $default)
EndFunc
Func SaveSaveboxParameter($name, $control)
  SaveParameter('Savebox', $name, $control)
EndFunc
Func SaveSaveboxCheckBox($name, $control)
  SaveCheckBox('Savebox', $name, $control)
EndFunc


Func IniReadSavebox($p1, $p2)
  Return IniRead($ini_file, 'Savebox', $p1, $p2)
EndFunc
Func IniReadSession($p1, $p2)
  Return IniRead($ini_file, 'Session', $p1, $p2)
EndFunc
Func IniWriteSavebox($p1, $p2)
  IniWrite($ini_file, 'Savebox', $p1, $p2)
EndFunc
Func isSavebox($parameter)
  Return IniReadSaveBox($parameter,'FALSE')=='TRUE'
EndFunc
