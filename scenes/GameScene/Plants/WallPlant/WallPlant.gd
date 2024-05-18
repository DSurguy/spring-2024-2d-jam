class_name WallPlant extends Node2D

@export var segments: int = 3
@export var harvested: bool = false
@export var face_left: bool = false

func harvest():
	harvested = true
