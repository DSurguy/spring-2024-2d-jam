extends Node2D

var station : Node2D
var sub_acceleration = 8
var sub_velocity_loss = 0.96
var velocity : float
# Called when the node enters the scene tree for the first time.
func _ready():
	station = get_node("Station")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if station.active:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity += direction * sub_acceleration
		else:
			velocity *= sub_velocity_loss
			
	station.submarine.position.x += velocity * delta
			
func activate():
	print("helm activated")
