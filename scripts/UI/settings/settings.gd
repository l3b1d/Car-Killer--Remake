extends Node2D

@onready var fullscreen_toggle: CheckButton = $settingsBckgr/fullscreen_toggle

func _ready() -> void:
	fullscreen_toggle.button_pressed = SettingsManager.fullscreen

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	SettingsManager.set_fullscreen(toggled_on)

func _on_san_btn_pressed() -> void:
	SettingsManager.save_settings(fullscreen_toggle.button_pressed)
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")