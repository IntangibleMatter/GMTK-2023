extends Sprite2D


## WHEN USING PROPS, DO NOT UNDER ANY CIRCUMSTANCES
## PUT A CHARACTER IN THE FIRST SLOT IN THE INTERACTION'S
## CHARACTER ARRAY! IT WILL BE ERASED!!!
@export var interactions : Array[Interaction]

@export var obj_name : String = ""
@export var obj_colour : Color
@export var obj_sound : AudioStream

@onready var interactablebase: Area2D = $interactablebase

func _ready() -> void:
	if interactions.is_empty():
		return
	
	interactions.shuffle()
	var inter : Interaction = interactions.pop_back()
	inter.speakers[0] = Character.new()
#	inter.speakers[0].name = obj_name
#	inter.speakers[0].colour = obj_colour
#	inter.speakers[0].sound = obj_sound
	interactablebase.interaction = inter
#	_on_interactablebase_current_interactable(true)


func _on_interactablebase_current_interactable(me) -> void:
	var tween := get_tree().create_tween()
	if me:
		tween.tween_property(self, "material:shader_parameter/flashstate", 1, 0.1)
	else:
		tween.tween_property(self, "material:shader_parameter/flashstate", 0, 0.1)
