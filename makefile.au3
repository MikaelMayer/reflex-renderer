#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mikaël Mayer

 Script Function:
  Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <Array.au3>

$zip_file = "ReflexRendererv2.1.zip"

$folderout = "ReflexRendererv2.5.01beta"

$filescript1 = "ReflexRenderer.au3"
$filescript2 = "LoadFormulaFromFile.au3"
$filescript3 = "AboutBox.au3"
$filescript4 = "SaveBox.au3"
$filescript6 = "EditFormula.au3"
$filescript5 = "IniHandling.au3"
$filescript7 = "translations.au3"
$filescript8 = "JpegHandling.au3"

$filebinout  = $folderout&"\ReflexRenderer.exe"
$fileini     = "ReflexRenderer.ini"
;$filetrad    = "translations.ini"
;$filetrad_en    = "translations_en.ini"
$filereadme  = "Readme.txt"
$filebin     = "Release\RenderReflex.exe"
$filenoir    = "Release\noir.bmp"
$filegris    = "Release\gris.bmp"
$fileimg    =  "Release\nice_function.jpg"
$fileico    =  "Release\nice_function.ico"
$filecolcod =  "Release\RenderCodeColor.JPG"
$filecolico =  "Release\RenderCodeColor.ico"

$dirtrad    = "lang"

$dependencies = _ArrayCreate($filescript1)
_ArrayAdd($dependencies, $filescript2)
_ArrayAdd($dependencies, $filescript3)
_ArrayAdd($dependencies, $filescript4)
_ArrayAdd($dependencies, $filescript5)
_ArrayAdd($dependencies, $filescript6)
_ArrayAdd($dependencies, $filescript7)
_ArrayAdd($dependencies, $filescript8)
;_ArrayAdd($dependencies, $filetrad)
;_ArrayAdd($dependencies, $filetrad_en)
_ArrayAdd($dependencies, $fileini)
_ArrayAdd($dependencies, $filereadme)
_ArrayAdd($dependencies, $filebin)
_ArrayAdd($dependencies, $filenoir)
_ArrayAdd($dependencies, $filegris)
_ArrayAdd($dependencies, $fileimg)
_ArrayAdd($dependencies, $fileico)
_ArrayAdd($dependencies, $dirtrad)
_ArrayAdd($dependencies, $filecolcod)
_ArrayAdd($dependencies, $filecolico)

;$fileini, _
$tocopy =  _ArrayCreate($filebin)
_ArrayAdd($tocopy, $filecolico)
_ArrayAdd($tocopy, $filereadme)
_ArrayAdd($tocopy, $filenoir)
_ArrayAdd($tocopy, $filegris)
_ArrayAdd($tocopy, $fileimg)
_ArrayAdd($tocopy, $filecolcod)
_ArrayAdd($tocopy, $filecolico)
;$filetrad_en, _
;$filetrad)

$dirtocopy = _ArrayCreate( _
$dirtrad)

assertAllFilesExist($dependencies)
If Not FileExists($folderout) Then
  DirCreate($folderout)
EndIf

$Aut2Exe = StringReplace(@AutoItExe, "AutoIt3.exe", "Aut2Exe\Aut2Exe.exe")
$cmd = StringFormat('%s /in "%s" /out "%s" /icon "%s" /nopack', $Aut2Exe, @ScriptDir&'\'&$filescript1, @ScriptDir&'\'&$filebinout, @ScriptDir&'\'&$fileico)
;MsgBox(0, "", $cmd)
RunWait($cmd)
copyAllFiles($tocopy, $folderout)
copyAllDirectories($dirtocopy, $folderout)
compressAll($folderout, $zip_file)

Func assertFileExists($filename)
  If FileExists($filename)== 0 Then
    MsgBox(0, "Erreur", "The file '"&$filename&"' does not exist but is required!"&@CR&"Cancelling compilation process...")
    Exit
  EndIf
EndFunc

Func assertAllFilesExist($listfilename)
  For $filename In $listfilename
    assertFileExists($filename)
  Next
EndFunc

Func copyAllFiles($arrayFiles, $folder)
  For $filename In $arrayFiles
    FileCopy($filename, $folder&"\"&$filename, 9)
  Next
EndFunc

Func copyAllDirectories($arrayDirs, $folder)
  For $dirname In $arrayDirs
    DirCopy($dirname, $folder&"\"&$dirname, 1)
  Next
EndFunc

Func compressAll($folderout, $zip_file)
  Return
  Run("explorer.exe"&" "&@ScriptDir)
  WinWaitActive("RenderReflex")
  Exit
  Send("!f")
  Send("n")
  Send("{UP}")
  Send("{ENTER}")
  Send($zip_file)
  Send("{ENTER}")
  Exit
  If FileExists($zip_file) Then
    FileDelete($zip_file)
  EndIf
EndFunc