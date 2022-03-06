extends AnimatedSprite


func _on_animate(input : Vector2, velocity : Vector2, grounded : bool) -> void:
	if(grounded):
		if(input.x > 0):
			play("Walk")
			flip_h = false
		elif(input.x < 0):
			play("Walk")
			flip_h = true
		else:
			play("Idle")

	else:
		if(input.x > 0):
			flip_h = false
		elif(input.x < 0):
			flip_h = true
		
		if(velocity.y < -40):
			play("Jump")
		elif(velocity.y < 40):
			play("Float")
		else:
			play("Fall")
		
