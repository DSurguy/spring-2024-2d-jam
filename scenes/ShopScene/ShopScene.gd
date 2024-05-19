extends LoadableScene

@onready var oxygen_label: Label = $CanvasLayer/Control/OxygenLabel
@onready var score_label : Label = $CanvasLayer/Control/ScoreLabel
@onready var inscrease_oxygen_button : Button = $CanvasLayer/Control/IncreaseOxygenButton
@onready var purchase_scythe_button : Button = $CanvasLayer/Control/PurchaseScythe
@onready var purchase_ascent_button : Button = $CanvasLayer/Control/PurchaseAscent
@onready var purchase_speed_button : Button = $CanvasLayer/Control/PurchaseSpeed
@onready var purchase_win_button : Button = $CanvasLayer/Control/WinButton

@onready var sfx: UISFX = $Uisfx

@export var oxygen_price = 10
@export var scythe_price = 20
@export var ascent_upgrade_price = 20
@export var speed_upgrade_base_price = 10
@export var win_base_price = 500
var speed_upgrade_max = 5

func _ready():
	inscrease_oxygen_button.text = "Increase Oxygen: %d$" % oxygen_price
	update_oxygen_label()
	update_score_label()
	update_scythe_label()
	update_ascent_label()
	update_speed_label()
	update_win_label()

	load_complete.emit()
	$CanvasLayer/Control/IncreaseOxygenButton.grab_focus()

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		print("bye")
		get_tree().quit()
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
	
func update_win_label():
	purchase_win_button.set_text("Gobo's Immortal Soul: %d" % win_base_price) 

func _on_start_level_button_pressed():
	sfx.accept()
	loader.load_scene("res://scenes/GameScene/GameScene.tscn")

func _on_increase_oxygen_button_pressed():
	if GameState.score < oxygen_price : 
		sfx.reject()
	else :
		GameState.max_oxygen += 10
		GameState.score -= oxygen_price
		update_oxygen_label()
		update_score_label()
		sfx.accept()

func _on_purchase_scythe_button_down():
	if GameState.score < scythe_price || GameState.enable_scythe == true:
		sfx.reject()
	else :
		GameState.score -= scythe_price
		GameState.enable_scythe = true
		purchase_scythe_button.set_text("PURCHASED")
		update_score_label()
		sfx.accept()

func _on_purchase_ascent_button_down():
	if GameState.score < ascent_upgrade_price || GameState.ascent_upgrade == true:
		sfx.reject()
	else :
		GameState.score -= ascent_upgrade_price
		GameState.ascent_upgrade = true
		purchase_ascent_button.set_text("PURCHASED")
		update_score_label()
		sfx.accept()

func _on_purchase_speed_button_down():
	var current_price = speed_upgrade_base_price + (speed_upgrade_base_price * GameState.speed_upgrade) 
	if GameState.score < current_price: 
		sfx.reject()
	elif GameState.speed_upgrade == speed_upgrade_max :
		purchase_speed_button.set_text("PURCHASED")
		sfx.reject()
	else :
		GameState.score -= current_price
		GameState.speed_upgrade += 1
		
		if GameState.speed_upgrade == speed_upgrade_max :
			purchase_speed_button.set_text("PURCHASED")
		else :
			current_price = speed_upgrade_base_price + (speed_upgrade_base_price * GameState.speed_upgrade)
			purchase_speed_button.set_text("Speed Upgrade : %d$" % current_price)
		
		update_score_label()
		sfx.accept()

func _on_purchase_win_button_down():
	if GameState.score < win_base_price:
		sfx.reject()
	else :
		sfx.accept()
		loader.load_scene("res://scenes/WinScene/WinScene.tscn")


func _on_start_level_button_mouse_entered():
	sfx.mouseover()


func _on_increase_oxygen_button_mouse_entered():
	sfx.mouseover()


func _on_purchase_scythe_mouse_entered():
	sfx.mouseover()


func _on_purchase_ascent_mouse_entered():
	sfx.mouseover()


func _on_purchase_speed_mouse_entered():
	sfx.mouseover()


func _on_win_button_mouse_entered():
	sfx.mouseover()
