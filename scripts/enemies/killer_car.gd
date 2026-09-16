extends CharacterBody3D

const COLLISION_DAMAGE := 30
const DAMAGE_INTERVAL := 1.0

@export var chase_speed := 7.0
@export var acceleration := 6.0
@export var stopping_distance := 2.5
@export var gravity := 9.8
@export var shot_slow_multiplier := 0.45
@export var shot_slow_duration := 2.5
@export var shot_knockback_force := 4.0

var target: Node3D
var player_in_contact := false
var damage_timer := 0.0
var slow_timer := 0.0
var shot_knockback_velocity := Vector3.ZERO

@onready var damage_area: Area3D = $DamageArea

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player") as Node3D
	damage_area.body_entered.connect(_on_damage_area_body_entered)
	damage_area.body_exited.connect(_on_damage_area_body_exited)

func _physics_process(delta: float) -> void:
	slow_timer = maxf(slow_timer - delta, 0.0)
	shot_knockback_velocity = shot_knockback_velocity.move_toward(Vector3.ZERO, acceleration * delta)

	if target == null or not is_instance_valid(target):
		target = get_tree().get_first_node_in_group("player") as Node3D
		return

	var direction := target.global_position - global_position
	direction.y = 0.0
	var distance := direction.length()

	if distance > stopping_distance:
		direction = direction.normalized()
		var current_chase_speed := chase_speed * shot_slow_multiplier if slow_timer > 0.0 else chase_speed
		var desired_velocity := direction * current_chase_speed
		velocity.x = desired_velocity.x + shot_knockback_velocity.x
		velocity.z = desired_velocity.z + shot_knockback_velocity.z
		rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 5.0)
	else:
		velocity.x = shot_knockback_velocity.x
		velocity.z = shot_knockback_velocity.z

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	_process_contact_damage(delta)
	move_and_slide()

func apply_shot_slow() -> void:
	if slow_timer <= 0.0:
		slow_timer = shot_slow_duration

func apply_shot_impact(impact_direction: Vector3) -> void:
	var horizontal_direction := Vector3(impact_direction.x, 0.0, impact_direction.z)
	if horizontal_direction.length_squared() == 0.0:
		return

	horizontal_direction = horizontal_direction.normalized()
	shot_knockback_velocity = horizontal_direction * shot_knockback_force

func _process_contact_damage(delta: float) -> void:
	if not player_in_contact:
		return

	damage_timer -= delta
	if damage_timer <= 0.0 and is_instance_valid(target) and target.has_method("take_damage"):
		target.take_damage(COLLISION_DAMAGE)
		damage_timer = DAMAGE_INTERVAL

func _on_damage_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = body
		player_in_contact = true
		damage_timer = 0.0

func _on_damage_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_contact = false
		damage_timer = 0.0
