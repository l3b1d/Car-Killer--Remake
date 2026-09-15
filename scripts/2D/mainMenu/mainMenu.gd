extends Node2D

## For Quit Button
@onready var quit_btn: Button = $mainMenuBckgr/VBoxContainer/quitBtn

func _ready() -> void:
	quit_btn.pressed.connect(_on_quit_btn_pressed)
	
func _on_quit_btn_pressed() -> void:
	get_tree().quit()
	
## For Quit Button
