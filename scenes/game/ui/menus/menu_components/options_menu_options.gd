extends Control

signal return_to_menu

@onready var fullscreen: CheckBox = $HBoxContainer/Labels/HBoxContainer/VBoxContainer2/Fullscreen
@onready var h_slider_mus: HSlider = $HBoxContainer/Labels/HBoxContainer/VBoxContainer2/HSlider_mus
@onready var h_slider_sfx: HSlider = $HBoxContainer/Labels/HBoxContainer/VBoxContainer2/HSlider_sfx

func _ready() -> void:
	h_slider_mus.value = Save.savedata.mus_v
	h_slider_sfx.value = Save.savedata.sfx_v
	fullscreen.button_pressed = Save.savedata.fullscreen

func _on_back_button_pressed():
	emit_signal("return_to_menu")
	Save.save_game()


func set_focus_self() -> void:
	$HBoxContainer/Labels/BackButton.grab_focus()


func _on_fullscreen_toggled(button_pressed: bool) -> void:
	Save.savedata.fullscreen = button_pressed
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if Save.savedata.fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)


func _on_h_slider_mus_value_changed(value: float) -> void:
	prints("SADASD", value)
	Save.savedata.mus_v = value
	prints("GDFSD", Save.savedata)
	AudioServer.set_bus_volume_db(2, linear_to_db(Save.savedata.mus_v))


func _on_h_slider_sfx_value_changed(value: float) -> void:
	prints("SADASD", value)
	Save.savedata.sfx_v = value
	AudioServer.set_bus_volume_db(1, linear_to_db(Save.savedata.sfx_v))
