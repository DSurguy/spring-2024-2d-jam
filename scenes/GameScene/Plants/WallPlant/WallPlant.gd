class_name WallPlant extends Node2D

@export var segments: int = 3
@export var harvested: bool = false

func _ready():
	$WallPlantRoot.attach_to_next_part($WallPlantStalk)
	$WallPlantStalk.attach_to_next_part($WallPlantStalk2)
	$WallPlantStalk2.attach_to_next_part($WallPlantStalk3)
	$WallPlantStalk3.attach_to_next_part($WallPlantLeaf.get_rigid_body())

func harvest():
	harvested = true

