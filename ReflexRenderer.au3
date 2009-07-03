#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mikaël Mayer
 Date:           June 14, 2008
 Script Function:
  A user-friendly interface for the RenderReflex programm

Doing:
 - Reflex renderer video: Generate program to generate images (self-executable?) should be able to be loaded back

 Wish List:

 - If window reset / next / previous, smooth transition.
 - 'Reset all' button
 - Save/open session(s) in ini files
 - Axes
 - An option dialog box (gray/black zooming box, if save session when leaving, display axes, default NaN color, black rendering for realmode,
   how many formulas in history before it gets stored again, if stores in history and where, how many in local history, etc.)
 - Interface to render openOffice Formula

 Design questions:
 - Little "cancel" button close to the "Rentering..." label.
 - Ok - Appliquer - Annuler dans Savebox + indicateur s'il faut sauvegarder ou non
 
 Difficult/long:
 - Explanation and demo script / tutorial ?
 
 ===== Need feed-back or bug reproduction ====
 - Bug redim en 640 x 480 + zoom avant, pas bon le redimensionnement, à reproduire?

 ==== Erwin's notes ====
V Ne pas avoir besoin de cliquer pour relâcher le drag, quand on veut naviguer sur la réflex. Il faudrait que ça actualise lorsqu'on relâche le bouton de la souris.
V Ce serait bien d'avoir une infobulle pour les boutons de l'éditeur de formule comme 'o, oo, randf, randh, comp, prod, sum, circle, conj, imag et real', pour qu'on sache quelle est la syntaxe. Et à quoi sert la checkbox 'inv'
V Aussi, il serait souhaitable d'enregistrer aussi les coordonnées de l'image (windows Min et Max),
V Ajouter une option pour ne pas fermer l'éditeur de formule lorsqu'on fait 'draw'.
V Si le fichier jpg existe déjà, il sera remplacé, mais dans le fichier formulas.txt une nouvelle entrée sera ajoutée.
V Il faudrait qu'à chaque fichier corresponde une seule entrée dans formulas.txt.
  car la formule ne suffit pas forcément pour retrouver l'image.
V Il serait bien de pouvoir nommer automatiquement les fichiers avec le nom de la formule + les coordonnés, c'est une alternative au fichier txt à côté. Dans Save Reflex and/or Formula,
    * Ajouter une option dans la zone 'Save Reflex' pour nommer, préfixer ou suffixer le nom de fichier par la formule + éventuellement les coordonnées
    * Ajouter une Condition 'If file exists' > Replace, or > Rename (ajout d'un incrément pour différencier le fichier)
V "Libeller la Reflex comme la formule" m'a fait penser au début que ça mettrait la formule comme nom du fichier. Je remplacerais donc par "Utiliser le libellé comme nom du fichier". Mais en fait je n'ai pas réussi à mettre en évidence à quoi servait cette option.
- Au démarrage, il faudrait changer la seed automatiquement en utilisant l'heure ou un paramètre variable quelconque de l'ordi.
- Donner la possibilité de générer différentes fonctions aléatoires simplement en cliquant une fois de plus sur MàJ.


 ===== Done ====
 
Mik notes : 
 V Done the main script to render a video from an ini file.
 V Export to a readable OpenOffice formula string (renderreflex.exe --simplify --openoffice --formula "z+sqrt(x/y)")
 V Corrected bug when changing percentage, the internal width was not modified
 V Corrected bug because of intempestive width/height calculations.
 V Animated zoom. Threaded & exponential + parameter
 V Parallelized the save window.
 V Move/resize the main window => Move the children
 V Find how to store that there are some variables : [Variables], and when loading a session, loading these variables.
 V Corrected: BUG: file drag&drop does not work anymore.
 V Added a close methods for registered windows
 V Corrected a language changing bug.
 V Added closing animation to top for variables
 V Corrected redimensionnal bug for variable windows.
 V Added variable support + saving and loading variables and edit formula state.
 V Keeping the number of rendered pixels constant when changing the resolution
 V Minimizing/Maximizing the main window => do the same for the children
 V Syntax coloring in EditFormula highlights variables and strings containing numbers.
 V If press over "inv", labels "sin, cos, sinh" change to "arcsin", "arccos", "argsh" or color change?
 V [Bug] If no INI file is provided, or some values are missing (ex: seed hidden), should fill it automatically
 V PNG support (quick)...
 V Speed - Accelerate syntax coloring
 V Bug - Find why "Fracture dans toile" is not imported.
 V Bug - Find why "Autres" does not reset the tree
 V Resizable formula editor
 V Load the history_formulas file first and then do not read it again, just record the last 5 _ArrayPush (else it's slow)
 V ENTER in Edit formula mode submits the changes
 V All formulas which have been used are written to a common file (history_formulas.txt)
 V 1-click choose in the formula recovery (or formula import)
 V Coloration syntaxique
 V When saving, automatically detects if the last picture has just to be copied in HD and LR
 V Repair insertion/deletion in Edit box
 V Fonctions réelles!! (c'était le gros plus. Trouvé comment le faire en rendu graphique ;)
 V Zooming out/in by factor is more precise (used "simplify" function)
 V Customize default complex color for NaN
 V Set up a calculator inside ReflexRenderer (renderreflex.exe --simplify formula="(1+i)*3")
 V Do not always save the session at the end.
 V Highlight the problem in the formula when there is an error.
 V 1/z^ is crashing (and a lot of other bugs)
 V Error when something is missing in formula: window does not respond
 V Il me met missing « , » at position 2 : oo(tan(ln(sinh(cosh(i*z)))))*z,5)
 V rendering percent displayed on title (AutoItWinSetTitle($g_szVersion))

Previous version: 2.5.0.1
 
 V Color code for Reflex available somewhere (create a custom image to be displayed when click over a "?")
 V x.y should be a multiplication.
 X Add the comment to an existing formula if already exists
 V Change language on place
 V Low resolution (need to code now)
 V To change the saving directory, go to Tools>Save Reflex/Formula => To change the saving directory, go to 
puis d'y adjoindre les chaînes traduites de &Tools + ' > ' + &Save reflex / formula...
 V Anchor texts to the right (Koda bug repaired)
 V Highlight Render button when needed
 V Copy instead of rendering again!!
 V Zoom forward/backward should not trigger rendering if option off
 V Default resolutions should not be checked on the beginning
 V Default windows should not be checked on the beginning
 V Delete 'Customized' options & update the functions.
 V Use local file instead of c:\output
 V Find why the picture is not displayed at David.
 V Name given to a reflex => comment. Why is it not working at DC?
 V Make the icon disappear
 V Verify focus if a 'close' button is detected in dialog box, if not, focus the window
 V Hint over the buttons
 V remplacer Rendering options par Creating Options en anglais
 V Changer texte 'Output file' to 'Temp file'
 V Draw => Set
 V Unifier 'Text File' & 'Formula File'
 V Retranslate 'Save comment' in french
 V Create folder containing translations + set the translation file as an option.
 V Save All instead of just 'save'
 V Save... => Saving options?
 V Reset formula / Reset values => make a difference
 V Default folders : %MY_DOCUMENTS%\Reflex => Converted on-the-fly to @MyDocumentsDir&"\Reflex"
 V default comment in the Quicksave box to change before it is suggested => add a number / update last number after it?
 V Not to render two times consecutively
 V Hints for savebox
 V Créer une Reflex => changer le titre de l'application. Générateur de Reflex
 V Garder traductions Copyright
 V Bug if we just give "H" for a formula!!!
 V Cancel rendering if something gets updated => put rendering handling into the main loop
 V Rendering in another thread
 V Write formula/comment/option into the JPEG reflex
 V Script to update existing reflex
 V Read the JPG comment as a comment + formula
 V editbox and load box independent from the main application (put a directory bin/scripts)
 V scientific number support
 V @PARAM Seed for setting initial random numbers.
 V Randf and randh are generating functions, not only displaying them
 V Zoom in should not blink
 V Color the formula differently than the comment
 V Pas fermer importeur de formule quand on l'utilise.
 V Bug render qui s'highlight après un rendu
 V Previous formula / Next formula : drop down?
 V Quit menu without saving
 V 'Center on this point' button (window) (right button)
 V Absolute factor to zoom
 V Pi is complex!!!? Fixed
 V Refresh bug when click over a resolution fixed
 V Zoom preview
 V Semi-Animated zoom
 V Put variables instead of strings in koda
 V Quit menu
 V The zoom box should also display what will be zoomed instead of just the black box
 V Dans la FAQ 'This is an friendly user interface' > 'a friendly'.
 V Script which updates the #Region script.
 V When the window is resized, the reflex is not centered at the right place.
 V update width & height when resolution changed
 V If render high-res BMP, render it directly into the right folder and update the visible reflex
 V More robustness in the extension bmp/jpg (do not finish with the ')')
 V Do not change working dir
 V Find ouy why GUICtrlSetImage is not updating.
 V More precision in winmin, winmax
 V Interactive Formula Editor
 V Zooming by factor
 V Save/append formulas
 V Save reflex & formula. ([] Render reflex after saving formula)
 V Highlight RENDER button when a change is made
 V About dialog box
 V Recover session (INI file)
 V Automatically specify the percent view
 V AutoRender
 V Able to reload another file.
 V Zooming out and in
 V Window Previous and Next (buttons)
 
 _IsPressed can be useful?
 
#ce ----------------------------------------------------------------------------
#include-once
;Version number is in GlobalUtils

HotKeySet('{ESC}', 'cancelDrag')

$output_x = 312
$output_y = 28
$output_max_size=401

Opt('MouseCoordMode', 2)

#include <Math.au3>
#Include <Misc.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>

#include <Array.au3>
#Include <GuiEdit.au3>
#include 'GlobalUtils.au3'
#include 'AboutBox.au3'
#include 'EditFormula.au3'
#include 'IniHandling.au3'
#include 'LoadFormulaFromFile.au3'
#include 'Parameters.au3'
#include 'SaveBox.au3'
#include 'Translations.au3'
#include 'WindowManager.au3'
#include 'Tutorial.au3'

Func retrieveRenderVideoAndAut2Exe()
  $rv = @TempDir&"\RenderVideoExploded.au3"
  $au2exe = @TempDir&"\Aut2Exe.exe"
  $autoitscbin = @TempDir&"\AutoItSC.bin"
  $rrx = @TempDir&"\Release\RenderReflex.exe"
  FileInstall("RenderVideoExploded.au3", $rv, 1)
  FileInstall("C:\Program Files\AutoIt3\Aut2Exe\Aut2Exe.exe", $au2exe, 1)
  FileInstall("C:\Program Files\AutoIt3\Aut2Exe\AutoItSC.bin", $autoitscbin, 1)
  logging("Copying "&$RenderReflexExe&" to "&$rrx)
  FileDelete(@TempDir&"\Release")
  DirCreate(@TempDir&"\Release")
  FileCopy($RenderReflexExe, $rrx , 1+8)
  Return _ArrayCreate($rv, $au2exe, $autoitscbin, $rrx )
EndFunc   ;==>retrieveRenderVideoAndAut2Exe

Global $noir_file = $bin_dir&'black.bmp'
Global $gris_file = $bin_dir&'gray.bmp'

Global $arrayWindows = emptySizedArray()
Global $nPreviousWindows = 0
Global $nNextWindows = 0
Global $currentWindow = 0
Global $pid_rendering = 0, $rendering_thread = False
Global Enum $DRAG = 0, $ZOOM_FORWARD, $ZOOM_BACKWARD
Global $RENDERING_IMAGE_TO_UPDATE = 0
Global $UPDATE_PIC = False
Global $factor_threading = 1.0
Global $rri_out_rendu_pos
Global Enum $REFLEX_NOT_UP_TO_DATE = 0, $REFLEX_RENDERED_IN_LR, $REFLEX_RENDERED_IN_HR
Global $REFLEX_RENDERING = $REFLEX_NOT_UP_TO_DATE, $REFLEX_RENDERED = $REFLEX_NOT_UP_TO_DATE, $REFLEX_RENDERED_FINISHED = True
Global $history_formula_array[19] = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
Global $rri_win_pos[4]
Global $auto_save_formula = True
Global $zooming = 0
Global $zoomvars[8]
Global $inverted_zoom = False

Global $initWorkingDir = @ScriptDir
Global $moving = False
Global $navigation = $DRAG
Global $width_highres, $height_highres, $maxwh, $width_percent, $height_percent
Global $winmin, $winmax
Global $x = 0, $y = 0, $dx = 0, $dy = 0
Global $xprev = -1, $yprev = -1
Global $k = 0

EditFormula__setCallbackFunction("EditFormulaCallBack")
LoadFormulaFromFile__setCallbackFunction("loadFormulaCallback")
SaveBox__setCallbackFunction("SaveBoxCallback")
Tutorial__setCallbackFunction("TutorialCallback")

rri_main()

Func rri_main()
  loadRRI()

  renderIfAutoRender($rri_out_rendu)
  ;$arrayWindows = emptySizedArray()
  ;$nPreviousWindows = 0
  ;$currentWindow = 0
  ;winChangeState()

  ;Main loop. Used to execute code in "parallel"
  While 1
    If $moving Then
      $xy = MouseGetPos()
      if $xprev = $xy[0] and $yprev = $xy[1] Then ContinueLoop
      Switch $navigation
      Case $DRAG
        $dx = $xy[0]-$x
        $dy = $xy[1]-$y
        repositionneRendu($rri_out_rendu, $dx, $dy)
      Case $ZOOM_FORWARD To $ZOOM_BACKWARD
        resizeZoomBox($x, $y, $xy[0], $xy[1])
      EndSwitch
      $xprev = $xy[0]
      $yprev = $xy[1]
    ElseIf $rendering_thread Then
      WinSetTitle($rri_win, "", GUICtrlRead($rri_progress)&"% done")
      If handleRenderingAndIsFinished() Then
        If handleFinishedRendering() Then
          handlePostFinishedRendering()
        EndIf
        WinSetTitle($rri_win, "", $__reflex_renderer_interface__)
        $rendering_thread = False
      EndIf
    Else
      Sleep(100)
    EndIf
  WEnd
EndFunc   ;==>rri_main

Func loadRRI()
  Opt('GUIOnEventMode', 1)
  #Region ### START Koda GUI section ### Form=C:\Documents and Settings\Mikaël\Mes documents\Reflex\LogicielOrdi\RenderReflex\ReflexRendererInterface.kxf
  Global $rri_win = GUICreate($__reflex_renderer_interface__, 737, 468, 1, 1, BitOR($WS_MINIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_GROUP,$WS_BORDER,$WS_CLIPSIBLINGS,$DS_MODALFRAME), BitOR($WS_EX_ACCEPTFILES,$WS_EX_WINDOWEDGE))
  GUISetOnEvent($GUI_EVENT_CLOSE, "rri_winClose")
  GUISetOnEvent($GUI_EVENT_MINIMIZE, "rri_winMinimize")
  GUISetOnEvent($GUI_EVENT_MAXIMIZE, "rri_winMaximize")
  GUISetOnEvent($GUI_EVENT_RESTORE, "rri_winRestore")
  Global $rri_line_reset = GUICtrlCreatePic("", -100, 0, 100, 100, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetOnEvent(-1, "rri_line_resetClick")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_zoom_box0 = GUICtrlCreatePic("", -100, 0, 100, 100, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetOnEvent(-1, "rri_zoom_box0Click")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_zoom_box1 = GUICtrlCreatePic("", -100, 0, 100, 100, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetOnEvent(-1, "rri_zoom_box1Click")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_zoom_box2 = GUICtrlCreatePic("", -100, 0, 100, 100, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetOnEvent(-1, "rri_zoom_box2Click")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_zoom_box3 = GUICtrlCreatePic("", -100, 0, 100, 100, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetOnEvent(-1, "rri_zoom_box3Click")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_zoom_box_gray0 = GUICtrlCreatePic("", -100, 8, 100, 100, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetOnEvent(-1, "rri_zoom_box_gray0Click")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_zoom_box_gray1 = GUICtrlCreatePic("", -100, 0, 100, 100, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetOnEvent(-1, "rri_zoom_box_gray1Click")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_zoom_box_gray2 = GUICtrlCreatePic("", -100, 0, 100, 100, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetOnEvent(-1, "rri_zoom_box_gray2Click")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_zoom_box_gray3 = GUICtrlCreatePic("", -100, 0, 100, 100, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetOnEvent(-1, "rri_zoom_box_gray3Click")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_out_rendu = GUICtrlCreatePic("", 312, 28, 401, 401, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetOnEvent(-1, "rri_out_renduClick")
  Global $rri_group_reflex = GUICtrlCreateGroup($__reflex__, 296, 8, 433, 433)
  GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
  GUICtrlCreateGroup("", -99, -99, 1, 1)
  Global $rri_group_options = GUICtrlCreateGroup($__creating_options__, 8, 40, 281, 255)
  GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP)
  Global $rri_Label1 = GUICtrlCreateLabel($__formula__, 10, 60, 54, 17, $SS_RIGHT)
  GUICtrlSetOnEvent(-1, "rri_Label1Click")
  Global $rri_in_formula = GUICtrlCreateInput("", 64, 58, 193, 21)
  GUICtrlSetOnEvent(-1, "rri_in_formulaChange")
  Global $rri_formula_editor = GUICtrlCreateButton("...", 260, 59, 21, 21, 0)
  GUICtrlSetOnEvent(-1, "rri_menu_formula_editorClick")
  Global $rri_DimLabel = GUICtrlCreateLabel($__width_height__, 10, 89, 96, 17, $SS_RIGHT)
  GUICtrlSetOnEvent(-1, "rri_DimLabelClick")
  Global $rri_width = GUICtrlCreateInput("201", 109, 87, 41, 21)
  GUICtrlSetOnEvent(-1, "rri_widthChange")
  Global $rri_labelX = GUICtrlCreateLabel("x", 152, 89, 9, 17)
  GUICtrlSetOnEvent(-1, "rri_labelXClick")
  Global $rri_height = GUICtrlCreateInput("201", 162, 87, 41, 21)
  GUICtrlSetOnEvent(-1, "rri_heightChange")
  Global $rri_reset_resolution = GUICtrlCreateButton($__reset_resolution__, 240, 85, 41, 25, 0)
  GUICtrlSetOnEvent(-1, "rri_reset_resolutionClick")
  Global $rri_preview = GUICtrlCreateCheckbox($__preview__, 28, 113, 81, 17)
  GUICtrlSetOnEvent(-1, "rri_previewClick")
  Global $rri_LabelWinMin = GUICtrlCreateLabel($__winmin__, 10, 139, 97, 17, BitOR($SS_RIGHT,$SS_RIGHTJUST))
  GUICtrlSetOnEvent(-1, "rri_LabelWinMinClick")
  Global $rri_percent = GUICtrlCreateInput("10", 109, 112, 33, 21)
  GUICtrlSetOnEvent(-1, "rri_percentChange")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_winmin = GUICtrlCreateInput("-4-4i", 109, 137, 129, 21)
  GUICtrlSetOnEvent(-1, "rri_winminChange")
  Global $rri_LabelWinMax = GUICtrlCreateLabel($__winmax__, 10, 161, 97, 17, $SS_RIGHT)
  GUICtrlSetOnEvent(-1, "rri_LabelWinMaxClick")
  Global $rri_winmax = GUICtrlCreateInput("4+4i", 109, 159, 129, 21)
  GUICtrlSetOnEvent(-1, "rri_winmaxChange")
  Global $rri_reset_window = GUICtrlCreateButton($__reset_window__, 240, 146, 41, 25, 0)
  GUICtrlSetOnEvent(-1, "rri_reset_windowClick")
  Global $rri_check_auto_render = GUICtrlCreateCheckbox($__auto_render__, 16, 190, 118, 17)
  GUICtrlSetOnEvent(-1, "rri_check_auto_renderClick")
  GUICtrlSetTip(-1, $__auto_render_hint__)
  Global $rri_LabelTempFile = GUICtrlCreateLabel($__temp_file__, 15, 269, 89, 17, BitOR($SS_RIGHT,$SS_RIGHTJUST))
  GUICtrlSetOnEvent(-1, "rri_LabelTempFileClick")
  Global $rri_render = GUICtrlCreateButton($__render_reflex__, 136, 188, 145, 25, $BS_DEFPUSHBUTTON)
  GUICtrlSetFont(-1, 11, 400, 0, "MS Sans Serif")
  GUICtrlSetOnEvent(-1, "rri_renderClick")
  Global $rri_output = GUICtrlCreateInput("c:\My_nice_function.bmp", 106, 267, 153, 21)
  GUICtrlSetOnEvent(-1, "rri_outputChange")
  Global $rri_PercentSign = GUICtrlCreateLabel("%", 144, 115, 12, 17)
  GUICtrlSetOnEvent(-1, "rri_PercentSignClick")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_select = GUICtrlCreateButton("...", 260, 267, 21, 21, 0)
  GUICtrlSetOnEvent(-1, "rri_selectClick")
  Global $rri_progress = GUICtrlCreateProgress(10, 245, 271, 16)
  Global $rri_rendering_text = GUICtrlCreateLabel($__rendering__, 16, 227, 102, 17)
  GUICtrlSetOnEvent(-1, "rri_rendering_textClick")
  Global $rri_quicksave = GUICtrlCreateButton($__quick_save__, 136, 212, 89, 25, 0)
  GUICtrlSetOnEvent(-1, "rri_quicksaveClick")
  GUICtrlSetTip(-1, $__quicksave_hint__)
  Global $rri_save_noquick = GUICtrlCreateButton($__noquick_save__, 224, 212, 57, 25, 0)
  GUICtrlSetOnEvent(-1, "rri_menu_saveClick")
  GUICtrlSetTip(-1, $__noquick_save_hint__)
  Global $rri_seed = GUICtrlCreateInput("", 264, 128, 17, 21)
  GUICtrlSetOnEvent(-1, "rri_seedChange")
  GUICtrlSetState(-1, $GUI_HIDE)
  Global $rri_realmode = GUICtrlCreateCheckbox($__real_mode__, 16, 208, 113, 17)
  GUICtrlSetOnEvent(-1, "rri_realmodeClick")
  GUICtrlCreateGroup("", -99, -99, 1, 1)
  Global $rri_LabelTitre = GUICtrlCreateLabel($__reflex_renderer_interface__, 9, 8, 244, 28, $SS_CENTER)
  GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
  GUICtrlSetOnEvent(-1, "rri_LabelTitreClick")
  Global $rri_navigation = GUICtrlCreateGroup($__navigation__, 8, 296, 281, 145)
  GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM)
  Global $rri_drag_reflex = GUICtrlCreateRadio($__drag_reflex__, 168, 311, 113, 20)
  GUICtrlSetState(-1, $GUI_CHECKED)
  GUICtrlSetOnEvent(-1, "rri_drag_reflexClick")
  Global $rri_zoom_forward = GUICtrlCreateRadio($__zoom_rectangle_in__, 168, 334, 113, 20)
  GUICtrlSetOnEvent(-1, "rri_zoom_forwardClick")
  Global $rri_zoom_backward = GUICtrlCreateRadio($__zoom_rectangle_out__, 168, 357, 113, 20)
  GUICtrlSetOnEvent(-1, "rri_zoom_backwardClick")
  Global $rri_previous_window = GUICtrlCreateButton($__previous_window__, 168, 382, 113, 25, 0)
  GUICtrlSetOnEvent(-1, "rri_previous_windowClick")
  GUICtrlSetState(-1, $GUI_DISABLE)
  Global $rri_next_window = GUICtrlCreateButton($__next_window__, 168, 408, 113, 25, 0)
  GUICtrlSetOnEvent(-1, "rri_next_windowClick")
  GUICtrlSetState(-1, $GUI_DISABLE)
  Global $rri_zoom_factor = GUICtrlCreateInput("2", 96, 382, 58, 21)
  GUICtrlSetOnEvent(-1, "rri_zoom_factorChange")
  GUICtrlSetTip(-1, $__zoom_factor_hint__)
  Global $rri_zoom_in_factor = GUICtrlCreateButton($__zoom_in_factor__, 37, 351, 58, 25, 0)
  GUICtrlSetOnEvent(-1, "rri_zoom_in_factorClick")
  Global $rri_zoom_out_factor = GUICtrlCreateButton($__zoom_out_factor__, 96, 351, 58, 25, 0)
  GUICtrlSetOnEvent(-1, "rri_zoom_out_factorClick")
  Global $rri_LabelZoomFactor = GUICtrlCreateLabel($__zoom_factor__, 10, 384, 84, 17, $SS_RIGHT)
  GUICtrlSetOnEvent(-1, "rri_LabelZoomFactorClick")
  GUICtrlSetTip(-1, $__zoom_factor_hint__)
  Global $rri_LabelZoomAbsolute = GUICtrlCreateLabel($__zoom_absolute__, 10, 412, 84, 17, $SS_RIGHT)
  GUICtrlSetOnEvent(-1, "rri_LabelZoomAbsoluteClick")
  GUICtrlSetTip(-1, $__zoom_absolute_hint__)
  Global $rri_zoom_absolute = GUICtrlCreateInput("1", 96, 410, 57, 21)
  GUICtrlSetOnEvent(-1, "rri_zoom_absoluteChange")
  GUICtrlSetTip(-1, $__zoom_absolute_hint__)
  GUICtrlCreateGroup("", -99, -99, 1, 1)
  Global $rri_color_code_button = GUICtrlCreateButton("Code", 257, 12, 32, 26, 0)
  GUICtrlSetOnEvent(-1, "rri_color_code_buttonClick")
  GUICtrlSetTip(-1, $__hint_color_code_button__)
  Global $rri_menu_tools = GUICtrlCreateMenu($__tools__)
  GUICtrlSetOnEvent(-1, "rri_menu_toolsClick")
  Global $rri_menu_save = GUICtrlCreateMenuItem($__menu_save__, $rri_menu_tools)
  GUICtrlSetOnEvent(-1, "rri_menu_saveClick")
  Global $rri_menu_windows = GUICtrlCreateMenu($__menu_windows__, $rri_menu_tools)
  GUICtrlSetOnEvent(-1, "rri_menu_windowsClick")
  Global $rri_window_1 = GUICtrlCreateMenuItem("-1-i, 1+i", $rri_menu_windows, -1 , 1)
  GUICtrlSetOnEvent(-1, "windowClick")
  Global $rri_window_2 = GUICtrlCreateMenuItem("-2-2i, 2+2i", $rri_menu_windows, -1 , 1)
  GUICtrlSetOnEvent(-1, "windowClick")
  Global $rri_window_4 = GUICtrlCreateMenuItem("-4-4i, 4+4i", $rri_menu_windows, -1 , 1)
  GUICtrlSetState(-1, $GUI_CHECKED)
  GUICtrlSetOnEvent(-1, "windowClick")
  Global $rri_window_8 = GUICtrlCreateMenuItem("-8-8i, 8+8i", $rri_menu_windows, -1 , 1)
  GUICtrlSetOnEvent(-1, "windowClick")
  Global $rri_window_pi = GUICtrlCreateMenuItem("-pi-i*pi, pi+i*pi", $rri_menu_windows, -1 , 1)
  GUICtrlSetOnEvent(-1, "windowClick")
  Global $rri_menu_resolutions = GUICtrlCreateMenu($__menu_resolutions__, $rri_menu_tools)
  GUICtrlSetOnEvent(-1, "rri_menu_resolutionsClick")
  Global $rri_resolutions_201 = GUICtrlCreateMenuItem("201 x 201", $rri_menu_resolutions, -1 , 1)
  GUICtrlSetState(-1, $GUI_CHECKED)
  GUICtrlSetOnEvent(-1, "resolutionsClick")
  Global $rri_resolutions_401 = GUICtrlCreateMenuItem("401 x 401", $rri_menu_resolutions, -1 , 1)
  GUICtrlSetOnEvent(-1, "resolutionsClick")
  Global $rri_resolutions_801 = GUICtrlCreateMenuItem("801 x 801", $rri_menu_resolutions, -1 , 1)
  GUICtrlSetOnEvent(-1, "resolutionsClick")
  Global $rri_resolutions_640 = GUICtrlCreateMenuItem("640 x 480", $rri_menu_resolutions, -1 , 1)
  GUICtrlSetOnEvent(-1, "resolutionsClick")
  Global $rri_resolutions_1024 = GUICtrlCreateMenuItem("1024 x 768", $rri_menu_resolutions, -1 , 1)
  GUICtrlSetOnEvent(-1, "resolutionsClick")
  Global $rri_resolutions_1280 = GUICtrlCreateMenuItem("1280 x 800", $rri_menu_resolutions, -1 , 1)
  GUICtrlSetOnEvent(-1, "resolutionsClick")
  Global $rri_resolutions_1601 = GUICtrlCreateMenuItem("1601 x 1601", $rri_menu_resolutions)
  GUICtrlSetOnEvent(-1, "resolutionsClick")
  Global $rri_resolutions_16000 = GUICtrlCreateMenuItem("16000 x 16000", $rri_menu_resolutions, -1 , 1)
  GUICtrlSetOnEvent(-1, "resolutionsClick")
  Global $rri_menu_export_formula = GUICtrlCreateMenuItem($__export_formula__, $rri_menu_tools)
  GUICtrlSetOnEvent(-1, "rri_menu_export_formulaClick")
  Global $rri_menu_quitnosave = GUICtrlCreateMenuItem($__menu_quitnosave__, $rri_menu_tools)
  GUICtrlSetOnEvent(-1, "rri_menu_quitnosaveClick")
  Global $rri_menu_quit = GUICtrlCreateMenuItem($__menu_quit__, $rri_menu_tools)
  GUICtrlSetOnEvent(-1, "rri_menu_quitClick")
  Global $rri_menu_formula_editor = GUICtrlCreateMenu($__formula_menu__)
  GUICtrlSetOnEvent(-1, "rri_menu_formula_editorClick")
  Global $rri_menu_formula_edito = GUICtrlCreateMenuItem($__menu_formula_editor__, $rri_menu_formula_editor)
  GUICtrlSetOnEvent(-1, "rri_menu_formula_editorClick")
  Global $rri_menu_import_formula = GUICtrlCreateMenuItem($__menu_formula_import__, $rri_menu_formula_editor)
  GUICtrlSetOnEvent(-1, "rri_menu_import_formulaClick")
  Global $rri_menu_import_reflex = GUICtrlCreateMenuItem($__menu_formula_import_reflex__, $rri_menu_formula_editor)
  GUICtrlSetOnEvent(-1, "rri_menu_import_reflexClick")
  Global $rri_menu_formula_history = GUICtrlCreateMenuItem($__menu_formula_history__, $rri_menu_formula_editor)
  GUICtrlSetOnEvent(-1, "rri_menu_formula_historyClick")
  Global $rri_menu_language = GUICtrlCreateMenu($__language_menu__)
  GUICtrlSetOnEvent(-1, "rri_menu_languageClick")
  #EndRegion ### END Koda GUI section ###
  
  ;Koda doesn't know how to handle that
  $menu_about = GUICtrlCreateMenuItem($__menu_about__, -1)
  GUICtrlSetOnEvent(-1, "menu_aboutClick")
  GUICtrlSetStyle($rri_color_code_button, $BS_ICON)
  GUICtrlSetImage($rri_color_code_button, $bin_dir&"RenderCodeColor.ico")

  If $languages <> False Then
    ;_ArrayDisplay($languages)
    For $langue in $languages
    ; 'Français', 'fr_lang', 'fr'
    Assign($langue[1], GUICtrlCreateMenuItem($langue[0], $rri_menu_language), 2)
    GUICtrlSetOnEvent(-1, "menu_setLang")
    Next
  EndIf

  ;WindowManager__registerWindow($rri_win)

  Global $sessionParametersMap = _ArrayCreate( _
   _ArrayCreate('formula', $rri_in_formula, 'oo(cosh(z)-i*argsh(j*z)-z/(x^y),5)'), _
   _ArrayCreate('width', $rri_width, '401'), _
   _ArrayCreate('height', $rri_height, '401'), _
   _ArrayCreate('winmin', $rri_winmin, '-4-4i'), _
   _ArrayCreate('winmax', $rri_winmax, '4+4i'), _
   _ArrayCreate('percentPreview', $rri_percent, '25'), _
   _ArrayCreate('outputFile', $rri_output, '.\My_temporary_nice_function.bmp'), _
   _ArrayCreate('ZoomFactor', $rri_zoom_factor, '2'), _
   _ArrayCreate('seed', $rri_seed, '1986') _
  )

  Global $sessionCheckBoxMap = _ArrayCreate( _
   _ArrayCreate('preview', $rri_preview, 'FALSE'), _
   _ArrayCreate('AutoRender', $rri_check_auto_render, 'TRUE'), _
   _ArrayCreate('RealMode', $rri_realmode, 'FALSE') _
  )
  
  ;Global $sessionWindowMap = _ArrayCreate( _
  ; _ArrayCreate('')
  ;)

  Global $resolutionsMap = _ArrayCreate( _
    _ArrayCreate($rri_resolutions_201, '201 x 201'), _
    _ArrayCreate($rri_resolutions_401, '401 x 401'), _
    _ArrayCreate($rri_resolutions_801, '801 x 801'), _
    _ArrayCreate($rri_resolutions_640, '640 x 480'), _
    _ArrayCreate($rri_resolutions_1024, '1024 x 768'), _
    _ArrayCreate($rri_resolutions_1280, '1280 x 800'), _
    _ArrayCreate($rri_resolutions_1601, '1601 x 1601'), _
    _ArrayCreate($rri_resolutions_16000, '16000 x 16000') _
  )

  GUISetOnEvent($GUI_EVENT_RESIZED, 'rri_winResize', $rri_win)
  GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, 'rri_winMouseLeftDown', $rri_win)
  GUISetOnEvent($GUI_EVENT_PRIMARYUP, 'rri_winMouseLeftUp', $rri_win)
  GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, 'rri_winMouseRightDown', $rri_win)
  GUISetOnEvent($GUI_EVENT_SECONDARYUP, 'rri_winMouseRightUp', $rri_win)
  GUISetOnEvent($GUI_EVENT_DROPPED, "loadImgDropped", $rri_win)
  GUICtrlSetState($rri_out_rendu, $GUI_DROPACCEPTED)
  GUICtrlSetState($rri_rendering_text, $GUI_HIDE)
  GUICtrlSetState($rri_progress, $GUI_HIDE)

  GUICtrlSetImage($rri_zoom_box0, $noir_file)
  GUICtrlSetImage($rri_zoom_box1, $noir_file)
  GUICtrlSetImage($rri_zoom_box2, $noir_file)
  GUICtrlSetImage($rri_zoom_box3, $noir_file)
  GUICtrlSetImage($rri_zoom_box_gray0, $gris_file)
  GUICtrlSetImage($rri_zoom_box_gray1, $gris_file)
  GUICtrlSetImage($rri_zoom_box_gray2, $gris_file)
  GUICtrlSetImage($rri_zoom_box_gray3, $gris_file)
  GUICtrlSetImage($rri_line_reset, $noir_file)
  ;TODO: here refrafctor
  displayZoombox(False)

  ;Line from Reset button to Heigh input box
  rri_line_resetInit()

  LoadSession()
  
  Global $zoomAbsolutePrevious = Number(GUICtrlRead($rri_zoom_absolute))
  updateWinmin()
  updateWinmax()
  calculateWidthHeight()
  winSave()
  
  If FileExists(GUICtrlRead($rri_output)) Then
    GUICtrlSetImage($rri_out_rendu,  GUICtrlRead($rri_output))
  EndIf
  winChange()
  resolutionChanged()

  updatePos()
  repositionneRendu($rri_out_rendu, 0, 0)
  
  AnimateFromTopLeft($rri_win)
  
  EditFormula__setParentWindow($rri_win)
  LoadFormulaFromFile__setParentWindow($rri_win)
  SaveBox__setParentWindow($rri_win)
  Tutorial__setParentWindow($rri_win)

  $rri_win_pos = WinGetPos($rri_win)
  WindowManager__loadAll()

  history_formula_arrayLoad()
EndFunc   ;==>loadRRI

; Cancels a drag action performed by the user,
; typically cancelled when the user press "ESC".
Func cancelDrag()
  If $moving Then
    $moving = False
    Switch $navigation
    Case $DRAG
      repositionneRendu($rri_out_rendu, 0, 0)
    Case $ZOOM_FORWARD To $ZOOM_BACKWARD
      displayZoombox(False)
    EndSwitch
  EndIf
EndFunc   ;==>cancelDrag

; Gives focus to the "Render" button
Func FocusRenderButton()
  GUICtrlSetState($rri_render, $GUI_FOCUS)
EndFunc   ;==>FocusRenderButton

; Performs rendering action
Func rri_renderClick()
  render($rri_out_rendu)
EndFunc   ;==>rri_renderClick

; Asks the user for a temporary bitmap file
Func rri_selectClick()
  $fullpath = FileSaveDialog($Reflex_name, '', $Bitmap_24_bits____bmp__All______ , 16, GUICtrlRead($rri_output))
  if @error <> 1 Then
    GUICtrlSetData($rri_output, $fullpath)
  EndIf
  FileChangeDir(@ScriptDir)
EndFunc   ;==>rri_selectClick

; Performs a conditionnal rendering if the formula changes
Func rri_in_formulaChange()
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>rri_in_formulaChange

; If height changes, set up window size to keep
; the product $percent*$percent*$width*$height constant.
Func rri_heightChange()
  $height_pred = $height_highres
  $height_new = Number(GUICtrlRead($rri_height))
  logging("Previous height: "&$height_pred&", new height: "&$height_new)
  recalculatePreviewPercent(Sqrt($height_pred / $height_new))
  calculateWidthHeight()
  resolutionChanged()
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>rri_heightChange

; If width changes, set up window size to keep
; the product $percent*$percent*$width*$height constant.
Func rri_widthChange()
  $width_pred = $width_highres
  $width_new = Number(GUICtrlRead($rri_width))
  logging("Previous width: "&$width_pred&", new width: "&$width_new)
  recalculatePreviewPercent(Sqrt($width_pred / $width_new))
  calculateWidthHeight()
  resolutionChanged()
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>rri_widthChange

; Multiplies the current percent preview by a given ratio
;   $ratioPredNew : A float containing the ratio
Func recalculatePreviewPercent($ratioPredNew)
  $percent = Number(GUICtrlRead($rri_percent))
  If Not isChecked($rri_preview) Then $percent = 100
  $percent *= Sqrt($ratioPredNew)
  setPreviewPercent(Round($percent*4)/4)
  
EndFunc   ;==>recalculatePreviewPercent

; Action to perform is the resolution is manually changed
Func resolutionChanged()
  GUICtrlSetState($rri_resolutions_201, $GUI_UNCHECKED)
  GUICtrlSetState($rri_resolutions_401, $GUI_UNCHECKED)
  GUICtrlSetState($rri_resolutions_801, $GUI_UNCHECKED)
  GUICtrlSetState($rri_resolutions_640, $GUI_UNCHECKED)
  GUICtrlSetState($rri_resolutions_1024, $GUI_UNCHECKED)
  GUICtrlSetState($rri_resolutions_1280, $GUI_UNCHECKED)
  GUICtrlSetState($rri_resolutions_16000, $GUI_UNCHECKED)
EndFunc   ;==>resolutionChanged

; Action to perform if the user changes the "preview" check box
Func rri_previewClick()
  changePreviewState()
  calculateWidthHeight()
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>rri_previewClick

;
Func changePreviewState()
  if BitAnd(GUICtrlRead($rri_preview), $GUI_CHECKED) Then
    GUICtrlSetState($rri_percent, $GUI_SHOW)
    GUICtrlSetState($rri_PercentSign, $GUI_SHOW)
  Else
    GUICtrlSetState($rri_percent, $GUI_HIDE)
    GUICtrlSetState($rri_PercentSign, $GUI_HIDE)
  EndIf
EndFunc   ;==>changePreviewState
Func updateWinmax()
  $winmax = GUICtrlRead($rri_winmax)
EndFunc
Func updateWinmin()
  $winmin = GUICtrlRead($rri_winmin)
EndFunc
Func rri_winmaxChange()
  updateWinmax()
  winChange()
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>rri_winmaxChange
Func rri_winminChange()
  updateWinmin()
  winChange()
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>rri_winminChange
Func winChange()
  GUICtrlSetState($rri_window_1, $GUI_UNCHECKED)
  GUICtrlSetState($rri_window_2, $GUI_UNCHECKED)
  GUICtrlSetState($rri_window_4, $GUI_UNCHECKED)
  GUICtrlSetState($rri_window_8, $GUI_UNCHECKED)
  GUICtrlSetState($rri_window_pi, $GUI_UNCHECKED)
EndFunc   ;==>winChange

Func rri_menu_formula_editorClick()
  $formula = GUICtrlRead($rri_in_formula)
  $seed    = GUICtrlRead($rri_seed)
  EditFormula($formula, $seed)
EndFunc   ;==>rri_menu_formula_editorClick

;   $formula_modified : 
;   $seed_modified    : 
;   $history_save     : 
Func EditFormulaCallBack($formula_modified, $seed_modified, $history_save)
  ;$formula = GUICtrlRead($rri_in_formula)
  ;$seed    = GUICtrlRead($rri_seed)
  $auto_save_formula_sav = $auto_save_formula
  $auto_save_formula = $history_save
  
  updateFormula($formula_modified)
  GUICtrlSetData($rri_seed, $seed_modified)
  
  renderIfAutoRender($rri_out_rendu)
  
  $auto_save_formula = $auto_save_formula_sav
EndFunc   ;==>EditFormulaCallBack

Func rri_menu_import_formulaClick()
  loadFormula()
EndFunc   ;==>rri_menu_import_formulaClick
Func loadImgDropped()
  ;logging(@GUI_DRAGFILE)
  LoadFormulaFromFile__LoadImgContainingReflex(@GUI_DRAGFILE)
EndFunc   ;==>loadImgDropped
Func rri_menu_import_reflexClick()
  loadFormulaFromReflex()
EndFunc   ;==>rri_menu_import_reflexClick
;   $formula : 
Func loadFormulaCallback($formula)
  $render_again = False
  For $i = 1 To $formula[0]
    $item = $formula[$i]
    ;Logging("Loading "&$item[0])
    Switch $item[0]
    Case "formula"
      updateFormula($item[1])
      $render_again = True
    Case "window"
      updateWindow($item[1])
      $render_again = True
    Case "comment"
      ;TODO : Put a variable, even hidden (like seed), containing the comment, so that it can be changed dynamically, not on the file.
    Case "resolution"
      updateResolution($item[1])
      $render_again = True
    Case Else
      logging("Unknown tag : "&$item[0])
    EndSwitch
  Next
  if $render_again Then renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>loadFormulaCallback
Func rri_menu_resolutionsClick()
EndFunc   ;==>rri_menu_resolutionsClick
Func rri_menu_saveClick()
  $savingParameters = SaveBox__createInstance()
EndFunc   ;==>rri_menu_saveClick
;   $savingParameters : 
Func SaveBoxCallback($savingParameters)
  If $savingParameters <> 1 Then Return
  saveboxSave()  
EndFunc   ;==>SaveBoxCallback

Func rri_quicksaveClick()
  ;Only prompt the comment.
  $defaultComment = IniReadSavebox('formulaComment', $My_nice_function)
  $defaultComment = getFirstAvailableComment($defaultComment)
  $result = InputBox($Quick_save, $Give_a_comment_for_this_reflex_&@CRLF&@CRLF& _
StringFormat($To_change_the_saving_directory__go_to, _
StringReplace($__tools__, "&", ""), _
StringReplace($__menu_save__, "&", "")), _
$defaultComment, ' M')
  if $result == '' Then Return
  IniWriteSavebox('formulaComment', $result)
  If isSavebox('useComment') Then
    $rfn = reflexFileNameFromComment( _
        IniReadSavebox('formulaComment',$defaultComment), _
        IniReadSavebox('formulaFile',''), _
        IniReadSavebox('Extension','') )
    if $rfn == '' Then
      MsgBox(0, '', $Error_while_quick_saving_in_file)
      Return
    EndIf
    IniWriteSavebox('reflexFile', $rfn)
  EndIf
  SaveSession()
  saveboxSave()
EndFunc   ;==>rri_quicksaveClick
Func rri_menu_toolsClick()

EndFunc   ;==>rri_menu_toolsClick
Func rri_menu_windowsClick()

EndFunc   ;==>rri_menu_windowsClick
Func menu_aboutClick()
  aboutBox($rri_win)
EndFunc   ;==>menu_aboutClick
;   $ctrl : 
Func MouseOverControl($ctrl)
  $pos = ControlGetPos($rri_win, '', $ctrl)
  $mpos = MouseGetPos()
  Return $mpos[0]>=$pos[0] and $mpos[0]<=$pos[0]+$pos[2] and $mpos[1]>=$pos[1] and $mpos[1]<=$pos[1]+$pos[3]
EndFunc   ;==>MouseOverControl
Func MouseOverPicture()
  Return MouseOverControl($rri_out_rendu)
EndFunc   ;==>MouseOverPicture
Func MouseOverFormula()
  Return MouseOverControl($rri_in_formula)
EndFunc   ;==>MouseOverFormula

Func rri_winMouseRightDown()
  If Not $moving and MouseOverPicture() Then
    $moving = True
    $inverted_zoom = True
    winChange()
    $xy = MouseGetPos()
    $x = $xy[0]
    $y = $xy[1]
    Switch $navigation
    Case $DRAG
    Case $ZOOM_FORWARD To $ZOOM_BACKWARD
      resizeZoomBox($x, $y, $x, $y)
      displayZoombox(True)
    EndSwitch
  EndIf
EndFunc   ;==>rri_winMouseRightDown

Func rri_winMouseRightUp()
  If $moving Then
    $moving = False
    $xy = MouseGetPos()
    If Abs($x - $xy[0]) < $threshold_zoom_drag and Abs($y - $xy[1]) < $threshold_zoom_drag  Then
      If MouseOverPicture() Then
        $xy = MouseGetPos()
        $x = $xy[0]
        $y = $xy[1]
        $new_x = Int($output_x + $output_max_size/2)
        $new_y = Int($output_y + $output_max_size/2)
        MouseMove($new_x, $new_y, 0)
        $dx = $output_x + $output_max_size/2 - $x
        $dy = $output_y + $output_max_size/2 - $y
        repositionneRendu($rri_out_rendu, $dx, $dy)
        $moving = True
        $old_navigation = $navigation
        $navigation = $DRAG
        rri_winMouseLeftUp()
        $navigation = $old_navigation
        $xy2 = MouseGetPos()
        ;Logging(StringFormat("Moved from %d, %d to %d, %d", $new_x, $new_y, $xy2[0], $xy2[1]))
        If $new_x == $xy2[0] and $new_y == $xy2[1] Then
          MouseMove($x, $y, 2)
        EndIf
      EndIf
    Else
      handleFinishMouseMove($xy)
    EndIf
  EndIf
EndFunc   ;==>rri_winMouseRightUp

Func rri_winMouseLeftDown()
  If Not $moving and MouseOverPicture() Then
    $moving = True
    $inverted_zoom = False
    winChange()
    $xy = MouseGetPos()
    $x = $xy[0]
    $y = $xy[1]
    Switch $navigation
    Case $DRAG
    Case $ZOOM_FORWARD To $ZOOM_BACKWARD
      resizeZoomBox($x, $y, $x, $y)
      displayZoombox(True)
    EndSwitch
  EndIf
EndFunc   ;==>rri_winMouseLeftDown


Func rri_winMouseLeftUp()
  ;Detects window movement
  $rri_win_pos2 = WinGetPos($rri_win)
  
  If $rri_win_pos2[0] <> $rri_win_pos[0] or $rri_win_pos2[1] <> $rri_win_pos[1] or $rri_win_pos2[2] <> $rri_win_pos[2] or $rri_win_pos2[3] <> $rri_win_pos[3] Then
    ;logging("Window moved to "&toString($rri_win_pos2)&", previous="&toString($rri_win_pos))
    WindowManager__resizeAll($rri_win_pos, $rri_win_pos2)
    $rri_win_pos = $rri_win_pos2
  EndIf
  
  ;Detect complex window shift
  If $moving Then
    $moving = False
    $xy = MouseGetPos()
    If $x == $xy[0] and $y == $xy[1] Then Return
    handleFinishMouseMove($xy)
  EndIf
EndFunc   ;==>rri_winMouseLeftUp


;   $xy : 
Func handleFinishMouseMove($xy)
  Switch $navigation
    Case $DRAG
      move_window()
      updatePic()
    Case $ZOOM_FORWARD To $ZOOM_BACKWARD
      displayZoombox(False)
      If ($navigation == $ZOOM_FORWARD and Not $inverted_zoom) or ($navigation == $ZOOM_BACKWARD and $inverted_zoom) Then
        zoomForward($x, $y, $xy[0], $xy[1])
      Else
        zoomBackward($x, $y, $xy[0], $xy[1])
      EndIf
      updatePic()
    EndSwitch
EndFunc   ;==>handleFinishMouseMove

Func rri_out_renduClick()
EndFunc   ;==>rri_out_renduClick
Func rri_PercentSignClick()

EndFunc   ;==>rri_PercentSignClick
;   $state : 
Func checkAutoRender($state)
  GUICtrlSetState($rri_check_auto_render, _Iif($state, $GUI_CHECKED, $GUI_UNCHECKED))
EndFunc   ;==>checkAutoRender
;   $state : 
Func checkPreview($state)
  GUICtrlSetState($rri_preview, _Iif($state, $GUI_CHECKED, $GUI_UNCHECKED))
EndFunc   ;==>checkPreview
;   $percent : 
Func setPreviewPercent($percent)
  if $percent >= 100 or $percent <=0 Then
    checkPreview(False)
  Else
    checkPreview(True)
    GUICtrlSetData($rri_percent, $percent)
  EndIf
  changePreviewState()
EndFunc   ;==>setPreviewPercent

;   $resolution_string : 
Func updateResolution($resolution_string)
  if StringInStr($resolution_string, ' x ') <> 0 Then
    $elements = StringSplit($resolution_string, ' x ', 1)
    GUICtrlSetData($rri_width, $elements[1])
    GUICtrlSetData($rri_height, $elements[2])
    $w = Int($elements[1])
    $h = Int($elements[2])
    $percent = Int(400 * _Min($output_max_size/$w, $output_max_size/$h))/4
    setPreviewPercent($percent)
  EndIf
EndFunc   ;==>updateResolution

Func resolutionsClick()
  $res_string = ''
  For $resolution in $resolutionSMap
    If $resolution[0] == @GUI_CTRLID Then
      $res_string = $resolution[1]
      ;setPreviewPercent($resolution[2])
    EndIf
  Next 
  updateResolution($res_string)
  ;calculateWidthHeight()
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>resolutionsClick
Func rri_menu_quitClick()
  SaveSession()
  rri_winClose()
EndFunc   ;==>rri_menu_quitClick
Func rri_menu_export_formulaClick()
  $flags = getCurrentFlags()
  Local $pid = runReflexWithArguments('--simplify --openoffice'&$flags)
  Local $lines = ''
  Local $f = ''
  While True
    $text = StdoutRead($pid)
    if @error Then
      ExitLoop
    Else
      $lines &= $text
    EndIf
  WEnd
  $errors_pid = StderrRead($pid)
  If $errors_pid<>'' Then
    MsgBox(0, $Errors, $errors_pid);
    Return -1
  EndIf
  $lines = StringSplit($lines, @LF)
  For $i = 1 To $lines[0]
    If StringStartsWith($lines[$i], 'formula:') Then
      $f = StringMid($lines[$i], 9)
      ExitLoop
    EndIf
  Next
  If $f <> "" Then
    ClipPut($f)
    MsgBox(0, $__formula_exported__, $__formula_correctly_exported_to_clipboard__&@CRLF&$f)
  EndIf
EndFunc
Func rri_menu_quitnosaveClick()
  CloseApp()
EndFunc   ;==>rri_menu_quitnosaveClick
Func rri_winClose()
  CloseApp()
EndFunc   ;==>rri_winClose
Func CloseApp()
  AnimateToTopRight($rri_win)
  Exit
EndFunc   ;==>CloseApp

Func rri_winMaximize()
  updatePos()
  rri_line_resetInit()
EndFunc   ;==>rri_winMaximize
Func rri_winMinimize()
  ;If BitAND(WinGetState($rri_win), 16) Then Return
  logging("Main window minimized")
  WindowManager__minimizeAll()
EndFunc   ;==>rri_winMinimize
Func rri_winRestore()
  updatePos()
  logging("Main window restored")
  rri_line_resetInit()
  WindowManager__restoreAll()
EndFunc   ;==>rri_winRestore
Func rri_winResize()
  logging("Main window resized")
  updatePos()
  rri_line_resetInit()
EndFunc   ;==>rri_winResize
;   $window_string : 
Func updateWindow($window_string)
  if StringInStr($window_string, ', ') <> 0 Then
    $elements = StringSplit($window_string, ', ', 1)
    setWinminmax($elements[1], $elements[2])
  EndIf
EndFunc   ;==>updateWindow
Func windowClick()
  $window_string = ''
  if @GUI_CTRLID==$rri_window_1 Then $window_string = '-1-i, 1+i'
  if @GUI_CTRLID==$rri_window_2 Then $window_string = '-2-2i, 2+2i'
  if @GUI_CTRLID==$rri_window_4 Then $window_string = '-4-4i, 4+4i'
  if @GUI_CTRLID==$rri_window_8 Then $window_string = '-8-8i, 8+8i'
  if @GUI_CTRLID==$rri_window_pi Then $window_string = '-pi-pi*i, pi+pi*i'
  updateWindow($window_string)
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>windowClick
Func rri_drag_reflexClick()
  $navigation = $DRAG
EndFunc   ;==>rri_drag_reflexClick
Func rri_next_windowClick()
  If winNext() Then
    renderIfAutoRender($rri_out_rendu)
  EndIf
EndFunc   ;==>rri_next_windowClick
Func rri_previous_windowClick()
  If winPrevious() Then
    renderIfAutoRender($rri_out_rendu)
  EndIf
EndFunc   ;==>rri_previous_windowClick
Func changeNavigationState()
  If isChecked($rri_drag_reflex) Then $navigation = $DRAG
  If isChecked($rri_zoom_forward) Then $navigation = $ZOOM_FORWARD
  If isChecked($rri_zoom_backward) Then $navigation = $ZOOM_BACKWARD
EndFunc   ;==>changeNavigationState
Func rri_zoom_backwardClick()
  changeNavigationState()
EndFunc   ;==>rri_zoom_backwardClick
Func rri_zoom_forwardClick()
  changeNavigationState()
EndFunc   ;==>rri_zoom_forwardClick
;   $factor : 
Func zoom_factor($factor)
  ;$__reflex_renderer_interface__
  $zoom_factor_posrendu = $rri_out_rendu_pos
  $dw = Int($zoom_factor_posrendu[2]/2)
  $dh = Int($zoom_factor_posrendu[3]/2)
  $cx = $zoom_factor_posrendu[0]+$dw
  $cy = $zoom_factor_posrendu[1]+$dh
  ;logging(StringFormat("%d, %d, %d, %d", $dw, $dh, $cx, $y))
  $wincenter = complex_calculate(StringFormat("(%s+%s)/2", $winmin, $winmax))
  logging($wincenter)
  $winmin_new = complex_calculate(StringFormat("(%s-(%s))*%g+%s", $winmin, $wincenter, $factor, $wincenter))
  $winmax_new = complex_calculate(StringFormat("(%s-(%s))*%g+%s", $winmax, $wincenter, $factor, $wincenter))
  zoomForward($cx - $dw * $factor , $cy - $dh * $factor, $cx + $dw * $factor + 1, $cy + $dh * $factor + 1)
  setWinminmax($winmin_new, $winmax_new)
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>zoom_factor
Func rri_zoom_in_factorClick()
  zoom_factor(1.0 / Number(GUICtrlRead($rri_zoom_factor)))
EndFunc   ;==>rri_zoom_in_factorClick
Func rri_zoom_out_factorClick()
  zoom_factor(Number(GUICtrlRead($rri_zoom_factor)))
EndFunc   ;==>rri_zoom_out_factorClick
Func rri_zoom_factorChange()
EndFunc   ;==>rri_zoom_factorChange
Func rri_zoom_absoluteChange()
  $newZoomAbsolute = Number(GUICtrlRead($rri_zoom_absolute))
  If $newZoomAbsolute <= 0 Then Return
  If isAutoRender() Then
    zoom_factor($newZoomAbsolute / $zoomAbsolutePrevious)
  EndIf
  $zoomAbsolutePrevious = $newZoomAbsolute
EndFunc   ;==>rri_zoom_absoluteChange

;~ $id_graphic = GUICtrlCreateGraphic(46, 206, 205, 205)
;~ GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0x000000,0xc000000)
;~ GUICtrlSetGraphic(-1,$GUI_GR_RECT, 0, 0, 205, 2)
;~ GUICtrlSetGraphic(-1,$GUI_GR_RECT, 0, 203, 205, 2)
;~ GUICtrlSetGraphic(-1,$GUI_GR_RECT, 0, 0, 2, 205)
;~ GUICtrlSetGraphic(-1,$GUI_GR_RECT, 203, 0, 2, 205)
;~ GUICtrlSetState($id_graphic, $GUI_SHOW)

Func winChangeState()
  GUICtrlSetState($rri_previous_window, _IIf($nPreviousWindows > 0, $GUI_ENABLE, $GUI_DISABLE))
  GUICtrlSetState($rri_next_window, _IIf($nNextWindows > 0, $GUI_ENABLE, $GUI_DISABLE))
EndFunc   ;==>winChangeState

Func setWinminmax($winmin, $winmax)
  GUICtrlSetData($rri_winmin, $winmin)
  GUICtrlSetData($rri_winmax, $winmax)
  updateWinmin()
  updateWinmax()
EndFunc

;   $winmin : 
Func setWinmin($winmin)
  GUICtrlSetData($rri_winmin, $winmin)
  rri_winminChange()
EndFunc   ;==>setWinmin
;   $winmax : 
Func setWinmax($winmax)
  GUICtrlSetData($rri_winmax, $winmax)
  rri_winmaxChange()
EndFunc   ;==>setWinmax
Func getWinmin()
  Return $winmin
EndFunc   ;==>getWinmin
Func getWinmax()
  Return $winmax
EndFunc   ;==>getWinmax

Func winPrevious()
  If $nPreviousWindows <= 0 or $currentWindow == 0 Then Return False
  $currentWindow -= 1
  $nPreviousWindows -= 1
  $nNextWindows += 1
  $w = $arrayWindows[$currentWindow]
  setWinminmax($w[0], $w[1])
  winChangeState()
  Return True
EndFunc   ;==>winPrevious

Func winNext()
  If $nNextWindows <= 0 or $currentWindow == 0 Then Return False
  $currentWindow += 1
  $nPreviousWindows += 1
  $nNextWindows -= 1
  $w = $arrayWindows[$currentWindow]
  setWinminmax($w[0], $w[1])
  winChangeState()
  Return True
EndFunc   ;==>winNext

;   $string : 
Func updateFormula($string)
  ;TODO: Detect if there are some Variable windows somewhere,
  ;and if so, use them to replace the variables by their values.
  $string = Variables__updateString($string)
  ;logging("updated: "&$string)
  GUICtrlSetData($rri_in_formula, $string)
  ;GUICtrlSetData($rri_in_formula, $string)
EndFunc   ;==>updateFormula

Func frmSave()
  GUICtrlSetData($rri_in_formula, GUICtrlRead($rri_in_formula))
EndFunc   ;==>frmSave

Func winSave()
  ;logging("PWindow array: "&$currentWindow&" of "&toString($arrayWindows))
  $wn = getWinmin()
  $wx = getWinmax()
  If size($arrayWindows)==0 Then
    $new = _ArrayCreate($wn, $wx)
    $currentWindow = 1
    insert($arrayWindows, $new, $currentWindow)
    winChangeState()
  Else
    $prev = $arrayWindows[$currentWindow]
    If $wn == $prev[0] and $wx == $prev[1] Then
      ;Nothing
    Else
      $new = _ArrayCreate($wn, $wx)
      $currentWindow += 1
      $nPreviousWindows += 1
      insert($arrayWindows, $new, $currentWindow)
      
      if (UBound($arrayWindows) > 100) Then
        if $nNextWindows > 0 Then
          deleteAt($arrayWindows, $currentWindow + $nNextWindows)
          $nNextWindows -= 1
        Else
          $nPreviousWindows -= 1
          $currentWindow -= 1
          deleteAt($arrayWindows, 1)
        EndIf
      EndIf
      winChangeState()
    EndIf
  EndIf
  ;logging("SWindow array: "&$currentWindow&" of "&toString($arrayWindows))
EndFunc   ;==>winSave
Func isAutoRender()
  Return isChecked($rri_check_auto_render)
EndFunc   ;==>isAutoRender
;   $id_rendu : 
Func renderIfAutoRender($id_rendu)
  if isAutoRender() Then
    ;render($id_rendu)
    updatePic()
  Else
    $REFLEX_RENDERED = $REFLEX_NOT_UP_TO_DATE
    FocusRenderButton()
  EndIf
EndFunc   ;==>renderIfAutoRender
;   $id_rendu : 

Func getCurrentFlags()
  Local $flags = ""
  addFlag($flags, "formula", GUICtrlRead($rri_in_formula))
  addFlag($flags, "width",  $width_percent)
  addFlag($flags, "height", $height_percent)
  addFlag($flags, "winmin", getWinmin())
  addFlag($flags, "winmax", getWinmax())
  addFlag($flags, "output", GUICtrlRead($rri_output))
  addFlag($flags, "seed",   GUICtrlRead($rri_seed))
  If isChecked($rri_realmode) Then addFlag($flags, "realmode","")
  addFlag($flags, "colornan", $color_NaN_complex)
  Return $flags
EndFunc
Func render($id_rendu)
  ;logging("Rendering...")
  winSave()
  frmSave()
  $flags = getCurrentFlags()
  $RENDERING_IMAGE_TO_UPDATE = $id_rendu
  startRendering($flags)
EndFunc   ;==>render

;   $flags : 
Func startRendering($flags)
  GUICtrlSetState($rri_rendering_text, $GUI_SHOW)
  GUICtrlSetState($rri_progress, $GUI_SHOW)
  GUICtrlSetData($rri_progress, 0)
  If $pid_rendering <> 0 or $rendering_thread Then
    ;Kill the previous process first
    ProcessClose($pid_rendering)
  EndIf
  $REFLEX_RENDERING = _Iif(isChecked($rri_preview), $REFLEX_RENDERED_IN_LR, $REFLEX_RENDERED_IN_HR)
  $REFLEX_RENDERED_FINISHED = False
  $pid_rendering = runReflexWithArguments('--render'&$flags)
  $rendering_thread = True
EndFunc   ;==>startRendering

Func handleRenderingAndIsFinished()
  Local $lines, $p = -1
  $text = StdoutRead($pid_rendering)
  If @error Then
    Return True
  Else
    $lines = StringSplit($text, @CRLF, 1)
    For $i = 1 To $lines[0]
      $current_line = $lines[$i]
      ;Logging("Line to compare: "&$current_line)
      If isFormulaLine($current_line) Then
        ;Logging("Formula!")
        $formula = extractFormulaLine($current_line)
        updateFormula($formula)
        If $EDIT_FORMULA_EXISTS Then
          $seed    = GUICtrlRead($rri_seed)
          EditFormula__UpdateFormulaFromApplication($formula)
        EndIf
      Else
        $progress = StringSplit($current_line, '/')
        If $progress[0]>=2 Then
          $p = 100*Int($progress[1])/Int($progress[2])

        EndIf
      EndIf
    Next
    If $p >= 0 Then
      GUICtrlSetData($rri_progress, $p)
    EndIf
    If $zooming <> 0 and $p >= 0 Then
      Local $growing = $zoomvars[2]/$zoomvars[6]
      Local $k = Exp($p/100 * log($zoomvars[6]))*Exp((1-$p/100) * log($zoomvars[2]))/$zoomvars[6]
      Local $c = ($k - 1)/($growing - 1)
      Local $m = 1 - $c
      GUICtrlSetPos($rri_out_rendu, _
          $c * $zoomvars[0] + $m * $zoomvars[4], $c * $zoomvars[1] + $m *  $zoomvars[5], _
          $c * $zoomvars[2] + $m * $zoomvars[6], $c * $zoomvars[3] + $m *  $zoomvars[7])
    EndIf
  EndIf
  Return False
EndFunc   ;==>handleRenderingAndIsFinished

Func handleFinishedRendering()
  $errors_pid = StderrRead($pid_rendering)
  $pid_rendering = 0
  GUICtrlSetState($rri_rendering_text, $GUI_HIDE)
  GUICtrlSetState($rri_progress, $GUI_HIDE)
  $REFLEX_RENDERED_FINISHED = True
  
  If $zooming <> 0 Then
    $zooming = 0
  EndIf
  
  if $errors_pid <> '' Then
    MsgBox(0, $Errors, $errors_pid);
    If $EDIT_FORMULA_EXISTS Then
      $p_str = StringInStr($errors_pid, "position ")
      $position = Int(StringMid($errors_pid, $p_str + 9))
      EditFormula__HighlightError($position, $position + 1)
    EndIf
    Return False
  EndIf
  $REFLEX_RENDERED = $REFLEX_RENDERING
  ;logging("Reflex rendered = "&$REFLEX_RENDERED)
  autosaveFormula()
  Return True
EndFunc   ;==>handleFinishedRendering

Func history_formula_arrayLoad()
  $f = FileOpen($history_formula_filename, 0)
  While True
    $formula = FileReadLine($f)
    If @error <> 0 Then ExitLoop
    If $formula <> "" Then _ArrayPush($history_formula_array, $formula)
  WEnd
  FileClose($f)
EndFunc   ;==>history_formula_arrayLoad

Func autosaveFormula()
  $formula = GUICtrlRead($rri_in_formula)
  If _ArraySearch($history_formula_array, $formula) == -1 Then
    saveFormulaIntoFile($history_formula_filename, GUICtrlRead($rri_in_formula), "", False, False, False)
    _ArrayPush($history_formula_array, $formula)
  EndIf
EndFunc   ;==>autosaveFormula

Func handlePostFinishedRendering()
  repositionneRendu($RENDERING_IMAGE_TO_UPDATE, 0, 0)
  GUICtrlSetImage($RENDERING_IMAGE_TO_UPDATE,  GUICtrlRead($rri_output))
  If $UPDATE_PIC Then
    GUICtrlSetState($rri_out_rendu2, $GUI_SHOW)
    GUICtrlSetState($rri_out_rendu, $GUI_HIDE)
    repositionneRendu($rri_out_rendu, 0, 0)
    GUICtrlSetImage($rri_out_rendu, GUICtrlRead($rri_output))
    GUICtrlSetState($rri_out_rendu, $GUI_SHOW)
    GUICtrlSetState($rri_out_rendu2, $GUI_HIDE)
    GUICtrlDelete($rri_out_rendu2);
  EndIf
EndFunc   ;==>handlePostFinishedRendering

;   $flags        : 
;   $bool_highres : 
Func renderWithFlags($flags, $bool_highres)
  startRendering($flags)
  $rendering_thread = False
  ;Override what the render engine thinks
  If $bool_highres Then
    $REFLEX_RENDERING = $REFLEX_RENDERED_IN_HR
  Else
    $REFLEX_RENDERING = $REFLEX_RENDERED_IN_LR
  EndIf
  Sleep(100)
  While True
    If handleRenderingAndIsFinished() Then ExitLoop
  WEnd
  Return handleFinishedRendering()
EndFunc   ;==>renderWithFlags

;   $filename : 
Func getFirstAvailableFileName($filename)
  While FileExists($filename)
    $filename = incrementFileName($filename)
  WEnd
  Return $filename
EndFunc   ;==>getFirstAvailableFileName

Func saveReflex()
  SaveSession()
  Local $reflex_file = UpdateMyDocuments(IniReadSavebox('reflexFile', ''))
  $reflex_file = getFirstAvailableFileName($reflex_file)
  $isBmp =  StringEndsWith($reflex_file, '.bmp')
  $isJpeg = StringEndsWith($reflex_file, '.jpeg') Or StringEndsWith($reflex_file, '.jpg')
  $isPng =  StringEndsWith($reflex_file, '.png')
  If Not ($isBmp Or $isJpeg Or $isPng) Then
    MsgBox(0, $Error, StringFormat($unknown_file_format_s, $reflex_file))
    Return
  EndIf
  $lowres = isSavebox('LRReflex')
  $highres = isSavebox('HRReflex')
  ;logging(StringFormat("Valeur: highres=%d, lowres=%d, reflex_rendered=%d", $highres, $lowres, $reflex_rendered))
  If ($highres And $REFLEX_RENDERED <> $REFLEX_RENDERED_IN_HR) Or ($lowres And $REFLEX_RENDERED <> $REFLEX_RENDERED_IN_LR) _
Or $REFLEX_RENDERED = $REFLEX_NOT_UP_TO_DATE Then
    ;Renders the reflex depending on the resolution (low or high)
    $width_local = Int(IniRead($ini_file, $ini_file_session, 'width', ''))
    $height_local = Int(IniRead($ini_file, $ini_file_session, 'height', ''))
    If $lowres Then
      $percent_preview = Number(IniRead($ini_file, $ini_file_session, 'percentPreview', ''))
      $width_local = Int(($width_local * $percent_preview)/100)
      $height_local =Int(($height_local * $percent_preview)/100)
    EndIf
    Dim $flags = ""
    addFlag($flags, "formula", IniRead($ini_file, $ini_file_session, 'formula', ''))
    addFlag($flags, "width"  , $width_local)
    addFlag($flags, "height",  $height_local)
    addFlag($flags, "winmin",  IniRead($ini_file, $ini_file_session, 'winmin', ''))
    addFlag($flags, "winmax",  IniRead($ini_file, $ini_file_session, 'winmax', ''))
    If $isBmp Then ;On le rend directement à la bonne place!
      addFlag($flags, "output", $reflex_file)
    Else
      addFlag($flags, "output", IniRead($ini_file, $ini_file_session, 'outputFile', ''))
    EndIf
	addFlag($flags, "seed",     GUICtrlRead($rri_seed))
    If isChecked($rri_realmode) Then addFlag($flags, "realmode")
    addFlag($flags, "colornan", $color_NaN_complex)
    If renderWithFlags($flags, $highres) Then
      repositionneRendu($rri_out_rendu, 0, 0)
      GUICtrlSetImage($rri_out_rendu,  GUICtrlRead($rri_output))
    EndIf
    ;FocusRenderButton()
  EndIf
  $existing = IniRead($ini_file, $ini_file_session, 'outputFile', '')
  If $isBmp Then
    ;If FileGetSize($reflex_file) < 10000000 Then
      ;FileCopy($reflex_file, $existing, 1)
      ;If @error Then
      ;  MsgBox(0, $Error, StringFormat($Could_not_copy_from___s__to___s_, $reflex_file, $existing))
      ;EndIf
    GUICtrlSetImage($rri_out_rendu,  $reflex_file)
    ;EndIf
  ElseIf $isJpeg Then
    ;Logging("Copying to "&$reflex_file)
    ImageConvert($existing, $reflex_file)
    If Not FileExists($reflex_file) Then
      FileMove($existing, StringReplace(StringReplace($reflex_file, ".jpg", ".bmp"), ".jpeg", ".bmp"))
      MsgBox(0, $Error, StringFormat($Could_not_convert_from___s__to___s_, $existing, $reflex_file))
    Else
      $formula_and_options = defaultFormulaString()
      Dim $informations = _ArrayCreate(2, _ArrayCreate("title", "Reflex"), _ArrayCreate("comment", $formula_and_options))
      WriteXPSections($reflex_file, $informations)
    EndIf
  ElseIf $isPng Then
    ImageConvert($existing, $reflex_file)
    If Not FileExists($reflex_file) Then
      FileMove($existing, StringReplace($reflex_file, ".png", ".bmp"))
      MsgBox(0, $Error, StringFormat($Could_not_convert_from___s__to___s_, $existing, $reflex_file))
    Else
      $formula_and_options = defaultFormulaString()
      Dim $informations = _ArrayCreate(3, _ArrayCreate("Title", "Reflex"), _ArrayCreate("Comment", $formula_and_options), _ArrayCreate("Software", "ReflexRenderer v."&$VERSION_NUMER))
      WritePngTextChunks($reflex_file, $informations)
    EndIf
  EndIf
EndFunc   ;==>saveReflex

Func defaultFormulaString()
  $comment = IniReadSavebox('formulaComment', '')
  $formula_and_options = saveFormulaString(IniRead($ini_file, 'Session', 'formula', ''), $comment, isSavebox('saveComment'), isSavebox('saveResolution'), isSavebox('saveWindow'))
  return $formula_and_options
EndFunc   ;==>defaultFormulaString

Func calculateWidthHeight()
  $width_highres  = Int(GUICtrlRead($rri_width))
  $height_highres = Int(GUICtrlRead($rri_height))
  if isChecked($rri_preview) Then
    $percent = Int(GUICtrlRead($rri_percent))
    $width_percent = Int(($width_highres * $percent)/100)
    $height_percent = Int(($height_highres * $percent)/100)
  Else
    $width_percent = $width_highres
    $height_percent = $height_highres
  EndIf
  $maxwh = _Max($width_percent, $height_percent)
EndFunc   ;==>calculateWidthHeight

;   $delta_x : 
;   $delta_y : 
Func getWinMinMaxMoved($delta_x, $delta_y)
  Dim $flags = ""
  ;addFlag($flags, "formula", GUICtrlRead($rri_in_formula))
  addFlag($flags, "width",  $width_percent)
  addFlag($flags, "height", $height_percent)
  addFlag($flags, "winmin", getWinmin())
  addFlag($flags, "winmax", getWinmax())
  ;addFlag($flags, "output", GUICtrlRead($rri_output))
  addFlag($flags, "delta_x", $delta_x)
  addFlag($flags, "delta_y", $delta_y)
  $pid = runReflexWithArguments('--new_window'&$flags)
  Dim $lines = '';
  While True
    $text = StdoutRead($pid)
    if @error Then
      ExitLoop
    Else
      $lines &= $text
    EndIf
  WEnd
  $errors_pid = StderrRead($pid)
  If $errors_pid<>'' Then
    MsgBox(0, $Errors, $errors_pid);
    Return -1
  EndIf
  $lines = StringSplit($lines, @CRLF, 1)
  $winminmax = StringSplit($lines[1],';:,')
  Return $winminmax
EndFunc   ;==>getWinMinMaxMoved

Func updatePos()
  ;Logging("UpdatePos & "&Random(0, 1))
  $pos = ControlGetPos($rri_win, '', $rri_group_reflex)
  ;Centered!
  $output_x = $pos[0] + $pos[2]/2 - $output_max_size/2
  $output_y = $pos[1] + $pos[3]/2 - $output_max_size/2
  repositionneRendu($rri_out_rendu, 0, 0)
  $rri_out_rendu_pos = ControlGetPos($rri_win, '', $rri_out_rendu)
  ;$output_max_size = _Max($pos[2],$pos[3])
EndFunc   ;==>updatePos

Func updatePic()
  Global $rri_out_rendu2 = GUICtrlCreatePic('', 0, 0, 1, 1, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
  GUICtrlSetState($rri_out_rendu2, $GUI_HIDE)
  ;Logging("updatePic - repositionneRendu")
  repositionneRendu($rri_out_rendu2, 0, 0)
  $UPDATE_PIC = True
  render($rri_out_rendu2)
EndFunc   ;==>updatePic

Func move_window()
  ;calculateWidthHeight()
  $winminmax = getWinMinMaxMoved((-$dx * $maxwh / $output_max_size), $dy * $maxwh / $output_max_size)
  if $winminmax == -1 Then Return
  setWinminmax($winminmax[1], $winminmax[2])
EndFunc   ;==>move_window

;   $pos  : 
;   $xmin : 
;   $ymin : 
;   $xmax : 
;   $ymax : 
Func AnimateZoomForward($pos, $xmin, $ymin, $xmax, $ymax)
  ;How to resize $rri_out_rendu so that $x0... $y1 would be replaced to $rri_out_rendu?
  invertCoordinates($pos, $xmin, $ymin, $xmax, $ymax)
  $dx = $xmax - $xmin + 1
  $dy = $ymax - $ymin + 1
  ;Logging("Animation to size "&$dx&","&$dy)
  $limite_taille = 3000
  If $dx > $limite_taille Or $dy > $limite_taille Then Return
  $pos = ControlGetPos($rri_win, "", $rri_out_rendu)
  If Not $animated_zoom Then
    GUICtrlSetPos($rri_out_rendu, $xmin, $ymin, $dx, $dy)
    Return
  Else
    $zooming = 1
    $zoomvars = _ArrayCreate($pos[0], $pos[1], $pos[2], $pos[3], $xmin, $ymin, $dx, $dy)
  EndIf
  ;logging("Animated.")
  Return
EndFunc   ;==>AnimateZoomForward

;   $pos  : 
;   $xmin : 
;   $ymin : 
;   $xmax : 
;   $ymax : 
Func AnimateZoomBackward($pos, $xmin, $ymin, $xmax, $ymax)
  ;How to resize $rri_out_rendu so that $x0... $y1 would be replaced to $rri_out_rendu?
  $dx = $xmax - $xmin + 1
  $dy = $ymax - $ymin + 1
  ;logging("Animation back to size "&$dx&","&$dy)
  $limite_taille = 3000
  If $dx > $limite_taille Or $dy > $limite_taille Then Return
  $pos = ControlGetPos($rri_win, "", $rri_out_rendu)
  If Not $animated_zoom Then
    GUICtrlSetPos($rri_out_rendu, $xmin, $ymin, $dx, $dy)
    Return
  Else
    $zooming = -1
    $zoomvars = _ArrayCreate($pos[0], $pos[1], $pos[2], $pos[3], $xmin, $ymin, $dx, $dy)
  EndIf
  ;logging("Animated.")
  Return
EndFunc   ;==>AnimateZoomBackward

;   $x0     : 
;   $y0     : 
;   $x1     : 
;   $y1     : 
;   $width  : 
;   $height : 
Func resizeCoordinates($x0, $y0, $x1, $y1, $width, $height)
  $xmin = _Min($x0, $x1)
  $ymin = _Min($y0, $y1)
  $xmax = _Max($x0, $x1)
  $ymax = _Max($y0, $y1)
    
  $xcenter = ($xmax + $xmin)/2;
  $ycenter = ($ymax + $ymin)/2;
  if ($xmax-$xcenter) / ($ymax-$ycenter) < $width / $height Then
    $xmax = $width / $height * ($ymax - $ycenter) + $xcenter
    $xmin = $width / $height * ($ymin - $ycenter) + $xcenter
  Else
    $ymax = $height / $width * ($xmax - $xcenter) + $ycenter
    $ymin = $height / $width * ($xmin - $xcenter) + $ycenter
  EndIf  
  return _ArrayCreate($xmin, $ymin, $xmax, $ymax)
EndFunc   ;==>resizeCoordinates

;   $x0 : 
;   $y0 : 
;   $x1 : 
;   $y1 : 
Func zoomForward($x0, $y0, $x1, $y1)
  ;calculateWidthHeight()
  $coord = resizeCoordinates($x0, $y0, $x1, $y1, $width_percent, $height_percent)
  $xmin = $coord[0]
  $ymin = $coord[1]
  $xmax = $coord[2]
  $ymax = $coord[3]  
  if $xmin == $xmax and $ymin == $ymax Then Return
  $zoom_forward_pos = $rri_out_rendu_pos
  
  AnimateZoomForward($zoom_forward_pos, $xmin, $ymin, $xmax, $ymax)
  
  $deltax_min = $xmin - $zoom_forward_pos[0]
  $deltay_min = -$ymax + ($zoom_forward_pos[1]+$zoom_forward_pos[3])
  $deltax_max = $xmax - ($zoom_forward_pos[0]+$zoom_forward_pos[2])
  $deltay_max = - $ymin + $zoom_forward_pos[1]
  $winminmax = getWinMinMaxMoved(($deltax_min * $maxwh / $output_max_size), ($deltay_min * $maxwh / $output_max_size))
  $future_winmin = $winminmax[1]

  $winminmax = getWinMinMaxMoved(($deltax_max * $maxwh / $output_max_size), ($deltay_max * $maxwh / $output_max_size))
  ;Winmax part
  $future_winmax = $winminmax[2]
  setWinminmax($future_winmin, $future_winmax)
EndFunc   ;==>zoomForward

;   $pos  : 
;   $xmin : 
;   $ymin : 
;   $xmax : 
;   $ymax : 
Func invertCoordinates(Const ByRef $pos, ByRef $xmin, ByRef $ymin, ByRef $xmax, ByRef $ymax)
  ;Make xmin/xmax/ymin/ymax bigger so that it fits $pos,
  ;and increase $pos the same way.
  
  ;First: find the center of  the x transformation.
  
  ; $pos[0] = $xmin * $facteur + $offset
  ; ($pos[0]+$pos[2]) = $xmax * $facteur + $offset
  $facteur = ($pos[2])/($xmax-$xmin)
  $offset = $pos[0] - $xmin * $facteur
  
  ;and then:
  $xmin = $pos[0] * $facteur + $offset
  $xmax = ($pos[0]+$pos[2]) * $facteur + $offset
  
  ; $pos[1] = $ymin * $facteur + $offset
  ; ($pos[1]+$pos[3]) = $ymax * $facteur + $offset
  $facteur = ($pos[3])/($ymax-$ymin)
  $offset = $pos[1] - $ymin * $facteur 
  ;and then:
  $ymin = $pos[1] * $facteur + $offset
  $ymax = ($pos[1]+$pos[3]) * $facteur + $offset
EndFunc   ;==>invertCoordinates

;   $x0 : 
;   $y0 : 
;   $x1 : 
;   $y1 : 
Func zoomBackward($x0, $y0, $x1, $y1)
  ;calculateWidthHeight()
  ; Everything is to be recalculated... because it's not linear
  
  $coord = resizeCoordinates($x0, $y0, $x1, $y1, $width_percent, $height_percent)
  $xmin = $coord[0]
  $ymin = $coord[1]
  $xmax = $coord[2]
  $ymax = $coord[3]
  if $xmin == $xmax or $ymin == $ymax Then Return
  
  $pos = $rri_out_rendu_pos
  AnimateZoomBackward($pos, $xmin, $ymin, $xmax, $ymax)
  invertCoordinates($pos, $xmin, $ymin, $xmax, $ymax)
  
  $deltax_min = $xmin - $pos[0]
  $deltay_min = - $ymax + ($pos[1]+$pos[3])
  $deltax_max = $xmax - ($pos[0]+$pos[2])
  $deltay_max = - $ymin + $pos[1]
  
  $winminmax = getWinMinMaxMoved(($deltax_min * $maxwh / $output_max_size), ($deltay_min * $maxwh / $output_max_size))
  $future_winmin = $winminmax[1]

  $winminmax = getWinMinMaxMoved(($deltax_max * $maxwh / $output_max_size), ($deltay_max * $maxwh / $output_max_size))
  ;Winmax part
  $future_winmax = $winminmax[2]
  
  
  setWinminmax($future_winmin, $future_winmax)
EndFunc   ;==>zoomBackward

;   $id_rendu : 
;   $dx       : 
;   $dy       : 
Func repositionneRendu($id_rendu, $dx, $dy)
  ;calculateWidthHeight()
  Local $width, $height
  
  If $width_percent > $height_percent Then
    $height = $height_percent *  $output_max_size / $width_percent
    $width = $output_max_size
  Else
    $width = $width_percent *  $output_max_size / $height_percent
    $height = $output_max_size
  EndIf
  $xmin = $output_x+($output_max_size-$width)/2+$dx
  $ymin = $output_y+($output_max_size-$height)/2+$dy
  GUICtrlSetPos($id_rendu, $xmin, $ymin, $width, $height)
  ;Logging(StringFormat("Déplacement vers %s, %s, %s, %s", $xmin, $ymin, $width, $height))
EndFunc   ;==>repositionneRendu

;   $boolean : 
Func displayZoombox($boolean)
  $state = _Iif($boolean, $GUI_SHOW, $GUI_HIDE)
  GUICtrlSetState($rri_zoom_box0, $state)
  GUICtrlSetState($rri_zoom_box1, $state)
  GUICtrlSetState($rri_zoom_box2, $state)
  GUICtrlSetState($rri_zoom_box3, $state)
  GUICtrlSetState($rri_zoom_box_gray0, $state)
  GUICtrlSetState($rri_zoom_box_gray1, $state)
  GUICtrlSetState($rri_zoom_box_gray2, $state)
  GUICtrlSetState($rri_zoom_box_gray3, $state)
EndFunc   ;==>displayZoombox

;   $x0 : 
;   $y0 : 
;   $x1 : 
;   $y1 : 
Func resizeZoomBox($x0, $y0, $x1, $y1)
  If $x0 > $x1 Then
    $temp = $x0
    $x0 = $x1
    $x1 = $temp
  EndIf
  If $y0 > $y1 Then
    $temp = $y0
    $y0 = $y1
    $y1 = $temp
  EndIf
  $dx = $x1 - $x0 + 1
  $dy = $y1 - $y0 + 1
  ControlMove($rri_win,'', $rri_zoom_box0, $x0, $y0, $dx, 1)
  ControlMove($rri_win,'', $rri_zoom_box1, $x1, $y0, 1, $dy)
  ControlMove($rri_win,'', $rri_zoom_box2, $x0, $y1, $dx, 1)
  ControlMove($rri_win,'', $rri_zoom_box3, $x0, $y0, 1, $dy)
  
  $coord = resizeCoordinates($x0, $y0, $x1, $y1, $width_percent, $height_percent)
  $x0 = $coord[0]
  $y0 = $coord[1]
  $x1 = $coord[2]
  $y1 = $coord[3]
  $dx = $x1 - $x0 + 1
  $dy = $y1 - $y0 + 1
  ControlMove($rri_win,'', $rri_zoom_box_gray0, $x0, $y0, $dx, 1)
  ControlMove($rri_win,'', $rri_zoom_box_gray1, $x1, $y0, 1, $dy)
  ControlMove($rri_win,'', $rri_zoom_box_gray2, $x0, $y1, $dx, 1)
  ControlMove($rri_win,'', $rri_zoom_box_gray3, $x0, $y0, 1, $dy)
EndFunc   ;==>resizeZoomBox
Func rri_line_resetInit()
  $respos = ControlGetPos($rri_win,'',$rri_reset_resolution)
  $heipos = ControlGetPos($rri_win,'',$rri_height)
  $newx = $heipos[0]+$heipos[2]
  $newy = $heipos[1]+$heipos[3]/2
  $neww = $respos[0] - ($heipos[0]+$heipos[2])
  $newh = 2
  ControlMove($rri_win,'', $rri_line_reset, _
  $newx, $newy, $neww, $newh)
  GUICtrlSetState($rri_line_reset, $GUI_SHOW)
EndFunc   ;==>rri_line_resetInit
Func rri_line_resetClick()
EndFunc   ;==>rri_line_resetClick
Func id_graphicClick()
EndFunc   ;==>id_graphicClick
Func rri_out_rendu_zoomClick()
EndFunc   ;==>rri_out_rendu_zoomClick
Func rri_zoom_box0Click()
  rri_out_renduClick()
EndFunc   ;==>rri_zoom_box0Click
Func rri_zoom_box1Click()
  rri_out_renduClick()
EndFunc   ;==>rri_zoom_box1Click
Func rri_zoom_box2Click()
  rri_out_renduClick()
EndFunc   ;==>rri_zoom_box2Click
Func rri_zoom_box3Click()
  rri_out_renduClick()
EndFunc   ;==>rri_zoom_box3Click
Func rri_zoom_box_gray0Click()
  rri_out_renduClick()
EndFunc   ;==>rri_zoom_box_gray0Click
Func rri_zoom_box_gray1Click()
  rri_out_renduClick()
EndFunc   ;==>rri_zoom_box_gray1Click
Func rri_zoom_box_gray2Click()
  rri_out_renduClick()
EndFunc   ;==>rri_zoom_box_gray2Click
Func rri_zoom_box_gray3Click()
  rri_out_renduClick()
EndFunc   ;==>rri_zoom_box_gray3Click

Func rri_reset_resolutionClick()
  LoadDefaultResolution()
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>rri_reset_resolutionClick
Func rri_reset_windowClick()
  LoadDefaultWindow()
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>rri_reset_windowClick

Func menu_setLang()
  $res_string = ''
  $language_name = ''
  For $language in $languages
    ;Logging("$"&$language[1]&Execute("$"&$language[1])&" : Value to be compared to "&@GUI_CTRLID)
    If Execute("$"&$language[1]) == @GUI_CTRLID Then
      $res_string = $language[2]
      $language_name = $language[0]
    EndIf
  Next
  If $res_string == '' Then
    MsgBox(0, "Error", "Internal error 9907")
    Return
  EndIf
  IniWrite($ini_file, $ini_file_session, "language", $res_string)
  SaveSession()
  WindowManager__closeAll()
  LoadTranslations()
  Local $old_rri_win = $rri_win
  AnimateToBottomRight($old_rri_win)
  LoadRRI()
  GUIDelete($old_rri_win)
  ;MsgBox(0, $changement_langue_titre, StringFormat($changement_langue_text__s, $language_name))
EndFunc   ;==>menu_setLang

Func rri_percentChange()
  calculateWidthHeight()
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>rri_percentChange

Func rri_realmodeClick()
  renderIfAutoRender($rri_out_rendu)
EndFunc   ;==>rri_realmodeClick

Func rri_menu_formula_historyClick()
  loadFormula($history_formula_filename)
EndFunc   ;==>rri_menu_formula_historyClick

;============================= Color code ==================================;

Func rri_color_code_buttonClick()
  Global $rcc_base_x = 484, $rcc_base_y = 408
  Global $rcc_win = GUICreate($__hint_color_code_button__, $rcc_base_x, $rcc_base_y, Default, Default, BitOR($WS_MAXIMIZEBOX,$WS_MINIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_SYSMENU,$WS_CAPTION,$WS_OVERLAPPEDWINDOW,$WS_TILEDWINDOW,$WS_POPUP,$WS_POPUPWINDOW,$WS_GROUP,$WS_TABSTOP,$WS_BORDER,$WS_CLIPSIBLINGS,$DS_MODALFRAME))
  GUISetOnEvent($GUI_EVENT_CLOSE, "rcc_winClose")
  GUISetOnEvent($GUI_EVENT_MAXIMIZE, "rcc_winResize")
  GUISetOnEvent($GUI_EVENT_RESIZED, 'rcc_winResize')
  Global $rcc_color_code = GUICtrlCreatePic($bin_dir&"RenderCodeColor.JPG", 0, 0, $rcc_base_x, $rcc_base_y)
  GUICtrlSetResizing ( $rcc_color_code, $GUI_DOCKLEFT+$GUI_DOCKTOP + $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM)
  rcc_winResize()
  AnimateFromTopLeft($rcc_win)
EndFunc   ;==>rri_color_code_buttonClick

Func rcc_winClose()
  AnimateToTopRight($rcc_win)
  GUIDelete($rcc_win)
  $rcc_win = 0
EndFunc   ;==>rcc_winClose

Func rcc_winResize()
  $pos = WinGetClientSize ($rcc_win)
  $rrc_w = $pos[0]
  $rrc_h = $pos[1]  
  If $rrc_h * $rcc_base_x > $rrc_w * $rcc_base_y  Then
    $rrc_h =  ($rrc_w  * $rcc_base_y) / $rcc_base_x
  Else
    $rrc_w  =  ($rrc_h * $rcc_base_x) / $rcc_base_y
  EndIf
  ControlMove($rcc_win, "", $rcc_color_code, 0, 0, $rrc_w, $rrc_h)
  GUICtrlSetState($rcc_color_code, $GUI_SHOW)
EndFunc   ;==>rcc_winResize

;============================= UNUSED FUNCS ==================================;

Func rri_outputChange()
EndFunc   ;==>rri_outputChange
Func rri_check_auto_renderClick()
EndFunc   ;==>rri_check_auto_renderClick
Func rri_menu_languageClick()
EndFunc   ;==>rri_menu_languageClick
Func rri_seedChange()
EndFunc   ;==>rri_seedChange

;============================= SILLY FUNCS ==================================;

Func rri_Label1Click()
EndFunc   ;==>rri_Label1Click
Func rri_LabelTitreClick()
EndFunc   ;==>rri_LabelTitreClick
Func rri_LabelTempFileClick()
EndFunc   ;==>rri_LabelTempFileClick
Func rri_LabelWinMaxClick()
EndFunc   ;==>rri_LabelWinMaxClick
Func rri_LabelWinMinClick()
EndFunc   ;==>rri_LabelWinMinClick
Func rri_DimLabelClick()
EndFunc   ;==>rri_DimLabelClick
Func rri_rendering_textClick()
EndFunc   ;==>rri_rendering_textClick
Func rri_LabelZoomFactorClick()
EndFunc   ;==>rri_LabelZoomFactorClick
Func rri_LabelZoomAbsoluteClick()
EndFunc   ;==>rri_LabelZoomAbsoluteClick
Func rri_labelXClick()
EndFunc   ;==>rri_labelXClick

;============================== LOAD/SAVE ===================================;

Func LoadDefaultResolution()
  LoadDefaultParameter('width', $rri_width)
  LoadDefaultParameter('height', $rri_height)
EndFunc   ;==>LoadDefaultResolution
Func LoadDefaultWindow()
  LoadDefaultParameter('winmin', $rri_winmin)
  LoadDefaultParameter('winmax', $rri_winmax)
  rri_winminChange()
  rri_winmaxChange()
EndFunc   ;==>LoadDefaultWindow

Func LoadSession()
  For $singlemap in $sessionParametersMap
    LoadSessionParameter($singlemap[0], $singlemap[1], $singlemap[2])
	Next
  For $singlemap in $sessionCheckBoxMap
    LoadSessionCheckBox($singlemap[0], $singlemap[1], $singlemap[2])
  Next
  changePreviewState()
EndFunc   ;==>LoadSession

Func SaveSession()
  For $singlemap in $sessionParametersMap
    SaveSessionParameter($singlemap[0], $singlemap[1])
  Next
  For $singlemap in $sessionCheckBoxMap
    SaveSessionCheckBox($singlemap[0], $singlemap[1])
  Next
  WindowManager__saveAll()
EndFunc   ;==>SaveSession