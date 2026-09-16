extends Node3D

@export var speed := 35.0
@export var lifetime := 3.0
@export var collision_mask := 1

var direction := Vector3.FORWARD
var source: Node3D
var remaining_lifetime := 0.0

func setup(flight_direction: Vector3, projectile_source: Node3D) -> void:
	direction = flight_direction.normalized()
	source = projectile_source
	remaining_lifetime = lifetime
	look_at(global_position + direction, Vector3.UP)

func _physics_process(delta: float) -> void:
	if remaining_lifetime <= 0.0:
		queue_free()
		return

	remaining_lifetime -= delta
	var next_position := global_position + direction * speed * delta
	var query := PhysicsRayQueryParameters3D.create(global_position, next_position, collision_mask)
	query.exclude = [source, self]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		if hit.collider.has_method("apply_shot_slow"):
			hit.collider.apply_shot_slow()
		if hit.collider.has_method("apply_shot_impact"):
			hit.collider.apply_shot_impact(direction)
		queue_free()
		return

	global_position = next_position