extends Node2D

@onready var display_mode_option: OptionButton = $settingsBckgr/display_mode_option
@onready var language_option: OptionButton = $settingsBckgr/language_option
@onready var save_button: Button = $settingsBckgr/san_btn

func _ready() -> void:
	display_mode_option.clear()
	display_mode_option.add_item(tr("Windowed"), 0)
	display_mode_option.add_item(tr("Fullscreen"), 1)
	display_mode_option.select(1 if SettingsManager.fullscreen else 0)

	language_option.clear()
	language_option.add_item("English", 0)
	language_option.add_item("Українська", 1)
	language_option.select(1 if SettingsManager.language == "ua" else 0)
	_update_text()

func _on_display_mode_option_item_selected(index: int) -> void:
	SettingsManager.set_fullscreen(index == 1)

func _on_language_option_item_selected(index: int) -> void:
	SettingsManager.set_language("ua" if index == 1 else "en")
	_update_text()

func _update_text() -> void:
	$settingsBckgr/display_label.text = tr("Display mode")
	$settingsBckgr/language_label.text = tr("Language")
	save_button.text = tr("Save & Exit")
	display_mode_option.set_item_text(0, tr("Windowed"))
	display_mode_option.set_item_text(1, tr("Fullscreen"))
	language_option.set_item_text(0, tr("English"))
	language_option.set_item_text(1, tr("Ukrainian"))

func _on_san_btn_pressed() -> void:
	SettingsManager.save_settings(display_mode_option.selected == 1, SettingsManager.language)
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
