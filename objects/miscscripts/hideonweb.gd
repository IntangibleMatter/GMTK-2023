extends Control


func _ready() -> void:
	if OS.get_name() == "Web":
		hide()
