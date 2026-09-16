extends Node3D

var pause_menu: CanvasLayer

@onready var player: CharacterBody3D = $Player
@onready var shotgun: Node = $Player/CameraPivot/Shotgun
@onready var health_bar: ProgressBar = $HUD/StatsPanel/Stats/HpBar
@onready var stamina_bar: ProgressBar = $HUD/StatsPanel/Stats/StaminaBar
@onready var health_label: Label = $HUD/StatsPanel/Stats/HealthLabel
@onready var stamina_label: Label = $HUD/StatsPanel/Stats/StaminaLabel
@onready var ammo_label: Label = $HUD/StatsPanel/Stats/AmmoLabel

func _ready() -> void:
	pause_menu = preload("res://scenes/ui/game_pause_menu.tscn").instantiate()
	add_child(pause_menu)
	player.stats_changed.connect(_on_player_stats_changed)
	shotgun.ammo_changed.connect(_on_ammo_changed)
	_on_player_stats_changed(player.health, player.MAX_HEALTH, player.stamina, player.MAX_STAMINA)
	_on_ammo_changed(shotgun.ammo, shotgun.magazine_size, shotgun.reloading)

func _on_player_stats_changed(health: int, max_health: int, stamina: float, max_stamina: float) -> void:
	health_bar.max_value = max_health
	health_bar.value = health
	stamina_bar.max_value = max_stamina
	stamina_bar.value = stamina
	health_label.text = tr("HP status") % [health, max_health]
	stamina_label.text = tr("Stamina status") % [roundi(stamina), roundi(max_stamina)]

func _on_ammo_changed(ammo: int, magazine_size: int, reloading: bool) -> void:
	ammo_label.text = tr("Reloading") if reloading else tr("Shells status") % [ammo, magazine_size]
