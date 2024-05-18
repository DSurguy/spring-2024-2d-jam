extends Node2D

@export var attach_from: Node2D
@export var attach_to: Node2D

func _process(delta):
	$Line2D.points[0] = attach_from.position
	$Line2D.points[1] = attach_to.position
