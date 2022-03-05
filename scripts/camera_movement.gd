extends Camera2D


export var follow_factor_x : float = 0.05
export var follow_factor_y : float = 0.07

onready var unrounded_position = position


func _process(_delta):
	$CPUParticles2D.emitting = Input.is_key_pressed(KEY_Z)
		
	
	unrounded_position.x += (GameManager.get_player_position().x - unrounded_position.x) * follow_factor_x
	unrounded_position.y += (GameManager.get_player_position().y - unrounded_position.y) * follow_factor_y
	
	position = Vector2(round(unrounded_position.x), round(unrounded_position.y))
