extends Node2D

var station : Node2D
var ui : HelmUI

var sub_acceleration = 8
var sub_velocity_loss = 0.96
var velocity : float
@onready var engine_audio: SubEngine = $Engine

# Called when the node enters the scene tree for the first time.
func _ready():
	station = get_node("Station")
	ui = get_node("HelmUI")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if station.active:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity += direction * sub_acceleration
			engine_audio.start()
			if direction > 0:
				ui.set_status(ui.HELM_STATUS.RIGHT)
			else:
				ui.set_status(ui.HELM_STATUS.LEFT)
		else:
			engine_audio.stop()
			ui.set_status(ui.HELM_STATUS.NONE)
			
	station.submarine.position.x += velocity * delta
	velocity *= sub_velocity_loss
			
func activate():
	print("helm activated")
	ui.visible = true
	
func deactivate():
	print("helm deactivated")
	ui.visible = false
	
func use():
	print("helm used")
