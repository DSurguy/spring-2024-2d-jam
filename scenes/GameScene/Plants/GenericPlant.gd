class_name GenericPlant extends Node2D

@onready var animation_tree : AnimationTree = $AnimationTree
@export var data: PlantData

var velocity:Vector2

func _ready():
	assert(data != null, "PlantData is required")
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


func _on_area_2d_area_entered(area):
	
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	if body is TileMap:
		velocity = -velocity * Vector2(0.5, 0.5)
	pass # Replace with function body.
