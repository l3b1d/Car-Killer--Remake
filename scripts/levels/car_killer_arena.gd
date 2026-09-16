extends Area3D

signal level_completed(player: Node3D)

var completed := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if completed or not body.is_in_group("player"):
		return
	completed = true
	set_meta("player_reached_forest", true)
	level_completed.emit(body)
