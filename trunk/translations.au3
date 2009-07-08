#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mika�l Mayer
 Date:           05/07/2008

 Script Function:
  Generates string variables for traduction.

#ce ----------------------------------------------------------------------------
#include-once
#include "IniHandling.au3"
#include "GlobalUtils.au3"
#include <Array.au3>

Global $lang_folder = 'lang' ;TODO: To externalize?
Global $translation_ini = ""
Global $ini_section = 'Messages'
Global $gui_section = 'GUI'
Global $translation_current_language = 'en'
Global $languages = emptySizedArray()

LoadTranslations()

Func LoadTranslations()

  $translation_current_language = IniRead($ini_file, $ini_file_session, 'language', 'en')
  Local $updates = True
  $translation_ini = @ScriptDir&'\'&$lang_folder&'\'&translationFile($translation_current_language)

  If not listLanguages() Then $languages = False

  Global $affectations_messages = _ArrayCreate( _ArrayCreate('Reflex_name', $ini_section, 'Reflex name', 'Reflex name'))
  add($affectations_messages, 'Bitmap_24_bits____bmp__All______', $ini_section, 'Bitmap 24 bits (*.bmp)|All (*.*)', 'Bitmap 24 bits (*.bmp)|All (*.*)')
  add($affectations_messages, 'My_nice_function', $ini_section, 'My nice function', 'My nice function')
  add($affectations_messages, 'Quick_save', $ini_section, 'Quick save', 'Quick save')
  add($affectations_messages, 'Give_a_comment_for_this_reflex_', $ini_section, 'Give a comment for this reflex.', 'Give a comment for this reflex.')
  add($affectations_messages, 'To_change_the_saving_directory__go_to', $ini_section, 'To change the saving directory, go to %s>%s', 'To change the saving directory, go to %s>%s')
  add($affectations_messages, 'Error_while_quick_saving_in_file', $ini_section, 'Error while quick saving in file', 'Error while quick saving in file')
  add($affectations_messages, 'Errors', $ini_section, 'Errors', 'Errors')
  add($affectations_messages, 'Error', $ini_section, 'Error', 'Error')
  add($affectations_messages, 'Could_not_copy_from___s__to___s_', $ini_section, "Could not copy from '%s' to '%s'", "Could not copy from '%s' to '%s'")
  add($affectations_messages, "Could_not_convert_from___s__to___s_", $ini_section, "Could not convert from '%s' to '%s'", "Could not convert from '%s' to '%s'")
  add($affectations_messages, "Formula_File", $ini_section, "Formula File", "Formula File")
  add($affectations_messages, "Formula_file____txt__All______", $ini_section, "Formula file (*.txt)|All (*.*)", "Formula file (*.txt)|All (*.*)")
  add($affectations_messages, "Jpeg_Reflex_File", $ini_section, "Jpeg Reflex File", "Jpeg Reflex File")
  add($affectations_messages, "Jpeg_Reflex_File____jpg__All______", $ini_section, "Jpeg Reflex file (*.jpg;*.jpeg)|All (*.*)", "Jpeg Reflex file (*.jpg;*.jpeg)|All (*.*)")
  add($affectations_messages, "I_love_the_Reflex_Renderer", $ini_section, "I love the Reflex Renderer", "I love the Reflex Renderer")
  add($affectations_messages, "Open_Formula_file", $ini_section, "Open Formula file", "Open Formula file")
  add($affectations_messages, "New_Formula_file", $ini_section, "New Formula file", "New Formula file")
  add($affectations_messages, "New_Reflex_file", $ini_section, "New Reflex file", "New Reflex file")
  add($affectations_messages, "Bitmap_24_bits____bmp__Jpeg____jpg_", $ini_section, "Bitmap 24 bits (*.bmp)|Jpeg (*.jpg)", "Bitmap 24 bits (*.bmp)|Jpeg (*.jpg)")
  add($affectations_messages, "__s__is_not_a_valid_filename__s_Saving_canceled_", $ini_section, "'%s' is not a valid filename.%s Saving canceled.", "'%s' is not a valid filename.%s Saving canceled.")
  add($affectations_messages, "changement_langue_titre", $ini_section, "New language set", "New language set")
  add($affectations_messages, "changement_langue_text__s", $ini_section, "Please restart the application to have it in %s.", "Please restart the application to have it in %s.")
  add($affectations_messages, "No_xp_comments_in_this_jpeg_image", $ini_section, "No XP comments corresponding to a formula in this jpeg image.", "No XP comments corresponding to a formula in this jpeg image.")
  add($affectations_messages, "Bad_formatting_in_xp_comment", $ini_section, "Bad formatting in xp comment", "Bad formatting in xp comment")
  add($affectations_messages, "no_algorithm_to_import_data_from_this_kind_of_file__s", $ini_section, "No possible import from %s", "No possible import from %s")
  add($affectations_messages, "error_while_importing_from__s", $ini_section, "Error occured when importing from %s", "Error occured when importing from %s")
  add($affectations_messages, "No_comments_found_in_this_image", $ini_section, "No comments corresponding to a formula in this image.", "No comments corresponding to a formula in this image.")

  ;=============== GUI ===================;
  ; Reflex Renderer Interface

  Global $affectations = _ArrayCreate( _ArrayCreate("__reflex__", $gui_section, 'Reflex', 'Reflex'))
  add($affectations, "__creating_options__", $gui_section, 'Creating options', 'Creating options')
  add($affectations, "__formula__", $gui_section, 'Formula :', 'Formula :')
  add($affectations, "__width_height__", $gui_section, 'Width x Height :', 'Width x Height :')
  add($affectations, "__preview__", $gui_section, 'Preview', 'Preview')
  add($affectations, "__winmin__", $gui_section, 'Window Minimum:', 'Window Minimum:')
  add($affectations, "__winmax__", $gui_section, 'Window Maximum:', 'Window Maximum:')
  add($affectations, "__auto_render__", $gui_section, 'Auto Render', 'Auto Render')
  add($affectations, "__temp_file__", $gui_section, 'Temp file:', 'Temp file:')
  add($affectations, "__render_reflex__", $gui_section, '&Render Reflex', '&Render Reflex')
  add($affectations, "__rendering__", $gui_section, 'Rendering...', 'Rendering...')
  add($affectations, "__reset_resolution__", $gui_section, 'Reset [resolution/window]', 'Reset')
  add($affectations, "__reset_window__", $gui_section, 'Reset [resolution/window]', 'Reset')
  add($affectations, "__quick_save__", $gui_section, 'Quick save...', 'Quick save...')
  add($affectations, "__noquick_save__", $gui_section, 'Options...', 'Options...')
  add($affectations, "__reflex_renderer_interface__", $gui_section, 'Reflex Renderer', 'Reflex Renderer')
  add($affectations, "__navigation__", $gui_section, 'Navigation', 'Navigation')
  add($affectations, "__drag_reflex__", $gui_section, 'Dr&ag reflex', 'Dr&ag reflex')
  add($affectations, "__visit_click__", $gui_section, '&Visit click', '&Visit click')
  add($affectations, "__visit_rectangle__", $gui_section, 'Visit r&ectangle', 'Visit r&ectangle')
  add($affectations, "__previous_window__", $gui_section, 'P&revious window', 'P&revious window')
  add($affectations, "__next_window__", $gui_section, 'Nex&t window', 'Nex&t window')
  add($affectations, "__zoom_in_factor__", $gui_section, 'Zoom &in', 'Zoom &in')
  add($affectations, "__zoom_out_factor__", $gui_section, 'Zoom &out', 'Zoom &out')
  add($affectations, "__zoom_factor__", $gui_section, 'Zoom Factor:', 'Zoom Factor:')
  add($affectations, "__zoom_absolute__", $gui_section, 'Absolute Zoom:', 'Absolute Zoom:')
  add($affectations, "__tools__", $gui_section, '&Tools', '&Tools')
  add($affectations, "__menu_save__", $gui_section, '&Saving options...', '&Saving options...')
  add($affectations, "__menu_windows__", $gui_section, '&Windows', '&Windows')
  add($affectations, "__menu_resolutions__", $gui_section, '&Resolutions', '&Resolutions')
  add($affectations, "__menu_about__", $gui_section, '&About...', '&About...')
  add($affectations, "__menu_quit__", $gui_section, 'Quit [menu]', 'Quit')
  add($affectations, "__formula_menu__", $gui_section, '&Formula', '&Formula')
  add($affectations, "__menu_formula_editor__", $gui_section, '&Editor...', '&Editor...')
  add($affectations, "__menu_formula_import__", $gui_section, '&Import...', '&Import...')
  ;Savebox
  add($affectations, "__save_reflex_and_or_formula__", $gui_section, 'Save Reflex and/or Formula', 'Save Reflex and/or Formula')
  add($affectations, "__saving_parameters__", $gui_section, 'Saving parameters', 'Saving parameters')
  add($affectations, "__save_formula_reflex__", $gui_section, 'Save Formula && Reflex', 'Save Formula && Reflex')
  add($affectations, "__save_only_formula__", $gui_section, 'Save only Formula', 'Save only Formula')
  add($affectations, "__save_only_reflex__", $gui_section, 'Save only Reflex', 'Save only Reflex')
  add($affectations, "__save_button__", $gui_section, 'Save all', 'Save all')
  add($affectations, "__cancel_button__", $gui_section, 'Cancel', 'Cancel')
  add($affectations, "__save_formula_group__", $gui_section, 'Save Formula', 'Save Formula')
  add($affectations, "__my_nice_function__", $gui_section, 'My nice function', 'My nice function')
  add($affectations, "__save_comment__", $gui_section, 'Comment', 'Comment')
  add($affectations, "__formula_file_name__", $gui_section, 'Formula File Name:', 'Formula File Name:')
  add($affectations, "__comment__", $gui_section, 'Comment:', 'Comment:')
  add($affectations, "__save_reflex_group__", $gui_section, 'Save Reflex', 'Save Reflex')
  add($affectations, "__high_resolution_reflex__", $gui_section, 'High-resolution reflex', 'High-resolution reflex')
  add($affectations, "__copy_last_reflex__", $gui_section, 'Copy last reflex', 'Copy last reflex')
  add($affectations, "__low_resolution_reflex__", $gui_section, 'Low-resolution reflex', 'Low-resolution reflex')
  add($affectations, "__reflex_file_name__", $gui_section, 'Reflex file name:', 'Reflex file name:')
  add($affectations, "__use_formula_comment__", $gui_section, 'Use Formula comment as the Reflex name', 'Use Formula comment as the Reflex name')
  add($affectations, "__just_save_settings__", $gui_section, 'Just save settings', 'Just save settings')
  ;About box
  add($affectations, "__about_box__", $gui_section, 'About', 'About')
  add($affectations, "__version__", $gui_section, 'Version %s', 'Version %s')
  add($affectations, "__copyright__", $gui_section, 'Copyright 2008', 'Copyright 2008')
  add($affectations, "__ok_button__", $gui_section, '&OK', '&OK')
  ;LoadFormulaFromFile
  add($affectations, "__formula_chooser__", $gui_section, 'Formula Chooser', 'Formula Chooser')
  add($affectations, "__choose_a_formula__", $gui_section, 'Choose a formula :', 'Choose a formula :')
  add($affectations, "__other_file__", $gui_section, 'Other file', 'Other file')
  ;EditFormula (hints to be put in the traduction file)
  add($affectations, "__edit_formula__", $gui_section, 'Edit Formula', 'Edit Formula')
  add($affectations, "__set_button__", $gui_section, 'Set', 'Set')
  add($affectations, "__del_button__", $gui_section, 'del', 'del')
  add($affectations, "__reset_formula__", $gui_section, 'Reset [formula]', 'Reset')
  add($affectations, "__x_hint__", $gui_section, 'The real part of z', 'The real part of z')
  add($affectations, "__y_hint__", $gui_section, 'The imaginary part of z', 'The imaginary part of z')
  add($affectations, "__sin_hint__", $gui_section, 'Sinus', 'Sinus')
  add($affectations, "__cos_hint__", $gui_section, 'Cosinus', 'Cosinus')
  add($affectations, "__tan_hint__", $gui_section, 'Tangent', 'Tangent')
  add($affectations, "__sinh_hint__", $gui_section, 'Hyperbolic sinus', 'Hyperbolic sinus')
  add($affectations, "__cosh_hint__", $gui_section, 'Hyperbolic cosinus', 'Hyperbolic cosinus')
  add($affectations, "__tanh_hint__", $gui_section, 'Hyperbolic tangent', 'Hyperbolic tangent')
  add($affectations, "__ln_hint__", $gui_section, 'Natural logarithm', 'Natural logarithm')
  add($affectations, "__exp_hint__", $gui_section, 'Exponential function', 'Exponential function')
  add($affectations, "__sqrt_hint__", $gui_section, 'Square root', 'Square root')
  add($affectations, "__randf_hint__", $gui_section, 'Random function', 'Random function')
  add($affectations, "__randh_hint__", $gui_section, 'Random holomorphic function', 'Random holomorphic function')
  add($affectations, "__inv_hint__", $gui_section, 'Inverse function', 'Inverse function')
  add($affectations, "__real_hint__", $gui_section, 'Real part', 'Real part')
  add($affectations, "__imag_hint__", $gui_section, 'Imaginary part', 'Imaginary part')
  add($affectations, "__conj_hint__", $gui_section, 'Complex conjugation', 'Complex conjugation')
  add($affectations, "__dollar_hint__", $gui_section, 'Prefix of a variable', 'Prefix of a variable')
  ;Misc
  add($affectations, "__language_menu__", $gui_section, 'Languages', 'Languages')
  add($affectations, "__auto_render_hint__", $gui_section, 'Renders automatically when something is modified.', 'Renders automatically when something is modified.')
  add($affectations, "__quicksave_hint__", $gui_section, 'Give a comment and save!', 'Give a comment and save!')
  add($affectations, "__noquick_save_hint__", $gui_section, 'Set saving options.', 'Set saving options.')
  add($affectations, "__zoom_factor_hint__", $gui_section, 'Zoom factor hint', '"Zoom in" or "Zoom out" are using this multiplier.')
  add($affectations, "__zoom_absolute_hint__", $gui_section, 'Zoom absolute hint', '')
  add($affectations, "__menu_quitnosave__", $gui_section, 'Quit without saving', 'Quit without saving')
  add($affectations, "__import_window__", $gui_section, 'Import window', 'Import window')
  add($affectations, "__import_resolution__", $gui_section, 'Import resolution', 'Import resolution')
  add($affectations, "__formula_chooser_hint__", $gui_section, 'Formula chooser hint', '')
  add($affectations, "__import_comment__", $gui_section, 'Import comment', 'Import comment')
  add($affectations, "__save_window__", $gui_section, 'Window', 'Window')
  add($affectations, "__save_resolution__", $gui_section, 'Resolution', 'Resolution')
  add($affectations, "__save_with__", $gui_section, 'Save with...', 'Save with...')
  add($affectations, "__seed_hint__", $gui_section, 'Seed hint', 'The seed used in randf and randh functions')
  add($affectations, "__quit_button__", $gui_section, 'Quit', 'Quit')
  add($affectations, "__menu_formula_import_reflex__", $gui_section, 'Import from Reflex in Jpeg', 'Import from Reflex in Jpeg')
  add($affectations, "__hint_color_code_button__", $gui_section, 'Reflex color code', 'Reflex color code')
  add($affectations, "__hint_save_all_button__", $gui_section, 'Hint save all button', 'Hint save all button')
  add($affectations, "__hint_use_formula_comment__", $gui_section, 'Hint use formula comment', 'Hint use formula comment')
  add($affectations, "__hint_save_options_button__", $gui_section, 'Hint save options button', 'Hint save options button')
  add($affectations, "__real_mode__", $gui_section, 'Real mode', 'Real mode')
  add($affectations, "__set_button_hint__", $gui_section, 'Updates the main formula field', 'Updates the main formula field')
  add($affectations, "__menu_formula_history__", $gui_section, 'Formula history', 'Formula history')
  add($affectations, "__variable__", $gui_section, 'Variable', 'Variable')
  add($affectations, "__variable_name__", $gui_section, 'Variable name', 'Variable name')
  add($affectations, "__render_along_variable__", $gui_section, 'Render video', 'Render video')
  add($affectations, "__set_min__", $gui_section, 'Set min', 'Set min')
  add($affectations, "__set_max__", $gui_section, 'Set Max', 'Set Max')
  add($affectations, "__increase_range__", $gui_section, 'Increase range', 'Increase range')
  add($affectations, "__minimum__", $gui_section, 'Minimum', 'Minimum')
  add($affectations, "__maximum__", $gui_section, 'Maximum', 'Maximum')
  add($affectations, "__variable_editor__", $gui_section, 'Variable Editor', 'Variable Editor')
  add($affectations, "__insert_var__", $gui_section, 'Insert variable', 'Insert variable')
  add($affectations, "__randomize_seed__", $gui_section, 'Randomize seed', 'Randomize seed')
  add($affectations, "__decrease_range__", $gui_section, 'Decrease range', 'Decrease range')
  add($affectations, "__export_formula__", $gui_section, 'Export formula...', 'Export formula...')
  add($affectations, "__formula_exported__", $gui_section, 'Formule export�e', 'Formule export�e')
  add($affectations, "__formula_correctly_exported_to_clipboard__", $gui_section, 'La formule a �t� mise dans le presse-papier au format OpenOffice.', 'La formule a �t� mise dans le presse-papier au format OpenOffice.')
  add($affectations, "__next__", $gui_section, 'Next', 'Next')
  add($affectations, "__play__", $gui_section, 'Play', 'Play')
  add($affectations, "__previous__", $gui_section, 'Previous', 'Previous')
  add($affectations, "__stop__", $gui_section, 'Stop', 'Stop')
  add($affectations, "__tutorial__", $gui_section, 'Reflex Renderer Tutorial', 'Reflex Renderer Tutorial')
  add($affectations, "__tutorial_sections__", $gui_section, 'Tut1|Tut2|Tut3|Tut4|Tut5|Tut6|Tut7', 'Zooming|Navigation|Saving options|Discover the Reflex concept|Formula Editor|Browsing formulas|Video recording')
  add($affectations, "__autoplay__", $gui_section, 'Autoplay', 'Autoplay')
  add($affectations, "__error__", $gui_section, 'Error', 'Error')
  add($affectations, "__tutorial_section_misformed_aborting_loading__", $gui_section, 'Tutorial section misformed', 'Tutorial section misformed')
  add($affectations, "__open_tutorial__", $gui_section, 'Tutorial...', 'Tutorial...')
  ;ADD_AFFECTATION

  If $updates and Not @Compiled Then
    update($affectations)
    update($affectations_messages)
  EndIf

  For $var In $affectations_messages
    Assign($var[0], IniRead($translation_ini, $var[1], $var[2], $var[3]), 2)
  Next
  For $var In $affectations
    Assign($var[0], IniRead($translation_ini, $var[1], $var[2], $var[3]), 2)
  Next

EndFunc

Func update($affectations)
  If $languages == False Then Return
  For $var In $affectations
    For $language In $languages
      Local $ini_translation = $lang_folder&'\'&translationFile($language[2])
      If IniRead($ini_translation, $var[1], $var[2], 'ZXW')=='ZXW' Then
        IniWrite($ini_translation, $var[1], $var[2], $var[3])
      EndIf
    Next
  Next
EndFunc

Func translationFile($str)
  Return "translations_"&$str&".ini"
EndFunc

Func listLanguages()
  $languages = emptySizedArray()
  FileChangeDir(@ScriptDir&"\"&$lang_folder)
  $search = FileFindFirstFile(translationFile("*"))
  ; Check if the search was successful
  If $search = -1 Then
    FileClose($search)
    FileChangeDir(@ScriptDir)
    Return False
  EndIf
  While 1
    $file = FileFindNextFile($search) 
    If @error Then ExitLoop
    ; 'Fran�ais', 'fr_lang', 'fr'
    $language_name = StringReplace(FileReadLine($file, 1), ';', '')
    $array = StringRegExp($file, "_(\w*?).ini", 1)
    $language_code = $array[0]
    $language_var  = $language_code&"_lang"
    _ArrayAdd($languages, _ArrayCreate($language_name, $language_var, $language_code))
  WEnd
  _ArrayDelete($languages, 0)
  _ArraySort($languages)
  ; Close the search handle
  FileClose($search)
  FileChangeDir(@ScriptDir)
  Return True
EndFunc

Func add(ByRef $tab, $var_name, $section, $word, $traduction)
  _ArrayAdd($tab, _ArrayCreate($var_name, $section, $word, $traduction))
EndFunc