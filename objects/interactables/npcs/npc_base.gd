class_name NpcBase
extends CharacterBody2D

@export var interaction: Interaction

@onready var interactable_base: Area2D = $InteractableBase

const SPEED = 100.0
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	interactable_base.interaction = interaction
	DialogueDisplay.dialogue_signal.connect(Callable(self, "handle_signal"))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

## *OVERRIDE ME*
func handle_signal(signame: String) -> void:
	pass
