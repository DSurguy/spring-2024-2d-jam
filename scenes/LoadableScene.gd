class_name LoadableScene extends Node2D

signal load_complete
signal load_error
@onready var loader: SceneLoader = get_parent().get_node("SceneLoader")

func _ready():
	load_complete.emit()

