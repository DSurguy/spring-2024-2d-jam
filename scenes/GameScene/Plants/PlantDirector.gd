extends Node2D

@export var submarine_node: Submarine

var generic_plant_scene: PackedScene = load("res://scenes/GameScene/Plants/GenericPlant.tscn")
var spawn_time_seconds = 2
var seconds_since_last_spawn: float = 0
var random = RandomNumberGenerator.new()
var temp_x_clamp = 500
var spawn_y_offset_mult = 3
var spawn_y_offset_const = 10
var clump_radius = 10

func _ready():
	assert(submarine_node != null, "submarine node is required")

func _process(delta):
	if submarine_node.descending:
		_handle_descent_process(delta)

func _handle_descent_process(delta):
	seconds_since_last_spawn += delta
	if seconds_since_last_spawn > spawn_time_seconds:
		seconds_since_last_spawn = 0
		spawn_plants()

func spawn_plants():
	var num_clusters = random.randi_range(1, 3)
	for cluster in num_clusters:
		var x = random.randi_range(submarine_node.position.x - temp_x_clamp, submarine_node.position.x + temp_x_clamp)
		var clump_position = Vector2(submarine_node.position.y * spawn_y_offset_mult + spawn_y_offset_const)
		var num_plants = random.randi_range(1, 5)
		for plant in num_plants:
			var plant_position = Vector2(
				random.randi_range(-clump_radius, clump_radius),
				random.randi_range(-clump_radius, clump_radius)
			)
			var new_plant = generic_plant_scene.instantiate()
			new_plant.position = clump_position + plant_position
