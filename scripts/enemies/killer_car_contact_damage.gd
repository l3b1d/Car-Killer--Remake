extends Node

const COLLISION_DAMAGE := 30
const DAMAGE_INTERVAL := 1.0

@onready var damage_area: Area3D = get_parent().get_node("DamageArea")

var target: Node3D
var player_in_contact := false
var damage_timer := 0.0

func _ready() -> void:
	damage_area.body_entered.connect(_on_damage_area_body_entered)
	damage_area.body_exited.connect(_on_damage_area_body_exited)

func physics_process(delta: float) -> void:
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