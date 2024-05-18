extends Node
class_name StationAudio

@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@export var open_sound: AudioStream
@export var close_sound: AudioStream

func play_open():
	player.stream = open_sound
	player.play()

func play_close():
	player.stream = close_sound
	player.play()
