extends Node3D

var pause_menu: CanvasLayer
var death_screen: CanvasLayer
var elapsed_time := 0.0
var level_completed := false

@onready var player: CharacterBody3D = $player
@onready var shotgun: Node = $player/camera_pivot/shotgun
@onready var health_bar: ProgressBar = $hud/stats_panel/stats/hp_bar
@onready var stamina_bar: ProgressBar = $hud/stats_panel/stats/stamina_bar
@onready var health_label: Label = $hud/stats_panel/stats/health_label
@onready var stamina_label: Label = $hud/stats_panel/stats/stamina_label
@onready var ammo_label: Label = $hud/stats_panel/stats/ammo_label
@onready var finish_zone: Area3D = $gameplay/finish_zone
@onready var victory_panel: PanelContainer = $hud/victory_panel
@onready var victory_time_label: Label = $hud/victory_panel/victory_content/time_label
@onready var victory_restart_btn: Button = $hud/victory_panel/victory_content/restart_btn

func _ready() -> void:
	pause_menu = preload("res://scenes/ui/game_pause_menu.tscn").instantiate()
	death_screen = preload("res://scenes/ui/death_screen.tscn").instantiate()
	add_child(pause_menu)
	add_child(death_screen)
	finish_zone.level_completed.connect(_on_level_completed)
	player.stats_changed.connect(_on_player_stats_changed)
	shotgun.ammo_changed.connect(_on_ammo_changed)
	_on_player_stats_changed(player.health, player.max_health, player.stamina, player.max_stamina)
	_on_ammo_changed(shotgun.ammo, shotgun.magazine_size, shotgun.reloading)

func _process(delta: float) -> void:
	if not level_completed and not get_tree().paused:
		elapsed_time += delta

func _on_player_stats_changed(health: int, max_health: int, stamina: float, max_stamina: float) -> void:
	health_bar.max_value = max_health
	health_bar.value = health
	stamina_bar.max_value = max_stamina
	stamina_bar.value = stamina
	health_label.text = tr("HP status") % [health, max_health]
	stamina_label.text = tr("Stamina status") % [roundi(stamina), roundi(max_stamina)]

	if health <= 0 and not death_screen.visible:
		get_tree().paused = true
		death_screen.show_screen()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_ammo_changed(ammo: int, magazine_size: int, reloading: bool) -> void:
	ammo_label.text = tr("Reloading") if reloading else tr("Shells status") % [ammo, magazine_size]

func _on_level_completed(_completed_player: Node3D) -> void:
	if level_completed:
		return
	level_completed = true
	victory_time_label.text = "TIME: %.2f s" % elapsed_time
	victory_panel.show()
	victory_restart_btn.grab_focus()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_victory_restart_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/base_game.tscn")

func _on_victory_menu_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
