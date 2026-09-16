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
	var view_model: Node3D
	if model_scene != null:
		view_model = model_scene.instantiate()
		add_child(view_model)
		_disable_shadows(view_model)
	if hands_scene != null:
		var hands := hands_scene.instantiate()
		if view_model != null:
			view_model.add_child(hands)
		else:
			add_child(hands)
		_disable_shadows(hands)
	ammo_component.changed.connect(_on_ammo_changed)
	_emit_ammo_changed()

func _disable_shadows(node: Node) -> void:
	for child in node.get_children():
		if child is GeometryInstance3D:
			child.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_disable_shadows(child)

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
