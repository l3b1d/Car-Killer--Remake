extends Node

@export var mass := 1400.0
@export var max_speed := 16.0
@export var engine_force := 14000.0
@export var brake_force := 22000.0
@export var stopping_distance := 2.5
@export var gravity := 9.8
@export var wheel_base := 2.5
@export var wheel_radius := 0.3625
@export var max_steering_angle := 0.45
@export var steering_response := 1.6
@export var max_turn_rate := 1.15
@export var turn_response := 2.0
@export var lateral_grip := 3.5
@export var reverse_speed := 3.6
@export var reverse_angle_threshold := 1.65

@onready var car: CharacterBody3D = get_parent()
@onready var hit_reaction: Node = car.get_node("hit_reaction")
@onready var model: Node3D = car.get_node("killer_car_model")
@onready var front_left_wheel: Node3D = model.find_child("LFrontWheel", true, false) as Node3D
@onready var front_right_wheel: Node3D = model.find_child("RFrontWheel", true, false) as Node3D
@onready var rear_left_wheel: Node3D = model.find_child("LBackWheel", true, false) as Node3D
@onready var rear_right_wheel: Node3D = model.find_child("RBackWheel", true, false) as Node3D

var target: Node3D
var drive_velocity := Vector3.ZERO
var steering_angle := 0.0
var turn_rate := 0.0
var rest_bases: Dictionary[Node3D, Basis] = {}

func _ready() -> void:
	for wheel in [front_left_wheel, front_right_wheel, rear_left_wheel, rear_right_wheel]:
		rest_bases[wheel] = wheel.basis
	target = get_tree().get_first_node_in_group("player") as Node3D
	call_deferred("_align_to_target")

func _align_to_target() -> void:
	if target == null or not is_instance_valid(target):
		return

	var direction := target.global_position - car.global_position
	direction.y = 0.0
	if direction.length_squared() > 0.01:
		car.rotation.y = atan2(-direction.x, -direction.z)

func physics_process(delta: float) -> void:
	hit_reaction.physics_process(delta)

	if target == null or not is_instance_valid(target):
		target = get_tree().get_first_node_in_group("player") as Node3D
		_apply_gravity(delta)
		car.move_and_slide()
		return

	var local_target := car.global_transform.affine_inverse() * target.global_position
	local_target.y = 0.0
	var distance := Vector2(local_target.x, local_target.z).length()
	var knockback_velocity: Vector3 = hit_reaction.get_knockback_velocity()
	var target_angle := atan2(-local_target.x, -local_target.z)
	var desired_steering := clampf(target_angle, -max_steering_angle, max_steering_angle)
	var is_reversing := absf(target_angle) > reverse_angle_threshold and distance > stopping_distance
	if is_reversing:
		var reverse_direction := signf(target_angle)
		if is_zero_approx(reverse_direction):
			reverse_direction = 1.0
		desired_steering = -reverse_direction * max_steering_angle
	steering_angle = move_toward(steering_angle, desired_steering, steering_response * delta)

	var speed_limit: float = max_speed * hit_reaction.get_speed_multiplier()
	var target_speed := speed_limit
	if distance <= stopping_distance:
		target_speed = 0.0
	elif is_reversing:
		target_speed = -reverse_speed
	else:
		target_speed *= maxf(cos(absf(target_angle)), 0.2)

	var forward := -car.global_transform.basis.z
	var forward_speed := drive_velocity.dot(forward)
	var lateral_velocity := drive_velocity - forward * forward_speed
	var acceleration := engine_force / mass
	var braking := brake_force / mass
	var speed_change := acceleration if target_speed > forward_speed else braking
	forward_speed = move_toward(forward_speed, target_speed, speed_change * delta)

	var desired_turn_rate := 0.0
	if absf(forward_speed) > 0.01:
		desired_turn_rate = forward_speed / wheel_base * tan(steering_angle)
		desired_turn_rate = clampf(desired_turn_rate, -max_turn_rate, max_turn_rate)
	turn_rate = move_toward(turn_rate, desired_turn_rate, turn_response * delta)
	car.rotation.y += turn_rate * delta

	forward = -car.global_transform.basis.z
	var lateral_damping := clampf(lateral_grip * delta, 0.0, 1.0)
	lateral_velocity = lateral_velocity.lerp(Vector3.ZERO, lateral_damping)
	drive_velocity = forward * forward_speed + lateral_velocity
	car.velocity.x = drive_velocity.x + knockback_velocity.x
	car.velocity.z = drive_velocity.z + knockback_velocity.z

	_apply_gravity(delta)
	_update_wheels(delta, forward_speed)
	car.move_and_slide()


func _apply_gravity(delta: float) -> void:
	if not car.is_on_floor():
		car.velocity.y -= gravity * delta
	else:
		car.velocity.y = 0.0

func _update_wheels(delta: float, forward_speed: float) -> void:
	var wheel_roll := forward_speed * delta / wheel_radius
	_pose_wheel(front_left_wheel, steering_angle, wheel_roll)
	_pose_wheel(front_right_wheel, steering_angle, wheel_roll)
	_pose_wheel(rear_left_wheel, 0.0, wheel_roll)
	_pose_wheel(rear_right_wheel, 0.0, wheel_roll)

func _pose_wheel(wheel: Node3D, steer: float, spin: float) -> void:
	wheel.basis = Basis(Vector3.UP, steer) * rest_bases[wheel] * Basis(Vector3.UP, spin)
