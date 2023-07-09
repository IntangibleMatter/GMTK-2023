extends "res://objects/interactables/props/propbase.gd"

func _ready() -> void:
	if interactions.is_empty():
		return
	
	material = preload("res://assets/shaders/prop_shader.tres").duplicate(true)
	
	DialogueDisplay.done.connect(Callable(self, "self_destruct"))
	
	interactions.shuffle()
	var inter : Interaction = interactions[0]
#	inter.speakers[0] = Character.new()
#	inter.speakers[0].name = obj_name
#	inter.speakers[0].colour = obj_colour
#	inter.speakers[0].sound = obj_sound
	if hide_on_interact:
		inter.disable_on_interact = true
	interactablebase.interaction = inter
	DialogueDisplay.dialogue_signal.connect(Callable(self, "handle_signal"))


func handle_signal(signame: String) -> void:
	print("bb!")
	if signame == "shake":
		show()
		Save.savedata.beaten = true


func self_destruct(inter: Interaction) -> void:
	print("kjahsdk")
	if interactablebase.used and hide_on_interact and inter == interactablebase.interaction:
		var tween := get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1,1,1,0), 0.1)
		await tween.finished
		queue_free()


