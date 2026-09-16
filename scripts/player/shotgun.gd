extends Node3D

signal ammo_changed(ammo: int, magazine_size: int, reloading: bool)

@export var model_scene: PackedScene
@export var projectile_scene: PackedScene
@export var cooldown := 0.8
@export var range := 80.0
@export var magazine_size := 2
@export var reload_duration := 1.7

var cooldown_timer := 0.0
var reload_timer := 0.0
var ammo := 0
var reloading := false

@onready var camera: Camera3D = get_node("../Camera3D")
@onready var muzzle: Node3D = $Muzzle

func _ready() -> void:
	ammo = magazine_size
	if model_scene != null:
		add_child(model_scene.instantiate())
	_emit_ammo_changed()

func _process(delta: float) -> void:
	cooldown_timer = maxf(cooldown_timer - delta, 0.0)
	if reloading:
		reload_timer -= delta
		if reload_timer <= 0.0:
			reloading = false
			ammo = magazine_size
			_emit_ammo_changed()
		return

	if Input.is_action_just_pressed("reload"):
		_reload()
	elif Input.is_action_just_pressed("shoot") and cooldown_timer <= 0.0 and ammo > 0:
		_shoot()

func _shoot() -> void:
	ammo -= 1
	cooldown_timer = cooldown
	_emit_ammo_changed()
	var viewport_center := get_viewport().get_visible_rect().size * 0.5
	var ray_origin := camera.project_ray_origin(viewport_center)
	var ray_end := ray_origin + camera.project_ray_normal(viewport_center) * range
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [get_parent()]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	var target_point: Vector3 = hit.position if not hit.is_empty() else ray_end
	var projectile := projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = muzzle.global_position
	projectile.setup((target_point - muzzle.global_position).normalized(), get_parent())

func _reload() -> void:
	if ammo >= magazine_size:
		return

	reloading = true
	reload_timer = reload_duration
	_emit_ammo_changed()

func _emit_ammo_changed() -> void:
	ammo_changed.emit(ammo, magazine_size, reloading)