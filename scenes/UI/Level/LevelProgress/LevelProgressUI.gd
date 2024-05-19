class_name LevelProgressUI extends Control

@export var submarine_node: Node2D = Node2D.new()
@onready var depth_label = $MarginContainer/HBoxContainer/TextureRect3/MarginContainer/DepthLabel
@onready var oxy_label = $MarginContainer/HBoxContainer/TextureRect2/MarginContainer/OxygenLabel
@onready var score_label = $MarginContainer/HBoxContainer/TextureRect/MarginContainer/MoneyLabel
@onready var tutorial : TextureRect = $ControlsTutorial

var format_string = "%.2f m"
var oxy_format_string = "%d"
var score_format_string = "%d"

@onready var wasd_arrows_image
@onready var wasd_space_image
@onready var wasd_image

func _ready():
	if submarine_node == null:
		push_error("submarine_node is null")
	
	tutorial.texture = null
	wasd_arrows_image = preload("res://resources/tutorial_image1.tres")
	wasd_space_image = preload("res://resources/tutorial_image2.tres")
	wasd_image = preload("res://resources/tutorial_image3.tres")

func _process(delta):
	if submarine_node:
		depth_label.text = format_string % submarine_node.position.y
		oxy_label.text = oxy_format_string % submarine_node.current_oxygen()
	score_label.text = score_format_string % GameState.score

func _on_player_tutorial_message_deactivate():
	tutorial.texture = null

func _on_helm_tutorial_image_activate():
	tutorial.texture = wasd_image

func _on_ascend_tutorial_image_activate():
	tutorial.texture = wasd_space_image

func _on_scythe_tutorial_image_activate():
	tutorial.texture = wasd_image

func _on_trawl_tutorial_image_activate():
	tutorial.texture = wasd_arrows_image
