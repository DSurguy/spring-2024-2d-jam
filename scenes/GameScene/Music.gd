extends Node

@export var descent_music: AudioStream = null
@export var ascent_music: AudioStream = null

@onready var music_player: AudioStreamPlayer = $MusicPlayer


func play_descent():
	music_player.stop()
	music_player.stream = descent_music
	music_player.play()
	
func play_ascent():
	music_player.stop()
	music_player.stream = ascent_music
	music_player.play()


# Called when the node enters the scene tree for the first time.
func _ready():
	play_descent()
