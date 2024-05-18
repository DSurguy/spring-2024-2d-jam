class_name WallPlantStalk extends RigidBody2D

func attach_to_next_part(next_part: PhysicsBody2D):
	$PinJoint2D.node_a = self.get_path()
	$PinJoint2D.node_b = next_part.get_path()

func _ready():
	apply_force(Vector2(0, -200))

func _physics_process(delta):
	apply_force(Vector2(0, -200))
	pass

func on_scythe_hit():
	print("HIT")
