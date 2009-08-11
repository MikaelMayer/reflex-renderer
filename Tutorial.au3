#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Mikaël Mayer
 Date:           2009.07.01

 Script Function:
	Go through the tutorial.

#ce ----------------------------------------------------------------------------
#include-once
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include "WindowManager.au3"
#include "GlobalUtils.au3"
#include "IniHandling.au3"
#include "translations.au3"
  
Opt("GUIOnEventMode", 1)

Global $TUTORIAL_BOX_EXISTS = False, $TutorialBox = 0
Global $TUTORIAL_BOX_CALLBACK = "", $TUTORIAL_BOX_PARENT_WINDOW = 0
Global $current_tutorial
Global $n_current_section = 1
Global $n_current_subsection = 1
Global $tutorial_play = False
Global $tutorial_automatic_move = True
Global $global_after_ms = 0

Func GenerateTutorialBox()
  If $TUTORIAL_BOX_EXISTS Then
    WinActivate($TutorialBox)
    Return
  EndIf
  $TUTORIAL_BOX_EXISTS = True
  #Region ### START Koda GUI section ### Form=C:\Documents and Settings\Mikaël\Mes documents\Reflex\LogicielOrdi\RenderReflex\ReflexRendererTutorial.kxf
  Global $TutorialBox = GUICreate($__tutorial__, 484, 165, 281, 198)
  GUISetOnEvent($GUI_EVENT_CLOSE, "TutorialBoxClose")
  GUISetOnEvent($GUI_EVENT_MINIMIZE, "TutorialBoxMinimize")
  GUISetOnEvent($GUI_EVENT_MAXIMIZE, "TutorialBoxMaximize")
  GUISetOnEvent($GUI_EVENT_RESTORE, "TutorialBoxRestore")
  Global $tb_texte = GUICtrlCreateEdit("", 0, 0, 360, 128, BitOR($ES_AUTOVSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
  GUICtrlSetData(-1, "tb_texte")
  GUICtrlSetFont(-1, 12, 400, 0, "Arial")
  GUICtrlSetOnEvent(-1, "tb_texteChange")
  Global $tb_previous = GUICtrlCreateButton($__previous__, 0, 130, 48, 33, 0)
  GUICtrlSetOnEvent(-1, "tb_previousClick")
  Global $tb_stop = GUICtrlCreateButton($__stop__, 100, 130, 48, 33, 0)
  GUICtrlSetOnEvent(-1, "tb_stopClick")
  GUICtrlSetState(-1, $GUI_DISABLE)
  Global $tb_play = GUICtrlCreateButton($__play__, 50, 130, 48, 33, 0)
  GUICtrlSetOnEvent(-1, "tb_playClick")
  Global $tb_next = GUICtrlCreateButton($__next__, 150, 130, 48, 33, 0)
  GUICtrlSetOnEvent(-1, "tb_nextClick")
  Global $tb_autoplay = GUICtrlCreateCheckbox($__autoplay__, 208, 138, 97, 17)
  GUICtrlSetState(-1, $GUI_CHECKED)
  GUICtrlSetOnEvent(-1, "tb_autoplayClick")
  Global $tb_sections = GUICtrlCreateList("", 360, 0, 121, 162, $WS_BORDER)
  GUICtrlSetData(-1, $__tutorial_sections__)
  GUICtrlSetOnEvent(-1, "tb_sectionsClick")
  #EndRegion ### END Koda GUI section ###
  WindowManager__registerWindow($TutorialBox, "Tutorial", "TutorialBoxClose")
  tb_autoplayClick()
  $tutorial_play = False
  ;If WinExists($main_window_handle) Then
  ;  $pos = WinGetPos($main_window_handle, "")
  ;  $pos2 = WinGetPos($AboutBox, "")
  ;  WinMove($AboutBox, "", $pos[0]+$pos[2]/2-$pos2[2]/2, $pos[1]+$pos[3]/2-$pos2[3]/2)
  ;EndIf
EndFunc

; SubSection class declaration
; SubSection:Before,Action,After,Text
Global Enum $N_SubSection_Before, $N_SubSection_Action, $N_SubSection_After, $N_SubSection_Text, $N_SubSection_size

Func setSubSection_Before(ByRef $obj, $value)
  $obj[$N_SubSection_Before] = $value
EndFunc ;==> setSubSection_Before
Func getSubSection_Before($obj)
  Return $obj[$N_SubSection_Before]
EndFunc ;==> getSubSection_Before

Func setSubSection_Action(ByRef $obj, $value)
  $obj[$N_SubSection_Action] = $value
EndFunc ;==> setSubSection_Action
Func getSubSection_Action($obj)
  Return $obj[$N_SubSection_Action]
EndFunc ;==> getSubSection_Action

Func setSubSection_After(ByRef $obj, $value)
  $obj[$N_SubSection_After] = $value
EndFunc ;==> setSubSection_After
Func getSubSection_After($obj)
  Return $obj[$N_SubSection_After]
EndFunc ;==> getSubSection_After

Func setSubSection_Text(ByRef $obj, $value)
  $obj[$N_SubSection_Text] = $value
EndFunc ;==> setSubSection_Text
Func getSubSection_Text($obj)
  Return $obj[$N_SubSection_Text]
EndFunc ;==> getSubSection_Text

; SubSection constructor
Func newSubSection($Before, $Action, $After, $Text)
  Local $result[$N_SubSection_size]
  $result[$N_SubSection_Before] = $Before
  $result[$N_SubSection_Action] = $Action
  $result[$N_SubSection_After]  = $After
  $result[$N_SubSection_Text]   = $Text
  Return $result
EndFunc ;==> newSubSection

; Tutorial internal format:
; tutorial = SizedArray of sections
; section = SizedArray of subsections
; subsection = [Before, Action, After, Text]
Func loadTutorial()
  Local $tutorial_file = @ScriptDir&"\"&$lang_folder&"\tutorial_"&$translation_current_language&".txt"
  If Not FileExists($tutorial_file) Then
    MsgBox(0, "File does not exist", $tutorial_file)
    Return False
  EndIf
  Local $tutorial_current_textfile = FileRead($tutorial_file)

  Local $sections_tutorial = StringSplit($tutorial_current_textfile, "@@", 1)
  $sections_titles = pop($sections_tutorial)
  ;Overwrite section titles
  $__tutorial_sections__ = StringStripWS(removeComments($sections_titles), 1+2)
  
  For $i = 1 to size($sections_tutorial)
    $subsections = StringSplit($sections_tutorial[$i], "@", 1)
    For $j = 1 To size($subsections)
      $subsection = $subsections[$j]
      $pos_first_line = StringInStr($subsection, @CRLF)
      $parameters = StringSplit(StringLeft($subsection, $pos_first_line-1), ",")
      If size($parameters) < 3 Then
        MsgBox(0, $__error__, $__tutorial_section_misformed_aborting_loading__&@CRLF&@CRLF&$subsection)
        Return False
      EndIf
      $text = StringStripWS(StringMid($subsection, $pos_first_line+2), 1+2)
      $subsections[$j] = newSubSection(Int($parameters[1]), $parameters[2], Int($parameters[3]), $text)
    Next
    $sections_tutorial[$i] = $subsections
  Next
  $current_tutorial = $sections_tutorial ; Global
  Return True
EndFunc

Func Tutorial__setCallbackFunction($callbackfunction)
  $TUTORIAL_BOX_CALLBACK = $callbackfunction
EndFunc
Func Tutorial__setParentWindow($main_window_handle)
  $TUTORIAL_BOX_PARENT_WINDOW = $main_window_handle
EndFunc

Func Tutorial__putInFrontOfParentWindow()
  If WinExists($TUTORIAL_BOX_PARENT_WINDOW) Then
    Local $pos = WinGetPos($TUTORIAL_BOX_PARENT_WINDOW, "")
    Local $q = WinGetPos($TutorialBox, "")
    WinMove($TutorialBox, "", $pos[0]+$pos[2]/2-$q[2]/2, $pos[1]+$pos[3]/2-$q[3]/2)
  EndIf
EndFunc
Func Tutorial__stickToParentWindow()
  If WinExists($TUTORIAL_BOX_PARENT_WINDOW) Then
    $pos = WinGetPos($TUTORIAL_BOX_PARENT_WINDOW, "")
    WinMove($TutorialBox, "", $pos[0], $pos[1]+$pos[3], Default, Default, 2)
  EndIf
EndFunc

; Functions to save and load the TutorialBox window
Func Tutorial__Load()
  Tutorial__LoadFromValue(1)
EndFunc

WindowManager__addLoadSaveFunctionForType("Tutorial", "Tutorial__LoadFromValue", "Tutorial__SaveToValue")
Func Tutorial__LoadFromValue($value)
  If Not loadTutorial() Then Return
  Local $t_save = $TUTORIAL_BOX_EXISTS
  GenerateTutorialBox()
  $n_current_section = Int($value)
  $n_current_subsection = 1
  loadCurrentSection()
  If Not $t_save Then
    Tutorial__putInFrontOfParentWindow()
    AnimateFromTop($TutorialBox)
  EndIf
  GUISetState(@SW_SHOW, $TutorialBox)
EndFunc
Func Tutorial__SaveToValue($win_handle)
  Return String(getCurrentSectionNumber())
EndFunc

Func getSectionNumberFromName($name)
  Local $sections = StringSplit($__tutorial_sections__, "|")
  For $i = 1 To size($sections)
    If $sections[$i] == $name Then Return $i
    ;logging("Comparing "&$sections[$i]&" and "&$name)
  Next
  Return 0
EndFunc
Func getSectionNameFromNumber($n)
  Local $sections = StringSplit($__tutorial_sections__, "|")
  $n = Int($n)
  If $n < 1 Then $n = 1
  If $n > size($sections) Then $n = size($sections)
  Return $sections[$n]
EndFunc
Func getCurrentSectionNumber()
  Return getSectionNumberFromName(GUICtrlRead($tb_sections))
EndFunc
Func setCurrentSectionNumber($n)
  GUICtrlSetData($tb_sections, getSectionNameFromNumber($n))
EndFunc

Func previousSubSection()
  $n_current_subsection -=  1
  If $n_current_subsection == 0 Then
    If $n_current_section == 1 Then Return
    $n_current_section -= 1
    Local $section = $current_tutorial[$n_current_section]
    $n_current_subsection = size($section)
  EndIf
  loadCurrentSection()
EndFunc
Func nextSubSection()
  Local $section = $current_tutorial[$n_current_section]
  Local $subsection = $section[$n_current_subsection]
  $n_current_subsection +=  1
  If $n_current_subsection > size($section) Then
    If $n_current_section == size($current_tutorial) Then Return
    $n_current_section += 1
    $n_current_subsection = 1
  EndIf
  loadCurrentSection()
EndFunc
Func loadCurrentSection()
  If Not $TUTORIAL_BOX_EXISTS Then Return
  If $n_current_section < 1 Then $n_current_section = 1
  If $n_current_section > size($current_tutorial) Then $n_current_section = size($current_tutorial)
  Local $section = $current_tutorial[$n_current_section]
  If $n_current_subsection < 1 Then $n_current_subsection = 1
  If $n_current_subsection > size($section) Then $n_current_subsection = size($section)
  
  Local $subsection = $section[$n_current_subsection]
  GUICtrlSetData($tb_texte, getSubSection_Text($subsection))
  setCurrentSectionNumber($n_current_section)
  
  If $n_current_section == 1 and $n_current_subsection == 1 Then
    GUICtrlSetState($tb_previous, $GUI_DISABLE)
  Else
    GUICtrlSetState($tb_previous, $GUI_ENABLE)
  EndIf
  If $n_current_section == size($current_tutorial) and $n_current_subsection == size($current_tutorial[$n_current_section]) Then
    GUICtrlSetState($tb_next, $GUI_DISABLE)
  Else
    GUICtrlSetState($tb_next, $GUI_ENABLE)
  EndIf
  
  ;logging("Loaded subsection : "&toString($subsection))
  Local $action = getSubSection_Action($subsection)
  Local $before_ms = 1000*getSubSection_Before($subsection) 
  Local $after_ms  = 1000*getSubSection_After($subsection) 
  $global_after_ms = $after_ms
  Switch $action
  Case "Miniature", "Zoomout1", "Zoomin1", "Zoomout2", "Zoomin2", "Zoomin3", "Zoomout3", "Navig1"
    setTimeout("_Tutorial_"&$action, $before_ms)
  Case ""
    If $tutorial_play Then
      setTimeout("nextSubSection", $before_ms + $after_ms)
    EndIf
  Case Else ;TODO: To delete ?
    setTimeout("_Tutorial_"&$action, $before_ms)
  EndSwitch
  ;TODO : initialize animation, etc.
EndFunc

Func cancelAllTutorialActions()
  cancelAllTimeoutsStartingWith("_Tutorial_")
  cancelAllTimeouts("nextSubSection")
EndFunc
Func tb_autoplayClick()
  cancelAllTutorialActions()
  If BitAND(GUICtrlRead($tb_autoplay), $GUI_CHECKED) Then
    $tutorial_automatic_move = True
  Else
    $tutorial_play = False
  EndIf
EndFunc ;==>tb_autoplayClick
Func tb_playClick()
  cancelAllTutorialActions()
  GUICtrlSetState($tb_play, $GUI_DISABLE)
  GUICtrlSetState($tb_stop, $GUI_ENABLE)
  $tutorial_play = True
  Tutorial__stickToParentWindow()
  loadCurrentSection()
EndFunc ;==>tb_playClick
Func tb_stopClick()
  cancelAllTutorialActions()
  GUICtrlSetState($tb_play, $GUI_ENABLE)
  GUICtrlSetState($tb_stop, $GUI_DISABLE)
  $tutorial_play = False
EndFunc ;==>tb_stopClick

Func tb_previousClick() ; Previous subsection.
  cancelAllTutorialActions()
  previousSubSection()
EndFunc ;==>tb_previousClick
Func tb_nextClick()
  cancelAllTutorialActions()
  nextSubSection()
EndFunc ;==>tb_nextClick
Func tb_sectionsClick()
  cancelAllTutorialActions()
  $n_current_section = getCurrentSectionNumber()
  $n_current_subsection = 1
  loadCurrentSection()
EndFunc
Func tb_texteChange()
  ; Nothing to write here.
EndFunc ;==>tb_texteChange
Func TutorialBoxClose($win_handle=$TutorialBox)
  If Not IsDeclared("win_handle") Then  $win_handle=$TutorialBox
  If $TUTORIAL_BOX_EXISTS Then
    AnimateToTop($win_handle)
    GUIDelete($TutorialBox)
    $TUTORIAL_BOX_EXISTS = False
    WindowManager__unregisterWindow($win_handle)
  EndIf
EndFunc ;==>TutorialBoxClose
Func TutorialBoxMaximize()
EndFunc ;==>TutorialBoxMaximize
Func TutorialBoxMinimize()
EndFunc ;==>TutorialBoxMinimize
Func TutorialBoxRestore()
EndFunc ;==>TutorialBoxRestore

Func positionCenter($control, $main_win = $rri_win)
  Local $wpos = WinGetPos($main_win, "")
  Local $cpos = ControlGetPos($main_win, "", $control)
  Return _ArrayCreate($wpos[0]+$cpos[0]+$cpos[2]/2+6, $wpos[1]+$cpos[1]+$cpos[3]/2+_iif($main_win == $rri_win, 50, 30))
EndFunc

Func positionRatio($control, $xratio, $yratio)
  Local $wpos = WinGetPos($rri_win, "")
  Local $cpos = ControlGetPos($rri_win, "", $control)
  Return _ArrayCreate($wpos[0]+$cpos[0]+$cpos[2]*$xratio+6, $wpos[1]+$cpos[1]+$cpos[3]*$yratio+50)
EndFunc

Func _Tutorial_MouseMove($control, $main_win = $rri_win)
  Local $mpos = positionCenter($control, $main_win)
  Local $save_MouseCoordMode = Opt("MouseCoordMode", 1)
  MouseMove($mpos[0], $mpos[1])
  Opt("MouseCoordMode", $save_MouseCoordMode)
EndFunc

Func _Tutorial_MouseMoveRatio($control, $xratio, $yratio, $speed=10)
  Local $mpos = positionRatio($control, $xratio, $yratio)
  Local $save_MouseCoordMode = Opt("MouseCoordMode", 1)
  MouseMove($mpos[0], $mpos[1], $speed)
  Opt("MouseCoordMode", $save_MouseCoordMode)
EndFunc

Func _Tutorial_cancel()
  Return Not $tutorial_automatic_move Or Not $tutorial_play
EndFunc

Func _Tutorial_continue()
  setTimeout("nextSubSection", $global_after_ms)
EndFunc

;=================== Tutorial pre-defined functions ===================;

Func _Tutorial_Quick0()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_Quick0", 500)
  _Tutorial_MouseMove($rri_switch_fract)
  _Tutorial_MouseMove($rri_lucky_fract)
  _Tutorial_MouseMove($rri_lucky_func)
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_Quick1($seed, $func_name)
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout($func_name, 500)
  _Tutorial_MouseMove($rri_lucky_func)
  updateFormula("randf(16)")
  updateSeed($seed)
  renderIfAutoRenderDefault()
  If $tutorial_play Then _Tutorial_continue()
EndFunc
Func _Tutorial_Quick1_1()
  _Tutorial_Quick1("1524393753", "_Tutorial_Quick1_1")
EndFunc
Func _Tutorial_Quick1_2()
  _Tutorial_Quick1("1693264836", "_Tutorial_Quick1_2")
EndFunc
Func _Tutorial_Quick1_3()
  _Tutorial_Quick1("2031282463", "_Tutorial_Quick1_3")
EndFunc

Func _Tutorial_Quick2()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_Quick2", 500)
  _Tutorial_MouseMove($rri_switch_fract)
  rri_switch_fractClick()
  renderIfAutoRenderDefault()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_Quick3()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_Quick3", 500)
  _Tutorial_MouseMove($rri_lucky_fract)
  updateFormula("oo(o(y-z,y)-x/z-sin(argth(z*argsh(z))),5)")
  renderIfAutoRenderDefault()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_LoadInit()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_LoadInit", 500)
  ResetSession()
  renderIfAutoRenderDefault()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_Miniature()
  If _Tutorial_cancel() Then Return
  _Tutorial_MouseMove($rri_preview)
  setPreviewPercent(50)
  rri_previewClick()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_Zoomout1()
  If _Tutorial_cancel() Then Return
  _Tutorial_MouseMove($rri_zoom_out_factor)
  rri_zoom_out_factorClick()
  If $tutorial_play Then _Tutorial_continue()
EndFunc
Func _Tutorial_Zoomin1()
  If _Tutorial_cancel() Then Return
  _Tutorial_MouseMove($rri_zoom_factor)
  GUICtrlSetData($rri_zoom_factor, "4")
  rri_zoom_factorChange()
  Sleep(1000)
  _Tutorial_MouseMove($rri_zoom_in_factor)
  rri_zoom_in_factorClick()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_ZoomAbsolute($factor)
  If _Tutorial_cancel() Then Return
  _Tutorial_MouseMove($rri_zoom_absolute)
  GUICtrlSetData($rri_zoom_absolute, String($factor))
  rri_zoom_absoluteChange()
  If $tutorial_play Then _Tutorial_continue()
EndFunc
Func _Tutorial_Zoomout2()
  _Tutorial_ZoomAbsolute(6)
EndFunc
Func _Tutorial_Zoomin2()
  _Tutorial_ZoomAbsolute(2)
EndFunc
Func _Tutorial_Zoomin3()
  _Tutorial_ZoomAbsolute(0.5)
EndFunc

Func _Tutorial_Zoomout3()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_Zoomout3", 500)
  _Tutorial_MouseMove($rri_previous_window)
  rri_previous_windowClick()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_Navig1()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_Navig1", 500)
  GUICtrlSetData($rri_zoom_factor, "2")
  _Tutorial_MouseMove($rri_reset_window)
  rri_reset_windowClick()
  setTimeout("_Tutorial_Navig1_1", 500)
EndFunc
Func _Tutorial_Navig1_1()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_Navig1_1", 500)
  WinActivate($rri_win)
  _Tutorial_MouseMoveRatio($rri_out_rendu, 0.25, 0.25)
  rri_winMouseLeftDown()
  rri_winMouseLeftUp()
  setTimeout("_Tutorial_Navig1_2", 500)
EndFunc
Func _Tutorial_Navig1_2()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_Navig1_2", 500)
  WinActivate($rri_win)
  _Tutorial_MouseMoveRatio($rri_out_rendu, 147/400, 245/400)
  rri_winMouseLeftDown()
  rri_winMouseLeftUp()
  setTimeout("_Tutorial_Navig1_3", 500)
EndFunc
Func _Tutorial_Navig1_3()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_Navig1_3", 500)
  WinActivate($rri_win)
  _Tutorial_MouseMoveRatio($rri_out_rendu, 200/400, 200/400)
  rri_winMouseLeftDown()
  rri_winMouseLeftUp()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_Rectangle1()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_Rectangle1", 500)
  _Tutorial_MouseMove($rri_visit_rectangle)
  GUICtrlSetState($rri_visit_rectangle, $GUI_CHECKED)
  rri_visit_rectangleClick()
  Sleep(300)
  WinActivate($rri_win)
  _Tutorial_MouseMoveRatio($rri_out_rendu, 3/7, 3/7)
  rri_winMouseLeftDown()
  displayZoombox(True)
  _Tutorial_MouseMoveRatio($rri_out_rendu, 4/7, 4/7)
  Local $xy = MouseGetPos()
  resizeZoomBox($x, $y, $xy[0], $xy[1])
  Sleep(100)
  rri_winMouseLeftUp()
  If $tutorial_play Then _Tutorial_continue()
EndFunc
  
Func _Tutorial_OpenSaveDialog()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_OpenSaveDialog", 500)
  logging("Setting winminmax")
  setWinminmax("-2.61166+1.4742i", "-2.4652+1.62066i")
  logging("Update pic")
  _Tutorial_MouseMove($rri_render)
  MouseClick("left")
  ;updatePic()
  setTimeout("_Tutorial_OpenSaveDialog2", 1000)
EndFunc

Func _Tutorial_OpenSaveDialog2()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_OpenSaveDialog2", 500)
  logging("Tutorial MouseMove")
  _Tutorial_MouseMove($rri_save_noquick)
  logging("Opening instance")
  MouseClick("left")
  ;SaveBox__createInstance()
  logging("Play")
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_SaveDialogPng()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_SaveDialogPng", 500)
  If Not $SAVE_BOX_EXISTS Then SaveBox__createInstance()
  _Tutorial_MouseMove($sb_reflex_extension, $sb_savebox)
  MouseClick("left")
  Sleep(500)
  Send("p")
  Sleep(500)
  Send("{ENTER}")
  Sleep(1000)
  _Tutorial_MouseMove($sb_formula_comment, $sb_savebox)
  MouseClick("left")
  GUICtrlSetData($sb_formula_comment, "Montagne")
  sb_formula_commentChange()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_SaveAll()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_SaveAll", 500)
  If Not $SAVE_BOX_EXISTS Then SaveBox__createInstance()
  _Tutorial_MouseMove($sb_save_button, $sb_savebox)
  MouseClick("left")
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_SaveQuick()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_SaveAll", 500)
  If $SAVE_BOX_EXISTS Then
    sb_saveboxClose()
  EndIf
  ;GUICtrlSetState($rri_visit_click, $GUI_CHECKED)
  ;rri_visit_clickClick()
  Sleep(1000)
  _Tutorial_MouseMove($rri_zoom_out_factor)
  rri_zoom_out_factorClick()
  setTimeout("_Tutorial_SaveQuick2", 500)
EndFunc
Func _Tutorial_SaveQuick2()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_SaveQuick2", 500)
  _Tutorial_MouseMove($rri_quicksave)
  setTimeout_external("WinWaitActive('"&$Quick_save&"');Sleep(500);Send('Vegetation');Sleep(500);Send('{ENTER}')", 0)
  MouseClick("left")
  If $tutorial_play Then _Tutorial_continue()
EndFunc
  
Func _Tutorial_OpenColors()
  If _Tutorial_cancel() Then Return
  _Tutorial_MouseMove($rri_color_code_button)
  MouseClick("left")
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_CloseColors()
  If _Tutorial_cancel() Then Return
  If WinActive($__hint_color_code_button__) Then
    rcc_winClose()
  EndIf
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_LoadConcept()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_LoadConcept", 500)
  _Tutorial_MouseMove($rri_in_formula)
  Sleep(500)
  updateFormula("z^2-4")
  _Tutorial_MouseMove($rri_realmode)
  Sleep(500)
  GUICtrlSetState($rri_realmode, $GUI_CHECKED)
  _Tutorial_MouseMove($rri_reset_window)
  Sleep(500)
  rri_reset_windowClick()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_SwitchComplex()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_SwitchComplex", 500)
  _Tutorial_MouseMove($rri_realmode)
  Sleep(500)
  GUICtrlSetState($rri_realmode, $GUI_UNCHECKED)
  rri_realmodeClick()
  setTimeout("_Tutorial_DisplayRealLine", 500)
EndFunc
Func _Tutorial_DisplayRealLine()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_DisplayRealLine", 500)
  _Tutorial_MouseMoveRatio($rri_out_rendu, 0.1, 0.5)
  Sleep(500)
  _Tutorial_MouseMoveRatio($rri_out_rendu, 0.1, 0.5, 0)
  _Tutorial_MouseMoveRatio($rri_out_rendu, 0.9, 0.5)
  Sleep(200)
  _Tutorial_MouseMoveRatio($rri_out_rendu, 0.1, 0.5)
  
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_LoadConcept2()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_LoadConcept2", 500)
  _Tutorial_MouseMove($rri_in_formula)
  Sleep(200)
  updateFormula("0.5z^2+2")
  _Tutorial_MouseMove($rri_realmode)
  Sleep(200)
  GUICtrlSetState($rri_realmode, $GUI_CHECKED)
  _Tutorial_MouseMove($rri_reset_window)
  Sleep(200)
  rri_reset_windowClick()
  If $tutorial_play Then _Tutorial_continue()
EndFunc
;TODO: Tutorial
Func _Tutorial_SwitchComplex2()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_SwitchComplex2", 500)
  _Tutorial_MouseMove($rri_realmode)
  Sleep(500)
  GUICtrlSetState($rri_realmode, $GUI_UNCHECKED)
  rri_realmodeClick()
  setTimeout("_Tutorial_LoadConcept2_ShowRoots", 500)
EndFunc
Func _Tutorial_LoadConcept2_ShowRoots()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_LoadConcept2_ShowRoots", 500)
  _Tutorial_MouseMoveRatio($rri_out_rendu, 0.5, 0.25)
  Sleep(1000)
  _Tutorial_MouseMoveRatio($rri_out_rendu, 0.5, 0.75)
  Sleep(1000)
  setTimeout("_Tutorial_DisplayRealLine", 500)
EndFunc

Func _Tutorial_OpenFormulaEditor()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_OpenFormulaEditor", 500)
  _Tutorial_MouseMove($rri_formula_editor)
  rri_menu_formula_editorClick()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_GenerateRandomFunctions()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_GenerateRandomFunctions", 500)
  _Tutorial_MouseMove($IDC_F_RANDH_AUTO, $ID_EDITFORMULA)
  deleteText($IDC_EDIT1, 0)
  insertText($IDC_EDIT1, TEXT('randh([{15}])'))
  GUICtrlSetData($IDC_F_SEED, "1459936610")
  Sleep(500)
  ResetSession()
  ID_DRAWClick()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_CloseFormulaEditor()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_CloseFormulaEditor", 500)
  ID_EDITFORMULAClose()
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_OpenSmallHistory()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_OpenSmallHistory", 500)
  ResetSession()
  WinActivate($rri_win)
  setTimeout_external("WinWaitActive('"&WinGetTitle($rri_win)&"');Send('!f');Sleep(100);Send('{DOWN 3}');Sleep(400);Send('p')", 0)
  If $tutorial_play Then _Tutorial_continue()
EndFunc

Func _Tutorial_LoadFromSmallHistory()
  If _Tutorial_cancel() Then Return
  If $rendering_thread Then  Return setTimeout("_Tutorial_OpenSmallHistory", 500)
  _Tutorial_MouseMove($lf_formula_tree, $formula_chooser)
  MouseClick("left")
  If $tutorial_play Then _Tutorial_continue()
EndFunc