extends Node

@export var cooldown := 0.8
@export var range := 80.0

var cooldown_timer := 0.0

@onready var shotgun: Node3D = get_parent()
@onready var camera: Camera3D = shotgun.get_node("../Camera3D")
@onready var muzzle: Node3D = shotgun.get_node("Muzzle")
@onready var ammo: Node = shotgun.get_node("Ammo")

func process_cooldown(delta: float) -> void:
	cooldown_timer = maxf(cooldown_timer - delta, 0.0)

func can_fire() -> bool:
	return cooldown_timer <= 0.0 and not ammo.reloading and ammo.ammo > 0

func fire(projectile_scene: PackedScene) -> void:
	if not can_fire() or not ammo.consume_shell():
		return

	cooldown_timer = cooldown
	var viewport_center := get_viewport().get_visible_rect().size * 0.5
	var ray_origin := camera.project_ray_origin(viewport_center)
	var ray_end := ray_origin + camera.project_ray_normal(viewport_center) * range
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.exclude = [shotgun.get_parent().get_parent()]
	var hit := shotgun.get_world_3d().direct_space_state.intersect_ray(query)
	var target_point: Vector3 = hit.position if not hit.is_empty() else ray_end
	var projectile := projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = muzzle.global_position
	projectile.setup((target_point - muzzle.global_position).normalized(), shotgun.get_parent().get_parent())