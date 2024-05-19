class_name Station extends Node2D

var active = false
var submarine: Node2D
@onready var audio: StationAudio = $StationAudio

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	submarine = get_parent().get_parent().get_parent()
	if submarine.name != "Submarine":
		print("Submarine not found for station: " + name)
	animationPlayer.stop(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if Input.is_action_just_pressed("use"):
			get_parent().use()

func show_hint():
	if active == false:
		get_parent().show_hint()

func hide_hint():
	if active == false:
		get_parent().hide_hint()

func activate_station():
	active = true
	get_parent().activate()
	audio.play_open()
	animationPlayer.play("active")
	print("station active")
	
func deactivate_station():
	active = false
	get_parent().deactivate()
	audio.play_close()
	animationPlayer.stop(true)
	print("station inactive")
