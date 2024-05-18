extends LoadableScene

@onready var oxygen_label: Label = $CanvasLayer/OxygenLabel

var oxygen_foramt = "Current Oxygen: %d"

func _ready():
	_update_oxy_label()
	load_complete.emit()

func _update_oxy_label():
	oxygen_label.text = oxygen_foramt % GameState.max_oxygen

func _on_start_level_button_pressed():
	loader.load_scene("res://scenes/GameScene/GameScene.tscn")
	pass # Replace with function body.


func _on_increase_oxygen_button_pressed():
	GameState.max_oxygen += 10
	_update_oxy_label()
