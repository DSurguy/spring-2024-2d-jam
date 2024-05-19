class_name UISFX extends Node

@onready var _accept: AudioStreamPlayer = $accept
@onready var _reject: AudioStreamPlayer = $reject
@onready var _mouseover: AudioStreamPlayer = $mouseover

func accept():
	_accept.play()

func reject():
	_reject.play()

func mouseover():
	_mouseover.play()
