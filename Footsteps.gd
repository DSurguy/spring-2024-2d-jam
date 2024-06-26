extends Node

class_name Footsteps

@export var footsteps: Array[AudioStream]
@export var footstep_rate: float = 0.2
@export var volume_offset: float = 0
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
	for i in footsteps.size():
		sample_indices.append(i)
	
	timer.wait_time = footstep_rate
	player.volume_db += volume_offset

func _reset_sample_queue():		
	sample_index = 0
	
func _play_one():
	var pitch_randomization = random.randf_range(0.8, 1.5)
	player.pitch_scale = pitch_randomization
	player.stream = _pick_next_sample()
	player.play()

func _pick_next_sample() -> AudioStream:
	if sample_index == footsteps.size():
		_reset_sample_queue()
	var ret: AudioStream = footsteps[sample_indices[sample_index]]
	sample_index += 1
	return ret

func _on_timer_timeout():
	play_footstep()	
