extends CanvasLayer

@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var restart_button: Button = $Panel/MarginContainer/VBoxContainer/RestartButton
@onready var menu_button: Button = $Panel/MarginContainer/VBoxContainer/MenuButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	_update_text()

func show_screen() -> void:
	visible = true
	restart_button.grab_focus()

func _update_text() -> void:
	title_label.text = tr("You died")
	restart_button.text = tr("Restart")
	menu_button.text = tr("Exit to menu")

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/base_game.tscn")

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
