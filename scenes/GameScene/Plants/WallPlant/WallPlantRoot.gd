class_name WallPlantRoot extends StaticBody2D

@export var next_plant_part: Node2D
@export var face_left: bool = false

func _ready():
	$PinJoint2D.node_a = self.get_path()
	if face_left:
		$Sprite2D.flip_h = true
		$PinJoint2D.position.x = -7
		$RightFacingCollision.visible = false
		$LeftFacingCollision.visible = true
	else:
		$Sprite2D.flip_h = false
		$RightFacingCollision.visible = true
		$LeftFacingCollision.visible = false

func connect_joint_to(to: Node2D):
	next_plant_part = to
	if next_plant_part is WallPlantLeaf:
		$PinJoint2D.node_b = next_plant_part.get_rigid_body().get_path()
	elif next_plant_part is RigidBody2D:
		$PinJoint2D.node_b = next_plant_part.get_path()
