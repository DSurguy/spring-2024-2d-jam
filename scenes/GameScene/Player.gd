extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var using_station : bool = false
var station_touching : Node2D = null

@onready var animation_tree : AnimationTree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_animation_properties()
	pass

func update_animation_properties():
	pass

func _physics_process(delta):
	if using_station:
		if Input.is_action_just_pressed("interact"):
			station_touching.deactivate_station()
			using_station = false
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
		
		if Input.is_action_just_pressed("interact") and station_touching:
			station_touching.activate_station()
			using_station = true

func _on_station_interaction_area_entered(area):
	print("station entered") # Replace with function body.
	station_touching = area.get_parent()


func _on_station_interaction_area_exited(area):
	print("station exited") # Replace with function body.
	station_touching = null
