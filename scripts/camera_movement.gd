extends Camera2D


export var follow_factor : float = 0.05


func _process(delta):
	position += (GameManager.get_player_position() - position) * follow_factor
