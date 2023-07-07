@tool
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var marker_2d: Marker2D = $Marker2D

@export var shape : Shape2D
@export var spawn_offset := Vector2(0, 32)


func _ready() -> void:
	collision_shape_2d.shape = shape
	marker_2d.position = spawn_offset


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		collision_shape_2d.shape = shape
		marker_2d.position = spawn_offset
	else:
		set_process(false)
