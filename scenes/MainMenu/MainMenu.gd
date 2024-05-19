extends LoadableScene

func _ready():
	$CanvasLayer/MainMenu/VBoxContainer/CenterContainer/VBoxContainer/LoadGameScene.grab_focus()
	load_complete.emit()

func _on_load_test_scene_button_pressed():
	loader.load_scene("res://scenes/TestScene/TestScene.tscn")
	pass # Replace with function body.

func _on_load_game_scene_button_pressed():
	loader.load_scene("res://scenes/GameScene/GameScene.tscn")
	pass # Replace with function body.

func _on_load_shop_scene_button_pressed():
	loader.load_scene("res://scenes/ShopScene/ShopScene.tscn")
	pass # Replace with function body.

func _on_load_ui_test_scene_button_pressed():
	loader.load_scene("res://scenes/UI/UITestScene.tscn")
	pass # Replace with function body.
