extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var using_station : bool = false
var station_touching : Node2D = null

@onready var footsteps: Footsteps = $Footsteps


@onready var animation_tree : AnimationTree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if using_station:
		if Input.is_action_just_pressed("interact"):
			station_touching.deactivate_station()
			using_station = false
			animation_tree["parameters/conditions/is_interacting"] = false
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		#print(velocity.x)
		if velocity.x > 0:
			footsteps.start()
			animation_tree["parameters/conditions/is_idle"] = false
			animation_tree["parameters/conditions/is_moving_left"] = false
			animation_tree["parameters/conditions/is_moving_right"] = true
		elif velocity.x < 0:
			footsteps.start()
			animation_tree["parameters/conditions/is_idle"] = false
			animation_tree["parameters/conditions/is_moving_left"] = true
			animation_tree["parameters/conditions/is_moving_right"] = false
		else:
			footsteps.stop()
			animation_tree["parameters/conditions/is_idle"] = true
			animation_tree["parameters/conditions/is_moving_left"] = false
			animation_tree["parameters/conditions/is_moving_right"] = false
		
		if Input.is_action_just_pressed("interact") and station_touching:
			station_touching.activate_station()
			using_station = true
			animation_tree["parameters/conditions/is_interacting"] = true
			animation_tree["parameters/conditions/is_idle"] = false
			animation_tree["parameters/conditions/is_moving_left"] = false
			animation_tree["parameters/conditions/is_moving_right"] = false
			
		#print(animation_tree["parameters/conditions/is_interacting"])
		#print(animation_tree["parameters/conditions/is_idle"])
		#print(animation_tree["parameters/conditions/is_moving_left"])
		#print(animation_tree["parameters/conditions/is_moving_right"])

func _on_station_interaction_area_entered(area):
	print("station entered") # Replace with function body.
	station_touching = area.get_parent()


func _on_station_interaction_area_exited(area):
	print("station exited") # Replace with function body.
	station_touching = null
