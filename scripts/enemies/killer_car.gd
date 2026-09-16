extends CharacterBody3D

@onready var hit_reaction_component: Node = $hit_reaction

func _physics_process(delta: float) -> void:
	$movement.physics_process(delta)
	$contact_damage.physics_process(delta)

func apply_shot_slow() -> void:
	hit_reaction_component.apply_slow()

func apply_shot_impact(impact_direction: Vector3) -> void:
	hit_reaction_component.apply_impact(impact_direction)
