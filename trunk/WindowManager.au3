#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mikaël Mayer
 Date:           2008 /10/21
 Script Function:
  Controlls the available windows of the project.

#ce ----------------------------------------------------------------------------
#include-once
#include "translations.au3"
#include "GlobalUtils.au3"
#include "WindowManager.au3"
#include <GuiConstants.au3>

Global $wm_project_windows = emptySizedArray()

Func WindowManager__registerWindow($win_handle)
  push($wm_project_windows, $win_handle)
EndFunc

Func WindowManager__unregisterWindow($win_handle)
  deleteElement($wm_project_windows, $win_handle)
EndFunc

Func WindowManager__getAllWindowHandles()
  return $wm_project_windows
EndFunc

Func WindowManager__AllWinSetState($flag)
  For $i = 1 To $wm_project_windows[0]
    ;_SendMessage($wm_project_windows[$i], $WM_SYSCOMMAND, 0xF020, 0)
    Switch $flag
    Case @SW_MINIMIZE
      DllCall("user32.dll", "int", "PostMessage", "hwnd", $wm_project_windows[$i], "int", $WM_SYSCOMMAND, "int", 0xF020, "long", 0)
    Case @SW_MAXIMIZE
      DllCall("user32.dll", "int", "PostMessage", "hwnd", $wm_project_windows[$i], "int", $WM_SYSCOMMAND, "int", 0xF030, "long", 0)
    Case @SW_RESTORE
      DllCall("user32.dll", "int", "PostMessage", "hwnd", $wm_project_windows[$i], "int", $WM_SYSCOMMAND, "int", 0xF120, "long", 0)
    Case Else
      WinSetState($wm_project_windows[$i], "", $flag)
    EndSwitch
  Next
EndFunc

Func WindowManager__minimizeAll()
  WindowManager__AllWinSetState(@SW_MINIMIZE)
EndFunc

Func WindowManager__restoreAll()
  WindowManager__AllWinSetState(@SW_RESTORE)
EndFunc

