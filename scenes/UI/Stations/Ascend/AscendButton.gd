extends Control

@export var color: Color = Color.FIREBRICK

func _draw():
	draw_circle(Vector2(0,0), 12.0, color)
