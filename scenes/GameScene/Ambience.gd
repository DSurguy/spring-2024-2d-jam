extends Node

@export var is_playing = true
@export var listener: Node2D
@onready var bubble: Bubble = $Bubble

func _ready():
	bubble.listener = listener
	if is_playing:
		bubble.play()
