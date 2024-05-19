extends Node2D

func _ready():
	$GPUParticles2D.emitting = true

func _process(delta):
	if $GPUParticles2D.emitting == false:
		self.queue_free()
