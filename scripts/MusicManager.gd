extends Node2D

onready var is_title = true

func fade_to_title():
	if(!is_title):
		$AnimationPlayer.play("fade to title")
		is_title = true
	
func fade_to_game():
	if(is_title):
		$AnimationPlayer.play("fade to game")
		is_title = false
