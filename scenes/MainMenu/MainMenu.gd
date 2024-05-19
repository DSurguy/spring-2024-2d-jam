extends LoadableScene
@onready var sfx: UISFX = $Uisfx

func _ready():
	$CanvasLayer/MainMenu/VBoxContainer/CenterContainer/VBoxContainer/LoadGameScene.grab_focus()
	load_complete.emit()

func _on_load_test_scene_button_pressed():
	sfx.accept()
	loader.load_scene("res://scenes/TestScene/TestScene.tscn")	

func _on_load_game_scene_button_pressed():
	sfx.accept()
	loader.load_scene("res://scenes/GameScene/GameScene.tscn")	

func _on_load_shop_scene_button_pressed():
	sfx.accept()
	loader.load_scene("res://scenes/ShopScene/ShopScene.tscn")	

func _on_load_ui_test_scene_button_pressed():
	sfx.accept()
	loader.load_scene("res://scenes/UI/UITestScene.tscn")	


func _on_load_shop_scene_mouse_entered():
	sfx.mouseover()


func _on_load_game_scene_mouse_entered():
	sfx.mouseover()
