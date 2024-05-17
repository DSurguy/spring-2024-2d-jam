class_name AscendUI extends Control

@onready var button_node: Control = $Panel/VBoxContainer/HBoxContainer/Node2D
@onready var home_icon: TextureRect = $Panel/VBoxContainer/HBoxContainer/Node2D/TextureRect

@export var status: BUTTON_STATUS = BUTTON_STATUS.NOT_PRESSED
enum BUTTON_STATUS { NOT_PRESSED, PRESSED }
signal status_changed

func _ready():
	_on_status_changed()

func set_status(next_status: BUTTON_STATUS):
	status = next_status
	emit_signal("status_changed")

func _on_status_changed():
	if status == BUTTON_STATUS.NOT_PRESSED:
		button_node.color = Color.FIREBRICK
		home_icon.modulate = Color.WHITE
	else:
		button_node.color = Color.DARK_RED
		home_icon.modulate = Color.WEB_GRAY
	button_node.queue_redraw()
