class_name LoadableScene extends Node2D

signal load_complete
signal load_error
@onready var loader: SceneLoader = get_parent().get_node("SceneLoader")

func _ready():
	load_complete.emit()

func _on_load_test_scene_button_pressed():
	loader.load_scene("res://scenes/TestScene/TestScene.tscn")
	pass # Replace with function body.

func _on_load_game_scene_button_pressed():
	loader.load_scene("res://scenes/GameScene/GameScene.tscn")
	pass # Replace with function body.

func _on_load_shop_scene_button_pressed():
	loader.load_scene("res://scenes/ShopScene/ShopScene.tscn")
	pass # Replace with function body.
