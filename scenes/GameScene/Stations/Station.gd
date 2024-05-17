extends Node2D

var active = false
var submarine: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	submarine = get_parent().get_parent().get_parent()
	if submarine.name != "Submarine":
		printerr("Submarine not found for station: " + name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func activate_station():
	active = true
	get_parent().activate()
	print("station active")
	
func deactivate_station():
	active = false
	get_parent().activate()
	print("station inactive")
