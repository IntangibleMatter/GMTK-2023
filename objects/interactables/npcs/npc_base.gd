class_name NpcBase
extends CharacterBody2D

@export var nam : String
@export var interaction: Interaction

@onready var interactable_base: Area2D = $InteractableBase
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 100.0
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var talking : bool = false

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


func _on_interactablebase_current_interactable(me) -> void:
	var tween := get_tree().create_tween()
	if me:
		tween.tween_property(sprite_2d, "material:shader_parameter/flashstate", 1, 0.1)
	else:
		tween.tween_property(sprite_2d, "material:shader_parameter/flashstate", 0, 0.1)

func anim_shit() -> void:
	if DialogueDisplay.currently_talking == nam:
		animation_player.play("Talk")
		talking = true
	else:
		if talking:
			talking = false
			animation_player.play("Idle")
