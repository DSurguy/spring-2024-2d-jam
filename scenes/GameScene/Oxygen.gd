class_name Oxygen extends Node

signal oxygen_depleted

@export var is_depleting = false
@export var max_oxygen = 100
@export var current_oxygen = 0
@export var decay_rate_per_second = 1

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func start_depleting():
	is_depleting = true
	timer.start()
	
func stop_depleting():
	is_depleting = false
	timer.stop()

func is_empty():
	return current_oxygen <= 0

func reset():
	current_oxygen = max_oxygen

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _handle_deplete():
	current_oxygen -= decay_rate_per_second
	if is_empty():
		_handle_oxygen_empty()

func _handle_oxygen_empty():
	current_oxygen = 0
	stop_depleting()
	oxygen_depleted.emit()

func add_oxygen(amount: int):
	current_oxygen += amount
	if is_empty():
		_handle_oxygen_empty()

func _on_timer_timeout():
	_handle_deplete()
	if !is_depleting: 
		timer.stop()
		
