extends NpcBase


func handle_signal(signame: String) -> void:
	print("ah!")
	if signame == "crash":
		sprite_2d.flip_h = true
		animation_player.play("BeatWalkWack")
		await get_tree().create_timer(18).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position:x", 224, 8)
		await tween.step_finished
		animation_player.pause()
		
	elif signame == "shake":
		sprite_2d.flip_h = true
		animation_player.play("BeatWalk")
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position:x", -100, 8)
		await tween.step_finished
