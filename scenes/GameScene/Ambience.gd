extends Node

@export var is_playing = true
@onready var bubble: Bubble = $Bubble

func _ready():
	if is_playing:
		bubble.play()
