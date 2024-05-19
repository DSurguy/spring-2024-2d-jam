extends LoadableScene

@onready var button: Button = $CanvasLayer/Control/VBoxContainer/Button

func _ready():
	button.grab_focus()
	load_complete.emit()

func _on_button_pressed():
	loader.load_scene("res://scenes/MainMenu/MainMenu.tscn")
	pass # Replace with function body.
