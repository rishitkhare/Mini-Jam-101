extends Node

# Holds references to important nodes in the game

var current_scene = null

var scene_file_path

var player : Node2D

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func _input(event):
	if(event is InputEventKey):
		if(event.pressed && event.scancode == KEY_U):
			load_scene("res://scenes/Testing environment.tscn")

func register_player(player_node : Node2D) -> void:
	player = player_node

func load_scene(scene_path : String):
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
		
func _deferred_load_scene(path):
	current_scene.free()
	
	# load scene from files
	var s = ResourceLoader.load(path)
	
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	$AnimationPlayer.play("Swipe To Scene")
