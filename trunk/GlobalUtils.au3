#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mikaël Mayer
 Date:          10/08/2008

 Script Function:
	Util functions for Reflex Renderer

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#include "Parameters.au3"
#include "IniHandling.au3"
#include <GDIPlus.au3>
#include <Array.au3>
#include <Date.au3>

Global Const $VERSION_NUMER = "2.8.2 beta"
Global Const $COPYRIGHT_DATE = "2009"

Global $ERROR_DECODE_HANDLING = ""
Global Const $EmptySizedArray = emptySizedArray()
Global Const $LENGTH_SIZED_ARRAY_INDEX = 0

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

;Removes the first element of the sized array
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

Func insert(ByRef $queue, $element, $index)
  insertAfter($queue, $element, $index-1)
EndFunc

Func insertAfter(ByRef $queue, $element, $index)
  ;Logging("inserting "&formulaItemToString($element)&" into a queue")
  If $index+1 > size($queue) Then 
    push($queue, $element)
  Else
    _ArrayInsert($queue, $index+1, $element)
    $queue[0] += 1
  EndIf
EndFunc

;Inserts the obj = [a, b, c] in queue sorted on the first element
Func insertSortedObj(ByRef $queue, $obj, $increasing=True)
  ; Linear insertion... not that bad.
  For $i = 1 to size($queue)
    $el = $queue[$i]
    If $el[0] > $obj[0] and $increasing Then
      insert($queue, $obj, $i)
      Return
    EndIf
    If $el[0] < $obj[0] and Not $increasing Then
      insert($queue, $obj, $i)
      Return
    EndIf
  Next
  push($queue, $obj)
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

Func arrayDiff($t1, $t2)
  Local $result[UBound($t1)]
  For $i = 0 To UBound($t1) - 1
    $result[$i] = $t1[$i] - $t2[$i]
  Next
  Return $result
EndFunc

Func leftTopWithHeight_to_leftTopRightBottom($pos)
  $pos[2] = $pos[2] + $pos[0]
  $pos[3] = $pos[3] + $pos[1]
  Return $pos
EndFunc

Func leftTopRightBottom_to_leftTopWithHeight($pos)
  $pos[2] = $pos[2] - $pos[0]
  $pos[3] = $pos[3] - $pos[1]
  Return $pos
EndFunc


Func toString($element)
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

Func FileBaseName($longFileName)
  Return StringRegExpReplace($longFileName, ".*\\", "")
EndFunc

Func FileFolder($longFileName)
  Return StringLeft($longFileName, StringLen($longFileName) - StringLen(FileBaseName($longFileName)))
EndFunc

Func FileReplaceContent($file_name, $file_name_after, $to_search, $to_replace)
  $fi = FileOpen($file_name, 0)
  $fo = FileOpen($file_name_after&"_tmp", 2)
  While True
    $l = FileReadLine($fi)
    If @error <> 0 Then ExitLoop
    FileWriteLine($fo, StringReplace($l, $to_search, $to_replace))
  WEnd
  FileClose($fi)
  FileClose($fo)
  FileMove($file_name_after&"_tmp", $file_name_after, 1)
EndFunc

Func ImageConvert($previous_image, $after_image)
  _GDIPlus_Startup ()
  $hImage = _GDIPlus_ImageLoadFromFile($previous_image)
  _GDIPlus_ImageSaveToFile($hImage, $after_image)
  _GDIPlus_ImageDispose ($hImage)
  _GDIPlus_ShutDown ()
EndFunc

Func Logging($str, $line = @ScriptLineNumber)
  If Not @Compiled Then
    ConsoleWrite("Line:"&$line&": "&_NowCalc()&" : "&$str&@CRLF)
  EndIf
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
  If $value <> "" Or Not IsString($value) Then
    If StringLeft($value, 1) == "-" Then
      Return StringFormat(' --%s " %s"', $flag, $value)
    Else
      Return StringFormat(' --%s "%s"', $flag, $value)
    EndIf
  Else
    Return StringFormat(' --%s', $flag)
  EndIf
EndFunc

Func addFlag(ByRef $flags, $new_flag, $new_value="")
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

;$RenderReflexExe should be declared outside in global (like in Parameters.au3)
Func runReflexWithArguments($args)
  $cmd = StringFormat("%s %s", $RenderReflexExe, $args)
  ;logging("Running "&$cmd)
  Return Run($cmd, '', @SW_HIDE, 2+4)
EndFunc

Func complex_calculate($expr)
  ;logging("Calculating "&$expr)
  Dim $flags = ""
  addFlag($flags, "simplify")
  addFlag($flags, "formula", $expr)
  ;$flags = $formula_flag&$seed_flag
  $p = runReflexWithArguments($flags)
  $found = False
  $result = 0
  While True
    $text = StdoutRead($p)
    If @error Then ExitLoop
    ;BUG / TODO: Error if the std output is truncated.
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

; Returns the number of processors of this machine
Func getNumberOfProcessors()
  $test = 0
  While RegRead("HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\"&$test, "~MHz") <> ""
    $test += 1
  WEnd
  return $test
EndFunc


;=============== String management =============== 

;Returns a boolean indicating if the string starts with a certain prefix (case insensitive)
Func StringStartsWith($str, $start)
  REturn StringCompare(StringLeft($str, StringLen($start)), $start)==0
EndFunc

;Returns a boolean indicating if the string ends with a certain postfix (case insensitive)
Func StringEndsWith($str, $end)
  Return StringCompare(StringRight($str, StringLen($end)), $end)==0
EndFunc

;Return a boolean indicating if the $str contains some characters present in $char_str
Func StringContains($str, $char_str)
  For $i = 1 To StringLen($str)
    If StringInStr($char_str, StringMid($str, $i, 1)) Then Return True
  Next
  Return False
EndFunc

Func replaceVariableString($string, $varname, $varvalue)
  $varname = StringReplace(StringStripWS($varname, 3), "$", "\$")
  If StringContains($varvalue, "+*-/()") Then $varvalue = "("&$varvalue&")"
  $string = StringRegExpReplace($string, $varname&"([^[:alnum:]]|\z)", $varvalue&"\1")
  Return $string
EndFunc

Func StringSizeMin($str, $length, $add_char = " ")
  While StringLen($str) < $length
    $str = $str & $add_char
  WEnd
  Return $str
EndFunc

; Animation and windows

Func AnimateFromTopLeft($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 200, "long", 0x00040005);diag slide-in from Top-left
  GUISetState(@SW_SHOW, $win)
EndFunc

Func AnimateToTopRight($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 200, "long", 0x00050009);diag slide-out to Top-Right
EndFunc

Func AnimateToBottomRight($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 200, "long", 0x00050005);diag slide-out to Bottom-right
EndFunc

Func AnimateFromTop($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 100, "long", 0x00040004);diag slide-in from Top
  GUISetState(@SW_SHOW, $win)
EndFunc

Func AnimateToTop($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 100, "long", 0x00050008);slide-out to Top
EndFunc

Func AnimateFromLeft($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 100, "long", 0x00040001);slide in from left
EndFunc

Func AnimateToLeft($win)
  DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $win, "int", 100, "long", 0x00050002);slide out to left
EndFunc


;Moves a LTRB (left/top/right/bottom) rectangle $pos_child_ltrb given that a rectangle moved from $pos_before_ltrb to $pos_after_ltrb
Func move_ltrb(ByRef $pos_child_ltrb, ByRef $pos_before_ltrb, ByRef $pos_after_ltrb)
  
  Local $x_dep = 0, $y_dep = 0
  
  ;If the window can be hit if the window moves left or right
  ;logging(toString($pos_child_ltrb)&","&toString($pos_before_ltrb)&","&toString($pos_after_ltrb))
  If Not ($pos_child_ltrb[3] <= $pos_before_ltrb[1] Or $pos_child_ltrb[1] >= $pos_before_ltrb[3]) Then
    If $pos_child_ltrb[2] <= $pos_before_ltrb[0] Then $x_dep = $pos_after_ltrb[0] - $pos_before_ltrb[0]
    If $pos_child_ltrb[0] >= $pos_before_ltrb[2] Then $x_dep = $pos_after_ltrb[2] - $pos_before_ltrb[2]
  Else
    $x_dep = ($pos_after_ltrb[0] - $pos_before_ltrb[0] + $pos_after_ltrb[2] - $pos_before_ltrb[2])/2
  EndIf
  ;If the window can be hit if the window moves top or bottom
  If Not ($pos_child_ltrb[2] <= $pos_before_ltrb[0] Or $pos_child_ltrb[0] >= $pos_before_ltrb[2]) Then
    If $pos_child_ltrb[3] <= $pos_before_ltrb[1] Then $y_dep = $pos_after_ltrb[1] - $pos_before_ltrb[1]
    If $pos_child_ltrb[1] >= $pos_before_ltrb[3] Then $y_dep = $pos_after_ltrb[3] - $pos_before_ltrb[3]
  Else
    $y_dep = ($pos_after_ltrb[1] - $pos_before_ltrb[1] + $pos_after_ltrb[3] - $pos_before_ltrb[3])/2
  EndIf
  $pos_child_ltrb[0] += $x_dep
  $pos_child_ltrb[2] += $x_dep
  $pos_child_ltrb[1] += $y_dep
  $pos_child_ltrb[3] += $y_dep
EndFunc

; =============== Timeout control =================;

Global Const $global_timer = TimerInit()
Global $global_timeout_functions = emptySizedArray()

; Timeout class declaration
; Timeout:Timer,FunctionName
Global Enum $N_Timeout_Timer, $N_Timeout_FunctionName, $N_Timeout_size

Func setTimeout_Timer(ByRef $obj, $value)
  $obj[$N_Timeout_Timer] = $value
EndFunc ;==> setTimeout_Timer
Func getTimeout_Timer($obj)
  Return $obj[$N_Timeout_Timer]
EndFunc ;==> getTimeout_Timer

Func setTimeout_FunctionName(ByRef $obj, $value)
  $obj[$N_Timeout_FunctionName] = $value
EndFunc ;==> setTimeout_FunctionName
Func getTimeout_FunctionName($obj)
  Return $obj[$N_Timeout_FunctionName]
EndFunc ;==> getTimeout_FunctionName

; Timeout constructor
Func newTimeout($Timer, $FunctionName)
  Local $result[$N_Timeout_size]
  $result[$N_Timeout_Timer]        = $Timer
  $result[$N_Timeout_FunctionName] = $FunctionName
  Return $result
EndFunc ;==> newTimeout

Func setTimeout($function_name, $timeout)
  $now = TimerDiff($global_timer)
  insertSortedObj($global_timeout_functions, newTimeout($now + $timeout, $function_name))
EndFunc

Func setTimeout_external($command, $timeout)
  Local $arguments = ' timeout '&$timeout&' "'&$command&'"'
  If @Compiled Then
    Run(@ScriptFullPath&$arguments)
  Else
    Run('"'&@AutoItExe&'" "'&@ScriptFullPath&'"'&$arguments)
    logging('"'&@AutoItExe&'" "'&@ScriptFullPath&'"'&$arguments)
  EndIf
EndFunc

Func cancelAllTimeouts($function_name)
  For $i = size($global_timeout_functions) To 1 step -1
    If StringCompare(getTimeout_FunctionName($global_timeout_functions[$i]), $function_name)==0 Then
      deleteAt($global_timeout_functions, $i)
    EndIf
  Next
EndFunc

Func cancelAllTimeoutsStartingWith($function_name)
  For $i = size($global_timeout_functions) To 1 step -1
    If StringStartsWith(getTimeout_FunctionName($global_timeout_functions[$i]), $function_name) Then
      deleteAt($global_timeout_functions, $i)
    EndIf
  Next
EndFunc

Func parseTimeOutFunctions()
  If size($global_timeout_functions) > 0 Then
    ;Logging(TimerDiff($global_timer)&" should get bigger than "&getTimeout_Timer($global_timeout_functions[1]))
    If TimerDiff($global_timer) > getTimeout_Timer($global_timeout_functions[1]) Then
      Local $function = getTimeout_FunctionName($global_timeout_functions[1])
      deleteAt($global_timeout_functions, 1)
      Call($function)
      If @error = 0xDEAD And @extended = 0xBEEF Then
        logging("Error: Function '"&$function&" does not exist")
      EndIf
    EndIf
  EndIf
EndFunc

; ==================== Testing ====================;

Func AssertEqual($a, $b, $e="")
  If $a <> $b Then
    If $e <> "" Then $e = " : "&$e
    MsgBox(0, "Assertion error", StringFormat("%s != %s"&$e, $a, $b))
    Exit
  EndIf
EndFunc
