extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -360.0
const ACCELERATION = 200.0
const FRICTION = 500.0

var health_scale_factor := 4

var movement_locked := false
var was_in_air: bool = false

var health_anim : int = 0

@onready var animation_player = $AnimationPlayer
@onready var interaction_area = $InteractionArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_state: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var health_collider: CollisionPolygon2D = $CollisionPolygon2D
@onready var healthbar: TextureProgressBar = $healthbar
@onready var hurtsound: AudioStreamPlayer2D = $hurtsound

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	Save.player_health_changed.connect(Callable(self, "health_change"))
	healthbar.value = Save.savedata.health * health_scale_factor


func _input(event):
	if DialogueDisplay.player_frozen:
		return
	
	if event.is_action_pressed("ui_page_down"):
		Save.change_player_health(-1)
	if event.is_action_pressed("ui_page_up"):
		Save.change_player_health(1)
	
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
			#squash(Vector2(0.95, 1.05), 0.1, true)
			velocity.y += 1.2 * gravity * delta
	else:
		was_in_air = false
	
	if DialogueDisplay.player_frozen:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		move_and_slide()
		return
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		#squash(Vector2(0.9, 1.1), 0.1)
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
	
	if Music.current_song == Music.SONGS.MCR:
		print("dance")
		animation_state.travel("Anim_Edwin_dance")
		return
	
	if health_anim < 0:
		animation_state.travel("Anim_Edwin_Hit")
		health_anim = 0
		return
	elif health_anim > 0:
		animation_state.travel("Anim_Edwin_Healed")
		health_anim = 0
		return
	
	if is_on_floor() and was_in_air:
		animation_state.travel("Anim_Edwin_Land")
		#squash(Vector2.ONE, 0, true)
	elif not is_on_floor():
		animation_state.travel("Anim_Edwin_Jump")
	else:
		if velocity.x != 0:
			animation_state.travel("Anim_Edwin_Walk")
		else:
			animation_state.travel("Anim_Edwin_Idle")
	if DialogueDisplay.currently_talking == "Edwin":
		animation_state.travel("Anim_Edwin_Talk")


#func squash(by: Vector2, dur: float, hold: bool = false) -> void:
#	return
#	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
#	tween.tween_property(sprite, "scale", by, 0.05)
#	if hold:
#		return
#	else:
#		await get_tree().create_timer(dur).timeout
#	tween.tween_property(sprite, "scale", Vector2.ONE, 0.05)


func update_bar() -> void:
#	healthbar.value = Save.savedata.health * 4
	var healthbar_offset : float = healthbar.position.y + healthbar.size.y
	health_collider.polygon[0].y = -healthbar.value + healthbar_offset
	health_collider.polygon[1].y = -healthbar.value + healthbar_offset


func health_change(by: int) -> void:
	health_anim = by
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(healthbar, "value", Save.savedata.health * health_scale_factor, 0.2)

