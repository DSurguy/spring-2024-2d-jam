class_name Submarine extends RigidBody2D

signal player_died
signal death_restart_timeout

@onready var music: Music = $Music
@onready var button_audio: ButtonAudio = $ButtonAudio
@onready var ascent_audio: AscentAudio = $AscentAudio
#@onready var alarm_audio: AudioStreamPlayer2D = $AlarmAudio
@onready var sub_bonk_audio: AudioStreamPlayer = $SubBonkAudio.get_child(0)
@onready var oxygen: Oxygen = $Oxygen
@onready var player: Goblin = $Player
@onready var death_timer: Timer = $DeathRestartTimer
@onready var ray_right: RayCast2D = $raycast_right
@onready var ray_left: RayCast2D = $raycast_left
@onready var scythe = $Stations/Scythe

var bubble_emitter: PackedScene = load("res://scenes/particles/BubbleEmitter.tscn")

var descending = true
var ascending = false
var descent_force = 70
var descent_force_additional = 0
var descent_force_upgrade = 50
var ascent_force = -200
var ascent_force_multiplier = 1

var velocity : Vector2
var sub_speedX : float = 200
var speed_upgrade_value = 50
var bonk_timer = Timer.new()
var alarm_timer = Timer.new()

var bonk_damage_timer = 0
var bonk_damage_time = 0.5
var bonk_sfx_timer = 0
var bonk_sfx_time = 0.5

var bubble_timers = {}
var bubble_time = 0.5

var bonking : bool = false
var died = false

var lateral_move_force = 400
@onready var rigidbody:RigidBody2D = $Hull/RigidBody2D

@export var helm_direction : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	music.play_descent()
	oxygen.max_oxygen = GameState.max_oxygen
	oxygen.reset()
	oxygen.start_depleting()
	if !GameState.enable_scythe:		
		scythe.queue_free()
	if GameState.ascent_upgrade:
		ascent_force_multiplier = 2
	descent_force_additional = GameState.speed_upgrade * descent_force_upgrade
	
	bonk_timer.one_shot = true
	add_child(bonk_timer)
	alarm_timer.one_shot = true
	add_child(alarm_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_low_oxygen()
	
	if bonking:
		bonk_damage_timer += delta
		if bonk_damage_timer > bonk_damage_time:
			bonk_damage_timer -= bonk_damage_time
			oxygen.add_oxygen(-1)
	
		if bonk_sfx_timer > 0:
			bonk_sfx_timer -= delta
			
	for key in bubble_timers:
		if bubble_timers[key] > 0:
			bubble_timers[key] -= delta
		else:
			bubble_timers.erase(key)
	
func _physics_process(delta):
	if helm_direction.length() > 0:
		apply_central_force(helm_direction * lateral_move_force * mass)
	
	var move_force = 0
	if descending:
		move_force = descent_force + descent_force_additional
	elif ascending:
		move_force = ascent_force * ascent_force_multiplier
	
	apply_central_force(Vector2.DOWN * move_force * mass)
	
	var camera = get_parent().get_node("Camera2D")
	camera.position.y = position.y
	
func _integrate_forces(state:PhysicsDirectBodyState2D):
	var contact_count = state.get_contact_count()
	for i in range(contact_count):
		var contact_point = state.get_contact_collider_position(i)
		
		if not bubble_timers.has(contact_point):
			var emitter = bubble_emitter.instantiate()
			emitter.position = contact_point
			get_tree().get_root().add_child(emitter)
			bubble_timers[contact_point] = bubble_time

func current_oxygen():
	return oxygen.current_oxygen
	
func start_oxy_depletion():
	oxygen.start_depleting()
	
func stop_oxy_depletion():
	oxygen.stop_depleting()

func handle_low_oxygen():
	if !alarm_timer.is_stopped(): return
	
	#if oxygen.current_oxygen < 10:
		#alarm_audio.play()
		#flash_oxygen_ui.emit()
		#alarm_timer.start(0.25)
	#elif oxygen.current_oxygen < 25:
		#alarm_audio.play()
		#flash_oxygen_ui.emit()
		#alarm_timer.start(0.5)
	#elif oxygen.current_oxygen < 50:
		#alarm_audio.play()
		#flash_oxygen_ui.emit()
		#alarm_timer.start(1)

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
		if died: return
		died = true
		ascending = false
		descending = false
		music.stop()
		player.kill()
		player_died.emit()
		print("DED")
		death_timer.start()

func _on_death_restart_timer_timeout():
	death_restart_timeout.emit()

signal flash_oxygen_ui

func _on_body_entered(body):
	if body is TileMap:
		bonking = true
		if bonk_sfx_timer <= 0:
			sub_bonk_audio.play()
			bonk_sfx_timer = bonk_sfx_time
		print("BONK")


func _on_body_exited(body):
	if body is TileMap:
		bonking = false
