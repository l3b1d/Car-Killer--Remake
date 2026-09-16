extends Control

const BASE_GAME_SCENE := "res://scenes/levels/base_game.tscn"

@onready var status_label: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/StatusLabel
@onready var progress_bar: ProgressBar = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ProgressBar
@onready var start_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/StartButton

var game_scene: PackedScene
var loading_failed := false
var game_scene_path := BASE_GAME_SCENE

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel.text = tr("CAR KILLER: REMASTERED")
	start_button.text = tr("Start game")
	start_button.disabled = true
	start_button.visible = false
	progress_bar.value = 0.0

	var request_result := ResourceLoader.load_threaded_request(game_scene_path)
	if request_result != OK:
		_show_loading_error()

func _process(_delta: float) -> void:
	if loading_failed or game_scene != null:
		return

	var progress := []
	var load_status := ResourceLoader.load_threaded_get_status(game_scene_path, progress)
	if not progress.is_empty():
		progress_bar.value = progress[0] * 100.0

	match load_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			status_label.text = tr("Preparing the game...")
		ResourceLoader.THREAD_LOAD_LOADED:
			game_scene = ResourceLoader.load_threaded_get(game_scene_path)
			progress_bar.value = 100.0
			status_label.text = tr("Everything is ready.")
			start_button.visible = true
			start_button.disabled = false
			start_button.grab_focus()
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_show_loading_error()

func _on_start_button_pressed() -> void:
	if game_scene != null:
		get_tree().change_scene_to_packed(game_scene)

func _show_loading_error() -> void:
	loading_failed = true
	status_label.text = tr("The game could not be loaded.")
	progress_bar.visible = false
	start_button.visible = false
