class_name GenericPlant extends Node2D

var animation_algae: PackedScene = load("res://scenes/GameScene/Plants/AlgaeAnimation.tscn")
var animation_wall_stalk: PackedScene = load("res://scenes/GameScene/Plants/WallStalkAnimation.tscn")
var animation_wall_leaf: PackedScene = load("res://scenes/GameScene/Plants/WallLeafAnimation.tscn")
var animation_bulb: PackedScene = load("res://scenes/GameScene/Plants/BulbAnimation.tscn")

var animation_tree : AnimationTree
@export var data: PlantData
@export var initial_velocity: Vector2 = Vector2((randf() - .5) * 0.5, (randf() - .5) * 0.5)

var velocity:Vector2

func _ready():
	assert(data != null, "PlantData is required")
	create_animation()
	var scaleFactor = 1 + (1.5 * (randf() - 0.25))
	scale = Vector2(scaleFactor, scaleFactor)
	velocity = initial_velocity
	rotation_degrees = randf() * 360.0

func create_animation():
	var animation_scene: Node2D
	match data.animation:
		PlantData.ANIMATION_STRATEGY.ALGAE:
			animation_scene = animation_algae.instantiate()
		PlantData.ANIMATION_STRATEGY.WALL_STALK:
			animation_scene = animation_wall_stalk.instantiate()
		PlantData.ANIMATION_STRATEGY.WALL_LEAF:
			animation_scene = animation_wall_leaf.instantiate()
		PlantData.ANIMATION_STRATEGY.BULB:
			animation_scene = animation_bulb.instantiate()
	
	animation_scene.name = "Animation"
	add_child(animation_scene)
	animation_tree = $Animation.get_node("AnimationTree")
	animation_tree.active = true
	pass

func _process(delta):
	position += velocity

func collect(target: Node2D):
	print("Plant collected")
	animation_tree["parameters/conditions/is_collected"] = true
	
	GameState.score += data.value


func _on_area_2d_area_entered(area):
	
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	if body is TileMap:
		velocity = -velocity * Vector2(0.5, 0.5)
	pass # Replace with function body.
