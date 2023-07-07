extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var movement_locked := false

@onready var animation_player = $AnimationPlayer
@onready var interaction_area = $InteractionArea

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	if event.is_action_pressed("interact"):
		if interaction_area.has_overlapping_areas():
			if interaction_area.get_overlapping_areas()[0].is_in_group("Interactables"):
				var interactable : InteractableBase = interaction_area.get_overlapping_areas()[0]
				if interactable.used:
					return
				var interact : Interaction = interactable.interaction
				DialogueDisplay


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
