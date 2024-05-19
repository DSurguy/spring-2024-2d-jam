class_name PlantDirector extends Node2D

@export var submarine_node: Submarine

var generic_plant_data: PlantData = load("res://resources/plants/FloatingPlant.tres")
var generic_plant_scene: PackedScene = load("res://scenes/GameScene/Plants/GenericPlant.tscn")
var wall_plant_scene: PackedScene = load("res://scenes/GameScene/Plants/WallPlant/WallPlant.tscn")
var random = RandomNumberGenerator.new()

@export var floating_plant_first_spawn_time_seconds = 1
@export var floating_plant_spawn_time_seconds = 8
@export var floating_plant_seconds_since_last_spawn: float = 0
@export var wall_plant_first_spawn_time_seconds = 1
@export var wall_plant_spawn_time_seconds = 15
@export var wall_plant_seconds_since_last_spawn: float = 0
@export var spawn_y_offset_mult = 10
@export var spawn_y_offset_const = 100
@export var clump_radius = 100
var floating_plant_has_done_first_spawn: bool = false
var wall_plant_has_done_first_spawn: bool = false

func _ready():
	assert(submarine_node != null, "submarine node is required")

func _process(delta):
	if submarine_node.descending:
		_handle_descent_process(delta)

func _handle_descent_process(delta):
	# TODO: Actually make this garbage spawn off screen
	var spawn_y_position = submarine_node.position.y + spawn_y_offset_const + submarine_node.descent_speed * spawn_y_offset_mult
	$Rays.position.y = spawn_y_position
	$Rays/LeftRay.force_raycast_update()
	$Rays/RightRay.force_raycast_update()
	spawn_floating_plants(delta, spawn_y_position)
	spawn_wall_plants(delta, spawn_y_position)

func spawn_floating_plants(delta: float, spawn_y_position: float):
	
	floating_plant_seconds_since_last_spawn += delta
	if not floating_plant_has_done_first_spawn and floating_plant_seconds_since_last_spawn > floating_plant_first_spawn_time_seconds:
		floating_plant_has_done_first_spawn = true
		floating_plant_seconds_since_last_spawn = 0
	elif floating_plant_seconds_since_last_spawn > floating_plant_spawn_time_seconds:
		floating_plant_seconds_since_last_spawn = 0
	else: return
	
	# TODO: Adjust more to keep out of walls probably
	var left_clamp = $Rays/LeftRay.get_collision_point().x + clump_radius
	var right_clamp = $Rays/RightRay.get_collision_point().x - clump_radius
	
	# TODO: Weighted random, tend toward smaller clumps
	var num_clusters = random.randi_range(1, 3)
	for cluster in num_clusters:
		var clump_x_position = random.randi_range(left_clamp, right_clamp)
		var clump_position = Vector2(clump_x_position, spawn_y_position)
		var num_plants = random.randi_range(1, 3)
		for plant in num_plants:
			var plant_position = Vector2(
				random.randi_range(-clump_radius, clump_radius),
				random.randi_range(-clump_radius, clump_radius)
			)
			var new_plant: GenericPlant = generic_plant_scene.instantiate()
			new_plant.data = generic_plant_data
			new_plant.position = clump_position + plant_position
			add_child(new_plant)

func spawn_wall_plants(delta: float, spawn_y_position: float):
	wall_plant_seconds_since_last_spawn += delta
	if not wall_plant_has_done_first_spawn and wall_plant_seconds_since_last_spawn > wall_plant_first_spawn_time_seconds:
		wall_plant_has_done_first_spawn = true
		wall_plant_seconds_since_last_spawn = 0
	elif wall_plant_seconds_since_last_spawn > wall_plant_spawn_time_seconds:
		wall_plant_seconds_since_last_spawn = 0
	else: return
	
	# TODO: Iterate over plants and move down the wall to spawn more
	# TODO: Weighted random, tend toward small
	var num_plants = random.randi_range(1, 3)
	
	var new_plant: WallPlant = wall_plant_scene.instantiate()
	var left: bool = random.randi_range(0,1) == 1
	if left:
		var tile_map: TileMap = $Rays/LeftRay.get_collider()
		var collision_point = Vector2i($Rays/LeftRay.get_collision_point() + Vector2(-2, 0))
		var local_point = self.to_local(collision_point)
		var tilemap_point = tile_map.local_to_map(local_point)
		var tile = tile_map.get_cell_tile_data(0, tilemap_point)
		var can_spawn_wall_plant = tile.get_custom_data("can_spawn_wall_plant")
		if can_spawn_wall_plant:
			new_plant.position = collision_point - Vector2i(-2, 0) - Vector2i(collision_point.x % 32, collision_point.y % 32) + Vector2i(16, 16)
		else: return
	else:
		var tile_map = $Rays/RightRay.get_collider()
		var original_collision_point = $Rays/RightRay.get_collision_point()
		var collision_point = Vector2(original_collision_point + Vector2(2, 0))
		var local_point = self.to_local(collision_point)
		var tilemap_point = tile_map.local_to_map(local_point)
		var tile = tile_map.get_cell_tile_data(0, tilemap_point)
		var can_spawn_wall_plant = tile.get_custom_data("can_spawn_wall_plant")
		if can_spawn_wall_plant:
			var int_collision_point = Vector2i(collision_point)
			new_plant.position = int_collision_point - Vector2i(32, 0) - Vector2i(int_collision_point.x % 32, int_collision_point.y % 32) + Vector2i(16, 16)
			new_plant.face_left = true
		else: return
	
	add_child(new_plant)
