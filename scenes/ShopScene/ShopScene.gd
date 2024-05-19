extends LoadableScene

@onready var oxygen_label: Label = $CanvasLayer/OxygenLabel
@onready var score_label : Label = $CanvasLayer/ScoreLabel
@onready var inscrease_oxygen_button : Button = $CanvasLayer/IncreaseOxygenButton
@onready var purchase_scythe_button : Button = $CanvasLayer/PurchaseScythe
@onready var purchaseSFX : AudioStreamPlayer = $purchase_sfx
@onready var purchaseFailSFX : AudioStreamPlayer = $purchase_fail_sfx

@export var oxygen_price = 10
@export var scythe_price = 20

func _ready():
	inscrease_oxygen_button.text = "Increase Oxygen: %d$" % oxygen_price
	update_oxygen_label()
	update_score_label()
	update_scythe_label()

	load_complete.emit()

func update_oxygen_label():
	oxygen_label.set_text("Current Oxygen: %d" % GameState.max_oxygen) 

func update_score_label():
	score_label.set_text("Current Score: %d$" % GameState.score)

func update_scythe_label():
	if GameState.enable_scythe : 
		purchase_scythe_button.text = "PURCHASED"
	else : 
		purchase_scythe_button.set_text("Purchase Super Scythe: %d$" % scythe_price)

func _on_start_level_button_pressed():
	loader.load_scene("res://scenes/GameScene/GameScene.tscn")

func _on_increase_oxygen_button_pressed():
	if GameState.score < oxygen_price : 
		purchaseFailSFX.play()
	else :
		GameState.max_oxygen += 10
		GameState.score -= oxygen_price
		update_oxygen_label()
		update_score_label()
		purchaseSFX.play()

func _on_purchase_scythe_button_down():
	if GameState.score < scythe_price || GameState.enable_scythe == true:
		purchaseFailSFX.play()
	else :
		GameState.score -= scythe_price
		GameState.enable_scythe = true
		purchase_scythe_button.text = "PURCHASED"
		purchaseSFX.play()
