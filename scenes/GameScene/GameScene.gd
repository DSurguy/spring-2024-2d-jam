extends LoadableScene

@onready var fade_ui : CanvasLayer = $Fade_CanvasLayer
var load_path: String
signal fade_scene_in
signal fade_scene_out

func _ready():
	load_complete.emit()
	fade_scene_in.connect(Callable(fade_ui, "fade_in"))
	fade_scene_out.connect(Callable(fade_ui, "fade_out"))
	fade_scene_in.emit()

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		print("bye")
		get_tree().quit()
	
	if $Submarine.position.y < 0 and $Submarine.ascending:
		$Submarine.ascending = false
		load_path = "res://scenes/ShopScene/ShopScene.tscn"
		fade_scene_out.emit()
#		loader.load_scene("res://scenes/ShopScene/ShopScene.tscn")

func _on_submarine_death_restart_timeout():
	load_path = "res://scenes/GameOverScene/GameOverScene.tscn"
	fade_scene_out.emit()
#	loader.load_scene("res://scenes/GameOverScene/GameOverScene.tscn")
#	loader.load_scene("res://scenes/ShopScene/ShopScene.tscn")

func call_loader():
	loader.load_scene(load_path)

func _on_fade_canvas_layer_fade_out_complete():
	call_loader()
