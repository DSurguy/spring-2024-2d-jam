extends LoadableScene

func _on_button_pressed():
	$CanvasLayer/Helm.set_status(HelmUI.HELM_STATUS.LEFT)
	pass # Replace with function body.

func _on_button_2_pressed():
	$CanvasLayer/Helm.set_status(HelmUI.HELM_STATUS.RIGHT)
	pass # Replace with function body.

func _on_button_3_pressed():
	$CanvasLayer/Helm.set_status(HelmUI.HELM_STATUS.NONE)
	pass # Replace with function body.

func _on_press_ascend():
	$CanvasLayer/AscendUI.set_status(AscendUI.BUTTON_STATUS.PRESSED)

func _on_press_un_ascend():
	$CanvasLayer/AscendUI.set_status(AscendUI.BUTTON_STATUS.NOT_PRESSED)
