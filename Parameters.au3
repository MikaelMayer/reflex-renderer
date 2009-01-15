#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mikaël Mayer

 Script Function:
	Stores all customizable parameters of ReflexRenderer

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#include "GlobalUtils.au3"

Global $Global_Parameters = emptySizedArray()
Global Enum $PARAM_STRING, $PARAM_DROPDOWN, $PARAM_BOOL, $PARAM_INT
Global Enum $N_PARAM_VANAME, $N_PARAM_TYPE, $N_PARAM_DEFAULTVALUE, $N_PARAM_PRIORITY ; Priority to determine (for useless properties for example)

push($Global_Parameters, _ArrayCreate("lang_folder",            $PARAM_STRING,      "lang"))
push($Global_Parameters, _ArrayCreate("bin_dir",                $PARAM_STRING,      @ScriptDir&'\Release\'))
push($Global_Parameters, _ArrayCreate("color_out_zooming_box",  $PARAM_DROPDOWN,    "gray.bmp", _ArrayCreate("black.bmp", "gray.bmp")))
push($Global_Parameters, _ArrayCreate("color_in_zooming_box",   $PARAM_DROPDOWN,    "black.bmp", _ArrayCreate("black.bmp", "gray.bmp")))
push($Global_Parameters, _ArrayCreate("history_formula_filename", $PARAM_STRING,    "history_formulas.txt"))
push($Global_Parameters, _ArrayCreate("color_NaN_complex",      $PARAM_STRING,      "0xFFFFFF"))
push($Global_Parameters, _ArrayCreate("animated_zoom",          $PARAM_BOOL,        True))
push($Global_Parameters, _ArrayCreate("threshold_zoom_drag",    $PARAM_INT,         2))
push($Global_Parameters, _ArrayCreate("history_formula_filename",$PARAM_STRING,     @ScriptDir&"\"&"history_formulas.txt"))


GetParameters()
AssignParameters()

Global $RenderReflexExe = $bin_dir&"RenderReflex.exe"

;Open ini file and read it.
Func GetParameters()
EndFunc

Func AssignParameters()  
  For $i=1 To $Global_Parameters[0]
    $tab = $Global_Parameters[$i]
    Assign($tab[$N_PARAM_VANAME], $tab[$N_PARAM_DEFAULTVALUE], 2)
  Next
EndFunc