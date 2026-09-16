extends Node

signal changed(health: int, max_health: int)

@export var max_health := 100
var health := 0

func _ready() -> void:
	health = max_health

func take_damage(amount: int) -> void:
	if amount <= 0 or health <= 0:
		return

	health = maxi(health - amount, 0)
	changed.emit(health, max_health)