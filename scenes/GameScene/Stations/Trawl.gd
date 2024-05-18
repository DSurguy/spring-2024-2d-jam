extends Node2D

var station : Node2D
#var ui : AscendUI

@onready var anchor_left:RigidBody2D = $AnchorLeft
@onready var anchor_right:RigidBody2D = $AnchorRight
@onready var net:CollisionPolygon2D = $Net/CollisionPolygon2D
@onready var collection:Node2D = $Collection

var anchor_gravity_scale = 0.05
var anchor_move_force = 1000
var anchor_damping_force_factor = -1.5
#var anchor_damping_force_factor = 0
var anchor_max_speed = 100
var anchor_max_distance_origin = 400
var anchor_max_distance_between = 300
var anchor_counter_force_factor = -10
var anchor_distance_force_factor = -10

var plant_collection_layer = 4
var plant_consumption_layer = 9

var plant_collection_center_drift_factor = 0.99

var anchor_left_origin:Vector2
var anchor_right_origin:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	station = get_node("Station")
	#ui = get_node("AscendUI")
	
	anchor_left.gravity_scale = anchor_gravity_scale
	anchor_right.gravity_scale = anchor_gravity_scale
	
	anchor_left_origin = anchor_left.position
	anchor_right_origin = anchor_right.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if station.active:
		var left_anchor_direction : Vector2 = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
		#print("left: %s" % left_anchor_direction)
		var right_anchor_direction : Vector2 = Vector2(Input.get_axis("aim_left", "aim_right"), Input.get_axis("aim_up", "aim_down"))
		#print("right: %s" % right_anchor_direction)
		
		anchor_left.apply_central_force(left_anchor_direction * anchor_move_force)
		anchor_right.apply_central_force(right_anchor_direction * anchor_move_force)
	
	# ensure maximum speeds
	#print("left speed: %s" % anchor_left.linear_velocity.length())
	if anchor_left.linear_velocity.length() > anchor_max_speed:
		var counter_force = (anchor_left.linear_velocity.length() - anchor_max_speed) * anchor_counter_force_factor
		anchor_left.apply_central_force(anchor_left.linear_velocity.normalized() * counter_force)
		
	if anchor_right.linear_velocity.length() > anchor_max_speed:
		var counter_force = (anchor_right.linear_velocity.length() - anchor_max_speed) * anchor_counter_force_factor
		anchor_right.apply_central_force(anchor_right.linear_velocity.normalized() * counter_force)
		
	# ensure maximum distance between anchors (net size)
	var anchor_distance_between = anchor_right.global_position - anchor_left.global_position
	if anchor_distance_between.length() > anchor_max_distance_between:
		var counter_force = anchor_distance_between.normalized() * (anchor_distance_between.length() - anchor_max_distance_between) * anchor_distance_force_factor
		anchor_left.apply_central_force(counter_force * -1)
		anchor_right.apply_central_force(counter_force)
		
	# ensure maximum distance from origin (net reach)
	var anchor_left_origin_distance = anchor_left.position - anchor_left_origin
	#print(anchor_left_origin_distance.length())
	if anchor_left_origin_distance.length() > anchor_max_distance_origin:
		var counter_force = anchor_left_origin_distance.normalized() * (anchor_left_origin_distance.length() - anchor_max_distance_origin) * anchor_distance_force_factor
		anchor_left.apply_central_force(counter_force)
		
	var anchor_right_origin_distance = anchor_right.position - anchor_right_origin
	if anchor_right_origin_distance.length() > anchor_max_distance_origin:
		var counter_force = anchor_right_origin_distance.normalized() * (anchor_right_origin_distance.length() - anchor_max_distance_origin) * anchor_distance_force_factor
		anchor_right.apply_central_force(counter_force)
		
	# eventually come to rest
	anchor_left.apply_central_force(anchor_left.linear_velocity * anchor_damping_force_factor)
	anchor_right.apply_central_force(anchor_right.linear_velocity * anchor_damping_force_factor)
	
	# update collection location
	collection.position = (anchor_left.position + anchor_right.position) / 2
	
	# move collection toward net center
	for plant in collection.get_children():
		plant.position *= plant_collection_center_drift_factor

	#_update_net()
	queue_redraw()
		
# we make a hexagonal polygon between the two anchor points
func _physics_process(delta):
	net.polygon[0] = anchor_left.position
	net.polygon[3] = anchor_right.position
	
	var net_line:Vector2 = net.polygon[3] - net.polygon[0]
	var net_line_perp:Vector2 = net_line.rotated(deg_to_rad(90))
	var net_line_third:Vector2 = net_line / 3
	var net_line_perp_normal:Vector2 = net_line_perp.normalized()
	
	net.polygon[1] = anchor_left.position + net_line_third + (net_line_perp_normal * net_line_third.length() * 0.5)
	net.polygon[2] = anchor_right.position - net_line_third + (net_line_perp_normal * net_line_third.length() * 0.5)
	net.polygon[4] = anchor_right.position - net_line_third - (net_line_perp_normal * net_line_third.length() * 0.5)
	net.polygon[5] = anchor_left.position + net_line_third - (net_line_perp_normal * net_line_third.length() * 0.5)
	
func _draw():
	draw_line(anchor_left_origin, anchor_left.position, Color.TAN, 3.0)
	draw_line(anchor_right_origin, anchor_right.position, Color.TAN, 3.0)

func activate():
	pass
	#ui.visible = true

func deactivate():
	anchor_left.constant_force = Vector2.ZERO
	anchor_right.constant_force = Vector2.ZERO
	#ui.visible = false

func use():
	pass

func _on_net_area_entered(area:Area2D):
	print("PLANT GET")
	area.set_collision_layer_value(plant_collection_layer, false)
	area.set_collision_mask_value(plant_collection_layer, false)
	area.set_collision_layer_value(plant_consumption_layer, true)
	area.set_collision_mask_value(plant_consumption_layer, true)
	var plant:Node2D = area.get_parent()
	plant.reparent(collection)
