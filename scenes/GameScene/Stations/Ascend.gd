extends Node2D

var station : Node2D
var ui : AscendUI

var used = false

signal tutorial_image_activate

# Called when the node enters the scene tree for the first time.
func _ready():
	station = get_node("Station")
	ui = get_node("AscendUI")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate():
	print("ascend activated")
	ui.modulate = Color(1, 1, 1, 1)
	ui.visible = true
	tutorial_image_activate.emit()
	
func deactivate():
	print("ascend deactivated")
	if not used:
		ui.visible = false

func show_hint():
	ui.modulate = Color(1, 1, 1, 0.5)
	ui.visible = true

func hide_hint():
	ui.visible = false

func use():
	print("ascend used")
	if not used:
		used = true
		ui.set_status(ui.BUTTON_STATUS.PRESSED)
		station.submarine.start_ascent()
	
