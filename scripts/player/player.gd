extends CharacterBody3D

const MAX_HEALTH := 100
const MAX_STAMINA := 100.0

signal stats_changed(health: int, max_health: int, stamina: float, max_stamina: float)

@onready var health_component: Node = $Health
@onready var stamina_component: Node = $Stamina
@onready var movement_component: Node = $Movement

var health: int:
	get:
		return health_component.health

var stamina: float:
	get:
		return stamina_component.stamina

func _ready() -> void:
	_setup_default_input()
	position.y = 1.2
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	health_component.changed.connect(_on_health_changed)
	stamina_component.changed.connect(_on_stamina_changed)
	_emit_stats()

func _physics_process(delta: float) -> void:
	movement_component.physics_process(delta)

func take_damage(amount: int) -> void:
	health_component.take_damage(amount)

func _on_health_changed(_health: int, _max_health: int) -> void:
	_emit_stats()

func _on_stamina_changed(_stamina: float, _max_stamina: float) -> void:
	_emit_stats()

func _emit_stats() -> void:
	stats_changed.emit(health, health_component.max_health, stamina, stamina_component.max_stamina)

func _setup_default_input() -> void:
	var actions := {
		"player_move_forward": [KEY_W, KEY_UP],
		"player_move_backward": [KEY_S, KEY_DOWN],
		"player_move_left": [KEY_A, KEY_LEFT],
		"player_move_right": [KEY_D, KEY_RIGHT],
		"run": [KEY_SHIFT],
		"shoot": [MOUSE_BUTTON_LEFT],
		"reload": [KEY_R]
	}

	for action_name in actions:
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
		for input_code in actions[action_name]:
			var event: InputEvent
			if action_name == "shoot":
				event = InputEventMouseButton.new()
				event.button_index = input_code
			else:
				event = InputEventKey.new()
				event.physical_keycode = input_code
				event.keycode = input_code
			if not InputMap.action_has_event(action_name, event):
				InputMap.action_add_event(action_name, event)
