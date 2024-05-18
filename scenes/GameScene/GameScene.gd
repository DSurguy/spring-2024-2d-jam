extends LoadableScene

func _ready():
	load_complete.emit()

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		print("bye")
		get_tree().quit()
	
	if $Submarine.position.y < 0 and $Submarine.ascending:
		$Submarine.ascending = false
		loader.load_scene("res://scenes/ShopScene/ShopScene.tscn")
