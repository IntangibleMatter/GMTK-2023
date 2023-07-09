@tool
extends Area2D

@export var shape : Shape2D
@export var interaction : Interaction

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	collision_shape_2d.shape = shape


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		collision_shape_2d.shape = shape
	else:
		set_process(false)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerInteract"):
		DialogueDisplay.set_interaction(interaction)
		if interaction.disable_on_interact:
			queue_free()
