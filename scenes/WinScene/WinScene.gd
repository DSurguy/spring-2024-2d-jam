extends LoadableScene

@onready var fade_ui = $Fade_CanvasLayer
signal fade_scene_in

# Called when the node enters the scene tree for the first time.
func _ready():
	load_complete.emit()
	fade_scene_in.connect(Callable(fade_ui, "fade_in"))
	fade_scene_in.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		print("bye")
		get_tree().quit()
