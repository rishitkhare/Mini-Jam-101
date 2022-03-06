extends Node2D

const COLOR_MOD_INCREASE = 2
const TIMER = 5

export var wind_direction : Vector2
export var orb_texture : Texture

onready var Sprite

onready var color_mod : Color

onready var collected : bool = false
onready var exploded : bool = false

func _ready():
	color_mod = Color(1,1,1)
# warning-ignore:return_value_discarded
	GameManager.connect("wind_set", self, "_on_wind_set")
	
func _process(_delta):
	if(collected && !exploded):
		var mod = color_mod.r + COLOR_MOD_INCREASE
		color_mod = Color(mod, mod, mod)
		$Sprite.modulate = color_mod
		
		if(mod > 50 && !exploded):
			GameManager.unfreeze_player()
			$Sprite.visible = false
			$Explode.restart()
			GameManager.camera.shake(5, 3)
			exploded = true

func _on_Area2D_body_entered(body):
	if(body.is_in_group("Player") && !collected):
		disable()

func disable():
	GameManager.current_wind_orb = self
	GameManager.set_wind_value(wind_direction)
	$Fire.emitting = false
	collected = true
	GameManager.freeze_player()

func enable():
	$AnimationPlayer.play("pop in")
	$Fire.emitting = true
	collected = false
	exploded = false
	$Sprite.visible = true
	color_mod = Color(1, 1, 1)
	$Sprite.modulate = Color(1,1,1)

func _on_wind_set(_new_wind_direction):
	if(GameManager.current_wind_orb != self && collected):
		enable()
