extends CanvasLayer

@onready var dialogue: Control = $Dialogue

var currently_talking : String

var current_interaction : Interaction

var player_frozen = false

func set_interaction(interaction: Interaction) -> void:
	current_interaction = interaction
	play_interaction()


func play_interaction() -> void:
	player_frozen = true
	dialogue.interaction = current_interaction
	dialogue.play_interaction()
	await dialogue.interaction_finished
	player_frozen = false
	current_interaction = null


func _on_dialogue_speaker_changed(speaker) -> void:
	currently_talking = speaker
