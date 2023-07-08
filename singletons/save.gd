extends Node

signal player_health_changed(by: int)
 
var savepath := "user://grimaceshake.sav"

var default_savedata : Dictionary = {
	"save_exists": false,
	"room": "res://scenes/levels/rooms/room1.tscn",
	"checkpoint": 0,
	"beaten": false,
	"health": 16,
	"status": [],
	"inventory": [],
	"mus_v": 1,
	"sfx_v": 1,
	"fullscreen": false
}

var savedata : Dictionary

func _ready() -> void:
	savedata = default_savedata
	load_game()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if savedata.fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	AudioServer.set_bus_volume_db(1, linear_to_db(savedata.sfx_v))
	AudioServer.set_bus_volume_db(2, linear_to_db(savedata.mus_v))


func change_player_health(change: int) -> void:
	if change < -1000:
		match change:
			-69420:
				savedata.health = 1
	else:
		savedata.health += change
		savedata.health = clamp(savedata.health, 0, 16)
	emit_signal("player_health_changed", change)


func add_to_inventory(item: String) -> void:
	savedata.inventory.append(item)


func new_game() -> void:
	savedata = default_savedata
	save_game()


func update_room(room: String) -> void:
	savedata.save_exists = true
	savedata.room = room
	save_game()

func load_game() -> void:
	var config = ConfigFile.new()
	
	var err = config.load(savepath)
	
	if err != OK:
		save_game()
		return
	
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			savedata[key] = config.get_value(section, key)


func save_game() -> void:
	var config = ConfigFile.new()
	
	for value in savedata:
		config.set_value("heyo_save_data_editor", value, savedata[value])
	
	config.save(savepath)
