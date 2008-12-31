#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mikaël Mayer

 Script Function:
  Run Koda (Interface Editor for AutoIt3 GUI sections) and/or updates everything

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Array.au3>
#include <GUIConstantsEx.au3>

Opt('TrayIconDebug', 1)

Global $interfacesToUpdate = _ArrayCreate( _
 _ArrayCreate("ReflexRendererInterface.kxf",   "ReflexRenderer.au3",      True), _
 _ArrayCreate("ReflexRendererEditFormula.kxf", "EditFormula.au3",         True), _
 _ArrayCreate("ReflexRendererFormulaList.kxf", "LoadFormulaFromFile.au3", True), _
 _ArrayCreate("ReflexRendererSaveBox.kxf",     "SaveBox.au3",             True), _
 _ArrayCreate("ReflexRendererAboutBox.kxf",    "AboutBox.au3",            True), _
 _ArrayCreate("ReflexRendererVariables.kxf",   "Variables.au3",           True) _
)

;updateInterfaces()
;testFunctions()

Dim $interfacesEdit[UBound($interfacesToUpdate)]
Dim $interfacesUpdate[UBound($interfacesToUpdate)]
Dim $title = "Update interfaces"
Dim $step = 41, $offset = 10
$width = 150
$width2 = 150
GUICreate($title, $width + $width2, 500)
$i = 0
$all_button = GUICtrlCreateButton("Update all!", 20, $step*$i+$offset, $width-40)
$i += 1
GUICtrlCreateLabel("Edit", 20, $step*$i+$offset, $width-40)
GUICtrlCreateLabel("Update", 20+$width, $step*$i+$offset, $width2-40)
$i += 1
$i0 = $i
For $interface in $interfacesToUpdate
  ConsoleWrite("Position: "&($step*$i+$offset)&@CRLF)
	$interfacesEdit[$i-$i0] = GUICtrlCreateButton($interface[1], $offset, $step*$i+$offset, $width-20)
	$interfacesUpdate[$i-$i0] = GUICtrlCreateButton($interface[1], $offset+$width, $step*$i+$offset, $width2-20)
	$i += 1
Next
WinMove($title, "", Default, Default, $width + $width2, ($i+1)*$step+$offset)
GUISetState(@SW_SHOW)

While True
  $nMsg = GUIGetMsg()
  Switch $nMsg
  Case $GUI_EVENT_CLOSE
    ExitLoop
  Case $all_button
    updateInterfaces()
    updateTraductions()
    ExitLoop
  Case Else
    $i = 0
    for $ctrl in $interfacesEdit
      if $ctrl == $nMsg Then
        $pp = $interfacesToUpdate[$i]
        ShellExecute($pp[0])
        WinWaitActive("Koda","")
        WinWaitClose("Koda")
        updateFile($pp)
        updateTraductions()
      EndIf
      $i += 1
    Next
    $i = 0
    for $ctrl in $interfacesUpdate
      if $ctrl == $nMsg Then
        $pp = $interfacesToUpdate[$i]
        updateFile($pp)
        updateTraductions()
      EndIf
      $i += 1
    Next
  EndSwitch
WEnd

Func updateTraductions()
	RunWait(@AutoItExe&' "'&@ScriptDir&'\GenerateLanguageFile2.au3"')
EndFunc

Func updateInterfaces()
  For $pp in $interfacesToUpdate
	;$res =  MsgBox(32+3, "Update following?", $pp[1], 5)
	;If $res == 2 Then ExitLoop
	;If $res == 7 Then ContinueLoop
    updateFile($pp)
  Next
EndFunc
Func updateFile($pp)
  $copy_file = StringReplace($pp[1], ".au3", "_tmp.au3")
  $interface_file = $pp[0]
  $autoit_file_string = $pp[1]
  $onevent = $pp[2]
  ShellExecute($interface_file)
  WinWaitActive("Koda","")
  If Not $onevent Then
    ;Convert code to non-event loop
    Send("^{F9}")
    WinWaitActive("Génération", "")
    $delay = 200
    Sleep($delay)
    Send("{TAB 5}")
    Sleep($delay)
    Send("{SPACE}")
    Sleep($delay)
    Send("{TAB 2}")
    Sleep($delay)
    Send("{SPACE}")
    Sleep($delay)
    Send("{TAB 3}")
    Send("{ENTER}")
  Else
    Send("{F9}")
  EndIf
  WinWaitActive("Code", "")
  Send("!c")
  WinClose("Koda")
  If Not $onevent Then
    Sleep(300)
    Send("n")
  EndIf
  WinWaitClose("Koda","")
  $interface_content = StringSplit(ClipGet(), @CRLF, 1)
  $autoit_file = FileOpen($autoit_file_string, 0)
  $autoit_content = StringSplit(FileRead($autoit_file), @CRLF, 1)
  FileClose($autoit_file)
  _ArrayDelete($autoit_content, 0)
  _ArrayDelete($interface_content, 0)
  
  ;MsgBox(0, "Autoit content", $autoit_content[50])
  ;MsgBox(0, "Form content", $interface_content[20])
  ; TODO
  ;Allocate new array
  $new_autoit_content = _ArrayCreate(0)
  ;Determine when #Region is in autoit_content and interface_content
  $begin_region_autoit    = posRegion($autoit_content)
  $end_region_autoit      = posEndRegion($autoit_content)
  $begin_region_interface = posRegion($interface_content)
  $end_region_interface   = posEndRegion($interface_content)
  If $begin_region_autoit == -1 Or $end_region_autoit < $begin_region_autoit Or _
$begin_region_interface == -1 Or $end_region_interface < $begin_region_interface Then
    MsgBox(0, StringFormat("Error in %s or in its interface", $autoit_file), StringFormat("Bad #region - #endregion formatting"))
    ConsoleWriteError($begin_region_autoit&@CRLF)
    ConsoleWriteError($end_region_autoit&@CRLF)
    ConsoleWriteError($begin_region_interface&@CRLF)
    ConsoleWriteError($end_region_interface&@CRLF)
    ConsoleWrite(_ArrayToString($interface_content, @CRLF))
    Exit
  EndIf
  
  ;Copy everything before to the new array
  
  $index_autoit = 0
  $index_interface = $begin_region_interface
  $max_index_autoit    = UBound($autoit_content)
  $max_index_interface = UBound($interface_content)
  ;Complete with the original lines of autoit_content
  While $index_autoit < $begin_region_autoit
    _ArrayAdd($new_autoit_content, $autoit_content[$index_autoit])
    $index_autoit += 1
  WEnd
  ;Remove the previous line containing GUISetState(@SW_SHOW) => -1
  ;Copy the interface content up to #endregion
  While $index_interface < $end_region_interface - 1
    $sentence = $interface_content[$index_interface]
    $sentence2 = StringRegExpReplace($sentence, '\"\%(.*?)\%\"', '$\1')
    If $sentence2<>$sentence Then
      $sentence = StringReplace($sentence2, "&", "")
    EndIf
    _ArrayAdd($new_autoit_content, $sentence)
    $index_interface += 1
  WEnd
  $index_autoit = $end_region_autoit
  ;Complete with the original lines of autoit_content
  While $index_autoit < $max_index_autoit
    _ArrayAdd($new_autoit_content, $autoit_content[$index_autoit])
    $index_autoit += 1
  WEnd
  _ArrayDelete($new_autoit_content, 0)
  ;Create the new file and fill it with the new content
  $new_file = FileOpen($copy_file, 2)
  FileWrite($new_file, _ArrayToString($new_autoit_content, @CRLF)) 
  FileClose($new_file)
  
  ;Make an unique copy of the original file
  $i = 0
  ConsoleWrite(StringFormat("Copying from %s to %s"&@CRLF, $autoit_file_string, "tmp\snapshot"&$i&"\"&$autoit_file_string))
  While FileCopy($autoit_file_string, "tmp\snapshot"&$i&"\"&$autoit_file_string, 8)==0
    $i += 1
  WEnd
  FileCopy($autoit_file_string, "tmp\curent\"&$autoit_file_string, 9)
  
  ;Move the new file to the original file
  ;MsgBox(0, "Deleting", FileDelete($autoit_file_string))
  FileMove($copy_file, $autoit_file_string, 1)
  ClipPut("")
EndFunc

Func pos($array, $prefixString)
  ;TODO: To be stripped!
  $i = 0
  $found = False
  For $string in $array
    $string = StringStripWS($string, 3)
    If StringCompare(StringLeft($string, Stringlen($prefixString)), $prefixString, 0)==0 Then
      $found = True
      ExitLoop
    EndIf
    $i += 1
  Next
  If $found Then
    Return $i
  Else
    Return -1
  EndIf
EndFunc

Func posRegion($array)
  return pos($array, "#region")
EndFunc

Func posEndRegion($array)
  return pos($array, "#endregion")
EndFunc

Func testFunctions()
  $ar = _ArrayCreate("rale", "mik", "abc", "def", "det")
  assertPosGood($ar, "mik", 1)
  assertPosGood($ar, "def", 3)
  assertPosGood($ar, "de", 3)
  assertPosGood($ar, "det", 4)
  assertPosGood($ar, "dett", -1)
  ConsoleWrite(@CRLF&"Tests finished."&@CRLF)
EndFunc

Func assertPosGood($ar, $str, $pos)
  $result = pos($ar, $str)
  If $result <> $pos Then
    ConsoleWriteError(StringFormat(@CRLF&"Position of %s in the array"&@CRLF&"%s"&@CRLF&" is not %d, but %d instead.", $str, _ArrayToString($ar, ", "), $pos, $result))
  EndIf
EndFunc