extends Node3D

signal ammo_changed(ammo: int, magazine_size: int, reloading: bool)

@export var model_scene: PackedScene
@export var hands_scene: PackedScene
@export var projectile_scene: PackedScene

@onready var ammo_component: Node = $Ammo
@onready var firing_component: Node = $Firing

var ammo: int:
	get:
		return ammo_component.ammo

var magazine_size: int:
	get:
		return ammo_component.magazine_size

var reloading: bool:
	get:
		return ammo_component.reloading

func _ready() -> void:
	if model_scene != null:
		add_child(model_scene.instantiate())
	if hands_scene != null:
		add_child(hands_scene.instantiate())
	ammo_component.changed.connect(_on_ammo_changed)
	_emit_ammo_changed()

func _process(delta: float) -> void:
	ammo_component.process_reload(delta)
	firing_component.process_cooldown(delta)
	if ammo_component.reloading:
		return

	if Input.is_action_just_pressed("reload"):
		ammo_component.start_reload()
	elif Input.is_action_just_pressed("shoot"):
		firing_component.fire(projectile_scene)

func _on_ammo_changed(current_ammo: int, current_magazine_size: int, is_reloading: bool) -> void:
	ammo_changed.emit(current_ammo, current_magazine_size, is_reloading)

func _emit_ammo_changed() -> void:
	ammo_changed.emit(ammo, magazine_size, reloading)