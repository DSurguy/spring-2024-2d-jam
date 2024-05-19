extends Node2D

var station : Node2D
var ui : TrawlUI

var bubble_emitter: PackedScene = load("res://scenes/particles/BubbleEmitter.tscn")

@onready var anchor_left:RigidBody2D = $AnchorLeft
@onready var anchor_right:RigidBody2D = $AnchorRight
@onready var net:CollisionPolygon2D = $Net/CollisionPolygon2D
@onready var collection:Node2D = $Collection
@onready var grab_sound: AudioStreamPlayer2D = $AudioPlayer

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

@onready var netSprite: Sprite2D = $Net/Sprite2D

signal tutorial_image_activate

# Called when the node enters the scene tree for the first time.
func _ready():
	station = get_node("Station")
	ui = get_node("TrawlUI")
	
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
		ui.update_vectors(left_anchor_direction, right_anchor_direction)
	
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
	
	netSprite.scale.x = (net.polygon[0] - net.polygon[3]).length() / netSprite.texture.get_width()
	netSprite.scale.y = (net.polygon[1] - net.polygon[2]).length() / netSprite.texture.get_height()
	netSprite.position = net.polygon[0]
	netSprite.position -= (net.polygon[1] - net.polygon[5]) / 2
	netSprite.rotation = (net.polygon[3] - net.polygon[0]).angle()
	
func _draw():
	draw_line(anchor_left_origin, anchor_left.position, Color.TAN, 3.0)
	#draw_line(anchor_left.position, net.polygon[1], Color.TAN, 3.0)
	#draw_line(anchor_left.position, net.polygon[5], Color.TAN, 3.0)
	
	draw_line(anchor_right_origin, anchor_right.position, Color.TAN, 3.0)
	#draw_line(anchor_right.position, net.polygon[2], Color.TAN, 3.0)
	#draw_line(anchor_right.position, net.polygon[4], Color.TAN, 3.0)

func activate():
	ui.modulate = Color(1, 1, 1, 1)
	ui.visible = true
	tutorial_image_activate.emit()

func show_hint():
	ui.modulate = Color(1, 1, 1, 0.5)
	ui.visible = true

func hide_hint():
	ui.visible = false

func deactivate():
	anchor_left.constant_force = Vector2.ZERO
	anchor_right.constant_force = Vector2.ZERO
	ui.update_vectors(Vector2(0,0), Vector2(0,0))
	ui.visible = false

func use():
	pass

func _on_net_area_entered(area:Area2D):
	var plant:GenericPlant = area.get_parent()
	grab_sound.position = area.global_position
	grab_sound.play()
	if plant.get_parent().name == "Collection":
		return
		
	print("PLANT GET")
	
	area.set_collision_layer_value(plant_collection_layer, false)
	area.set_collision_mask_value(plant_collection_layer, false)
	area.set_collision_layer_value(plant_consumption_layer, true)
	area.set_collision_mask_value(plant_consumption_layer, true)
	# TODO: Fix with deferred call
	plant.reparent(collection)
	plant.collect(collection)

func has_plants() -> bool:
	if $Collection.get_child_count() > 0:
		return true
	return false

func consume_plant_for_oxygen() -> int:
	if has_plants():
		var plant: GenericPlant = $Collection.get_child(0)
		var value = plant.data.value
		var emitter = bubble_emitter.instantiate()
		emitter.position = plant.global_position
		get_tree().get_root().add_child(emitter)
		plant.queue_free()
		return value
	return 0
