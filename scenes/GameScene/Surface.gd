extends Node2D

@onready var wave: Line2D = $Line2D
var initial_position_x: float

func _ready():
	initial_position_x = $Line2D.position.x

func _process(delta):
	wave.position.x += delta * 32
	if wave.position.x - initial_position_x >= 64:
		wave.position.x = initial_position_x
	pass
