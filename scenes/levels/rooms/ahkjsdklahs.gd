extends AudioStreamPlayer2D

func _ready():
	DialogueDisplay.dialogue_signal.connect(Callable(self, "handle_signal"))


func handle_signal(signame: String) -> void:
	if signame == "crash":
		play()
