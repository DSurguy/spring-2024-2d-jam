class_name WallPlantLeaf extends Node2D

var rand = RandomNumberGenerator.new()
@onready var sprite_position = $ColorRect.position

func get_rigid_body():
	return $RigidBody2D

func _ready():
	$RigidBody2D.apply_force(Vector2(rand.randi_range(-10, 50), -250), $RigidBody2D.position)
#
func _physics_process(delta):
	$RigidBody2D.apply_force(Vector2(rand.randi_range(-10, 50), -250), $RigidBody2D.position)
	$ColorRect.position = sprite_position + $RigidBody2D.position
	pass
