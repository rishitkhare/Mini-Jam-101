extends AnimationPlayer

func _on_jump():
	stop(true)
	play("Stretch")

func _on_land():
	stop(true)
	play("Squash")
