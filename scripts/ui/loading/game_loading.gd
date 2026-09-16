extends Control

const base_game_scene := "res://scenes/levels/base_game.tscn"

@onready var status_label: Label = $center_container/panel_container/margin_container/vbox_container/status_label
@onready var progress_bar: ProgressBar = $center_container/panel_container/margin_container/vbox_container/progress_bar
@onready var start_btn: Button = $center_container/panel_container/margin_container/vbox_container/start_btn

var game_scene: PackedScene
var loading_failed := false
var game_scene_path := base_game_scene

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$center_container/panel_container/margin_container/vbox_container/title_label.text = tr("CAR KILLER: REMASTERED")
	start_btn.text = tr("Start game")
	start_btn.disabled = true
	start_btn.visible = false
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
			start_btn.visible = true
			start_btn.disabled = false
			start_btn.grab_focus()
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_show_loading_error()

func _on_start_btn_pressed() -> void:
	if game_scene != null:
		get_tree().change_scene_to_packed(game_scene)

func _show_loading_error() -> void:
	loading_failed = true
	status_label.text = tr("The game could not be loaded.")
	progress_bar.visible = false
	start_btn.visible = false
