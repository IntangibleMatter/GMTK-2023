class_name Interaction
extends Resource


@export var disable_on_interact : bool = false
@export var speakers: Array[Character] = [load("res://assets/interactions/characters/object.tres")]
@export var speaker_order : PackedInt32Array
@export var dialogue : PackedStringArray
@export var changes_health : bool = false
@export var health_change : int
@export var status_effect : String
@export var inventory: String
@export var required_inventory: PackedStringArray
