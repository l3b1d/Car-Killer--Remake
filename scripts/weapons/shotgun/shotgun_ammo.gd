extends Node

signal changed(ammo: int, magazine_size: int, reloading: bool)

@export var magazine_size := 2
@export var reload_duration := 1.7
@export var partial_reload_multiplier := 0.5

var ammo := 0
var reloading := false
var reload_timer := 0.0

func _ready() -> void:
	ammo = magazine_size

func process_reload(delta: float) -> void:
	if not reloading:
		return

	reload_timer -= delta
	if reload_timer <= 0.0:
		reloading = false
		ammo = magazine_size
		changed.emit(ammo, magazine_size, reloading)

func consume_shell() -> bool:
	if reloading or ammo <= 0:
		return false

	ammo -= 1
	changed.emit(ammo, magazine_size, reloading)
	return true

func start_reload() -> void:
	if reloading or ammo >= magazine_size:
		return

	reloading = true
	var current_reload_duration := reload_duration
	if ammo == magazine_size - 1:
		current_reload_duration *= partial_reload_multiplier
	reload_timer = current_reload_duration
	changed.emit(ammo, magazine_size, reloading)