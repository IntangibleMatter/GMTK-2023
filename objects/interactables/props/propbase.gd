extends Sprite2D

@export var interactions : Array[Interaction]
@export var obj_name : String = ""

@onready var interactablebase: Area2D = $interactablebase

func _ready() -> void:
	if interactions.is_empty():
		return
	
	interactions.shuffle()
	var inter : Interaction = interactions.pop_back()
	inter.characters[0] = Character.new()
	inter.characters[0].name = obj_name
