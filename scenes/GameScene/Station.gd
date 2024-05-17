extends Node2D

var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
