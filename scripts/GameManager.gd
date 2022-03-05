extends Node

# Holds references to important nodes in the game

var player : Node2D

func register_player(player_node : Node2D) -> void:
	player = player_node


func get_player_position() -> Vector2:
	if(player == null):
		return Vector2()
	else:
		return player.position
