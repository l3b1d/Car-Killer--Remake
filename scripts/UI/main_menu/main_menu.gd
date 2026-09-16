extends Node2D

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$main_menu_back/buttons_container/start_btn.text = tr("Start")
	$main_menu_back/buttons_container/settings_btn.text = tr("Settings")
	$main_menu_back/buttons_container/quit_btn.text = tr("Quit")
	$main_menu_back/main_text.text = tr("CAR KILLER: REMASTERED")

func _on_start_btn_pressed() -> void:
	_open_loading_screen()

func _open_loading_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/loading/game_loading.tscn")

func _on_settings_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings/settings.tscn")
