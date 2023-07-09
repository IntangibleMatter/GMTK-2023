extends CanvasLayer

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var new_status_sound: AudioStreamPlayer = $NewStatusSound

var curr_status_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_status_count = Save.savedata.status.size()
	for line in Save.savedata.status:
		rich_text_label.append_text(line + "\n")
		print(line)
#	rich_text_label.visible_characters = strip_bbcode(rich_text_label.text).length()
	print(rich_text_label.visible_characters)


func strip_bbcode(text) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(text, "", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Save.savedata.status.size() != curr_status_count:
		var diff : int = Save.savedata.status.size() - curr_status_count 
		curr_status_count = Save.savedata.status.size()
		for i in diff:
			new_status_sound.play()
			var newtext = Save.savedata.status[curr_status_count - diff + i] + "\n"
			rich_text_label.append_text(newtext)
#			for j in strip_bbcode(newtext).length():
#				rich_text_label.visible_characters += 1
#				await get_tree().create_timer(0.025).timeout
			await get_tree().create_timer(0.1).timeout
