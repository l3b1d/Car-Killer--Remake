extends Node

const player_config_path := "user://player_config.cfg"
const legacy_settings_path := "user://settings.cfg"
const display_section := "display"
const fullscreen_key := "fullscreen"
const language_key := "language"

var fullscreen := true
var language := "en"

func _ready() -> void:
	_load_settings()
	_apply_display_mode()

func save_settings(fullscreen_enabled: bool, language_code: String = language) -> void:
	fullscreen = fullscreen_enabled
	language = language_code

	var config := ConfigFile.new()
	config.set_value(display_section, fullscreen_key, fullscreen)
	config.set_value(display_section, language_key, language)
	config.save(player_config_path)
	_apply_language()
	_apply_display_mode()

func set_fullscreen(fullscreen_enabled: bool) -> void:
	fullscreen = fullscreen_enabled
	_apply_display_mode()

func set_language(language_code: String) -> void:
	language = language_code
	_apply_language()

func _load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(player_config_path) == OK:
		fullscreen = config.get_value(display_section, fullscreen_key, true)
		language = config.get_value(display_section, language_key, "en")
		if language == "uk":
			language = "ua"
			save_settings(fullscreen, language)
		_apply_language()
		return

	if config.load(legacy_settings_path) == OK:
		fullscreen = config.get_value(display_section, fullscreen_key, true)
		language = config.get_value(display_section, language_key, "en")
		if language == "uk":
			language = "ua"
		save_settings(fullscreen)
		return

	save_settings(fullscreen)

func _apply_display_mode() -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _apply_language() -> void:
	TranslationServer.set_locale(language)
