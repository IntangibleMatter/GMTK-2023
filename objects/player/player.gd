extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -360.0
const ACCELERATION = 200.0
const FRICTION = 500.0

var movement_locked := false
var was_in_air: bool = false


@onready var animation_player = $AnimationPlayer
@onready var interaction_area = $InteractionArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_state: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var health_collider: CollisionPolygon2D = $CollisionPolygon2D
@onready var healthbar: TextureProgressBar = $healthbar

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	if DialogueDisplay.player_frozen:
		return
	
	if event.is_action_pressed("ui_page_down"):
		Save.savedata.health -= 1
	if event.is_action_pressed("ui_page_up"):
		Save.savedata.health += 1
	
	if event.is_action_pressed("interact"):
		print("interact")
		if interaction_area.has_overlapping_areas():
			if interaction_area.get_overlapping_areas()[0].is_in_group("Interactables"):
				var interactable : InteractableBase = interaction_area.get_overlapping_areas()[0]
				print(interactable)
				if interactable.used:
					return
				var interact : Interaction = interactable.interaction
				DialogueDisplay.set_interaction(interact)


func _physics_process(delta):
	update_bar()
	animate()
	# Add the gravity.
	if not is_on_floor():
		was_in_air = true
		if velocity.y <= 0:
			velocity.y += gravity * delta
		else:
			velocity.y += 1.2 * gravity * delta
	else:
		was_in_air = false
	
	if DialogueDisplay.player_frozen:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		move_and_slide()
		return
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if velocity.y < 0 and Input.is_action_just_released("jump"):
		velocity.y /= 2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if sign(direction) != sign(velocity.x):
			velocity.x = lerpf(0, -velocity.x, 0.5)
		velocity.x += ACCELERATION * direction * delta
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	velocity.x = clamp(velocity.x, -SPEED, SPEED)
	
	
	move_and_slide()


func animate() -> void:
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	
	if is_on_floor() and was_in_air:
		animation_state.travel("Anim_Edwin_Land")
	elif not is_on_floor():
		animation_state.travel("Anim_Edwin_Jump")
	else:
		if velocity.x != 0:
			animation_state.travel("Anim_Edwin_Walk")
		else:
			animation_state.travel("Anim_Edwin_Idle")
	if DialogueDisplay.currently_talking == "Edwin":
		animation_state.travel("Anim_Edwin_Talk")


func update_bar() -> void:
	Save.savedata.health = clamp(Save.savedata.health, 0, 16)
	healthbar.value = Save.savedata.health * 4
	var healthbar_offset : float = healthbar.position.y + healthbar.size.y
	health_collider.polygon[0].y = -healthbar.value + healthbar_offset
	health_collider.polygon[1].y = -healthbar.value + healthbar_offset
