extends Node2D

@export var speaker : Character

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var label: Label = $Panel/Label

func _ready() -> void:
	audio_stream_player.stream = speaker.sound
	label.text = speaker.name
	label.label_settings.font_color = speaker.colour

func _process(_delta: float) -> void:
	if  not audio_stream_player.playing:
		audio_stream_player.play()
