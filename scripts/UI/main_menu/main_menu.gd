extends Node2D

## For Quit Button
@onready var quit_btn: Button = $mainMenuBckgr/VBoxContainer/quit_btn

func _quitBtnReady() -> void:
	quit_btn.pressed.connect(_on_quit_btn_pressed)

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
	
## For Quit Button

## For Start Button
@onready var start_btn: Button = $mainMenuBckgr/VBoxContainer/start_btn

func _startBtnReady() -> void:
	start_btn.pressed.connect(_on_start_btn_pressed)

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/base_game.tscn")

## For Start Button

## For Settings Button

@onready var settings_btn: Button = $mainMenuBckgr/VBoxContainer/settings_btn

func _settingsBtnReady() -> void:
	settings_btn.pressed.connect(_on_settings_btn_pressed)

func _on_settings_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/settings.tscn")

## For Settings Button
