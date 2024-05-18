class_name WallPlant extends Node2D

var stalk_scene: PackedScene = load("res://scenes/GameScene/Plants/WallPlant/WallPlantStalk.tscn")
var leaf_scene: PackedScene = load("res://scenes/GameScene/Plants/WallPlant/WallPlantLeaf.tscn")
var root_scene: PackedScene = load("res://scenes/GameScene/Plants/WallPlant/WallPlantRoot.tscn")

@export var segments: int = randi_range(5, 12)
@export var harvested: bool = false
@export var face_left: bool = false

func _ready():
	var new_root: WallPlantRoot = root_scene.instantiate()
	new_root.face_left = face_left
	add_child(new_root)
	var x_pos = -7 if face_left else 7
	# add stalks
	var last_stalk: WallPlantStalk
	for n in segments:
		var new_stalk: WallPlantStalk = stalk_scene.instantiate()
		if last_stalk != null:
			# connect to previous stalk
			new_stalk.position = Vector2(x_pos, -18 - n*30)
			add_child(new_stalk)
			last_stalk.connect_joint_to(new_stalk)
		else:
			# connect to root
			new_stalk.position = Vector2(x_pos, -18)
			add_child(new_stalk)
			new_root.connect_joint_to(new_stalk)
		last_stalk = new_stalk
	# add a leaf
	var new_leaf: WallPlantLeaf = leaf_scene.instantiate()
	new_leaf.position = Vector2(x_pos, -segments*30)
	new_leaf.face_left = face_left
	add_child(new_leaf)
	last_stalk.connect_joint_to(new_leaf)

func harvest():
	harvested = true
