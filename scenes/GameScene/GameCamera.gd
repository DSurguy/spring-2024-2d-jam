extends Camera2D

const ZOOM_MAX = Vector2(0.1,0.1)
const ZOOM_MIN = Vector2(3,3)
const ZOOM_SPEED = 0.2
var zoom_in = false
var zoom_out = false

func _process(delta):
	if Input.is_action_just_released("zoom_up") and zoom > ZOOM_MAX:
		zoom_in = true
		zoom_out = false
	if Input.is_action_just_released("zoom_down") and zoom < ZOOM_MIN:
		zoom_out = true
	if zoom_in == true:
		zoom = lerp(zoom, zoom - Vector2(0.1,0.1), ZOOM_SPEED)
		await get_tree().create_timer(0.10).timeout
		zoom_in = false

	if zoom_out == true:
		zoom = lerp(zoom, zoom + Vector2(0.1,0.1), ZOOM_SPEED)
		await get_tree().create_timer(0.10).timeout
		zoom_out = false
