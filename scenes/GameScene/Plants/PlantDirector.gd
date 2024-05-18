extends Node2D

@export var submarine_node: Submarine
@export var camera: Camera2D

var generic_plant_scene: PackedScene = load("res://scenes/GameScene/Plants/GenericPlant.tscn")
var first_spawn_time_seconds = 1
var has_done_first_spawn: bool = false
var spawn_time_seconds = 8
var seconds_since_last_spawn: float = 0
var random = RandomNumberGenerator.new()
var temp_x_clamp = 1000
var spawn_y_offset_mult = 5
var spawn_y_offset_const = 100
var clump_radius = 100

func _ready():
	assert(submarine_node != null, "submarine node is required")
	assert(camera != null, "camera is required")

func _process(delta):
	if submarine_node.descending:
		_handle_descent_process(delta)

func _handle_descent_process(delta):
	seconds_since_last_spawn += delta
	if not has_done_first_spawn and seconds_since_last_spawn > first_spawn_time_seconds:
		spawn_plants()
		has_done_first_spawn = true
	if seconds_since_last_spawn > spawn_time_seconds:
		seconds_since_last_spawn = 0
		spawn_plants()

func spawn_plants():
	var num_clusters = random.randi_range(1, 3)
	for cluster in num_clusters:
		var clump_x_position = random.randi_range(0 - temp_x_clamp, 0 + temp_x_clamp)
		# TODO: Actually make this garbage spawn off screen
		var view_rect = get_viewport_rect().size * camera.zoom
		var bottom = camera.get_screen_center_position().y + view_rect.y / 2
		var clump_y_position = bottom + spawn_y_offset_const + submarine_node.descent_speed * spawn_y_offset_mult
		var clump_position = Vector2(clump_x_position, clump_y_position)
		var num_plants = random.randi_range(1, 3)
		for plant in num_plants:
			var plant_position = Vector2(
				random.randi_range(-clump_radius, clump_radius),
				random.randi_range(-clump_radius, clump_radius)
			)
			var new_plant:Node2D = generic_plant_scene.instantiate()
			new_plant.position = clump_position + plant_position
			add_child(new_plant)

func spawn_wall_plants():
	pass
