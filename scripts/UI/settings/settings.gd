extends Node2D

@onready var display_mode_option: OptionButton = $settings_background/display_mode_option
@onready var language_option: OptionButton = $settings_background/language_option
@onready var master_volume_slider: HSlider = $settings_background/master_volume_slider
@onready var music_volume_slider: HSlider = $settings_background/music_volume_slider
@onready var sfx_volume_slider: HSlider = $settings_background/sfx_volume_slider
@onready var save_btn: Button = $settings_background/san_btn

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	display_mode_option.clear()
	display_mode_option.add_item(tr("Windowed"), 0)
	display_mode_option.add_item(tr("Fullscreen"), 1)
	display_mode_option.select(1 if SettingsManager.fullscreen else 0)

	language_option.clear()
	language_option.add_item("English", 0)
	language_option.add_item("Українська", 1)
	language_option.select(1 if SettingsManager.language == "ua" else 0)
	master_volume_slider.value = SettingsManager.master_volume * 100.0
	music_volume_slider.value = SettingsManager.music_volume * 100.0
	sfx_volume_slider.value = SettingsManager.sfx_volume * 100.0
	_update_text()

func _on_master_volume_slider_value_changed(value: float) -> void:
	SettingsManager.master_volume = value / 100.0
	SettingsManager._apply_audio()

func _on_music_volume_slider_value_changed(value: float) -> void:
	SettingsManager.music_volume = value / 100.0
	SettingsManager._apply_audio()

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	SettingsManager.sfx_volume = value / 100.0
	SettingsManager._apply_audio()

func _on_display_mode_option_item_selected(index: int) -> void:
	SettingsManager.set_fullscreen(index == 1)

func _on_language_option_item_selected(index: int) -> void:
	SettingsManager.set_language("ua" if index == 1 else "en")
	_update_text()

func _update_text() -> void:
	$settings_background/display_label.text = tr("Display mode")
	$settings_background/language_label.text = tr("Language")
	$settings_background/master_volume_label.text = tr("Master volume")
	$settings_background/music_volume_label.text = tr("Music volume")
	$settings_background/sfx_volume_label.text = tr("SFX volume")
	save_btn.text = tr("Save & Exit")
	display_mode_option.set_item_text(0, tr("Windowed"))
	display_mode_option.set_item_text(1, tr("Fullscreen"))
	language_option.set_item_text(0, tr("English"))
	language_option.set_item_text(1, tr("Ukrainian"))

func _on_san_btn_pressed() -> void:
	SettingsManager.save_settings(
		display_mode_option.selected == 1,
		SettingsManager.language,
		master_volume_slider.value / 100.0,
		music_volume_slider.value / 100.0,
		sfx_volume_slider.value / 100.0
	)
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
