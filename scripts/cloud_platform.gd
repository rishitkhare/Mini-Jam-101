extends KinematicBody2D

const DECEL = 0.95

var is_riding : bool = false

onready var velocity = Vector2()

func _process(_delta):
	if(GameManager.player.riding != self):
		is_riding = false
	
	velocity += GameManager.get_wind_value()
	
	velocity *= DECEL
	
	if(is_riding):
		# warning-ignore:return_value_discarded
		GameManager.player.move_and_slide(velocity)
		
	# warning-ignore:return_value_discarded
	move_and_slide(velocity)
