extends NpcBase

func _ready() -> void:
	interactable_base.interaction = interaction
	DialogueDisplay.dialogue_signal.connect(Callable(self, "handle_signal"))

func handle_signal(signame: String) -> void:
	print("ah!")
	if signame == "mcds":
		sprite_2d.flip_h = false
		animation_player.play("Walk")
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position:x", 832, 1)
		await tween.step_finished
		$driveaway.play()
		Music.play(Music.SONGS.ELEVATOR)
		await get_tree().create_timer(30).timeout
		$driveaway2.play()
		await $driveaway2.finished
		sprite_2d.flip_h = true
		animation_player.play("WalkWack")
		var tween2 = get_tree().create_tween()
		tween2.tween_property(self, "position:x", 264, 1)
		await tween2.step_finished
		await get_tree().create_timer(0.5).timeout
		animation_player.play("Idle")
		$"../props/mcds-burger".show()
