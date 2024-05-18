extends Node2D

var station : Node2D
var ui : HelmUI
var scythe : Node2D

var rotation_accel = 2
var rotation_speed = 0
var rotation_loss = 0.995
var rotation_drop_factor = 0.02
var bounce_loss = 0.75
var max_rotation = 88

var previous_submarine_position_x = 0
var submarine_move_rotation_speed = 7

var minimum_cut_speed = 1

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	station = get_node("Station")
	ui = get_node("HelmUI")
	scythe = get_node("ScytheCollision")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if station.active:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			rotation_speed += -1 * direction * rotation_accel
			if direction > 0:
				ui.set_status(ui.HELM_STATUS.RIGHT)
			else:
				ui.set_status(ui.HELM_STATUS.LEFT)
		else:
			ui.set_status(ui.HELM_STATUS.NONE)
			
	var submarine_velocity_x = station.submarine.position.x - previous_submarine_position_x
	var additional_sub_rotation = 0
	if submarine_velocity_x > 0:
		additional_sub_rotation = submarine_move_rotation_speed
	elif submarine_velocity_x < 0:
		additional_sub_rotation = -1 * submarine_move_rotation_speed
	previous_submarine_position_x = station.submarine.position.x
			
	var normalized_rotation_speed = (rotation_speed + additional_sub_rotation) * delta
			
	scythe.rotation_degrees += normalized_rotation_speed
	
	if abs(scythe.rotation_degrees) > max_rotation:
		scythe.rotation_degrees = clampf(scythe.rotation_degrees, -1 * max_rotation, max_rotation)
		rotation_speed = -1 * bounce_loss * rotation_speed
		audio.play()
	else:
		rotation_speed += -1 * scythe.rotation_degrees * rotation_drop_factor
		rotation_speed *= rotation_loss
			
func activate():
	ui.visible = true
	
func deactivate():
	ui.visible = false
	
func use():
	pass
