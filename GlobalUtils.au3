#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mika�l Mayer
 Date:          10/08/2008

 Script Function:
	Util functions for Reflex Renderer

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#include "IniHandling.au3"
#include <Array.au3>
#include <Date.au3>

Global $ERROR_DECODE_HANDLING = ""
Global $bin_dir = @ScriptDir&'\Release\'

If @Compiled Then
  Opt('TrayIconHide', 1)
Else
  Opt('TrayIconDebug', 1)
EndIf

;Manipulating Array which can be empty
Func size(ByRef $SizedArray)
  return $SizedArray[0]
EndFunc

Func emptyQueue()
  Return _ArrayCreate(0)
EndFunc

Func emptySizedArray()
  Return _ArrayCreate(0)
EndFunc

Func pop(ByRef $queue)
  $tmp = $queue[1]
  _ArrayDelete($queue, 1)
  $queue[0] -= 1
  Return $tmp
EndFunc

Func push(ByRef $queue, $element)
  _ArrayAdd($queue, $element)
  $queue[0] += 1
EndFunc

Func insertAfter(ByRef $queue, $element, $index)
  ;Logging("inserting "&formulaItemToString($element)&" into a queue")
  If $index+1 > $queue[0] Then 
    push($queue, $element)
  Else
    _ArrayInsert($queue, $index+1, $element)
    $queue[0] += 1
  EndIf
EndFunc

Func deleteAt(ByRef $queue, $index)
  If $index > $queue[0] or $index < 1 Then 
    Return
  Else
    _ArrayDelete($queue, $index)
    $queue[0] -= 1
  EndIf
EndFunc

Func indexOf(ByRef $queue, $element)
  For $i=1 To $queue[0]
    If $queue[$i] == $element Then Return $i
  Next
  Return 0
EndFunc

Func deleteElement(ByRef $queue, $element)
  deleteAt($queue, indexOf($queue, $element))
EndFunc

Func isEmpty(ByRef $queue)
  Return $queue[0]==0
EndFunc

Func isNotEmpty(ByRef $queue)
  Return $queue[0]<>0
EndFunc

Func toBasicArray(ByRef $queue)
  _ArrayDelete($queue, 0)
EndFunc

Func toString(ByRef $element)
  Local $res = ""
  If IsArray($element) Then
    Local $first = True
    $res = "["
    For $el in $element
      If $first Then
        $res &= toString($el)
        $first = False
      Else
        $res &= ", "&toString($el)
      EndIf
    Next
    $res &= "]"
  ElseIf IsString($element) Then
    $res = """"&$element&""""
  Else
    $res = String($element)
  EndIf
  If Not isArray($element) and StringLen($res)>1000 Then
    $res = StringLeft($res, 1000)&"..."
  EndIf
  Return $res
EndFunc

Func concatenate(ByRef $array, $array2)
  For $element in $array2
    _ArrayAdd($array, $element)
  Next
EndFunc

Func makeFileName($str)
  $badchars = StringSplit('*?\/""|<>:', '')
  _ArrayDelete($badchars, 0)
  For $char in $badchars
    $str = StringReplace($str, $char, '')
  Next
  Return $str
EndFunc

Func reflexFileNameFromComment($formula_comment, $formula_filename, $reflex_extension)
  $comment = makeFileName($formula_comment)
  $pos = StringInStr($formula_filename,'\', 0, -1)
  While True
    if $pos == 0 Then ExitLoop
    $basefilename = StringMid($formula_filename, 1, $pos)
    $pos1 = StringInStr($reflex_extension,'.')
    if $pos1 == 0 Then ExitLoop
    $extension = StringMid($reflex_extension, $pos1, 4)
    Return $basefilename&$comment&$extension
  WEnd
  Return IniReadSaveBox('reflexFile', '')
EndFunc

Func Logging($str, $line = @ScriptLineNumber)
  ;ConsoleWrite(_NowCalc()&" line "&$line&": "&$str&@CRLF)
  ConsoleWrite("Line:"&$line&": "&_NowCalc()&" : "&$str&@CRLF)
  ;ConsoleWrite(_NowCalc()&" line "&$line&": "&$str&@CRLF)
EndFunc

Func isChecked($ctrl)
  $state = GUICtrlRead($ctrl)
  Return BitAND($state, $GUI_CHECKED)
EndFunc

Func SetFocus($hCtrl)
  GUICtrlSetState($hCtrl, $GUI_FOCUS)
EndFunc

Func ErrorDecodeAdd($string)
  logging("Adding '"&$string&"' to error string")
  $ERROR_DECODE_HANDLING &= @CRLF&$string
EndFunc

Func ErrorDecodeDisplay()
  ConsoleWriteError($ERROR_DECODE_HANDLING&@CRLF)
  logging("Error: "&$ERROR_DECODE_HANDLING)
  Return False
EndFunc

; Flag and complex management

Func createFlag($flag, $value)
  Return StringFormat(' "%s=%s"', $flag, $value)
EndFunc

Func addFlag(ByRef $flags, $new_flag, $new_value)
  $flags = $flags&createFlag($new_flag, $new_value)
EndFunc

Func isFormulaLine($line)
  Return StringCompare(StringLeft($line, 8), "formula:")==0
EndFunc

Func extractFormulaLine($line)
  Return StringMid($line, 9)
EndFunc

Func simplifyParenthesis($complex_number)
  While StringLeft($complex_number, 1)=='(' and StringRight($complex_number, 1)==')'
    $complex_number = StringMid($complex_number, 2, StringLen($complex_number) - 2)
  WEnd
  return $complex_number
EndFunc

Func complex_calculate($expr)
  ;logging("Calculating "&$expr)
  Dim $flags = ""
  addFlag($flags, "formula", $expr)
  ;$flags = $formula_flag&$seed_flag
  $p = Run(StringFormat("%sRenderReflex.exe simplify%s", $bin_dir, $flags), '', @SW_HIDE, 2+4)
  $found = False
  $result = 0
  While True
    $text = StdoutRead($p)
    If @error Then ExitLoop
    $lines = StringSplit($text, @CRLF, 1)
    For $i = 1 To $lines[0]
      $current_line = $lines[$i]
      ;Logging("Line to compare: "&$current_line)
      If isFormulaLine($current_line) Then
        ;Logging("Formula!")
        $result= extractFormulaLine($current_line)
        $found = True
        ExitLoop 2
      EndIf
    Next
  WEnd
  ProcessClose($p)
  If Not $found Then
    logging(StringFormat("%s has not been simplified", $expr))
  EndIf
  $result = simplifyParenthesis($result)
  Return $result
EndFunc


; String management

Func StringEndsWith($str, $end)
  Return StringCompare(StringRight($str, StringLen($end)), $end)==0
EndFunc

; Animation

Func AnimateFromTopLeft($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 200, "long", 0x00040005);diag slide-in from Top-left
  GUISetState(@SW_SHOW, $win)
EndFunc

Func AnimateFromTop($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 200, "long", 0x00040004);diag slide-in from Top-left
  GUISetState(@SW_SHOW, $win)
EndFunc

Func AnimateToTopRight($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 200, "long", 0x00050009);diag slide-out to Top-Right
EndFunc

Func AnimateToBottomRight($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 200, "long", 0x00050005);diag slide-out to Bottom-right
EndFunc

Func AnimateFromLeft($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 100, "long", 0x00040001);slide in from left
EndFunc

Func AnimateToLeft($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 100, "long", 0x00050002);slide out to left
EndFunc

;Testing

Func AssertEqual($a, $b)
  If $a <> $b Then
    MsgBox(0, "Assertion error", StringFormat("%s != %s and it's bad", $a, $b))
    Exit
  EndIf
EndFunc
