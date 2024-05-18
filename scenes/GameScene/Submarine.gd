class_name Submarine extends Node2D

signal player_died
signal death_restart_timeout

@onready var music: Music = $Music
@onready var button_audio: ButtonAudio = $ButtonAudio
@onready var ascent_audio: AscentAudio = $AscentAudio
@onready var hull = $Hull
@onready var oxygen: Oxygen = $Oxygen
@onready var player: Goblin = $Player
@onready var death_timer: Timer = $DeathRestartTimer

var hull_collider : StaticBody2D

var descending = true
var ascending = false
var descent_speed = 30
var ascent_speed = -30

# Called when the node enters the scene tree for the first time.
func _ready():
	hull_collider = hull.get_child(0) #DONT MOVE THE COLLIDER NODE ORDER
	music.play_descent()
	# To set the max oxy, just oxygen.max_oxygen = x when we have the shop	
	oxygen.reset()
	oxygen.start_depleting()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if descending:
		position.y += descent_speed * delta
		
	if ascending:
		position.y += ascent_speed * delta	
	
	var camera = get_parent().get_node("Camera2D")
	camera.position.y = position.y
	
	# only use if using debug drawing
	#queue_redraw()
func current_oxygen():
	return oxygen.current_oxygen
	
func start_oxy_depletion():
	oxygen.start_depleting()
	
func stop_oxy_depletion():
	oxygen.stop_depleting()
	
func start_ascent():
	if oxygen.is_empty():
		print("Can't ascend, out of oxygen")
		return
	descending = false
	ascending = true
	button_audio.play()
	music.play_ascent()
	ascent_audio.play()
	oxygen.decay_rate_per_second *= 2
	

func _draw():
	pass
	
	# debug drawing
	#draw_rect(Rect2(1.0, 1.0, 3.0, 3.0), Color.RED)


func _on_oxygen_oxygen_depleted():
	ascending = false
	descending = false
	music.stop()
	player.kill()
	player_died.emit()
	print("DED")
	death_timer.start()


func _on_death_restart_timer_timeout():
	death_restart_timeout.emit()
