extends Node2D

var station : Node2D
var ui : HelmUI

@onready var engine_audio: SubEngine = $Engine
@onready var button_audio: ButtonAudio = $ButtonAudio
@onready var sub : Submarine
@onready var ui_script = get_parent().get_parent().get_parent().get_child(0).get_child(0)

signal tutorial_image_activate

# Called when the node enters the scene tree for the first time.
func _ready():
	station = get_node("Station")
	ui = get_node("HelmUI")
	sub = get_parent().get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if station.active:
		if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
			button_audio.play()
		
		var direction = Input.get_axis("move_left", "move_right")
		sub.helm_direction = Vector2(direction, 0)
		
		if direction:
			engine_audio.start()
			if direction > 0:
				ui.set_status(ui.HELM_STATUS.RIGHT)
			else:
				ui.set_status(ui.HELM_STATUS.LEFT)
		else:
			engine_audio.stop()
			ui.set_status(ui.HELM_STATUS.NONE)
	
func activate():
	print("helm activated")
	ui.modulate = Color(1, 1, 1, 1)
	ui.visible = true
	tutorial_image_activate.emit()
	
func deactivate():
	print("helm deactivated")
	sub.helm_direction = Vector2.ZERO
	engine_audio.stop()
	ui.visible = false

func show_hint():
	ui.modulate = Color(1, 1, 1, 0.5)
	ui.visible = true

func hide_hint():
	ui.visible = false

func use():
	print("helm used")
