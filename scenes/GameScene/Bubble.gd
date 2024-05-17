extends Node

class_name Bubble

@export var listener: Node2D
@export var is_playing = true
@export var max_distance_from_listener = 80.0
@export var bubble_sound: AudioStream
@export var min_time_between_bubbles = 4.0
@export var max_time_between_bubbles = 10.0

var random = RandomNumberGenerator.new()

@onready var bubble_timer: Timer = $BubbleTimer
@onready var bubble_player: AudioStreamPlayer2D = $BubblePlayer

func play():
	is_playing = true
	bubble_timer.stop()
	_schedule_bubble()

func stop():
	is_playing = false

# Called when the node enters the scene tree for the first time.
func _ready():	
	bubble_player.stream = bubble_sound

func _schedule_bubble():
	if !is_playing: return	
	bubble_timer.wait_time = random.randf_range(min_time_between_bubbles, max_time_between_bubbles)	
	bubble_timer.start()

func _on_bubble_timer_timeout():
	play_bubble()

func play_bubble():
	var randx = random.randf_range(-max_distance_from_listener, max_distance_from_listener)
	var randy = random.randf_range(-max_distance_from_listener, max_distance_from_listener)	
	var bubble_position = Vector2(listener.global_position.x + randx, listener.global_position.y + randy)	
	bubble_player.global_position = bubble_position
	var randomized_pitch = random.randf_range(0.7, 1.6)
	bubble_player.pitch_scale = randomized_pitch
	bubble_player.play()
	_schedule_bubble()
