extends LoadableScene

@onready var oxygen_label: Label = $CanvasLayer/OxygenLabel
@onready var score_label : Label = $CanvasLayer/ScoreLabel
@onready var inscrease_oxygen_button : Button = $CanvasLayer/IncreaseOxygenButton
@onready var purchase_scythe_button : Button = $CanvasLayer/PurchaseScythe
@onready var purchase_ascent_button : Button = $CanvasLayer/PurchaseAscent
@onready var purchase_speed_button : Button = $CanvasLayer/PurchaseSpeed
@onready var purchaseSFX : AudioStreamPlayer = $purchase_sfx
@onready var purchaseFailSFX : AudioStreamPlayer = $purchase_fail_sfx

@export var oxygen_price = 10
@export var scythe_price = 20
@export var ascent_upgrade_price = 20
@export var speed_upgrade_base_price = 10
var speed_upgrade_max = 5

func _ready():
	inscrease_oxygen_button.text = "Increase Oxygen: %d$" % oxygen_price
	update_oxygen_label()
	update_score_label()
	update_scythe_label()
	update_ascent_label()
	update_speed_label()

	load_complete.emit()

func _process(delta):
	if Input.is_action_just_pressed("test_button"): 
		GameState.score = 999
		update_score_label()

func update_oxygen_label():
	oxygen_label.set_text("Current Oxygen: %d" % GameState.max_oxygen) 

func update_score_label():
	score_label.set_text("Current Score: %d$" % GameState.score)

func update_scythe_label():
	if GameState.enable_scythe : purchase_scythe_button.set_text("PURCHASED")
	else : purchase_scythe_button.set_text("Super Scythe: %d$" % scythe_price)

func update_ascent_label():
	if GameState.ascent_upgrade : purchase_ascent_button.set_text("PURCHASED")
	else : purchase_ascent_button.set_text("Ascent Upgrade : %d$" % ascent_upgrade_price)

func update_speed_label():
	if GameState.speed_upgrade == speed_upgrade_max : purchase_speed_button.set_text("PURCHASED")
	else :
		var current_price = speed_upgrade_base_price + (speed_upgrade_base_price * GameState.speed_upgrade)
		purchase_speed_button.set_text("Speed Upgrade : %d$" % current_price)

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
		purchase_scythe_button.set_text("PURCHASED")
		update_score_label()
		purchaseSFX.play()

func _on_purchase_ascent_button_down():
	if GameState.score < ascent_upgrade_price || GameState.ascent_upgrade == true:
		purchaseFailSFX.play()
	else :
		GameState.score -= ascent_upgrade_price
		GameState.ascent_upgrade = true
		purchase_ascent_button.set_text("PURCHASED")
		update_score_label()
		purchaseSFX.play()

func _on_purchase_speed_button_down():
	var current_price = speed_upgrade_base_price + (speed_upgrade_base_price * GameState.speed_upgrade) 
	if GameState.score < current_price: 
		purchaseFailSFX.play()
	elif GameState.speed_upgrade == speed_upgrade_max :
		purchase_speed_button.set_text("PURCHASED")
		purchaseFailSFX.play()
	else :
		GameState.score -= current_price
		GameState.speed_upgrade += 1
		
		if GameState.speed_upgrade == speed_upgrade_max :
			purchase_speed_button.set_text("PURCHASED")
		else :
			current_price = speed_upgrade_base_price + (speed_upgrade_base_price * GameState.speed_upgrade)
			purchase_speed_button.set_text("Speed Upgrade : %d$" % current_price)
		
		update_score_label()
		purchaseSFX.play()
