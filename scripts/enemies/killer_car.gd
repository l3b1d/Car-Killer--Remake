extends CharacterBody3D

const COLLISION_DAMAGE := 1
const DAMAGE_INTERVAL := 1.0

@export var chase_speed := 4.0
@export var acceleration := 6.0
@export var stopping_distance := 2.5
@export var gravity := 9.8

var target: Node3D
var player_in_contact := false
var damage_timer := 0.0

@onready var damage_area: Area3D = $DamageArea

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player") as Node3D
	damage_area.body_entered.connect(_on_damage_area_body_entered)
	damage_area.body_exited.connect(_on_damage_area_body_exited)

func _physics_process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		target = get_tree().get_first_node_in_group("player") as Node3D
		return

	var direction := target.global_position - global_position
	direction.y = 0.0
	var distance := direction.length()

	if distance > stopping_distance:
		direction = direction.normalized()
		var desired_velocity := direction * chase_speed
		velocity.x = move_toward(velocity.x, desired_velocity.x, acceleration * delta)
		velocity.z = move_toward(velocity.z, desired_velocity.z, acceleration * delta)
		rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 5.0)
	else:
		velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0.0, acceleration * delta)

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	_process_contact_damage(delta)
	move_and_slide()

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