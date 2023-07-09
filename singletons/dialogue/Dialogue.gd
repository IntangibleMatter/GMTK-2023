extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rich_text_label: RichTextLabel = $Panel/RichTextLabel
@onready var label: Label = $Panel/ColorRect/Label
@onready var speaker_noise: AudioStreamPlayer = $speaker_noise

var interaction : Interaction
var currently_interacting : bool = false
var speaking := false

var index := 0
var last_speaker_index := -1

var jump_to_end = false
var waiting : bool = false
var wait_time : float = 0

signal speaker_changed(speaker: String)
signal interaction_finished

signal dialogue_signal(name: String)

signal setup_done
signal line_done
signal next_line

func cleanup() -> void:
	index = 0
	currently_interacting = false
	last_speaker_index = -1



func _input(event: InputEvent) -> void:
	if not currently_interacting:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("jump"):
		if speaking:
			jump_to_end = true
			return
		emit_signal("next_line")

func play_interaction() -> void:
	cleanup()
	
	animation_player.play("show_box")
	
	await animation_player.animation_finished
	currently_interacting = true
	while not index > interaction.dialogue.size() -1:
		if interaction.dialogue[index].contains("{{signal}}"):
			emit_signal("dialogue_signal", interaction.dialogue[index].replace("{{signal}}", ""))
			index += 1
			if index > interaction.dialogue.size() - 1:
				break
		setup_for_speaker()
		print("ASDASD")
		speaking = true
#		await setup_done
		display_dialogue()
		print("ADBGKJBKJJBK")
		if waiting:
			await get_tree().create_timer(wait_time).timeout
			waiting = false
#			emit_signal("next_line")
			print("hhhhh")
		else:
			await next_line
			print("kjhk")
		print("oop")
		index += 1
		
	cleanup()
	animation_player.play("hide_box")
	emit_signal("interaction_finished")
	rich_text_label.text = ""
	await animation_player.animation_finished
	if label.text != "":
		$Panel/ColorRect.size.x = 0
		label.text = ""


func display_dialogue() -> void:
	speaking = true
	rich_text_label.visible_characters = 0
	if interaction.dialogue[index].contains("{{wait}}"):
		print('askjd')
		waiting = true
		wait_time = float(interaction.dialogue[index].replace("{{wait}}", ""))
		speaking = false
		return
	rich_text_label.text = interaction.dialogue[index].replace("\\n", "\n")
	speaker_noise.play()
	for i in strip_bbcode(rich_text_label.text).length():
		print(strip_bbcode(rich_text_label.text[i]))
		rich_text_label.visible_characters += 1
		await get_tree().create_timer(0.03).timeout
		if jump_to_end:
			rich_text_label.visible_characters = strip_bbcode(rich_text_label.text).length()
			jump_to_end = false
			break
	speaking = false
	


func setup_for_speaker() -> void:
	if interaction.speaker_order[index] == last_speaker_index:
		await get_tree().process_frame
		emit_signal("setup_done")
		return
	else:
		emit_signal("speaker_changed", interaction.speakers[interaction.speaker_order[index]].name)
	last_speaker_index = interaction.speaker_order[index]
	
	speaker_noise.stream = interaction.speakers[interaction.speaker_order[index]].sound
	
	if not label.text == "":
		animation_player.play("hide_name")
		await animation_player.animation_finished
	label.text = interaction.speakers[interaction.speaker_order[index]].name
	if interaction.speakers[interaction.speaker_order[index]].name == "" or interaction.speakers[interaction.speaker_order[index]] == null:
		emit_signal("setup_done")
		return
	animation_player.play("show_name")
	await get_tree().process_frame
	emit_signal("setup_done")


func strip_bbcode(text) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(text, "", true)
