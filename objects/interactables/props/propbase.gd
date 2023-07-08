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
	inter.characters[0] = Character.new()
	inter.characters[0].name = obj_name
	inter.characters[0].colour = obj_colour
	inter.characters[0].sound = obj_sound
