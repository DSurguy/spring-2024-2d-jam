class_name WallPlantLeaf extends Node2D

@onready var sprite_position = $ColorRect.position
var wall_leaf_data = load("res://resources/plants/WallLeaf.tres")
var generic_plant_scene: PackedScene = load("res://scenes/GameScene/Plants/GenericPlant.tscn")
@onready var plant: WallPlant = get_parent()
@onready var plant_director: PlantDirector = get_parent().get_parent() # Should be PlantDirector
var rand = RandomNumberGenerator.new()

func get_rigid_body():
	return $RigidBody2D

func _ready():
	$RigidBody2D.apply_force(Vector2(rand.randi_range(-10, 50), -250), $RigidBody2D.position)
#
func _physics_process(delta):
	$RigidBody2D.apply_force(Vector2(rand.randi_range(-10, 50), -250), $RigidBody2D.position)
	$ColorRect.position = sprite_position + $RigidBody2D.position
	pass

func harvest():
	var spawn_position = self.global_position
	var spawn_velocity: Vector2
	if plant.face_left:
		spawn_velocity = Vector2((rand.randf_range(-1, 0.25)), randf_range(0.5, 0.5))
	else:
		spawn_velocity = Vector2((rand.randf_range(1, -0.25)), randf_range(0.5, 0.5))
	
	var new_plant = generic_plant_scene.instantiate()
	new_plant.data = wall_leaf_data
	new_plant.position = spawn_position
	new_plant.initial_velocity = spawn_velocity
	plant_director.add_child(new_plant)
	
	self.queue_free()
