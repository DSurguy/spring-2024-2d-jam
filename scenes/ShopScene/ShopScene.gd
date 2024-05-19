extends LoadableScene

@onready var oxygen_label: Label = $CanvasLayer/OxygenLabel
@onready var score_label : Label = $CanvasLayer/ScoreLabel
@onready var inscrease_oxygen_button : Button = $CanvasLayer/IncreaseOxygenButton
@onready var purchaseSFX : AudioStreamPlayer = $purchase_sfx
@onready var purchaseFailSFX : AudioStreamPlayer = $purchase_fail_sfx

var oxygen_string = "Current Oxygen: %d"
var score_string = "Current Score: %d$"

@export var oxygen_price = 5

func _ready():
	inscrease_oxygen_button.text = "Increase Oxygen: %d$" % oxygen_price
	update_oxygen_label()
	update_score_lable()
	load_complete.emit()

func update_oxygen_label():
	oxygen_label.set_text(oxygen_string % GameState.max_oxygen) 

func update_score_lable():
	score_label.set_text(score_string % GameState.score)

func _on_start_level_button_pressed():
	loader.load_scene("res://scenes/GameScene/GameScene.tscn")

func _on_increase_oxygen_button_pressed():
	if GameState.score < oxygen_price : 
		purchaseFailSFX.play()
		return
	
	GameState.max_oxygen += 10
	GameState.score -= 100
	update_oxygen_label()
	update_score_lable()
	purchaseSFX.play()
