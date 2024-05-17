extends LoadableScene

func _on_button_pressed():
	$CanvasLayer/Helm.set_status(HelmUiPanel.HELM_STATUS.LEFT)
	pass # Replace with function body.


func _on_button_2_pressed():
	$CanvasLayer/Helm.set_status(HelmUiPanel.HELM_STATUS.RIGHT)
	pass # Replace with function body.


func _on_button_3_pressed():
	$CanvasLayer/Helm.set_status(HelmUiPanel.HELM_STATUS.NONE)
	pass # Replace with function body.
