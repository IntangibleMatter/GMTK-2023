extends CanvasLayer

signal dialogue_signal(name: String)

@onready var dialogue: Control = $Dialogue

var currently_talking : String

var current_interaction : Interaction

var player_frozen = false

func set_interaction(interaction: Interaction) -> void:
	current_interaction = interaction
	check_for_required_inventory()
	play_interaction()


func check_for_required_inventory() -> void:
	if current_interaction.required_inventory.is_empty():
		return
	
	for item in current_interaction.required_inventory:
		if not item in Save.savedata.inventory:
			current_interaction = load("res://assets/interactions/missing_item.tres")
			current_interaction.dialogue[0].format(item)
			


func play_interaction() -> void:
	player_frozen = true
	dialogue.interaction = current_interaction
	dialogue.play_interaction()
	await dialogue.interaction_finished
	if current_interaction.changes_health:
		var status_mod : String = "[color=red]" if current_interaction.health_change <= 0 else "[color = green]"
		Save.savedata.status.append(status_mod + current_interaction.status_effect)
		Save.change_player_health(current_interaction.health_change)
	player_frozen = false
	current_interaction = null


func _on_dialogue_speaker_changed(speaker) -> void:
	currently_talking = speaker
