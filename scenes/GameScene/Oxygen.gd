class_name Oxygen extends Node

signal oxygen_depleted
signal oxygen_alarm_pulse
signal oxygen_warning
signal oxygen_critical
signal oxygen_ok

@export var is_depleting = false
@export var max_oxygen = 100
@export var current_oxygen = 0
@export var decay_rate_per_second = 1

@export var warning_threshold_percent = 0.4
@export var critical_threshold_percent = 0.1
@onready var alarm: Alarm = $Alarm
var _warning_threshold_val = 0.0
var _critical_threshold_val = 0.0

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
	_calc_thresholds()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _handle_deplete():
	current_oxygen -= decay_rate_per_second
	_handle_current_oxygen_update()
		
# there's probably a way to do this via setter. Not today though
func _handle_current_oxygen_update():
	if current_oxygen <= _critical_threshold_val:
		alarm.set_critical()
	elif current_oxygen <= _warning_threshold_val:
		alarm.set_warning()
	else:
		alarm.clear_alarm()
		
	if is_empty():
		_handle_oxygen_empty()

func _handle_oxygen_empty():
	current_oxygen = 0
	stop_depleting()
	oxygen_depleted.emit()

func add_oxygen(amount: int):
	current_oxygen += amount
	_handle_current_oxygen_update()	

func _calc_thresholds():
	_warning_threshold_val = max_oxygen * warning_threshold_percent
	_critical_threshold_val = max_oxygen * critical_threshold_percent

func _on_timer_timeout():
	_handle_deplete()
	if !is_depleting: 
		timer.stop()


func _on_alarm_alarm_pulse():
	oxygen_alarm_pulse.emit()
