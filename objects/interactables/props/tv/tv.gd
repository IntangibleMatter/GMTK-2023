extends "res://objects/interactables/props/propbase.gd"

@onready var tvscreen: Sprite2D = $tvscreen

@export var max_channel := 4

func change_channels() -> void:
	tvscreen.frame = randi_range(0, max_channel)
