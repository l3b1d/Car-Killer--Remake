extends Node

const collision_damage := 30
const damage_interval := 1.0

@onready var damage_area: Area3D = get_parent().get_node("damage_area")

var player_contacts: Dictionary = {}
var damage_timer := 0.0

func _ready() -> void:
	damage_area.body_entered.connect(_on_damage_area_body_entered)
	damage_area.body_exited.connect(_on_damage_area_body_exited)

func physics_process(delta: float) -> void:
	if player_contacts.is_empty():
		return

	damage_timer -= delta
	if damage_timer <= 0.0:
		var target := player_contacts.keys()[0] as Node3D
		if not is_instance_valid(target):
			player_contacts.erase(target)
			return
		if target.has_method("take_damage"):
			target.take_damage(collision_damage)
			damage_timer = damage_interval

func _on_damage_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_contacts[body] = player_contacts.get(body, 0) + 1
		damage_timer = 0.0

func _on_damage_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if not player_contacts.has(body):
			return
		player_contacts[body] -= 1
		if player_contacts[body] <= 0:
			player_contacts.erase(body)
			damage_timer = 0.0