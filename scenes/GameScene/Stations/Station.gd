extends Node2D

var active = false
var submarine: Node2D
@onready var audio: StationAudio = $StationAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	submarine = get_parent().get_parent().get_parent()
	if submarine.name != "Submarine":
		print("Submarine not found for station: " + name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if Input.is_action_just_pressed("use"):
			get_parent().use()
	
func activate_station():
	active = true
	get_parent().activate()
	audio.play_open()
	print("station active")
	
func deactivate_station():
	active = false
	get_parent().deactivate()
	audio.play_close()
	print("station inactive")
