extends GameScene

@onready var player: CharacterBody2D = $player
@onready var checkpoints: Array[Node] = $checkpoints.get_children()
@onready var camera_2d: Camera2D = $player/Camera2D

var player_flip_h : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Save.savedata.save_exists = true
	RenderingServer.set_default_clear_color(Color.AQUA)
	Music.play(Music.SONGS.MAIN)
	player.global_position = checkpoints[Save.savedata.checkpoint].get_spawn_point() \
	 if Save.savedata.room == get_tree().current_scene.curr_scene_path else checkpoints[0].get_spawn_point()
#
#func _process(_delta: float) -> void:
#	if player.sprite.flip_h:
#		if not player_flip_h:
#			player_flip_h = true
#			get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)\
#			.tween_property(camera_2d, "offset:x", -16, 0.2)
#	else:
#		if player_flip_h:
#			player_flip_h = false
#			get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)\
#			.tween_property(camera_2d, "offset:x", 16, 0.2)


func _on_level_exit_level_complete(level: String) -> void:
	emit_signal("done", {"scene": level})
