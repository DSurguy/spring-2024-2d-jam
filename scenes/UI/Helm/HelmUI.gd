class_name HelmUiPanel extends Control

@onready var LeftArrow = $Panel/VBoxContainer/GridContainer/HBoxContainer/LeftArrowTexture
@onready var RightArrow = $Panel/VBoxContainer/GridContainer/HBoxContainer2/RightArrowTexture

enum HELM_STATUS { LEFT, RIGHT, NONE }
@export var status: HELM_STATUS = HELM_STATUS.NONE
var active_color = Color(0.55, 0.68, 1)
signal status_changed

func set_status(next_status: HELM_STATUS):
	status = next_status
	emit_signal("status_changed")
	pass

func _on_status_changed():
	if status == HELM_STATUS.LEFT:
		LeftArrow.modulate = active_color
		RightArrow.modulate = Color(1,1,1)
	elif status == HELM_STATUS.RIGHT:
		LeftArrow.modulate = Color(1,1,1)
		RightArrow.modulate = active_color
	else:
		LeftArrow.modulate = Color(1,1,1)
		RightArrow.modulate = Color(1,1,1)
