extends LoadableScene

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		print("bye")
		get_tree().quit()
