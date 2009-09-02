#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mikaël Mayer

 Script Function:
  Displays an 'About box'

#ce ----------------------------------------------------------------------------

#include-once
#include "WindowManager.au3"
#include "translations.au3"

Global $ABOUT_BOX_EXISTS = False, $AboutBox = 0

Func GenerateAboutBox($main_window_handle)
  If $ABOUT_BOX_EXISTS Then
    ;GUISwitch($AboutBox)
    WinActivate($AboutBox)
    Return
  EndIf
  $ABOUT_BOX_EXISTS = True
  If StringInStr($__version__, "%s") Then
    $__version__ = StringFormat($__version__, $VERSION_NUMER)
  EndIf
  If StringInStr($__copyright__, "%s") Then
    $__copyright__ = StringFormat($__copyright__, $COPYRIGHT_DATE)
  EndIf
  #Region ### START Koda GUI section ### Form=C:\Documents and Settings\Mikaël\Mes documents\Reflex\LogicielOrdi\RenderReflex\ReflexRendererAboutBox.kxf
  Global $AboutBox = GUICreate($__about_box__, 355, 198, 396, 188)
  GUISetOnEvent($GUI_EVENT_CLOSE, "AboutBoxClose")
  GUISetOnEvent($GUI_EVENT_MINIMIZE, "AboutBoxMinimize")
  GUISetOnEvent($GUI_EVENT_MAXIMIZE, "AboutBoxMaximize")
  GUISetOnEvent($GUI_EVENT_RESTORE, "AboutBoxRestore")
  Global $ab_icon = GUICtrlCreatePic("Release\nice_function.JPG", 15, 15, 128, 96, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetOnEvent(-1, "ab_labelClick")
  Global $ab_groupbox1 = GUICtrlCreateGroup("", 8, 0, 337, 161)
  Global $ab_label_title = GUICtrlCreateLabel($__reflex_renderer_interface__, 152, 17, 192, 17, $WS_GROUP)
  GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
  GUICtrlSetOnEvent(-1, "ab_labelClick")
  Global $ab_label_version = GUICtrlCreateLabel($__version__, 242, 33, 97, 17, BitOR($SS_RIGHT,$WS_GROUP))
  GUICtrlSetOnEvent(-1, "ab_labelClick")
  Global $ab_label_site = GUICtrlCreateLabel("http://meak.free.fr/reflex", 16, 118, 121, 17, $WS_GROUP)
  GUICtrlSetColor(-1, 0x316AC5)
  GUICtrlSetOnEvent(-1, "ab_linkClick")
  GUICtrlSetCursor (-1, 0)
  Global $ab_label_copyright = GUICtrlCreateLabel($__copyright__, 152, 33, 87, 17, $WS_GROUP)
  GUICtrlSetOnEvent(-1, "ab_labelClick")
  Global $ab_label_name = GUICtrlCreateLabel("Mikaël Mayer", 152, 66, 67, 17, $WS_GROUP)
  GUICtrlSetOnEvent(-1, "ab_labelClick")
  Global $ab_label_email = GUICtrlCreateLabel("mikael.mayer@polytechnique.org", 152, 82, 160, 17)
  GUICtrlSetColor(-1, 0x008000)
  GUICtrlSetOnEvent(-1, "ab_linkClick")
  GUICtrlSetCursor (-1, 0)
  Global $ab_label_urlvideo = GUICtrlCreateLabel("http://www.youtube.com/watch?v=iHw6Hgs_qJ0", 16, 136, 241, 17, $WS_GROUP)
  GUICtrlSetColor(-1, 0x316AC5)
  GUICtrlSetOnEvent(-1, "ab_linkClick")
  GUICtrlSetCursor (-1, 0)
  GUICtrlCreateGroup("", -99, -99, 1, 1)
  Global $ab_ButtonOK = GUICtrlCreateButton($__ok_button__, 144, 166, 75, 25)
  GUICtrlSetOnEvent(-1, "ab_ButtonOKClick")
  #EndRegion ### END Koda GUI section ###
  WindowManager__registerWindow($AboutBox)
  If WinExists($main_window_handle) Then
    $pos = WinGetPos($main_window_handle, "")
    $pos2 = WinGetPos($AboutBox, "")
    WinMove($AboutBox, "", $pos[0]+$pos[2]/2-$pos2[2]/2, $pos[1]+$pos[3]/2-$pos2[3]/2)
  EndIf
EndFunc

Func DeleteAboutBox()
  If $ABOUT_BOX_EXISTS Then
    DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $AboutBox, "int", 100, "long", 0x00050002);slide out to left
    GUIDelete($AboutBox)
    $ABOUT_BOX_EXISTS = False
  EndIf
EndFunc

Func ab_linkClick()
  $nMsg = @GUI_CtrlId
  Switch $nMsg
    Case $ab_label_urlvideo
      ShellExecute(GUICtrlRead($ab_label_urlvideo))
    Case $ab_label_site
      ShellExecute(GUICtrlRead($ab_label_site))
    Case $ab_label_email
      ShellExecute('mailto:'&GUICtrlRead($ab_label_email)&'?subject='&$I_love_the_Reflex_Renderer)
    ;Case Else
    ;  If Not WinActive($AboutBox) Then WinActivate($AboutBox)
  EndSwitch
EndFunc

Func aboutBox($main_window_handle)
  ;Opt('GUIOnEventMode', 0)
  $abe_save = $ABOUT_BOX_EXISTS
  GenerateAboutBox($main_window_handle)

  ;#include "AboutBox_lang.au3"
  GUICtrlSetImage($ab_icon, @ScriptDir&"\Release\nice_function.JPG")
  If Not $abe_save Then
    DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $AboutBox, "int", 100, "long", 0x00040001);slide in from left
  EndIf
  GUISetState(@SW_SHOW)
  Return
  While 1
    $nMsg = GUIGetMsg()
    logging($nMsg)
    Switch $nMsg
    Case $GUI_EVENT_CLOSE
      If WinActive($AboutBox, "") Then
        ExitLoop
      Else
        WinActivate($AboutBox)
      EndIf
    Case $ab_ButtonOK
      ExitLoop
    Case $ab_label_urlvideo
      ShellExecute(GUICtrlRead($ab_label_urlvideo))
    Case $ab_label_site
      ShellExecute(GUICtrlRead($ab_label_site))
    Case $ab_label_email
      ShellExecute('mailto:'&GUICtrlRead($ab_label_email)&'?subject='&$I_love_the_Reflex_Renderer)
    Case 0
    Case -11
    Case Else
      If Not WinActive($AboutBox) Then WinActivate($AboutBox)
    EndSwitch
  WEnd
  DeleteAboutBox()
  Opt('GUIOnEventMode', 1)
EndFunc

Func ab_ButtonOKClick()
  AboutBoxClose()
EndFunc

Func AboutBoxClose()
  If WinActive($AboutBox, "") Then
    DeleteAboutBox()
    Opt('GUIOnEventMode', 1)
  Else
    WinActivate($AboutBox)
  EndIf
EndFunc
Func AboutBoxMinimize()
EndFunc
Func AboutBoxMaximize()
EndFunc
Func AboutBoxRestore()
EndFunc
Func ab_labelClick()
EndFunc

