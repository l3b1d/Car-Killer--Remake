extends CanvasLayer

@onready var panel: PanelContainer = $pause_panel
@onready var title_label: Label = $pause_panel/margin_container/vbox_container/title_label
@onready var resume_btn: Button = $pause_panel/margin_container/vbox_container/resume_btn
@onready var main_menu_btn: Button = $pause_panel/margin_container/vbox_container/main_menu_btn
@onready var quit_btn: Button = $pause_panel/margin_container/vbox_container/quit_btn

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.visible = false
	_update_text()

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	if event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		var death_screen := get_tree().get_first_node_in_group("death_screen") as CanvasLayer
		if death_screen != null and death_screen.visible:
			return
		if panel.visible:
			_resume_game()
		else:
			_open_pause_menu()
		get_viewport().set_input_as_handled()

func _open_pause_menu() -> void:
	get_tree().paused = true
	panel.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	resume_btn.grab_focus()

func _resume_game() -> void:
	panel.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _update_text() -> void:
	title_label.text = tr("Game paused")
	resume_btn.text = tr("Resume")
	main_menu_btn.text = tr("Main Menu")
	quit_btn.text = tr("Quit Game")

func _on_resume_btn_pressed() -> void:
	_resume_game()

func _on_main_menu_btn_pressed() -> void:
	_resume_game()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")

func _on_quit_btn_pressed() -> void:
	_resume_game()
	get_tree().quit()
