extends Node

@export var walk_speed := 5.0
@export var run_speed := 8.0
@export var jump_velocity := 6.0
@export var gravity := 9.8

@onready var player: CharacterBody3D = get_parent()
@onready var stamina: Node = get_node("../stamina")

func physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	elif player.velocity.y < 0.0:
		player.velocity.y = 0.0

	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.velocity.y = jump_velocity

	var input_vector := Input.get_vector(
		"player_move_left",
		"player_move_right",
		"player_move_forward",
		"player_move_backward"
	)
	var direction := (player.transform.basis * Vector3(input_vector.x, 0.0, input_vector.y)).normalized()
	var is_sprinting: bool = Input.is_action_pressed("run") and direction.length() > 0.0 and stamina.can_sprint()
	var current_speed := run_speed if is_sprinting else walk_speed
	stamina.update_stamina(delta, is_sprinting)

	if direction.length() > 0.0:
		player.velocity.x = direction.x * current_speed
		player.velocity.z = direction.z * current_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, current_speed)
		player.velocity.z = move_toward(player.velocity.z, 0.0, current_speed)

	player.move_and_slide()