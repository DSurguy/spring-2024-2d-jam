extends Node2D

var station : Node2D
var ui : AscendUI

# Called when the node enters the scene tree for the first time.
func _ready():
	station = get_node("Station")
	ui = get_node("AscendUI")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate():
	print("ascend activated")
	ui.visible = true
	
func deactivate():
	print("ascend deactivated")
	ui.visible = false
		
func use():
	print("ascend used")
	if station.submarine.ascending == false:
		station.submarine.start_ascent()
	
