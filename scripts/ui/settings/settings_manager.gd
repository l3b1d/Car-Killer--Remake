extends Node

const player_config_path := "user://player_config.cfg"
const legacy_settings_path := "user://settings.cfg"
const display_section := "display"
const audio_section := "audio"
const fullscreen_key := "fullscreen"
const language_key := "language"
const master_volume_key := "master_volume"
const music_volume_key := "music_volume"
const sfx_volume_key := "sfx_volume"

var fullscreen := true
var language := "en"
var master_volume := 1.0
var music_volume := 1.0
var sfx_volume := 1.0

func _ready() -> void:
	_load_settings()
	_apply_display_mode()

func save_settings(
		fullscreen_enabled: bool,
		language_code: String = language,
		master_volume_level: float = master_volume,
		music_volume_level: float = music_volume,
		sfx_volume_level: float = sfx_volume
	) -> void:
	fullscreen = fullscreen_enabled
	language = language_code
	master_volume = master_volume_level
	music_volume = music_volume_level
	sfx_volume = sfx_volume_level

	var config := ConfigFile.new()
	config.set_value(display_section, fullscreen_key, fullscreen)
	config.set_value(display_section, language_key, language)
	config.set_value(audio_section, master_volume_key, master_volume)
	config.set_value(audio_section, music_volume_key, music_volume)
	config.set_value(audio_section, sfx_volume_key, sfx_volume)
	config.save(player_config_path)
	_apply_language()
	_apply_display_mode()
	_apply_audio()

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
		master_volume = config.get_value(audio_section, master_volume_key, 1.0)
		music_volume = config.get_value(audio_section, music_volume_key, 1.0)
		sfx_volume = config.get_value(audio_section, sfx_volume_key, 1.0)
		if language == "uk":
			language = "ua"
			save_settings(fullscreen, language)
		_apply_language()
		_apply_audio()
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

func _apply_audio() -> void:
	_set_bus_volume("Master", master_volume)
	_set_bus_volume("Music", music_volume)
	_set_bus_volume("SFX", sfx_volume)

func _set_bus_volume(bus_name: String, volume: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(volume, 0.0001)))
	AudioServer.set_bus_mute(bus_index, is_zero_approx(volume))
