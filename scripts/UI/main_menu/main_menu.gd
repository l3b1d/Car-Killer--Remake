extends Node2D

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/loading/game_loading.tscn")

func _on_settings_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings/settings.tscn")
