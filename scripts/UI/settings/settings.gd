extends Node2D

#Save and Exit Button. W.I.P

@onready var san_btn: Button = $settingsBckgr/san_btn

func _san_btn_ready() -> void:
	san_btn.pressed.connect(_on_san_btn_pressed)

func _on_san_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")


#Save and Exit Button. W.I.P