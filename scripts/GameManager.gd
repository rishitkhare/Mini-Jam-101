extends Node

const DEATH_TIME = 20
const WIND_BOOST = -90

signal wind_set

# Holds references to important nodes in the game

var current_scene = null

var scene_file_path
onready var transitioning = false

var current_wind_orb
var wind_status : Vector2 = Vector2()

var player : Node2D
var camera : Camera2D

var death_timer = 0

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	scene_file_path = get_tree().current_scene.filename

func _process(_delta):
	if(Input.is_key_pressed(KEY_R)):
		load_scene(scene_file_path)
	
	
	if(player != null && camera != null):
		var oob = player.position.x > camera.limit_right + 20
		oob = oob || player.position.x < camera.limit_left
		oob = oob || player.position.y < camera.limit_top
	
		if(oob):
			load_scene(scene_file_path)
		
		if(player.position.y > camera.limit_bottom + 20 && death_timer == 0):
			player.frozen = true
			camera.shake(15,5)
			$Death_sound.play()
			death_timer += 1
		
		if(death_timer > 0):
			death_timer += 1
			
			if(death_timer > DEATH_TIME):
				load_scene(scene_file_path)

func register_player(player_node : Node2D) -> void:
	player = player_node
	
func register_camera(camera_node : Camera2D) -> void:
	camera = camera_node

func freeze_player():
	player.frozen = true
	var sprite : AnimatedSprite = player.get_node("AnimatedSprite")
	var squash_stretch : AnimationPlayer = player.get_node("SquashStretch")
	sprite.speed_scale = 0
	sprite.modulate = Color(255,255,255)
	squash_stretch.play("Squash")

func unfreeze_player():
	player.frozen = false
	var sprite : AnimatedSprite = player.get_node("AnimatedSprite")
	sprite.speed_scale = 1
	sprite.modulate = Color(1,1,1)

func get_wind_value() -> Vector2:
	if(Input.is_action_pressed("wind")):
		return wind_status
	else:
		return Vector2()

func set_wind_value(new_direction : Vector2):
	wind_status = new_direction
	emit_signal("wind_set", wind_status)
	if(Input.is_action_pressed("jump_key")):
		player.velocity.y += WIND_BOOST

func load_scene(scene_path : String):
	if(scene_path == "res://scenes/Title.tscn"):
		MusicManager.fade_to_title()
	else:
		MusicManager.fade_to_game()
	
	if(transitioning):
		return
	
	var file_checker = File.new()
	if(!file_checker.file_exists(scene_path)):
		push_warning("unable to find file: \"" + scene_path + "\"")
		return
	
	transitioning = true
	
	$AnimationPlayer.play("Swipe to Black")
	
	scene_file_path = scene_path

func get_player_position() -> Vector2:
	if(player == null):
		return Vector2()
	else:
		return player.position


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Swipe to Black"):
		call_deferred("_deferred_load_scene", scene_file_path)
	
	if(anim_name == "Swipe To Scene"):
		
		transitioning = false
		
func _deferred_load_scene(path):
	# reset
	current_wind_orb = null
	wind_status = Vector2()
	death_timer = 0
	player = null
	camera = null
	current_scene.free()
	
	# load scene from files
	var s = ResourceLoader.load(path)
	
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	$AnimationPlayer.play("Swipe To Scene")
