#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Mikaël Mayer
 Date:           05/07/2008

 Script Function:
  Generates string variables for traduction.

#ce ----------------------------------------------------------------------------
#include-once
#include "IniHandling.au3"
#include "GlobalUtils.au3"
#include <GUIListBox.au3>
#include <GuiConstantsEx.au3>
#include <Array.au3>

Global $lang_folder = 'lang' ;TODO: To externalize?
Global $translation_ini = ""
Global $ini_section = 'Messages'
Global $gui_section = 'GUI'
Global $translation_current_language = 'en'
Global $languages = emptySizedArray()

LoadTranslations()

Func LoadTranslations()
  ; Code to retrieve the main user language. 'Hack' found in the Autoit3 documentation of _GUICtrlListBox_GetLocalePrimLang
  Local $hlistBox, $default_language = 'en', $default_language_number
  Local $win = GUICreate("Dummy list box", 400, 296)
  $hListBox = GUICtrlCreateList("", 2, 2, 396, 296)
  Local $default_language_number = _GUICtrlListBox_GetLocalePrimLang($hListBox)
  GUIDelete($win)
  Switch Int($default_language_number)
  Case 09
    $default_language = 'en'
  Case 12
    $default_language = 'fr'
  EndSwitch

  ;Detection of the language file
  $translation_current_language = IniRead($ini_file, $ini_file_session, 'language', $default_language)
  Local $updates = True
  $translation_ini = globalTranslationIni($translation_current_language)
  If not FileExists($translation_ini) Then
    $translation_current_language = 'en'
    $translation_ini = globalTranslationIni($translation_current_language)
  EndIf

  ;Builds the list of all available languages (all *.ini files in the 'lang' folder)
  If not listLanguages() Then $languages = False

Global $Reflex_name                          = 0
Global $affectations_messages                = _ArrayCreate( _ArrayCreate('Reflex_name', $ini_section, 'Reflex name', 'Reflex name'))
Global $Bitmap_24_bits____bmp__All______     = add($affectations_messages, "Bitmap_24_bits____bmp__All______", $ini_section, 'Bitmap 24 bits (*.bmp)|All (*.*)', 'Bitmap 24 bits (*.bmp)|All (*.*)')
Global $My_nice_function                     = add($affectations_messages, "My_nice_function", $ini_section, 'My nice function', 'My nice function')
Global $Quick_save                           = add($affectations_messages, "Quick_save", $ini_section, 'Quick save', 'Quick save')
Global $Give_a_comment_for_this_reflex_      = add($affectations_messages, "Give_a_comment_for_this_reflex_", $ini_section, 'Give a comment for this reflex.', 'Give a comment for this reflex.')
Global $To_change_the_saving_directory__go_to= add($affectations_messages, "To_change_the_saving_directory__go_to", $ini_section, 'To change the saving directory, go to %s>%s', 'To change the saving directory, go to %s>%s')
Global $Error_while_quick_saving_in_file     = add($affectations_messages, "Error_while_quick_saving_in_file", $ini_section, 'Error while quick saving in file', 'Error while quick saving in file')
Global $Errors                               = add($affectations_messages, "Errors", $ini_section, 'Errors', 'Errors')
Global $Error_title                          = add($affectations_messages, "Error", $ini_section, 'Error', 'Error')
Global $Could_not_copy_from___s__to___s_     = add($affectations_messages, "Could_not_copy_from___s__to___s_", $ini_section, "Could not copy from '%s' to '%s'", "Could not copy from '%s' to '%s'")
Global $Could_not_convert_from___s__to___s_  = add($affectations_messages, "Could_not_convert_from___s__to___s_", $ini_section, "Could not convert from '%s' to '%s'", "Could not convert from '%s' to '%s'")
Global $Formula_File                         = add($affectations_messages, "Formula_File", $ini_section, "Formula File", "Formula File")
Global $Formula_file____txt__All______       = add($affectations_messages, "Formula_file____txt__All______", $ini_section, "Formula file (*.txt)|All (*.*)", "Formula file (*.txt)|All (*.*)")
Global $Jpeg_Reflex_File                     = add($affectations_messages, "Jpeg_Reflex_File", $ini_section, "Jpeg Reflex File", "Jpeg Reflex File")
Global $Jpeg_Reflex_File____jpg__All______   = add($affectations_messages, "Jpeg_Reflex_File____jpg__All______", $ini_section, "Jpeg Reflex file (*.jpg;*.jpeg)|All (*.*)", "Jpeg Reflex file (*.jpg;*.jpeg)|All (*.*)")
Global $I_love_the_Reflex_Renderer           = add($affectations_messages, "I_love_the_Reflex_Renderer", $ini_section, "I love the Reflex Renderer", "I love the Reflex Renderer")
Global $Open_Formula_file                    = add($affectations_messages, "Open_Formula_file", $ini_section, "Open Formula file", "Open Formula file")
Global $New_Formula_file                     = add($affectations_messages, "New_Formula_file", $ini_section, "New Formula file", "New Formula file")
Global $New_Reflex_file                      = add($affectations_messages, "New_Reflex_file", $ini_section, "New Reflex file", "New Reflex file")
Global $Bitmap_24_bits____bmp__Jpeg____jpg_  = add($affectations_messages, "Bitmap_24_bits____bmp__Jpeg____jpg_", $ini_section, "Bitmap 24 bits (*.bmp)|Jpeg (*.jpg)", "Bitmap 24 bits (*.bmp)|Jpeg (*.jpg)")
Global $__s__is_not_a_valid_filename__s_Saving_canceled_     = add($affectations_messages, "__s__is_not_a_valid_filename__s_Saving_canceled_", $ini_section, "'%s' is not a valid filename.%s Saving canceled.", "'%s' is not a valid filename.%s Saving canceled.")
Global $changement_langue_titre          = add($affectations_messages, "changement_langue_titre", $ini_section, "New language set", "New language set")
Global $changement_langue_text__s        = add($affectations_messages, "changement_langue_text__s", $ini_section, "Please restart the application to have it in %s.", "Please restart the application to have it in %s.")
Global $No_xp_comments_in_this_jpeg_image= add($affectations_messages, "No_xp_comments_in_this_jpeg_image", $ini_section, "No XP comments corresponding to a formula in this jpeg image.", "No XP comments corresponding to a formula in this jpeg image.")
Global $Bad_formatting_in_xp_comment     = add($affectations_messages, "Bad_formatting_in_xp_comment", $ini_section, "Bad formatting in xp comment", "Bad formatting in xp comment")
Global $no_algorithm_to_import_data_from_this_kind_of_file__s= add($affectations_messages, "no_algorithm_to_import_data_from_this_kind_of_file__s", $ini_section, "No possible import from %s", "No possible import from %s")
Global $error_while_importing_from__s  = add($affectations_messages, "error_while_importing_from__s", $ini_section, "Error occured when importing from %s", "Error occured when importing from %s")
Global $No_comments_found_in_this_image= add($affectations_messages, "No_comments_found_in_this_image", $ini_section, "No comments corresponding to a formula in this image.", "No comments corresponding to a formula in this image.")

  ;=============== GUI ===================;
  ; Reflex Renderer Interface
Global $__reflex__                   = 0
Global $affectations                 = _ArrayCreate( _ArrayCreate("__reflex__", $gui_section, 'Reflex', 'Reflex'))
Global $__creating_options__         = add($affectations, "__creating_options__", $gui_section, 'Creating options', 'Creating options')
Global $__formula__                  = add($affectations, "__formula__", $gui_section, 'Formula :', 'Formula :')
Global $__width_height__             = add($affectations, "__width_height__", $gui_section, 'Width x Height :', 'Width x Height :')
Global $__preview__                  = add($affectations, "__preview__", $gui_section, 'Preview', 'Preview')
Global $__winmin__                   = add($affectations, "__winmin__", $gui_section, 'Window Minimum:', 'Window Minimum:')
Global $__winmax__                   = add($affectations, "__winmax__", $gui_section, 'Window Maximum:', 'Window Maximum:')
Global $__auto_render__              = add($affectations, "__auto_render__", $gui_section, 'Auto Render', 'Auto Render')
Global $__temp_file__                = add($affectations, "__temp_file__", $gui_section, 'Temp file:', 'Temp file:')
Global $__render_reflex__            = add($affectations, "__render_reflex__", $gui_section, '&Render Reflex', '&Render Reflex')
Global $__rendering__                = add($affectations, "__rendering__", $gui_section, 'Rendering...', 'Rendering...')
Global $__reset_resolution__         = add($affectations, "__reset_resolution__", $gui_section, 'Reset [resolution/window]', 'Reset')
Global $__reset_window__             = add($affectations, "__reset_window__", $gui_section, 'Reset [resolution/window]', 'Reset')
Global $__quick_save__               = add($affectations, "__quick_save__", $gui_section, 'Quick save...', 'Quick save...')
Global $__noquick_save__             = add($affectations, "__noquick_save__", $gui_section, 'Options...', 'Options...')
Global $__reflex_renderer_interface__= add($affectations, "__reflex_renderer_interface__", $gui_section, 'Reflex Renderer', 'Reflex Renderer')
Global $__navigation__               = add($affectations, "__navigation__", $gui_section, 'Navigation', 'Navigation')
Global $__visit_click__              = add($affectations, "__visit_click__", $gui_section, '&Visit click', '&Visit click')
Global $__visit_rectangle__          = add($affectations, "__visit_rectangle__", $gui_section, 'Visit r&ectangle', 'Visit r&ectangle')
Global $__previous_window__          = add($affectations, "__previous_window__", $gui_section, 'P&revious window', 'P&revious window')
Global $__next_window__              = add($affectations, "__next_window__", $gui_section, 'Nex&t window', 'Nex&t window')
Global $__zoom_in_factor__           = add($affectations, "__zoom_in_factor__", $gui_section, 'Zoom &in', 'Zoom &in')
Global $__zoom_out_factor__          = add($affectations, "__zoom_out_factor__", $gui_section, 'Zoom &out', 'Zoom &out')
Global $__zoom_factor__              = add($affectations, "__zoom_factor__", $gui_section, 'Zoom Factor:', 'Zoom Factor:')
Global $__zoom_absolute__            = add($affectations, "__zoom_absolute__", $gui_section, 'Absolute Zoom:', 'Absolute Zoom:')
Global $__tools__                    = add($affectations, "__tools__", $gui_section, '&Tools', '&Tools')
Global $__menu_save__                = add($affectations, "__menu_save__", $gui_section, '&Saving options...', '&Saving options...')
Global $__menu_windows__             = add($affectations, "__menu_windows__", $gui_section, '&Windows', '&Windows')
Global $__menu_resolutions__         = add($affectations, "__menu_resolutions__", $gui_section, '&Resolutions', '&Resolutions')
Global $__menu_about__               = add($affectations, "__menu_about__", $gui_section, '&About...', '&About...')
Global $__menu_quit__                = add($affectations, "__menu_quit__", $gui_section, 'Quit [menu]', 'Quit')
Global $__formula_menu__             = add($affectations, "__formula_menu__", $gui_section, '&Formula', '&Formula')
Global $__menu_formula_editor__      = add($affectations, "__menu_formula_editor__", $gui_section, '&Editor...', '&Editor...')
Global $__menu_formula_import__      = add($affectations, "__menu_formula_import__", $gui_section, '&Import...', '&Import...')
  ;Savebox
Global $__save_reflex_and_or_formula__= add($affectations, "__save_reflex_and_or_formula__", $gui_section, 'Save Reflex and/or Formula', 'Save Reflex and/or Formula')
Global $__saving_parameters__         = add($affectations, "__saving_parameters__", $gui_section, 'Saving parameters', 'Saving parameters')
Global $__save_formula_reflex__       = add($affectations, "__save_formula_reflex__", $gui_section, 'Save Formula && Reflex', 'Save Formula && Reflex')
Global $__save_only_formula__         = add($affectations, "__save_only_formula__", $gui_section, 'Save only Formula', 'Save only Formula')
Global $__save_only_reflex__          = add($affectations, "__save_only_reflex__", $gui_section, 'Save only Reflex', 'Save only Reflex')
Global $__save_button__               = add($affectations, "__save_button__", $gui_section, 'Save all', 'Save all')
Global $__cancel_button__             = add($affectations, "__cancel_button__", $gui_section, 'Cancel', 'Cancel')
Global $__save_formula_group__        = add($affectations, "__save_formula_group__", $gui_section, 'Save Formula', 'Save Formula')
Global $__my_nice_function__          = add($affectations, "__my_nice_function__", $gui_section, 'My nice function', 'My nice function')
Global $__save_comment__              = add($affectations, "__save_comment__", $gui_section, 'Comment', 'Comment')
Global $__formula_file_name__         = add($affectations, "__formula_file_name__", $gui_section, 'Formula File Name:', 'Formula File Name:')
Global $__comment__                   = add($affectations, "__comment__", $gui_section, 'Comment:', 'Comment:')
Global $__save_reflex_group__         = add($affectations, "__save_reflex_group__", $gui_section, 'Save Reflex', 'Save Reflex')
Global $__high_resolution_reflex__    = add($affectations, "__high_resolution_reflex__", $gui_section, 'High-resolution reflex', 'High-resolution reflex')
Global $__copy_last_reflex__          = add($affectations, "__copy_last_reflex__", $gui_section, 'Copy last reflex', 'Copy last reflex')
Global $__low_resolution_reflex__     = add($affectations, "__low_resolution_reflex__", $gui_section, 'Low-resolution reflex', 'Low-resolution reflex')
Global $__reflex_file_name__          = add($affectations, "__reflex_file_name__", $gui_section, 'Reflex file name:', 'Reflex file name:')
Global $__use_formula_comment__       = add($affectations, "__use_formula_comment__", $gui_section, 'Use Formula comment as the Reflex name', 'Use Formula comment as the Reflex name')
Global $__just_save_settings__        = add($affectations, "__just_save_settings__", $gui_section, 'Just save settings', 'Just save settings')
;About box
Global $__about_box__                 = add($affectations, "__about_box__", $gui_section, 'About', 'About')
Global $__version__                   = add($affectations, "__version__", $gui_section, 'Version %s', 'Version %s')
Global $__copyright__                 = add($affectations, "__copyright__", $gui_section, 'Copyright 2008', 'Copyright 2008')
Global $__ok_button__                 = add($affectations, "__ok_button__", $gui_section, '&OK', '&OK')
;LoadFormulaFromFile
Global $__formula_chooser__           = add($affectations, "__formula_chooser__", $gui_section, 'Formula Chooser', 'Formula Chooser')
Global $__choose_a_formula__          = add($affectations, "__choose_a_formula__", $gui_section, 'Choose a formula :', 'Choose a formula :')
Global $__other_file__                = add($affectations, "__other_file__", $gui_section, 'Other file', 'Other file')
;EditFormula (hints to be put in the traduction file)
Global $__edit_formula__              = add($affectations, "__edit_formula__", $gui_section, 'Edit Formula', 'Edit Formula')
Global $__set_button__                = add($affectations, "__set_button__", $gui_section, 'Set', 'Set')
Global $__del_button__                = add($affectations, "__del_button__", $gui_section, 'del', 'del')
Global $__reset_formula__             = add($affectations, "__reset_formula__", $gui_section, 'Reset [formula]', 'Reset')
Global $__x_hint__                    = add($affectations, "__x_hint__", $gui_section, 'The real part of z', 'The real part of z')
Global $__y_hint__                    = add($affectations, "__y_hint__", $gui_section, 'The imaginary part of z', 'The imaginary part of z')
Global $__sin_hint__                  = add($affectations, "__sin_hint__", $gui_section, 'Sinus', 'Sinus')
Global $__cos_hint__                  = add($affectations, "__cos_hint__", $gui_section, 'Cosinus', 'Cosinus')
Global $__tan_hint__                  = add($affectations, "__tan_hint__", $gui_section, 'Tangent', 'Tangent')
Global $__sinh_hint__                 = add($affectations, "__sinh_hint__", $gui_section, 'Hyperbolic sinus', 'Hyperbolic sinus')
Global $__cosh_hint__                 = add($affectations, "__cosh_hint__", $gui_section, 'Hyperbolic cosinus', 'Hyperbolic cosinus')
Global $__tanh_hint__                 = add($affectations, "__tanh_hint__", $gui_section, 'Hyperbolic tangent', 'Hyperbolic tangent')
Global $__ln_hint__                   = add($affectations, "__ln_hint__", $gui_section, 'Natural logarithm', 'Natural logarithm')
Global $__exp_hint__                  = add($affectations, "__exp_hint__", $gui_section, 'Exponential function', 'Exponential function')
Global $__sqrt_hint__                 = add($affectations, "__sqrt_hint__", $gui_section, 'Square root', 'Square root')
Global $__randf_hint__                = add($affectations, "__randf_hint__", $gui_section, 'Random function', 'Random function')
Global $__randh_hint__                = add($affectations, "__randh_hint__", $gui_section, 'Random holomorphic function', 'Random holomorphic function')
Global $__inv_hint__                  = add($affectations, "__inv_hint__", $gui_section, 'Inverse function', 'Inverse function')
Global $__real_hint__                 = add($affectations, "__real_hint__", $gui_section, 'Real part', 'Real part')
Global $__imag_hint__                 = add($affectations, "__imag_hint__", $gui_section, 'Imaginary part', 'Imaginary part')
Global $__conj_hint__                 = add($affectations, "__conj_hint__", $gui_section, 'Complex conjugation', 'Complex conjugation')
Global $__dollar_hint__               = add($affectations, "__dollar_hint__", $gui_section, 'Prefix of a variable', 'Prefix of a variable')
;Misc
Global $__language_menu__             = add($affectations, "__language_menu__", $gui_section, 'Languages', 'Languages')
Global $__auto_render_hint__          = add($affectations, "__auto_render_hint__", $gui_section, 'Renders automatically when something is modified.', 'Renders automatically when something is modified.')
Global $__quicksave_hint__            = add($affectations, "__quicksave_hint__", $gui_section, 'Give a comment and save!', 'Give a comment and save!')
Global $__noquick_save_hint__         = add($affectations, "__noquick_save_hint__", $gui_section, 'Set saving options.', 'Set saving options.')
Global $__zoom_factor_hint__          = add($affectations, "__zoom_factor_hint__", $gui_section, 'Zoom factor hint', '"Zoom in" or "Zoom out" are using this multiplier.')
Global $__zoom_absolute_hint__        = add($affectations, "__zoom_absolute_hint__", $gui_section, 'Zoom absolute hint', 'Move this to view the function at different scales')
Global $__menu_quitnosave__           = add($affectations, "__menu_quitnosave__", $gui_section, 'Quit without saving', 'Quit without saving')
Global $__import_window__             = add($affectations, "__import_window__", $gui_section, 'Import window', 'Import window')
Global $__import_resolution__         = add($affectations, "__import_resolution__", $gui_section, 'Import resolution', 'Import resolution')
Global $__formula_chooser_hint__      = add($affectations, "__formula_chooser_hint__", $gui_section, 'Formula chooser hint', '')
Global $__import_comment__            = add($affectations, "__import_comment__", $gui_section, 'Import comment', 'Import comment')
Global $__save_window__               = add($affectations, "__save_window__", $gui_section, 'Window', 'Window')
Global $__save_resolution__           = add($affectations, "__save_resolution__", $gui_section, 'Resolution', 'Resolution')
Global $__save_with__                 = add($affectations, "__save_with__", $gui_section, 'Save with...', 'Save with...')
Global $__seed_hint__                 = add($affectations, "__seed_hint__", $gui_section, 'Seed hint', 'The seed used in randf and randh functions')
Global $__quit_button__               = add($affectations, "__quit_button__", $gui_section, 'Quit', 'Quit')
Global $__menu_formula_import_reflex__= add($affectations, "__menu_formula_import_reflex__", $gui_section, 'Import from Reflex in Jpeg', 'Import from Reflex in Jpeg')
Global $__hint_color_code_button__    = add($affectations, "__hint_color_code_button__", $gui_section, 'Reflex color code', 'Reflex color code')
Global $__hint_save_all_button__      = add($affectations, "__hint_save_all_button__", $gui_section, 'Hint save all button', 'Hint save all button')
Global $__hint_use_formula_comment__  = add($affectations, "__hint_use_formula_comment__", $gui_section, 'Hint use formula comment', 'Hint use formula comment')
Global $__hint_save_options_button__  = add($affectations, "__hint_save_options_button__", $gui_section, 'Hint save options button', 'Hint save options button')
Global $__real_mode__                 = add($affectations, "__real_mode__", $gui_section, 'Real mode', 'Real mode')
Global $__set_button_hint__           = add($affectations, "__set_button_hint__", $gui_section, 'Updates the main formula field', 'Updates the main formula field')
Global $__menu_formula_history__      = add($affectations, "__menu_formula_history__", $gui_section, 'Formula history', 'Formula history')
Global $__variable__                  = add($affectations, "__variable__", $gui_section, 'Variable', 'Variable')
Global $__variable_name__             = add($affectations, "__variable_name__", $gui_section, 'Variable name', 'Variable name')
Global $__render_along_variable__     = add($affectations, "__render_along_variable__", $gui_section, 'Render video', 'Render video')
Global $__set_min__                   = add($affectations, "__set_min__", $gui_section, 'Set min', 'Set min')
Global $__set_max__                   = add($affectations, "__set_max__", $gui_section, 'Set Max', 'Set Max')
Global $__increase_range__            = add($affectations, "__increase_range__", $gui_section, 'Increase range', 'Increase range')
Global $__minimum__                   = add($affectations, "__minimum__", $gui_section, 'Minimum', 'Minimum')
Global $__maximum__                   = add($affectations, "__maximum__", $gui_section, 'Maximum', 'Maximum')
Global $__variable_editor__           = add($affectations, "__variable_editor__", $gui_section, 'Variable Editor', 'Variable Editor')
Global $__insert_var__                = add($affectations, "__insert_var__", $gui_section, 'Insert variable', 'Insert variable')
Global $__randomize_seed__            = add($affectations, "__randomize_seed__", $gui_section, 'Randomize seed', 'Randomize seed')
Global $__decrease_range__            = add($affectations, "__decrease_range__", $gui_section, 'Decrease range', 'Decrease range')
Global $__export_formula__            = add($affectations, "__export_formula__", $gui_section, 'Export formula...', 'Export formula...')
Global $__formula_exported__          = add($affectations, "__formula_exported__", $gui_section, 'Formule exportée', 'Formule exportée')
Global $__formula_correctly_exported_to_clipboard__    = add($affectations, "__formula_correctly_exported_to_clipboard__", $gui_section, 'La formule a été mise dans le presse-papier au format OpenOffice.', 'La formule a été mise dans le presse-papier au format OpenOffice.')
Global $__next__    = add($affectations, "__next__", $gui_section, 'Next', 'Next')
Global $__play__    = add($affectations, "__play__", $gui_section, 'Play', 'Play')
Global $__previous__= add($affectations, "__previous__", $gui_section, 'Previous', 'Previous')
Global $__stop__    = add($affectations, "__stop__", $gui_section, 'Stop', 'Stop')
Global $__tutorial__= add($affectations, "__tutorial__", $gui_section, 'Reflex Renderer Tutorial', 'Reflex Renderer Tutorial')
Global $__autoplay__= add($affectations, "__autoplay__", $gui_section, 'Autoplay', 'Automated actions')
Global $__error__   = add($affectations, "__error__", $gui_section, 'Error', 'Error')
Global $__tutorial_section_misformed_aborting_loading__= add($affectations, "__tutorial_section_misformed_aborting_loading__", $gui_section, 'Tutorial section misformed', 'Tutorial section misformed')
Global $__open_tutorial__                = add($affectations, "__open_tutorial__", $gui_section, 'Tutorial...', 'Tutorial...')
Global $__randf_auto_hint__              = add($affectations, "__randf_auto_hint__", $gui_section, 'randf_auto_hint', 'randf_auto_hint')
Global $__randh_auto_hint__              = add($affectations, "__randh_auto_hint__", $gui_section, 'randh_auto_hint', 'randh_auto_hint')
Global $__randomize_seed_hint__          = add($affectations, "__randomize_seed_hint__", $gui_section, 'Randomize_seed_hint', 'Randomize_seed_hint')
Global $__customize_menu__               = add($affectations, "__customize_menu__", $gui_section, 'Customize', 'Customize')
Global $__customize_menu_all_parameters__= add($affectations, "__customize_menu_all_parameters__", $gui_section, 'General parameters', 'General parameters')
Global $__reset_menu__                   = add($affectations, "__reset_menu__", $gui_section, 'Reset All', 'Reset All')
Global $__confirmation_reset_title__     = add($affectations, "__confirmation_reset_title__", $gui_section, 'confirmation reset title', 'Confirm reset')
Global $__confirmation_reset_message__   = add($affectations, "__confirmation_reset_message__", $gui_section, 'Do you confirm to reset all fields?', 'Do you confirm to reset all fields?')
Global $__menu_formula_small_history__   = add($affectations, "__menu_formula_small_history__", $gui_section, 'menu small history', 'Small History')
Global $__lucky_func__                   = add($affectations, "__lucky_func__", $gui_section, 'Lucky function', 'Lucky function')
Global $__lucky_func_hint__              = add($affectations, "__lucky_func_hint__", $gui_section, 'Lucky func hint', 'Generates a random complex function')
Global $__lucky_fractal__                = add($affectations, "__lucky_fractal__", $gui_section, 'Lucky fractal', 'Lucky fractal')
Global $__lucky_fractal_hint__           = add($affectations, "__lucky_fractal_hint__", $gui_section, 'Lucky fractal hint', 'Generates a random complex function and compose it by itself')
Global $__switch_fractal__               = add($affectations, "__switch_fractal__", $gui_section, '(Un)fractalize!', '(Un)fractalize!')
Global $__switch_fractal_hint__          = add($affectations, "__switch_fractal_hint__", $gui_section, 'Switch fractal hint', 'Toggles betweens fractal and function')
Global $__autoplay_plus_action__         = add($affectations, "__autoplay_plus_action__", $gui_section, 'Autoplay action', 'Automated actions (1 planified action)')
Global $__switch_function__              = add($affectations, "__switch_function__", $gui_section, 'Unfractalize !', 'Unfractalize !')
Global $__wait_while_generating__        = add($affectations, "__wait_while_generating__", $gui_section, 'Wait while generating', 'Please wait while the function is generated')
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

Func globalTranslationIni($translation_current_language)
  Return @ScriptDir&'\'&$lang_folder&'\'&translationFile($translation_current_language)
EndFunc

Func translationFile($str)
  Local $result = "translations_"&$str&".ini"
  Return $result
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
    ; 'Français', 'fr_lang', 'fr'
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
