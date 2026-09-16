extends Node

@export var shot_slow_multiplier := 0.45
@export var shot_slow_duration := 2.5
@export var shot_impulse := 5600.0
@export var knockback_decay := 6.0

var slow_timer := 0.0
var knockback_velocity := Vector3.ZERO

func physics_process(delta: float) -> void:
	slow_timer = maxf(slow_timer - delta, 0.0)
	knockback_velocity = knockback_velocity.move_toward(Vector3.ZERO, knockback_decay * delta)

func get_speed_multiplier() -> float:
	return shot_slow_multiplier if slow_timer > 0.0 else 1.0

func get_knockback_velocity() -> Vector3:
	return knockback_velocity

func apply_slow() -> void:
	if slow_timer <= 0.0:
		slow_timer = shot_slow_duration

func apply_impact(impact_direction: Vector3) -> void:
	var horizontal_direction := Vector3(impact_direction.x, 0.0, impact_direction.z)
	if horizontal_direction.length_squared() == 0.0:
		return

	horizontal_direction = horizontal_direction.normalized()
	var vehicle_mass := float(get_parent().get_node("movement").get("mass"))
	knockback_velocity = horizontal_direction * shot_impulse / vehicle_mass