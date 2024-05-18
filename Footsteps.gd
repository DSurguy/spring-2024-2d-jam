extends Node

class_name Footsteps

@export var footsteps: Array[AudioStream]
@export var footstep_rate: float = 0.2

@onready var player: AudioStreamPlayer = $Player
@onready var timer: Timer = $Timer

var random: RandomNumberGenerator = RandomNumberGenerator.new()
var is_playing = false
var sample_indices = PackedInt32Array()
var sample_index = 0

## Plays a single footstep
func play_footstep():	
	_play_one()

## Starts playing footsteps until stop() is called
func start():
	if is_playing: return
	is_playing = true
	timer.autostart = true
	timer.start()
	
func stop():
	if !is_playing: return
	is_playing = false
	timer.autostart = false
	timer.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	# The way this works is that we have an array with 4 values, shuffle it,
	# and just go up the list. When we get to the end, reset the index, reshuffle,
	# and off we go
	sample_indices.append(0)
	sample_indices.append(1)
	sample_indices.append(2)
	sample_indices.append(3)
	timer.wait_time = footstep_rate

func _reset_sample_queue():		
	sample_index = 0
	
func _play_one():
	var pitch_randomization = random.randf_range(0.8, 1.5)
	player.pitch_scale = pitch_randomization
	player.stream = _pick_next_sample()
	player.play()

func _pick_next_sample() -> AudioStream:
	if sample_index == 4:
		_reset_sample_queue()
	var ret: AudioStream = footsteps[sample_indices[sample_index]]
	sample_index += 1
	return ret

func _on_timer_timeout():
	play_footstep()	
