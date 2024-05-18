class_name TrawlUI extends Control

@onready var left_joystick_inner: TextureRect = $Panel/VBoxContainer/GridContainer/LeftContainer/Control/InnerCircle
@onready var right_joystick_inner: TextureRect = $Panel/VBoxContainer/GridContainer/RightContainer/Control/InnerCircle

func update_vectors(left: Vector2, right: Vector2):
	left_joystick_inner.position = Vector2(8, 8) + left.normalized() * 6
	right_joystick_inner.position = Vector2(8, 8) + right.normalized() * 6
