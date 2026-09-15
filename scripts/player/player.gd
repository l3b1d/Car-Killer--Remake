extends CharacterBody3D

const WALK_SPEED := 5.0
const RUN_SPEED := 8.0
const JUMP_VELOCITY := 6.0

# Player health and stamina tuning.
const MAX_HEALTH := 100
const MAX_STAMINA := 100.0
const SPRINT_STAMINA_DRAIN := 20.0
const STAMINA_REGEN_DELAY := 1.0
const STAMINA_REGEN_RATE := 15.0

signal stats_changed(health: int, max_health: int, stamina: float, max_stamina: float)

var health := MAX_HEALTH
var stamina := MAX_STAMINA
var stamina_regen_timer := 0.0

@export var mouse_sensitivity := 0.0025
@export var gravity := 9.8

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D

func _ready() -> void:
	_setup_default_input()
	position.y = 1.2
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = true
	stats_changed.emit(health, MAX_HEALTH, stamina, MAX_STAMINA)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if velocity.y < 0.0:
			velocity.y = 0.0

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
	input_vector.y = Input.get_action_strength("player_move_backward") - Input.get_action_strength("player_move_forward")

	if input_vector.length() > 1.0:
		input_vector = input_vector.normalized()

	var direction := (transform.basis * Vector3(input_vector.x, 0.0, input_vector.y)).normalized()
	var current_speed := WALK_SPEED
	var is_sprinting := Input.is_action_pressed("run") and direction.length() > 0.0 and stamina > 0.0
	if is_sprinting:
		current_speed = RUN_SPEED
	_update_stamina(delta, is_sprinting)

	if direction.length() > 0.0:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, current_speed)
		velocity.z = move_toward(velocity.z, 0.0, current_speed)

	move_and_slide()

func take_damage(amount: int) -> void:
	if amount <= 0 or health <= 0:
		return

	health = maxi(health - amount, 0)
	stats_changed.emit(health, MAX_HEALTH, stamina, MAX_STAMINA)

func _update_stamina(delta: float, is_sprinting: bool) -> void:
	if is_sprinting:
		stamina = maxf(stamina - SPRINT_STAMINA_DRAIN * delta, 0.0)
		stamina_regen_timer = STAMINA_REGEN_DELAY
	elif stamina_regen_timer > 0.0:
		stamina_regen_timer = maxf(stamina_regen_timer - delta, 0.0)
	else:
		stamina = minf(stamina + STAMINA_REGEN_RATE * delta, MAX_STAMINA)

	stats_changed.emit(health, MAX_HEALTH, stamina, MAX_STAMINA)

func _setup_default_input() -> void:
	var actions := {
		"player_move_forward": [KEY_W, KEY_UP],
		"player_move_backward": [KEY_S, KEY_DOWN],
		"player_move_left": [KEY_A, KEY_LEFT],
		"player_move_right": [KEY_D, KEY_RIGHT],
		"run": [KEY_SHIFT]
	}

	for action_name in actions:
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
		for keycode in actions[action_name]:
			var event := InputEventKey.new()
			event.physical_keycode = keycode
			event.keycode = keycode
			if not InputMap.action_has_event(action_name, event):
				InputMap.action_add_event(action_name, event)
