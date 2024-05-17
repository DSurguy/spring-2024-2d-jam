class_name SceneLoader extends Node2D

# TODO: Use _process
# TODO: Allow subsequent call to interrupt and discard current load

@export var target_node: Node2D

var current_scene_node: LoadableScene
var loading_scene_node: LoadableScene
var loading_scene_path: String = ""
signal resource_load_error(scene_path: String)
signal resource_load_complete(scene: PackedScene)

func _ready():
	pass

func _handle_load_progress():
	var pct_complete = []
	var status = ResourceLoader.load_threaded_get_status(loading_scene_path, pct_complete)
	$CanvasLayer/Loader/CenterContainer/Panel/VBoxContainer/ProgressBar.value = pct_complete[0]*100
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		resource_load_complete.emit(ResourceLoader.load_threaded_get(loading_scene_path))
	elif status == ResourceLoader.THREAD_LOAD_FAILED || status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		resource_load_error.emit()

func _process(_delta):
	if loading_scene_path:
		_handle_load_progress()

func load_scene(scene_path: String):
	$CanvasLayer/Loader/CenterContainer/Panel/VBoxContainer/ProgressBar.value = 0
	$CanvasLayer/Loader/CenterContainer/Panel/VBoxContainer/Label.text = "Loading..."
	$CanvasLayer/Loader.visible = true
	ResourceLoader.load_threaded_request(scene_path)
	loading_scene_path = scene_path;

func _on_resource_load_error():
	loading_scene_path = ""
	$CanvasLayer/Loader/CenterContainer/Panel/VBoxContainer/Label.text = "ERROR"
	print("resource load error")
	pass
	
func _on_resource_load_complete(scene: PackedScene):
	loading_scene_path = ""
	$CanvasLayer/Loader/CenterContainer/Panel/VBoxContainer/Label.text = "Initializing..."
	var scene_node = scene.instantiate() as LoadableScene
	if not (scene_node is LoadableScene): _on_scene_load_error()
	loading_scene_node = scene_node
	scene_node.load_complete.connect(_on_scene_load_complete)
	scene_node.load_error.connect(_on_scene_load_error)
	target_node.add_child(scene_node)
	pass

func _on_scene_load_error():
	# TODO: show error details
	loading_scene_node = null
	$CanvasLayer/Loader/CenterContainer/Panel/VBoxContainer/Label.text = "ERROR"
	print("scene load error")
	#loading_scene_node.get_parent().remove_child(loading_scene_node)
	#loading_scene_node.load_complete.disconnect(_on_scene_load_complete)
	#loading_scene_node.load_error.disconnect(_on_scene_load_error)
	#loading_scene_node.queue_free
	#loading_scene_node = null
	pass

func _on_scene_load_complete():
	if current_scene_node:
		current_scene_node.get_parent().remove_child(current_scene_node)
		current_scene_node.queue_free()
	current_scene_node = loading_scene_node
	loading_scene_node.load_complete.disconnect(_on_scene_load_complete)
	loading_scene_node.load_error.disconnect(_on_scene_load_error)
	loading_scene_node = null
	loading_scene_path = ""
	$CanvasLayer/Loader.visible = false
	pass
