@tool
extends Area2D

@export var shape : Shape2D
@export var interaction : Interaction

@export var healthcheck: int = 0
enum HEALTH_CHECK_TYPE { LESS, MORE, EQUALS}
@export var check : HEALTH_CHECK_TYPE = HEALTH_CHECK_TYPE.MORE

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	collision_shape_2d.shape = shape


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		collision_shape_2d.shape = shape
	else:
		set_process(false)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerInteract"):
		print("checking")
		if not health_check():
			print("damn")
			return
		print("eep")
		DialogueDisplay.set_interaction(interaction)
		if interaction.disable_on_interact:
			queue_free()

func health_check() -> bool:
	print("wwk")
	match check:
		HEALTH_CHECK_TYPE.LESS:
			print("ooo")
			return healthcheck > Save.savedata.health
		HEALTH_CHECK_TYPE.MORE:
			print(":www")
			return healthcheck < Save.savedata.health
		HEALTH_CHECK_TYPE.EQUALS:
			print("fhhh")
			return healthcheck == Save.savedata.health
		_:
			return true
