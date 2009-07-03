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
  
;  Global $__next__
;  Global $__play__
;  Global $__previous__
;  Global $__stop__
;  Global $__tutorial__
;  Global $__tutorial_sections__
  
Func GenerateTutorialBox()
  If $TUTORIAL_BOX_EXISTS Then
    WinActivate($TutorialBox)
    Return
  EndIf
  $TUTORIAL_BOX_EXISTS = True
  #Region ### START Koda GUI section ### Form=C:\Documents and Settings\Mikaël\Mes documents\Reflex\LogicielOrdi\RenderReflex\ReflexRendererTutorial.kxf
  Global $TutorialBox = GUICreate($__tutorial__, 443, 164, 281, 198)
  GUISetOnEvent($GUI_EVENT_CLOSE, "TutorialBoxClose")
  GUISetOnEvent($GUI_EVENT_MINIMIZE, "TutorialBoxMinimize")
  GUISetOnEvent($GUI_EVENT_MAXIMIZE, "TutorialBoxMaximize")
  GUISetOnEvent($GUI_EVENT_RESTORE, "TutorialBoxRestore")
  Global $tb_texte = GUICtrlCreateEdit("", 0, 0, 320, 128, BitOR($ES_AUTOVSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
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
  Global $tb_sections = GUICtrlCreateList("", 320, 0, 121, 162, $WS_BORDER)
  GUICtrlSetData(-1, $__tutorial_sections__)
  GUICtrlSetOnEvent(-1, "tb_sectionsClick")
  #EndRegion ### END Koda GUI section ###
  WindowManager__registerWindow($TutorialBox, "Tutorial", "TutorialBoxClose")
  ;If WinExists($main_window_handle) Then
  ;  $pos = WinGetPos($main_window_handle, "")
  ;  $pos2 = WinGetPos($AboutBox, "")
  ;  WinMove($AboutBox, "", $pos[0]+$pos[2]/2-$pos2[2]/2, $pos[1]+$pos[3]/2-$pos2[3]/2)
  ;EndIf
EndFunc

Func Tutorial__setCallbackFunction($callbackfunction)
  $TUTORIAL_BOX_CALLBACK = $callbackfunction
EndFunc
Func Tutorial__setParentWindow($main_window_handle)
  $TUTORIAL_BOX_PARENT_WINDOW = $main_window_handle
EndFunc

Func Tutorial__stickToParentWindow()
  If WinExists($TUTORIAL_BOX_PARENT_WINDOW) Then
    $pos = WinGetPos($TUTORIAL_BOX_PARENT_WINDOW, "")
    WinMove($TutorialBox, "", $pos[0], $pos[1]+$pos[3])
  EndIf
EndFunc

; Functions to save and load the TutorialBox window

WindowManager__addLoadSaveFunctionForType("Tutorial", "Tutorial__LoadFromValue", "Tutorial__SaveToValue")
Func Tutorial__LoadFromValue($value)
  Local $t_save = $TUTORIAL_BOX_EXISTS
  GenerateTutorialBox()
  setCurrentSectionNumber($value)
  tb_updateTutorialState()
  If Not $t_save Then
    Tutorial__stickToParentWindow()
    AnimateFromTop($TutorialBox)
  EndIf
  GUISetState(@SW_SHOW, $TutorialBox)
EndFunc
Func Tutorial__SaveToValue($win_handle)
  Return String(getCurrentSectionNumber())
EndFunc

Func tb_autoplayClick()
EndFunc ;==>tb_autoplayClick
Func tb_playClick()
  GUICtrlSetState($tb_play $GUI_DISABLE)
  GUICtrlSetState($tb_stop $GUI_ENABLE)
EndFunc ;==>tb_playClick
Func getSectionNumberFromName($name)
  Local $sections = StringSplit($__tutorial_sections__, "|")
  For $i = 1 To $sections[0]
    If $sections[$i] == $name Then Return $i
    ;logging("Comparing "&$sections[$i]&" and "&$name)
  Next
  Return 1
EndFunc
Func getSectionNameFromNumber($n)
  Local $sections = StringSplit($__tutorial_sections__, "|")
  $n = Int($n)
  If $n < 1 Then $n = 1
  If $n > $sections[0] Then $n = $sections[0]
  Return $sections[$n]
EndFunc
Func getCurrentSectionNumber()
  Return getSectionNumberFromName(GUICtrlRead($tb_sections))
EndFunc
Func setCurrentSectionNumber($n)
  GUICtrlSetData($tb_sections, getSectionNameFromNumber($n))
EndFunc

Func tb_previousClick()
  setCurrentSectionNumber(getCurrentSectionNumber()-1)
  tb_updateTutorialState()
EndFunc ;==>tb_previousClick
Func tb_nextClick()
  setCurrentSectionNumber(getCurrentSectionNumber()+1)
  tb_updateTutorialState()
EndFunc ;==>tb_nextClick

Func tb_sectionsClick()
  tb_updateTutorialState()
EndFunc

Func tb_updateTutorialState()
  Local $sections = StringSplit($__tutorial_sections__, "|")
  Local $n = getCurrentSectionNumber()
  If $n == 1 Then
    GUICtrlSetState($tb_previous, $GUI_DISABLE)
  Else
    GUICtrlSetState($tb_previous, $GUI_ENABLE)
  EndIf
  If $n == $sections[0] Then
    GUICtrlSetState($tb_next, $GUI_DISABLE)
  Else
    GUICtrlSetState($tb_next, $GUI_ENABLE)
  EndIf
  ;TODO: import text
  GUICtrlSetData($tb_texte, "Bienvenue dans le tutorial !"&@CRLF&"Vous allez apprendre comment profiter à fond de ce logiciel.")
EndFunc ;==>tb_updateTutorialState
Func tb_stopClick()
  GUICtrlSetState($tb_play, $GUI_ENABLE)
  GUICtrlSetState($tb_stop, $GUI_DISABLE)
EndFunc ;==>tb_stopClick
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


