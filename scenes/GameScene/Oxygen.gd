extends Node

signal oxygen_depleted

@export var is_depleting = false
@export var max_oxygen = 100
@export var current_oxygen = 0
@export var decay_rate_per_second = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func start_depleting():
	is_depleting = true
	
func stop_depleting():
	is_depleting = false

func reset():
	current_oxygen = max_oxygen

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_depleting:
		current_oxygen -= decay_rate_per_second
	
	if current_oxygen <= 0:
		current_oxygen = 0
		oxygen_depleted.emit()
		is_depleting = false
			
func add_oxygen(amount: int):
	current_oxygen += amount
