extends CanvasLayer

@onready var title_label: Label = $panel/margin_container/vbox_container/title_label
@onready var restart_btn: Button = $panel/margin_container/vbox_container/restart_btn
@onready var menu_btn: Button = $panel/margin_container/vbox_container/menu_btn

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	_update_text()

func show_screen() -> void:
	visible = true
	restart_btn.grab_focus()

func _update_text() -> void:
	title_label.text = tr("You died")
	restart_btn.text = tr("Restart")
	menu_btn.text = tr("Exit to menu")

func _on_restart_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/base_game.tscn")

func _on_menu_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
