extends Node2D

## For Quit Button
@onready var quit_btn: Button = $mainMenuBckgr/VBoxContainer/quitBtn

func _quitBtnReady() -> void:
	quit_btn.pressed.connect(_on_quit_btn_pressed)

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
	
## For Quit Button

## For Start Button
@onready var start_btn: Button = $mainMenuBckgr/VBoxContainer/startBtn

func _startBtnReady() -> void:
	start_btn.pressed.connect(_on_start_btn_pressed)

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/3D/baseGame.tscn")
