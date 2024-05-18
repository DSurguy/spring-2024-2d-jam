class_name WallPlantStalk extends RigidBody2D

var wall_stalk_data = load("res://resources/plants/WallStalk.tres")
var generic_plant_scene: PackedScene = load("res://scenes/GameScene/Plants/GenericPlant.tscn")
@onready var plant: WallPlant = get_parent()
# @onready var plant_director: PlantDirector = get_parent().get_parent() # Should be PlantDirector
@export var next_plant_part: Node2D
var rand = RandomNumberGenerator.new()

func _ready():
	$PinJoint2D.node_a = self.get_path()
	apply_force(Vector2(0, -200))

func connect_joint_to(to: Node2D):
	next_plant_part = to
	if next_plant_part is WallPlantLeaf:
		$PinJoint2D.node_b = next_plant_part.get_rigid_body().get_path()
	elif next_plant_part is RigidBody2D:
		$PinJoint2D.node_b = next_plant_part.get_path()


func _physics_process(delta):
	apply_force(Vector2(0, -200))
	pass

func on_scythe_hit():
	harvest()
	pass

func harvest():
	var spawn_position = self.global_position
	var spawn_velocity: Vector2
	if plant.face_left:
		spawn_velocity = Vector2((rand.randf_range(-1, 0.25)), randf_range(0.5, 0.5))
	else:
		spawn_velocity = Vector2((rand.randf_range(1, -0.25)), randf_range(0.5, 0.5))
	
	var new_plant = generic_plant_scene.instantiate()
	new_plant.data = wall_stalk_data
	new_plant.position = spawn_position
	new_plant.initial_velocity = spawn_velocity
	# plant_director.add_child(new_plant)
	
	var next_node = next_plant_part
	if next_node != null:
		if next_node.get_parent() is WallPlantLeaf:
			next_node = next_node.get_parent()
		next_node.harvest()
	
	self.queue_free()
