extends Node

enum SONGS {MAIN, OVERTURE}

var current_song := SONGS.MAIN

@onready var main = $main
@onready var overture = $overture


func play(song: SONGS) -> void:
	match current_song:
		SONGS.MAIN:
			main.playing = false
		SONGS.OVERTURE:
			overture.playing = false
	
	match song:
		SONGS.MAIN:
			main.play()
		SONGS.OVERTURE:
			overture.play()
	current_song = song
