extends KinematicBody2D

const HORIZONTAL_ACCEL = 20
const HORIZONTAL_DECEL = 0.8
const GRAVITY = 6
const TERMINAL_FALL_VEL = 120

const COYOTE_TIME_FRAMES = 20

const PRE_JUMP_LEEWAY = 20

const JUMP_POWER = -150

onready var velocity : Vector2 = Vector2()
onready var grounded : bool = false

onready var frames_since_last_jump_press : int = 1000
onready var frames_since_last_grounded : int = 1000

onready var shape : CollisionShape2D = $CollisionShape2D

onready var rc_up : RayCast2D = $Raycasts/Up
onready var rc_down : RayCast2D = $Raycasts/Down
onready var rc_downleft : RayCast2D = $Raycasts/Downleft
onready var rc_downright : RayCast2D = $Raycasts/Downright

onready var rc_left : RayCast2D = $Raycasts/Left
onready var rc_right : RayCast2D = $Raycasts/Right

func _ready():
	GameManager.register_player(self)
	
	
func _draw():
	draw_rect(Rect2(-shape.shape.extents, shape.shape.extents * 2), Color.aqua, false)
	
func _physics_process(_delta):
	var input : Vector2 = get_input()
	
	if(Input.is_key_pressed(KEY_Z)):
		apply_wind(Vector2(14, 0))
	
	do_x_movement(input)
	
	do_y_movement(input)


func get_input() -> Vector2:
	var input = Vector2()
	if(Input.is_action_pressed("ui_right")):
		input.x += 1
	elif(Input.is_action_pressed("ui_left")):
		input.x -= 1
	
	if(Input.is_action_pressed("ui_up")):
		input.y -= 1
	elif(Input.is_action_pressed("ui_down")):
		input.y += 1
		
	return input.normalized()
	
func do_x_movement(input : Vector2) -> void:
	velocity.x += input.x * HORIZONTAL_ACCEL
	velocity.x *= HORIZONTAL_DECEL
	
# warning-ignore:return_value_discarded
	move_and_slide(Vector2(velocity.x, 0))
	
func do_y_movement(_input : Vector2) -> void:
	velocity.y += GRAVITY
	
	if(velocity.y > TERMINAL_FALL_VEL):
		velocity.y = TERMINAL_FALL_VEL
	
	grounded = rc_down.is_colliding() || rc_downleft.is_colliding() || rc_downright.is_colliding()
	
	if(grounded):
		if(Input.is_action_just_pressed("ui_accept")):
			velocity.y = JUMP_POWER
		else:
			velocity.y = 0
	
	
	# warning-ignore:return_value_discarded
	move_and_slide(Vector2(0, velocity.y))
		
	


func apply_wind(direction : Vector2):
	velocity += direction
