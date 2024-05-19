extends Node2D

var turtle_scene: PackedScene = load("res://scenes/GameScene/turtle.tscn")
var random = RandomNumberGenerator.new()

@export var submarine_node: Submarine

var turtle_depth_spawn_interval = 500
var turtle_spawn_depth = 700

var ascending_turtles_spawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(submarine_node != null, "submarine node is required")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var num_turtles = floor(submarine_node.position.y / turtle_depth_spawn_interval)
	
	if get_child_count() < num_turtles:
		spawn_turtle(submarine_node.position + Vector2.DOWN * turtle_spawn_depth)
	
	if submarine_node.ascending && not ascending_turtles_spawned:
		spawn_turtle(submarine_node.position + Vector2(-100, -1000))
		spawn_turtle(submarine_node.position + Vector2(100, -1000))
		ascending_turtles_spawned = true

func spawn_turtle(position:Vector2):
	print("a challenger approaches")
	var turtle:Turtle = turtle_scene.instantiate()
	turtle.position = position
	add_child(turtle)
	
