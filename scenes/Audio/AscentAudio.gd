extends Node
class_name AscentAudio

@export var chain_loop: AudioStream
@export var ascent_start: AudioStream

@onready var player: AudioStreamPlayer = $Player

var intro_finished = false

func _ready():
	player.stream = ascent_start

func rest():
	player.stop()
	player.stream = ascent_start
	intro_finished = false

func play():
	player.play()
	
func stop():
	player.stop()

func _on_player_finished():
	if !intro_finished:
		intro_finished = true
		player.stream = chain_loop
		player.play()
