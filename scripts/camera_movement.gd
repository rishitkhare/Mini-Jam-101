extends Camera2D


export var follow_factor_x : float = 0.08
export var follow_factor_y : float = 0.08

onready var unrounded_position = position

onready var shake_counter : int
onready var shake_intensity : float
onready var rng = RandomNumberGenerator.new()

func shake(length : int, intensity : float):
	shake_counter = length
	shake_intensity = intensity
	
func _ready():
	randomize()
	GameManager.register_camera(self)

func _process(_delta):
	unrounded_position.x += (GameManager.get_player_position().x - unrounded_position.x) * follow_factor_x
	unrounded_position.y += (GameManager.get_player_position().y - unrounded_position.y) * follow_factor_y
	
	position = Vector2(round(unrounded_position.x), round(unrounded_position.y))
	
	perform_shake()
	
func perform_shake():
	if(shake_counter > 0):
		shake_counter -= 1
		shake_intensity -= 0.5
		if(shake_intensity < 1):
			shake_intensity = 1
		var randx = rng.randf_range(-shake_intensity, shake_intensity)
		var randy = rng.randf_range(-shake_intensity, shake_intensity)
		
		offset = Vector2(randx, randy)
	else:
		offset = Vector2()
