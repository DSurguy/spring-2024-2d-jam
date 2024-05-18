extends Node2D

var station : Node2D
#var ui : AscendUI

@onready var anchor_left:RigidBody2D = $AnchorLeft
@onready var anchor_right:RigidBody2D = $AnchorRight
@onready var net:CollisionPolygon2D = $Net/CollisionPolygon2D

var anchor_force = 1000
var anchor_max_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	station = get_node("Station")
	#ui = get_node("AscendUI")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if station.active:
		var left_anchor_direction : Vector2 = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
		var right_anchor_direction : Vector2 = Vector2(Input.get_axis("aim_left", "aim_right"), Input.get_axis("aim_up", "aim_down"))
		
		anchor_left.apply_central_force(left_anchor_direction * anchor_force)
		anchor_right.apply_central_force(right_anchor_direction * anchor_force)
		
	if anchor_left.linear_velocity.length() > anchor_max_speed:
		anchor_left.linear_velocity = anchor_left.linear_velocity.normalized() * anchor_max_speed 
	if anchor_right.linear_velocity.length() > anchor_max_speed:
		anchor_right.linear_velocity = anchor_right.linear_velocity.normalized() * anchor_max_speed
		
	_update_net()
		
# we make a hexagonal polygon between the two anchor points
func _update_net():
	net.polygon[0] = anchor_left.position
	net.polygon[3] = anchor_right.position
	
	var net_line:Vector2 = net.polygon[3] - net.polygon[0]
	var net_line_perp:Vector2 = net_line.rotated(deg_to_rad(90))
	var net_line_third:Vector2 = net_line / 3
	var net_line_perp_normal:Vector2 = net_line_perp.normalized()
	
	net.polygon[1] = anchor_left.position + net_line_third + (net_line_perp_normal * net_line_third.length())
	net.polygon[2] = anchor_right.position - net_line_third + (net_line_perp_normal * net_line_third.length())
	net.polygon[4] = anchor_right.position - net_line_third - (net_line_perp_normal * net_line_third.length())
	net.polygon[5] = anchor_left.position + net_line_third - (net_line_perp_normal * net_line_third.length())

func activate():
	pass
	#ui.visible = true

func deactivate():
	pass
	#ui.visible = false

func use():
	pass
	

func _on_net_area_entered(area):
	print("PLANT GET")
