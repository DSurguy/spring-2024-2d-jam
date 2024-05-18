extends Node2D

@onready var animation_tree : AnimationTree = $AnimationTree

var velocity:Vector2

func _ready():
	animation_tree.active = true
	var scaleFactor = 1 + (1.5 * (randf() - 0.25))
	scale = Vector2(scaleFactor, scaleFactor)
	velocity = Vector2((randf() - .5) * 0.5, (randf() - .5) * 0.5)
	rotation_degrees = randf() * 360.0

func _process(delta):
	position += velocity

func collect(target: Node2D):
	print("Plant collected")
	animation_tree["parameters/conditions/is_collected"] = true

# TODO: Drift?
