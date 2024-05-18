extends Node

class_name SubEngine
var is_playing = false
@onready var player: AudioStreamPlayer = $Player
@export var fade_time: float = 0.2

var fade_in_tween: Tween
var fade_out_tween: Tween

func start():
	if is_playing: return
	is_playing = true
	if fade_out_tween and fade_out_tween.is_running():
		fade_out_tween.kill()
		fade_out_tween = null
	fade_in_tween = get_tree().create_tween()
	fade_in_tween.tween_property(player, "volume_db", 0, fade_time)
	player.play()
	
func stop():
	if !is_playing: return
	is_playing = false
	if fade_in_tween and fade_in_tween.is_running():
		fade_in_tween.kill()
		fade_in_tween = null
	fade_out_tween = get_tree().create_tween()
	fade_out_tween.tween_property(player, "volume_db", -60, fade_time * 2)
	fade_out_tween.tween_callback(player.stop)

func _ready():
	player.volume_db = -60
