extends KinematicBody2D

const TIME_FACTOR = 5

const HORIZONTAL_ACCEL = 5
const HORIZONTAL_DECEL = 0.8
const GRAVITY = 0.3
const TERMINAL_FALL_VEL = 25

const JUMP_POWER = -30

onready var velocity : Vector2 = Vector2()
onready var grounded : bool = false

onready var rc_up : RayCast2D = $Raycasts/Up
onready var rc_down : RayCast2D = $Raycasts/Down
onready var rc_left : RayCast2D = $Raycasts/Left
onready var rc_right : RayCast2D = $Raycasts/Right

func _ready():
	GameManager.register_player(self)
	
func _physics_process(_delta):
	var input : Vector2 = get_input()
	
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
	move_and_slide(Vector2(velocity.x, 0) * TIME_FACTOR)
	
func do_y_movement(_input : Vector2) -> void:
	velocity.y += 1
	
	if(velocity.y > TERMINAL_FALL_VEL):
		velocity.y = TERMINAL_FALL_VEL
	
	grounded = rc_down.is_colliding()
	
	if(grounded):
		velocity.y = 0
		
		if(Input.is_action_pressed("ui_accept")):
			velocity.y = JUMP_POWER
			
			
	# warning-ignore:return_value_discarded
	move_and_slide(Vector2(0, velocity.y) * TIME_FACTOR)

