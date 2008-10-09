#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mikaël Mayer
 Date:           2008/07/02

 Script Function:
  Opens a Save Box to save Formula and/or Reflex.

#ce ----------------------------------------------------------------------------
;testIncrementName()

#include <GUIConstants.au3>
#Include <GDIPlus.au3>

Func LoadSavebox($saveboxParametersMap, $saveboxCheckBoxMap)
  for $singlemap in $saveboxParametersMap
    LoadSaveboxParameter($singlemap[0], $singlemap[1], $singlemap[2])
  Next
  for $singlemap in $saveboxCheckBoxMap
    LoadSaveboxCheckBox($singlemap[0], $singlemap[1], $singlemap[2])
  Next
EndFunc

Func SaveSavebox($saveboxParametersMap, $saveboxCheckBoxMap)
  for $singlemap in $saveboxParametersMap
    SaveSaveboxParameter($singlemap[0], $singlemap[1])
  Next
  for $singlemap in $saveboxCheckBoxMap
    SaveSaveboxCheckBox($singlemap[0], $singlemap[1])
  Next
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

Func savebox()
  Opt('GUIOnEventMode', 0)

  #Region ### START Koda GUI section ### Form=C:\Documents and Settings\Mikaël\Mes documents\Reflex\LogicielOrdi\RenderReflex\ReflexRendererSaveBox.kxf
  Global $sb_savebox = GUICreate($__save_reflex_and_or_formula__, 283, 381, 302, 229)
  Global $sb_saving_parameters = GUICtrlCreateGroup($__saving_parameters__, 9, 5, 153, 86)
  Global $sb_save_fr = GUICtrlCreateRadio($__save_formula_reflex__, 20, 24, 136, 17)
  GUICtrlSetState($sb_save_fr, $GUI_CHECKED)
  Global $sb_save_f = GUICtrlCreateRadio($__save_only_formula__, 20, 45, 136, 17)
  Global $sb_save_r = GUICtrlCreateRadio($__save_only_reflex__, 20, 67, 136, 17)
  GUICtrlCreateGroup("", -99, -99, 1, 1)
  Global $sb_save_button = GUICtrlCreateButton($__save_button__, 169, 13, 105, 25, 0)
  GUICtrlSetTip($sb_save_button, $__hint_save_all_button__)
  Global $sb_cancel_button = GUICtrlCreateButton($__cancel_button__, 169, 64, 105, 25, 0)
  Global $sb_save_formula = GUICtrlCreateGroup($__save_formula_group__, 9, 93, 265, 131)
  Global $sb_formula_comment = GUICtrlCreateInput($__my_nice_function__, 82, 111, 185, 21)
  Global $sb_save_comment = GUICtrlCreateCheckbox($__save_comment__, 18, 154, 121, 17)
  GUICtrlSetState($sb_save_comment, $GUI_CHECKED)
  Global $sb_formula_filename = GUICtrlCreateInput("c:\Images\fileFormula.txt", 16, 195, 217, 21)
  Global $sb_open_formula_file = GUICtrlCreateButton("...", 239, 196, 28, 20, 0)
  Global $sb_LabelFormulaFileName = GUICtrlCreateLabel($__formula_file_name__, 17, 178, 129, 17)
  Global $sb_LabelFormulaComment = GUICtrlCreateLabel($__comment__, 16, 113, 64, 17, $SS_RIGHT)
  Global $sb_save_window = GUICtrlCreateCheckbox($__save_window__, 146, 135, 113, 17)
  GUICtrlSetState($sb_save_window, $GUI_CHECKED)
  Global $sb_save_resolution = GUICtrlCreateCheckbox($__save_resolution__, 146, 154, 117, 17)
  GUICtrlSetState($sb_save_resolution, $GUI_CHECKED)
  Global $sb_Label1 = GUICtrlCreateLabel($__save_with__, 20, 136, 92, 17)
  GUICtrlCreateGroup("", -99, -99, 1, 1)
  Global $sb_save_reflex = GUICtrlCreateGroup($__save_reflex_group__, 9, 226, 265, 145)
  Global $sb_save_highres_reflex = GUICtrlCreateRadio($__high_resolution_reflex__, 19, 244, 193, 17)
  GUICtrlSetState($sb_save_highres_reflex, $GUI_CHECKED)
  Global $sb_save_last_reflex = GUICtrlCreateRadio($__copy_last_reflex__, 19, 261, 193, 17)
  Global $sb_save_lowres_reflex = GUICtrlCreateRadio($__low_resolution_reflex__, 19, 279, 193, 17)
  Global $sb_LabelReflexFileName = GUICtrlCreateLabel($__reflex_file_name__, 22, 304, 120, 17)
  Global $sb_reflex_extension = GUICtrlCreateCombo("Jpeg (*.jpg)", 167, 298, 97, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
  GUICtrlSetData($sb_reflex_extension, "PNG (*.png)|Bitmap (*.bmp)")
  Global $sb_reflex_filename = GUICtrlCreateInput("c:\Images\My nice function.jpg", 19, 321, 217, 21)
  GUICtrlSetState($sb_reflex_filename, $GUI_DISABLE)
  Global $sb_new_reflex_filename = GUICtrlCreateButton("...", 238, 321, 28, 20, 0)
  Global $sb_use_formula_comment = GUICtrlCreateCheckbox($__use_formula_comment__, 19, 347, 249, 17)
  GUICtrlSetState($sb_use_formula_comment, $GUI_CHECKED)
  GUICtrlSetTip($sb_use_formula_comment, $__hint_use_formula_comment__)
  GUICtrlCreateGroup("", -99, -99, 1, 1)
  Global $sb_save_settings = GUICtrlCreateButton($__just_save_settings__, 169, 39, 105, 25, 0)
  GUICtrlSetTip($sb_save_settings, $__hint_save_options_button__)
  #EndRegion ### END Koda GUI section ###
  
  ;#include "SaveBox_lang.au3"
  ;$sb_formula_comment, _
  ;$sb_LabelFormulaComment _
  Global $formula_group_controls = _ArrayCreate( _
    $sb_formula_filename, _
    $sb_open_formula_file, _
    $sb_LabelFormulaFileName _
  )
  Global $reflex_group_controls = _ArrayCreate( _
    $sb_save_highres_reflex, _
    $sb_save_last_reflex, _
	$sb_save_lowres_reflex, _
    $sb_LabelReflexFileName, _
    $sb_reflex_extension, _
    $sb_reflex_filename, _
    $sb_new_reflex_filename, _
    $sb_use_formula_comment _
  )
  
  Global $saveboxParametersMap = _ArrayCreate( _
   _ArrayCreate('formulaComment', $sb_formula_comment, 'My nice function'), _
   _ArrayCreate('formulaFile', $sb_formula_filename, '%MY_DOCUMENTS%\Reflex\formulas.txt'), _
   _ArrayCreate('Extension', $sb_reflex_extension, 'Jpeg (*.jpg)'), _
   _ArrayCreate('reflexFile', $sb_reflex_filename, '%MY_DOCUMENTS%\Reflex\My nice function.jpg') _
  )

  Global $saveboxCheckBoxMap = _ArrayCreate( _
   _ArrayCreate('saveBoth', $sb_save_fr, 'TRUE'), _
   _ArrayCreate('saveFormula', $sb_save_f, 'FALSE'), _
   _ArrayCreate('saveReflex', $sb_save_r, 'FALSE'), _
   _ArrayCreate('saveComment', $sb_save_comment, 'TRUE'), _
   _ArrayCreate('saveWindow', $sb_save_window, 'TRUE'), _
   _ArrayCreate('saveResolution', $sb_save_resolution, 'TRUE'), _
   _ArrayCreate('HRReflex', $sb_save_highres_reflex, 'TRUE'), _
   _ArrayCreate('CopyLast', $sb_save_last_reflex, 'FALSE'), _
   _ArrayCreate('LRReflex', $sb_save_lowres_reflex, 'FALSE'), _
   _ArrayCreate('useComment', $sb_use_formula_comment, 'TRUE') _
  )

  LoadSavebox($saveboxParametersMap, $saveboxCheckBoxMap)
  GUICtrlSetData($sb_formula_filename, UpdateMyDocuments(GUICtrlRead($sb_formula_filename)))
  GUICtrlSetData($sb_reflex_filename, UpdateMyDocuments(GUICtrlRead($sb_reflex_filename)))
  
  EnableDisableGroups($sb_save_fr, $sb_save_f, $sb_save_r, $formula_group_controls, $reflex_group_controls)
  $returnValue = -1
  maybeUpdateReflexFilename($sb_formula_comment, $sb_formula_filename, _
      $sb_use_formula_comment, $sb_reflex_filename, $sb_reflex_extension)
  $pos = WinGetPos($rri_win)
  WinMove($sb_savebox, "", $pos[0]+$pos[2], $pos[1])
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $sb_savebox, "int", 100, "long", 0x00040001);slide in from left
  GUISetState(@SW_SHOW)
  While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
    Case $GUI_EVENT_CLOSE
      If WinActive(WinGetTitle($sb_savebox, ""), "") Then
        ExitLoop
      Else
        WinActivate($sb_savebox)
      EndIf
    Case $sb_cancel_button
      ExitLoop
    Case $sb_save_button
      $returnValue = 1
      ExitLoop
    Case $sb_save_settings
      $returnValue = 0
      ExitLoop
    Case $sb_save_fr,$sb_save_f,$sb_save_r
      EnableDisableGroups($sb_save_fr, $sb_save_f, $sb_save_r, $formula_group_controls, $reflex_group_controls)
    Case $sb_formula_comment, $sb_reflex_extension, $sb_use_formula_comment, $sb_formula_filename
      maybeUpdateReflexFilename($sb_formula_comment, $sb_formula_filename, _
          $sb_use_formula_comment, $sb_reflex_filename, $sb_reflex_extension)
    Case $sb_open_formula_file
      $f = FileOpenDialog($Open_Formula_file, '', $Formula_file____txt__All______ , 8, IniReadSavebox('formulaFile', ''))
      if @error <> 1 Then
		    FileChangeDir(@ScriptDir)
        GUICtrlSetData($sb_formula_filename, $f)
        maybeUpdateReflexFilename($sb_formula_comment, $sb_formula_filename, _
          $sb_use_formula_comment, $sb_reflex_filename, $sb_reflex_extension)
      EndIf
    Case $sb_new_reflex_filename
      $f = FileSaveDialog($New_Reflex_file, '', $Bitmap_24_bits____bmp__Jpeg____jpg_ , 16, IniReadSavebox('reflexFile', ''))
      if @error <> 1 Then
        FileChangeDir(@ScriptDir)
        GUICtrlSetData($sb_reflex_filename, $f)
        GUICtrlSetState($sb_use_formula_comment, $GUI_UNCHECKED)
      EndIf
    Case $sb_reflex_filename
      GUICtrlSetState($sb_use_formula_comment, $GUI_UNCHECKED)
    Case 0
    Case -11
    Case Else
      logging("Message non id : "&$nMsg)
      If Not WinActive($sb_savebox) Then WinActivate($sb_savebox)
    EndSwitch
  WEnd
  If $returnValue <> -1 Then
    SaveSavebox($saveboxParametersMap, $saveboxCheckBoxMap)
  EndIf
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $sb_savebox, "int", 100, "long", 0x00050002);slide out to left
  GUIDelete($sb_savebox)
  Opt('GUIOnEventMode', 1)
  Return $returnValue 
EndFunc

Func UpdateMyDocuments($str)
  Return StringReplace($str, "%MY_DOCUMENTS%", @MyDocumentsDir)
EndFunc

Func AllGUIctrlSetState($gui_controls, $state)
  For $control in $gui_controls
    GUICtrlSetState($control, $state)
  Next
EndFunc

Func EnableDisableGroups($sb_save_fr, $sb_save_f, $sb_save_r, $formula_group_controls, $reflex_group_controls)
  $fr = BitAnd(GUICtrlRead($sb_save_fr),$GUI_CHECKED)
  $f = BitAnd(GUICtrlRead($sb_save_f),$GUI_CHECKED)
  $r = BitAnd(GUICtrlRead($sb_save_r),$GUI_CHECKED)
  If $fr Or $f Then
    AllGUIctrlSetState($formula_group_controls, $GUI_ENABLE)
  Else
    AllGUIctrlSetState($formula_group_controls, $GUI_DISABLE)
  EndIf
  If $fr Or $r Then
    AllGUIctrlSetState($reflex_group_controls, $GUI_ENABLE)
  Else
    AllGUIctrlSetState($reflex_group_controls, $GUI_DISABLE)
  EndIf
EndFunc

Func maybeUpdateReflexFilename($sb_formula_comment, $sb_formula_filename, _
                               $sb_use_formula_comment, $sb_reflex_filename, $sb_reflex_extension)
  If BitAnd(GUICtrlRead($sb_use_formula_comment),$GUI_CHECKED) Then
    $newname = reflexFileNameFromComment( _
      GUICtrlRead($sb_formula_comment), _
      GUICtrlRead($sb_formula_filename), _
      GUICtrlRead($sb_reflex_extension))
    
    GUICtrlSetData($sb_reflex_filename, $newname)
    ;todo
  EndIf
EndFunc

Func saveboxSave()
  $save_fr = isSavebox('saveBoth')
  $save_f  = isSavebox('saveFormula') or $save_fr
  $save_r  = isSavebox('saveReflex') or $save_fr
  $continue = True
  $comment_to_increment = False

  If $save_f Then
    $continue = saveFormula()
    If Not $continue Then Return
  EndIf
  If $save_r Then
    saveReflex()
  EndIf
EndFunc
;saveReflex() is defined in ReflexRender.au3

Func addLine(ByRef $string, $line_withouth_crlf)
  $string &= $line_withouth_crlf&@CRLF
EndFunc

Func saveFormulaString($formula, $comment, $save_comment, $save_resolution, $save_window)
  $formula_string = ""
  If $save_comment Then
    addLine($formula_string, $comment)
  EndIf
  addLine($formula_string, $formula)
  If $save_window Or $save_resolution  Then
    $result = _ArrayCreate(0)
    ;$options_line_string
    if $save_window Then
      $wmi = IniReadSession('winmin', '')
      $wma = IniReadSession('winmax', '')
      If $wmi <> "" and $wma <> "" Then
        push($result, 'winmin='&$wmi)
        push($result, 'winmax='&$wma)
      EndIf
    EndIf
    if $save_resolution Then
      $wx = IniReadSession('width', '')
      $wy = IniReadSession('height', '')
      If $wx <> "" and $wy <> "" Then
        push($result, 'width='&$wx)
        push($result, 'height='&$wy)
      EndIf
    EndIf
    If $result[0] <> 0 Then
      _ArrayDelete($result, 0)
      $optline = $options_line_string&" "&_ArrayToString($result, "; ")
      addLine($formula_string, $optline)
    EndIf
  EndIf
  Return $formula_string
EndFunc

Func getFirstAvailableComment($comment)
  $filename = UpdateMyDocuments(IniReadSavebox('formulafile', ''))
  If FileExists($filename) Then
    $content = FileRead($filename)
    While StringInStr($content, $comment) > 0
      $comment = incrementName($comment)
    WEnd
  EndIf
  Return $comment
EndFunc

Func saveFormula()
  SaveSession()
  $filename = UpdateMyDocuments(IniReadSavebox('formulafile', ''))
  $formula = IniRead($ini_file, 'Session', 'formula', '')
  $comment = IniReadSavebox('formulaComment', '')
  $comment = getFirstAvailableComment($comment)
  Return saveFormulaIntoFile($filename, $formula, $comment, isSavebox('saveComment'), isSavebox('saveResolution'), isSavebox('saveWindow'))
EndFunc

Func saveFormulaIntoFile($filename, $formula, $comment, $b_saveComment, $b_saveResolution, $b_saveWindow)
  $fileExistedBefore = FileExists($filename)
  $f = FileOpen($filename, 9)
  If $f == -1 Then
    MsgBox(0, $Error, StringFormat($__s__is_not_a_valsb_filename__s_Saving_canceled_, $filename, @CRLF))
    Return False
  EndIf
  If $fileExistedBefore Then
    FileWriteLine($f, '')
  EndIf
  $to_be_written_for_formula = saveFormulaString($formula, _
$comment, $b_saveComment, $b_saveResolution, $b_saveWindow)
  FileWrite($f, $to_be_written_for_formula)
  FileClose($f)
  Return True
EndFunc

; Something => Something 001, Something 001=> Something 002
; Something 999=>Something 1000, Something [n]=>Something [n+1]
Func incrementName($name)
  $last_number = ""
  $size_number = -1
  $name_length = StringLen($name)
  Do
    $size_number += 1
    $char = StringMid($name, $name_length - $size_number, 1)
    If StringIsDigit($char) Then
      $last_number = $char & $last_number
    Else
      ExitLoop
    EndIf
  Until False
  If $size_number == 0 Then
    $maybe_space = " "
    If StringIsSpace(StringRight($name, 1)) Then 
      $maybe_space= ""
    EndIf
    Return $name&$maybe_space&"0002"
  Else
    $last_number = String(Int($last_number)+1)
    While StringLen($last_number) < $size_number
      $last_number = "0"&$last_number
    WEnd
    Return StringMid($name, 1, $name_length - $size_number)&$last_number
  EndIf
EndFunc

Func incrementFileName($name)
  $position_extension = StringInStr($name, ".")
  Return incrementName(StringLeft($name, $position_extension-1))&StringMid($name, $position_extension)
EndFunc

Func testIncrementName()
  assertEqual(incrementName("something"), "something 0002")
  assertEqual(incrementName("something "), "something 0002")
  assertEqual(incrementName("something 0002"), "something 0003")
  assertEqual(incrementName("something 62"), "something 63")
  assertEqual(incrementName("something42"), "something43")
  assertEqual(incrementName("something99"), "something100")
  assertEqual(incrementName("something 999"), "something 1000")
  assertEqual(incrementName("something 1928"), "something 1929")
  assertEqual(incrementFileName("something.bmpk"), "something 0002.bmpk")
  ;TestFinished
  Exit
EndFunc

;~ Func AssertEqual($a, $b)
;~   If $a <> $b Then
;~     MsgBox(0, "Assertion error", StringFormat("%s != %s and it's bad", $a, $b))
;~     Exit
;~   EndIf
;~ EndFunc