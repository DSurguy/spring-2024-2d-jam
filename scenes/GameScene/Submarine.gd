extends Node2D

var descending = true
var ascending = false
var descent_speed = 30
var ascent_speed = -30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if descending:
		position.y += descent_speed * delta
		
	if ascending:
		position.y += ascent_speed * delta
	
	var camera = get_parent().get_node("Camera2D")
	camera.position.y = position.y
	
	# only use if using debug drawing
	#queue_redraw()
	
func start_ascent():
	descending = false
	ascending = true

func _draw():
	pass
	
	# debug drawing
	#draw_rect(Rect2(1.0, 1.0, 3.0, 3.0), Color.RED)
