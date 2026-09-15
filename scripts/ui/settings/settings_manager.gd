extends Node

const PLAYER_CONFIG_PATH := "user://player_config.cfg"
const LEGACY_SETTINGS_PATH := "user://settings.cfg"
const DISPLAY_SECTION := "display"
const FULLSCREEN_KEY := "fullscreen"
const LANGUAGE_KEY := "language"

var fullscreen := true
var language := "en"

func _ready() -> void:
	_load_settings()
	_apply_display_mode()

func save_settings(fullscreen_enabled: bool, language_code: String = language) -> void:
	fullscreen = fullscreen_enabled
	language = language_code

	var config := ConfigFile.new()
	config.set_value(DISPLAY_SECTION, FULLSCREEN_KEY, fullscreen)
	config.set_value(DISPLAY_SECTION, LANGUAGE_KEY, language)
	config.save(PLAYER_CONFIG_PATH)
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
	if config.load(PLAYER_CONFIG_PATH) == OK:
		fullscreen = config.get_value(DISPLAY_SECTION, FULLSCREEN_KEY, true)
		language = config.get_value(DISPLAY_SECTION, LANGUAGE_KEY, "en")
		if language == "uk":
			language = "ua"
			save_settings(fullscreen, language)
		_apply_language()
		return

	if config.load(LEGACY_SETTINGS_PATH) == OK:
		fullscreen = config.get_value(DISPLAY_SECTION, FULLSCREEN_KEY, true)
		language = config.get_value(DISPLAY_SECTION, LANGUAGE_KEY, "en")
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
