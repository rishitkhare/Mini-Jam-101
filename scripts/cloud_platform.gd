extends KinematicBody2D

const DECEL = 0.9

var is_riding : bool = false

onready var velocity = Vector2()

func _physics_process(delta):
	if(GameManager.player == null || GameManager.player.riding != self):
		is_riding = false
	
	velocity += GameManager.get_wind_value()
	
	velocity *= DECEL
	
	if(is_riding):
		# warning-ignore:return_value_discarded
		GameManager.player.move_and_slide(velocity)
		
	# warning-ignore:return_value_discarded
	move_and_slide(velocity)
