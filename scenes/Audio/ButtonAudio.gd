extends Node

class_name ButtonAudio

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

func play():
	player.play()
