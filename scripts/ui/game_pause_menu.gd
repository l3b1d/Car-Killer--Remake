extends CanvasLayer

@onready var panel: PanelContainer = $PausePanel
@onready var title_label: Label = $PausePanel/MarginContainer/VBoxContainer/TitleLabel
@onready var resume_button: Button = $PausePanel/MarginContainer/VBoxContainer/ResumeButton
@onready var main_menu_button: Button = $PausePanel/MarginContainer/VBoxContainer/MainMenuButton
@onready var quit_button: Button = $PausePanel/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.visible = false
	_update_text()

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	if event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		if panel.visible:
			_resume_game()
		else:
			_open_pause_menu()

func _open_pause_menu() -> void:
	get_tree().paused = true
	panel.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	resume_button.grab_focus()

func _resume_game() -> void:
	panel.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _update_text() -> void:
	title_label.text = tr("Game paused")
	resume_button.text = tr("Resume")
	main_menu_button.text = tr("Main Menu")
	quit_button.text = tr("Quit Game")

func _on_resume_button_pressed() -> void:
	_resume_game()

func _on_main_menu_button_pressed() -> void:
	_resume_game()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")

func _on_quit_button_pressed() -> void:
	_resume_game()
	get_tree().quit()
