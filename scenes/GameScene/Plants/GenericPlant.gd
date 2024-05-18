extends Node2D

#@export var texture: Texture
#
#func _ready():
	#assert(texture != null, "Plant texture is null")
	#$Sprite2D.texture = texture

func collect(target: Node2D):
	print("Plant collected")

# TODO: Drift?
