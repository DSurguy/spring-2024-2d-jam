extends LoadableScene
@onready var sfx: UISFX = $Uisfx
@onready var fade_ui = $Fade_CanvasLayer
var load_path: String

signal fade_scene_in
signal fade_scene_out

func _ready():
	$CanvasLayer/MainMenu/VBoxContainer/CenterContainer/VBoxContainer/LoadGameScene.grab_focus()
	load_complete.emit()
	fade_scene_in.connect(Callable(fade_ui, "fade_in"))
	fade_scene_out.connect(Callable(fade_ui, "fade_out"))
	fade_scene_in.emit()

func _on_load_test_scene_button_pressed():
	sfx.accept()
	load_path = "res://scenes/TestScene/TestScene.tscn"
	fade_scene_out.emit()
#	loader.load_scene("res://scenes/TestScene/TestScene.tscn")	

func _on_load_game_scene_button_pressed():
	sfx.accept()
	load_path = "res://scenes/GameScene/GameScene.tscn"
	fade_scene_out.emit()
#	loader.load_scene("res://scenes/GameScene/GameScene.tscn")	

func _on_load_shop_scene_button_pressed():
	sfx.accept()
	load_path = "res://scenes/ShopScene/ShopScene.tscn"
	fade_scene_out.emit()
#	loader.load_scene("res://scenes/ShopScene/ShopScene.tscn")	

func _on_load_ui_test_scene_button_pressed():
	sfx.accept()
	load_path = "res://scenes/UI/UITestScene.tscn"
	fade_scene_out.emit()
#	loader.load_scene("res://scenes/UI/UITestScene.tscn")	

func _on_fade_canvas_layer_fade_out_complete():
	call_loader()

func call_loader():
	loader.load_scene(load_path)

func _on_load_shop_scene_mouse_entered():
	sfx.mouseover()


func _on_load_game_scene_mouse_entered():
	sfx.mouseover()
