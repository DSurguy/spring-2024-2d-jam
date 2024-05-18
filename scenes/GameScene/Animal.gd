class_name Animal extends Node2D

var max_speed = 250
var move_force = 300
var counter_force_factor = -10
var damping_force_factor = -1.5

var plant_direction:Vector2
var plant_distance = 99999
var plant_max_distance = 1500

var submarine:Node2D
var game_scene:Node2D
@onready var rigidbody:RigidBody2D = $RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	game_scene = get_parent().get_parent()
	submarine = game_scene.get_node("Submarine")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_find_closest_plant()
	
	#print(plant_distance)
	if plant_distance < plant_max_distance:
		#print(plant_direction)
		# move
		rigidbody.apply_central_force(plant_direction.normalized() * move_force)
	
	# enforce speed limits
	if rigidbody.linear_velocity.length() > max_speed:
		var counter_force = (rigidbody.linear_velocity.length() - max_speed) * counter_force_factor
		rigidbody.apply_central_force(rigidbody.linear_velocity.normalized() * counter_force)
	
	# eventually come to rest
	rigidbody.apply_central_force(rigidbody.linear_velocity * damping_force_factor)
	
func _find_closest_plant():
	var collection = submarine.get_node("Stations/Trawl/Collection")
	plant_distance = 99999
	for plant:GenericPlant in collection.get_children():
		var direction = collection.to_global(plant.position) - to_global(rigidbody.position)
		# print("%v -> %v" % [to_global(rigidbody.position), collection.to_global(plant.position)])
		if plant_direction.length() < plant_distance:
			plant_distance = plant_direction.length()
			plant_direction = direction
			
