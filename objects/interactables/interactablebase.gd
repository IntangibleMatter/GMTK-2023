@tool
class_name InteractableBase
extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

@export var shape: Shape2D
@export var interaction : Interaction

signal player_entered
signal player_exited

var used : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_shape_2d.shape = shape


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		collision_shape_2d.shape = shape
	else:
		set_process(false)

func _input(event):
	if used: return
	if event.is_action_pressed("interact"):
		if has_overlapping_bodies():
			for body in get_overlapping_bodies():
				if body.is_in_group("Player"):
					if interaction.disable_on_interact:
						await get_tree().process_frame
						used = true


func _on_area_entered(area):
	if used:
		return
	if area.is_in_group("PlayerInteract"):
		emit_signal("player_entered")


func _on_area_exited(area):
	if used:
		return
	if area.is_in_group("PlayerInteract"):
		emit_signal("player_exited")
