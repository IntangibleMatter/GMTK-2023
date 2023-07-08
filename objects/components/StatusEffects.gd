extends CanvasLayer

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var new_status_sound: AudioStreamPlayer = $NewStatusSound

var curr_status_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_status_count = Save.savedata.status.size()
	for line in Save.savedata.status:
		rich_text_label.append_text(line + "\n")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Save.savedata.status.size() != curr_status_count:
		var diff : int = Save.savedata.status.size() - curr_status_count 
		curr_status_count = Save.savedata.status.size()
		for i in diff:
			rich_text_label.append_text(Save.savedata.status[curr_status_count - diff + i] + "\n")
			new_status_sound.play()
			await get_tree().create_timer(0.1).timeout
