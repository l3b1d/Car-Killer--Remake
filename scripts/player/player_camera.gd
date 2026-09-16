extends Node

@export var mouse_sensitivity := 0.0025

@onready var player: CharacterBody3D = get_parent()
@onready var camera_pivot: Node3D = get_node("../camera_pivot")
@onready var camera: Camera3D = get_node("../camera_pivot/camera_3d")

func _ready() -> void:
	camera.current = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		player.rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-80), deg_to_rad(80))

