extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rich_text_label: RichTextLabel = $Panel/RichTextLabel
@onready var label: Label = $Panel/ColorRect/Label
@onready var speaker_noise: AudioStreamPlayer = $speaker_noise

var interaction : Interaction

signal speaker_changed(speaker: String)


