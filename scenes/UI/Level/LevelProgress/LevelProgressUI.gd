class_name LevelProgressUI extends Control

@export var submarine_node: Node2D = Node2D.new()
@onready var depth_label = $MarginContainer/HBoxContainer/TextureRect3/MarginContainer/DepthLabel
@onready var oxy_label = $MarginContainer/HBoxContainer/TextureRect2/MarginContainer/OxygenLabel
@onready var score_label = $MarginContainer/HBoxContainer/TextureRect/MarginContainer/MoneyLabel

var format_string = "%.2f m"
var oxy_format_string = "%d"
var score_format_string = "%d"

func _ready():
	if submarine_node == null:
		push_error("submarine_node is null")

func _process(delta):
	if submarine_node:
		depth_label.text = format_string % submarine_node.position.y
		oxy_label.text = oxy_format_string % submarine_node.current_oxygen()
	score_label.text = score_format_string % GameState.score
