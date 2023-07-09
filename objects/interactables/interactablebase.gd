@tool
class_name InteractableBase
extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

@export var shape: Shape2D
@export var interaction : Interaction

signal player_entered
signal player_exited

signal current_interactable(me: bool)

var used : bool = false

static var closest_distance: float = 99999
static var total_touching_player : int = 0
var i_am_closest : bool = false
var touching_player : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_shape_2d.shape = shape


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not Engine.is_editor_hint():
		calculate_closest()
	else:
		collision_shape_2d.shape = shape

func _input(event):
	if interaction == null:
		return
	if used: return
	if not interaction.required_inventory.is_empty():
			for item in interaction.required_inventory:
				if not item in Save.savedata.inventory:
					return
	if event.is_action_pressed("interact"):
		if i_am_closest:
			await get_tree().process_frame
			print("jshdfksdhfjlsd")
			print(interaction)
			if interaction.disable_on_interact:
				used = true
				print("iooooo")
#		if has_overlapping_bodies():
#			for body in get_overlapping_bodies():
#				if body.is_in_group("Player"):
#					
#						await get_tree().process_frame
#						used = true


func _on_area_entered(area):
	if used:
		return
	if area.is_in_group("PlayerInteract"):
		emit_signal("player_entered")


func _on_area_exited(area):
	if used:
		return
	if area.is_in_group("PlayerInteract"):
		emit_signal("player_exited")

func calculate_closest() -> void:
	if used: 
		emit_signal("current_interactable", false)
		
		return
	if DialogueDisplay.player_frozen: return
	var player : CharacterBody2D = get_tree().get_first_node_in_group("Player")
	if player.interaction_area.has_overlapping_areas():
#		print(self.get_path())
		if not player.interaction_area.get_overlapping_areas().is_empty():
			if player.interaction_area.get_overlapping_areas()[0] == self:
				emit_signal("current_interactable", true)
				i_am_closest = true
			else:
				if i_am_closest:
					emit_signal("current_interactable", false)
					i_am_closest = false
	else:
		if i_am_closest:
			emit_signal("current_interactable", false)
			i_am_closest = false
#	var player : Area2D = get_tree().get_nodes_in_group("PlayerInteract")[0]
#
#	var dist_to = global_position.distance_squared_to(player.global_position)
#	if total_touching_player == 1:
#		i_am_closest = true
#		dist_to = closest_distance
#		emit_signal("current_interactable", true)
#
#	if not overlaps_area(player):
#		if touching_player:
#			touching_player = false
#			total_touching_player -= 1
#		if i_am_closest:
#			i_am_closest = false
#			emit_signal("current_interactable", false)
#			closest_distance = 99999
#		return
#	else:
#		if not touching_player:
#			touching_player = true
#			total_touching_player += 1
#
#	if dist_to < closest_distance:
#		closest_distance = dist_to
#		i_am_closest = true
#		emit_signal("current_interactable", true)
#	else:
#		if i_am_closest:
#			i_am_closest = false
#			emit_signal("current_interactable", false)
#	prints(self, i_am_closest, closest_distance, total_touching_player)
