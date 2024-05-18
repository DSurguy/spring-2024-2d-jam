extends Node2D

var station : Node2D
var ui : AscendUI

var used = false

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
	if not used:
		ui.visible = false
		
func use():
	print("ascend used")
	if not used:
		used = true
		ui.set_status(ui.BUTTON_STATUS.PRESSED)
		station.submarine.start_ascent()
	
