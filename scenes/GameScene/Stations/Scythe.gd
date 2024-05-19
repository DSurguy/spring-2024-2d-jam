extends Node2D

var station : Node2D
var ui : HelmUI
var scythe : Node2D

@onready var cut_sound: AudioStreamPlayer2D = $CutSound

var rotation_accel = 2
var rotation_speed = 0
var rotation_speed_rebound_threshold = 10
var rotation_speed_rebound = 15
var rotation_loss = 0.995
var rotation_drop_factor = 0.02
var bounce_loss = 0.75
var max_rotation = 88

var left_blade_collision = false
var right_blade_collision = false

var previous_submarine_position_x = 0
var submarine_move_rotation_speed = 7

var minimum_cut_speed = 1
var random = RandomNumberGenerator.new()

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

@onready var animationPlayer: AnimationPlayer = $ScytheCollision/AnimationPlayer

signal tutorial_image_activate

# Called when the node enters the scene tree for the first time.
func _ready():
	station = get_node("Station")
	ui = get_node("HelmUI")
	scythe = get_node("ScytheCollision")
	animationPlayer.stop(true)

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
	
	# handle scythe collision
	if left_blade_collision:
		if rotation_speed > 0 && abs(rotation_speed) > rotation_speed_rebound_threshold:
			# not stationary, we can rebound
			rotation_speed = -1 * bounce_loss * rotation_speed
		else:
			# stationaryish, kick it in the opposite direction
			rotation_speed = -1 * rotation_speed_rebound
		
	if right_blade_collision:
		if rotation_speed < 0 && abs(rotation_speed) > rotation_speed_rebound_threshold:
			# not stationary, we can rebound
			rotation_speed = bounce_loss * rotation_speed
		else:
			# stationaryish, kick it in the opposite direction
			rotation_speed = rotation_speed_rebound
			
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
	ui.modulate = Color(1, 1, 1, 1)
	ui.visible = true
	tutorial_image_activate.emit()
	animationPlayer.play("idle")
	
func deactivate():
	ui.visible = false
	animationPlayer.stop(true)

func show_hint():
	ui.modulate = Color(1, 1, 1, 0.5)
	ui.visible = true

func hide_hint():
	ui.visible = false

func use():
	pass

func _play_cut_sound():
	var pitch_random = random.randf_range(0.8, 1.4)
	cut_sound.pitch_scale = pitch_random
	cut_sound.play()

func _on_scythe_blade_body_entered(body):
	# TODO: Make this a little more safe, relying on layer for now
	assert(body is WallPlantStalk)
	_play_cut_sound()
	body.on_scythe_hit()

func _on_rebound_area_left_body_entered(body):
	if body is TileMap:
		left_blade_collision = true

func _on_rebound_area_right_body_entered(body):
	if body is TileMap:
		right_blade_collision = true

func _on_rebound_area_left_body_exited(body):
	if body is TileMap:
		left_blade_collision = false

func _on_rebound_area_right_body_exited(body):
	if body is TileMap:
		right_blade_collision = false
