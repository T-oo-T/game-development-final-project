extends Node

var sounds = {}

func _ready() -> void:
	for sound in get_children():
		sounds[sound.name] = sound

func play(name):	
	sounds[name].play()
