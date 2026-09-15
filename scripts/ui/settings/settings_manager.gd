extends Node

const PLAYER_CONFIG_PATH := "user://player_config.cfg"
const LEGACY_SETTINGS_PATH := "user://settings.cfg"
const DISPLAY_SECTION := "display"
const FULLSCREEN_KEY := "fullscreen"

var fullscreen := true

func _ready() -> void:
	_load_settings()
	_apply_display_mode()

func save_settings(fullscreen_enabled: bool) -> void:
	fullscreen = fullscreen_enabled

	var config := ConfigFile.new()
	config.set_value(DISPLAY_SECTION, FULLSCREEN_KEY, fullscreen)
	config.save(PLAYER_CONFIG_PATH)
	_apply_display_mode()

func set_fullscreen(fullscreen_enabled: bool) -> void:
	fullscreen = fullscreen_enabled
	_apply_display_mode()

func _load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(PLAYER_CONFIG_PATH) == OK:
		fullscreen = config.get_value(DISPLAY_SECTION, FULLSCREEN_KEY, true)
		return

	if config.load(LEGACY_SETTINGS_PATH) == OK:
		fullscreen = config.get_value(DISPLAY_SECTION, FULLSCREEN_KEY, true)
		save_settings(fullscreen)
		return

	save_settings(fullscreen)

func _apply_display_mode() -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
