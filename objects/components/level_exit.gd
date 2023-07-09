@tool
extends Area2D

@export var shape : Shape2D
@export_file(".tscn") var next_scene : String

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal level_complete(level: String)

func _ready():
	collision_shape_2d.shape = shape


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		collision_shape_2d.shape = shape
	else:
		set_process(false)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Save.save_game()
		emit_signal("level_complete", next_scene)
