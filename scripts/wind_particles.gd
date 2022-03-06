extends Position2D


onready var active = false
onready var windstate = false

func _ready():
# warning-ignore:return_value_discarded
	GameManager.connect("wind_set", self, "_on_wind_set")

func _process(_delta):
	if(active):
		if(Input.is_action_pressed("wind") && !windstate):
			windstate = true
			$wind/AnimationPlayer.play("fade in")
		elif(!Input.is_action_pressed("wind") && windstate):
			windstate = false
			$wind/AnimationPlayer.play("fade out")

func _on_wind_set(direction : Vector2):
	rotation = direction.angle()
	active = true
	$wind.restart()
	
