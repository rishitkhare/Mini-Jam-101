extends AnimatedSprite

export(String, FILE, "*.tscn") var nextScene

func _on_body_entered(body):
	if(body.is_in_group("Player")):
		GameManager.load_scene(nextScene)

