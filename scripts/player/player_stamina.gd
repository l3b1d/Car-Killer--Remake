extends Node

signal changed(stamina: float, max_stamina: float)

@export var max_stamina := 100.0
@export var drain_rate := 20.0
@export var regen_delay := 2.5
@export var regen_rate := 10.0

var stamina := 0.0
var regen_timer := 0.0

func _ready() -> void:
	stamina = max_stamina

func can_sprint() -> bool:
	return stamina > 0.0

func update_stamina(delta: float, is_sprinting: bool) -> void:
	if is_sprinting:
		stamina = maxf(stamina - drain_rate * delta, 0.0)
		regen_timer = regen_delay
	elif regen_timer > 0.0:
		regen_timer = maxf(regen_timer - delta, 0.0)
	else:
		stamina = minf(stamina + regen_rate * delta, max_stamina)

	changed.emit(stamina, max_stamina)