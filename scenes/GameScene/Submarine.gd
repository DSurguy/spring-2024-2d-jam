class_name Submarine extends Node2D

signal player_died
signal death_restart_timeout

@onready var music: Music = $Music
@onready var button_audio: ButtonAudio = $ButtonAudio
@onready var ascent_audio: AscentAudio = $AscentAudio
@onready var sub_bonk_audio: AudioStreamPlayer = $SubBonkAudio.get_child(0)
@onready var hull : StaticBody2D = $Hull_Collider
@onready var oxygen: Oxygen = $Oxygen
@onready var player: Goblin = $Player
@onready var death_timer: Timer = $DeathRestartTimer
@onready var ray_right: RayCast2D = $raycast_right
@onready var ray_left: RayCast2D = $raycast_left
@onready var scythe = $Stations/Scythe

var hull_collider : StaticBody2D

var descending = true
var ascending = false
var descent_speed = 30
var ascent_acceleration = -0.2

var velocity : Vector2
var sub_speedX : float = 200
var speed_upgrade_value = 50
var bonk_timer = Timer.new()
var alarm_timer = Timer.new()
var bonk_move : Vector2

@export var directionX : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	music.play_descent()
	oxygen.max_oxygen = GameState.max_oxygen
	oxygen.reset()
	oxygen.start_depleting()
	if !GameState.enable_scythe : scythe.hide()
	if GameState.ascent_upgrade : 
		ascent_acceleration *= 2
	if GameState.speed_upgrade != 0 :
		sub_speedX += (speed_upgrade_value * GameState.speed_upgrade)
	
	bonk_timer.one_shot = true
	add_child(bonk_timer)
	alarm_timer.one_shot = true
	add_child(alarm_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_low_oxygen()
	if bonk_timer.is_stopped():
		velocity.x = lerp(velocity.x, sub_speedX * directionX, 0.01)
	else : velocity.x = lerp(velocity.x, 0.0, 0.005)
	
	if descending:
		velocity.y = descent_speed
	
	if ascending:
		velocity.y += ascent_acceleration
	
	var final_move = velocity * delta
	if !hull.test_move(transform, final_move):
		position += final_move
		if ascending && velocity.y < -1500 : velocity.y = -1500
	elif bonk_timer.is_stopped():
		bonk_timer.start(0.5)
		velocity.x *= -0.5
		
		var bonk_direction = 0
		if ray_left: bonk_direction = -1
		elif ray_right: bonk_direction = 1
		bonk_move.x = bonk_direction
		bonk_move.y = 0
		oxygen.add_oxygen(-5)
		sub_bonk_audio.play()
		
	else :
		bonk_timer.start(0.5)
		position += bonk_move
	
	var camera = get_parent().get_node("Camera2D")
	camera.position.y = position.y

func current_oxygen():
	return oxygen.current_oxygen
	
func start_oxy_depletion():
	oxygen.start_depleting()
	
func stop_oxy_depletion():
	oxygen.stop_depleting()

func handle_low_oxygen():
	if !alarm_timer.is_stopped(): return
	
	if oxygen.current_oxygen < 25:
		button_audio.play()
		alarm_timer.start(0.3)
	elif oxygen.current_oxygen < 50:
		button_audio.play()
		alarm_timer.start(0.6)

func start_ascent():
	if oxygen.is_empty():
		print("Can't ascend, out of oxygen")
		return
	descending = false
	ascending = true
	button_audio.play()
	music.play_ascent()
	ascent_audio.play()

func _on_oxygen_oxygen_depleted():
	# If we have any netted plants, consume one and turn its value into oxygen
	if $Stations/Trawl.has_plants():
		var amount = $Stations/Trawl.consume_plant_for_oxygen()
		oxygen.add_oxygen(amount)
		oxygen.start_depleting()
	else:
		# Otherwise, we ded
		ascending = false
		descending = false
		music.stop()
		player.kill()
		player_died.emit()
		print("DED")
		death_timer.start()

func _on_death_restart_timer_timeout():
	death_restart_timeout.emit()
