class_name Alarm extends Node

enum AlarmState { OK, WARNING, CRITICAL }
signal alarm_pulse

var alarm_state: AlarmState = AlarmState.OK
@export var warning_rate = 3
@export var critical_rate = 1
@export var alarm_sound: AudioStream
@onready var player: AudioStreamPlayer = $AlarmSound
@onready var timer: Timer = $Timer

func set_warning():
	if alarm_state == AlarmState.WARNING: return
	alarm_state = AlarmState.WARNING
	timer.stop()
	timer.wait_time = warning_rate
	timer.start()
	

func set_critical():
	if alarm_state == AlarmState.CRITICAL: return
	alarm_state = AlarmState.CRITICAL
	timer.stop()
	timer.wait_time = critical_rate
	timer.start()
	
	
func clear_alarm():
	if alarm_state == AlarmState.OK: return
	alarm_state = AlarmState.OK
	timer.stop()


func _on_timer_timeout():
	player.play()
	alarm_pulse.emit()
