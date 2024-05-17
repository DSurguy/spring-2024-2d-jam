extends Control

@export var color: Color = Color.FIREBRICK

func _draw():
	draw_circle(Vector2(0,0), 20.0, color)
