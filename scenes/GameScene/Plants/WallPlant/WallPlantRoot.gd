class_name WallPlantRoot extends StaticBody2D

func attach_to_next_part(next_part: PhysicsBody2D):
	$PinJoint2D.node_a = self.get_path()
	$PinJoint2D.node_b = next_part.get_path()
