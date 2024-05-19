extends CanvasLayer
class_name Fade_UI

@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var cRect : ColorRect = $ColorRect

signal fade_out_complete

func fade_in():
	animator.play("fade_in")

func fade_out():
	animator.play("fade_out")
	await get_tree().create_timer(animator.current_animation_length).timeout
	print("woot")
	fade_out_complete.emit()
