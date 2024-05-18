extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY_MAX : float = -350.0
const JUMP_VELOCITY_MIN : float = -150.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var using_station : bool = false
var station_touching : Node2D = null
var directional_input : int = 0
var flip_sprite : bool = false
var is_grounded : bool = false
var was_grounded : bool = false
var jump_timer : Timer = Timer.new()

@onready var footsteps: Footsteps = $Footsteps
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D


func _ready():
	jump_timer.one_shot = true
	add_child(jump_timer)

func _process(delta):
	pass

func _physics_process(delta):
	if using_station:
		if Input.is_action_just_pressed("interact"):
			station_touching.deactivate_station()
			using_station = false
	else:
		check_grounded()

		if  !is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_grounded:
			velocity.y = JUMP_VELOCITY_MAX
			footsteps._play_one()
		if Input.is_action_just_released("ui_accept") && velocity.y < JUMP_VELOCITY_MIN:
			velocity.y = JUMP_VELOCITY_MIN

		# Get the input direction and handle the movement/deceleration.
		var directional_input = Input.get_axis("move_left", "move_right")
		if directional_input !=0 : 
			flip_sprite = (directional_input == -1)
		sprite.flip_h = flip_sprite
		
		if directional_input:
			velocity.x = lerp(velocity.x, directional_input * SPEED, 0.15) 
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.5)
		
		animation_player.speed_scale = 1
		if is_grounded:
			if using_station :
				animation_player.play("interact")
				footsteps.stop()
			elif directional_input != 0 && !is_on_wall():
				animation_player.speed_scale = 3
				animation_player.play("walk_right")
				footsteps.start()
			else : 
				animation_player.play("idle")
				footsteps.stop()
		else :
			animation_player.play("idle")
			footsteps.stop()
		
		if Input.is_action_just_pressed("interact") && station_touching && is_grounded:
			station_touching.activate_station()
			velocity.x = 0
			animation_player.play("interact")
			footsteps._play_one()
			footsteps.stop()
			using_station = true
		
		
		move_and_slide()
	
	was_grounded = is_on_floor()

func check_grounded():
	if (!is_on_floor() && was_grounded):
		jump_timer.start(0.03)
	elif is_on_floor() && was_grounded: jump_timer.stop()
	
	is_grounded = (!jump_timer.is_stopped() || is_on_floor())

func _on_station_interaction_area_entered(area):
	print("station entered") 
	station_touching = area.get_parent()


func _on_station_interaction_area_exited(area):
	if using_station : return
	station_touching = null
	print("station exited")
