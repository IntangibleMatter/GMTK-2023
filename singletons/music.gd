extends Node

enum SONGS {MAIN, OVERTURE, MENU, ELEVATOR, MCR}

var current_song := SONGS.MAIN

@onready var main = $main
@onready var overture = $overture
@onready var menu: AudioStreamPlayer = $menu
@onready var elevator: AudioStreamPlayer = $elevator
@onready var mcr: AudioStreamPlayer = $mcr


func play(song: SONGS) -> void:
	if song == current_song:
		return
	
	match current_song:
		SONGS.MAIN:
			main.playing = false
		SONGS.OVERTURE:
			overture.playing = false
		SONGS.MENU:
			menu.playing = false
		SONGS.ELEVATOR:
			elevator.playing = false
		SONGS.MCR:
			mcr.playing = false
	
	match song:
		SONGS.MAIN:
			main.play()
		SONGS.OVERTURE:
			overture.play()
		SONGS.MENU:
			menu.play()
		SONGS.ELEVATOR:
			elevator.play()
		SONGS.MCR:
			mcr.play()
	current_song = song
	print(current_song)
