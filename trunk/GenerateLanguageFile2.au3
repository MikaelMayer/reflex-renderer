#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mika�l Mayer

 Script Function:
  ;Generates a language file for all strings in a file.
  
  If the string  either:
  - ends with "Click", "Change" or ".au3"
  - contains a "\"
  - is surrounded by '' instead of ""
  it will not be taken into account.

#ce ----------------------------------------------------------------------------

#include <Array.au3>

$filescript1 = "ReflexRenderer.au3"
$filescript2 = "LoadFormulaFromFile.au3"
$filescript3 = "AboutBox.au3"
$filescript4 = "SaveBox.au3"
;$filescript5 = "IniHandling.au3"
$filescript6 = "EditFormula.au3"
$filescript7 = "Variables.au3"
$filescript8 = "Tutorial.au3"

;$filescript5, _
Global $filestoextract

If $CmdLine[0] <> 0 Then
  $filestoextract = _ArrayCreate($CmdLine[1])
Else
$filestoextract = _ArrayCreate( _
$filescript1, _
$filescript2, _
$filescript3, _
$filescript4, _
$filescript6, _
$filescript7, _
$filescript8)
EndIf

;$initranslation = "translations.ini"
$translation_file = "translations.au3"

$strings = _ArrayCreate(0)

parseAllFiles($filestoextract)

Func makeVar($str)
  $tab = StringSplit($str, "")
  _ArrayDelete($tab, 0)
  $result = "$"
  $letter = 0
  For $char in $tab
    If StringInStr("abcdefghijklmnopqrstuvwxyz",$char) <> 0 Then
      $result = $result & $char
      $letter += 1
    ElseIf StringInStr("1234567890",$char) <> 0 Then
      $result = $result & $char
    Else
      $result = $result & "_"
    EndIf
  Next
  If $letter>2 Then
    Return $result
  Else
    Return ""
  EndIf
EndFunc

Func addString($string)
  If StringRight($string, 5) == "Click" _
Or StringRight($string, 6) == "Change" _
Or StringRight($string, 4) == ".au3" _
Or StringLen($string)==0 Then Return
  For $i = 1 To $strings[0]
    If $strings[$i] == $string Then Return
  Next
  _ArrayAdd($strings, $string)
  $strings[0] += 1
EndFunc

Func extractStrings($line, ByRef $matches)
  ; Extraction only if we find the pattern
  ; ($variable) = GUI.*Create.*("(.*)"
  $array = StringRegExp($line, '\$(\_\_\w*?\_\_)\b', 4)
  $e = @error
  If $e == 0 Then
    For $i = 0 to UBound($array) - 1
      $match = $array[$i]
      For $j = 0 to UBound($match) - 1
        $varname = $match[1]
        _ArrayAdd($matches, $varname)
      Next
    Next
  EndIf
EndFunc

Func parseFile($file)
  $f = FileOpen($file, 0) 
  $region = False
  $matches = _ArrayCreate(6)
  While True
    $line = FileReadLine($f)
    If @error == -1 Then ExitLoop
    ;If StringLeft(StringStripWS($line, 1), 10)=="#EndRegion" Then $region=False
    ;If $region Then
      extractStrings($line, $matches)
    ;EndIf
    ;If StringLeft(StringStripWS($line, 1), 7)=="#Region" Then $region=True
  WEnd
  FileClose($f)
  ;MsgBox(0 ,"tt", UBound($matches))
  If UBound($matches)==1 Then Return
  _ArrayDelete($matches, 0)
  $file_lang = $translation_file
  $f2 = FileOpen($file_lang, 0)
  $content_lang = FileRead($f2)
  FileClose($f2)
  
  For $match in $matches
    ;MsgBox(0, "", $match)
    ;$pos = StringInStr($content_lang, StringFormat("GUICtrlSetData($%s", $match[0]))
    ;TODO: detect updates, differences, etc.
    ;Special code when no traduction? ;NOTRAD $variable_name
    $regexp = """"&$match&""", .*?, '(.*?)', '.*?'\)"
    $array = StringRegExp($content_lang, $regexp, 4)
    $e = @error
    If $e == 0 Then
    ElseIf $e == 1 Then
      $r = MsgBox(3+32+256, "Nothing found in "&$file&" for", $match&@CRLF&"[yes]: Enter a traduction"&@CRLF&"[no]: Set no traduction"&@CRLF&"[Cancel]: Cancel process")
      If $r == 7 Then
      ElseIf $r == 2 Then
        Exit
      ElseIf $r == 6 Then
        $res = InputBox("Give a traduction", "Variable name: "&$match, $match)
        If $res<> "" Then
          $newline = StringFormat("add($affectations, ""%s"", $gui_section, '%s', '%s')", $match, $res, $res)
          $content_lang = StringReplace($content_lang, ";ADD_AFFECTATION", $newline&@CRLF&"  ;ADD_AFFECTATION", 1)
          ;IniWrite($initranslation, 'GUI', $match[0], $res)
        EndIf
        ;MsgBox(0, "R�sultat", StringRight($content_lang, 200))
      EndIf
      ;ElseIf $e == 2 Then
      ;  MsgBox(0, "Error "&$e, StringLeft($regexp, @extended))
      ;EndIf
    ElseIf $e == 2 Then
      MsgBox(0, "Error "&$e, StringLeft($regexp, @extended))
    EndIf
    ;If $pos == 0 Then
    ;  MsgBox(0, "Going to add this:", StringFormat("GUICtrlSetData($%s, _"&@CRLF&"IniRead($translation_ini, 'GUI', '%s', '%s'))", $match[0], $match[1], $match[1]))
    ;EndIf
    ;FileWriteLine($f2, StringFormat("GUICtrlSetData($%s, _"&@CRLF&"IniRead($translation_ini, 'GUI', '%s', '%s'))", $match[0], $match[1], $match[1]))
    ;IniWrite($initranslation, 'GUI', $match[1], $match[1])
  Next
  FileCopy($file_lang, $file_lang&"_tmp")
  $f2 = FileOpen($file_lang, 2)
  FileWrite($f2, $content_lang)
  FileClose($f2)
EndFunc

Func parseAllFiles($fileArray)
  For $file in $fileArray
    parseFile($file)
  Next
EndFunc