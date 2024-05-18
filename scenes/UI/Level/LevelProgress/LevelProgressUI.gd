class_name LevelProgressUI extends Control

@export var submarine_node: Node2D = Node2D.new()
@onready var label = $MarginContainer/HBoxContainer/Label
@onready var oxy_label = $MarginContainer/HBoxContainer/OxygenLabel

var format_string = "Depth: %.2f"
var oxy_format_string = "Oxygen: %d"

func _ready():
	if submarine_node == null:
		push_error("submarine_node is null")

func _process(delta):
	if submarine_node:
		label.text = format_string % submarine_node.position.y
		
	oxy_label.text = oxy_format_string % 100
	
