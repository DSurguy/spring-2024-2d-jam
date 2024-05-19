extends Node2D

@export var attach_from: Node2D
@export var attach_to: Node2D

func _process(delta):
	$Line2D.points[0] = attach_from.position - Vector2(0, 32)
	$Line2D.points[1] = attach_to.position
