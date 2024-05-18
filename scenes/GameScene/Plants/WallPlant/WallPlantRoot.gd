class_name WallPlantRoot extends StaticBody2D

@export var next_plant_part: Node2D

func _ready():
	$PinJoint2D.node_a = self.get_path()
	if next_plant_part is WallPlantLeaf:
		$PinJoint2D.node_b = next_plant_part.get_rigid_body().get_path()
	else:
		$PinJoint2D.node_b = next_plant_part.get_path()
