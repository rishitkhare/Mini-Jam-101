extends KinematicBody2D

const HORIZONTAL_ACCEL = 27
const HORIZONTAL_DECEL = 0.75
const HORIZONTAL_AIR_DECEL = 0.78
const JUMP_GRAVITY = 2
const GRAVITY = 10
const TERMINAL_FALL_VEL = 170

const SHAKE_THRESHOLD = 80

const COYOTE_TIME_FRAMES = 10

const PRE_JUMP_LEEWAY = 10

const JUMP_POWER = -110
const JUMP_LENGTH = 20


signal land
signal jump

signal animate(input, velocity, grounded)


onready var frozen : bool = false
onready var velocity : Vector2 = Vector2()
onready var grounded : bool = false
onready var riding : Object = null

onready var frames_since_last_jump_press : int = 1000
onready var frames_since_last_grounded : int = 1000
onready var frames_holding_jump_key : int = 0
onready var falling_frames = 0

onready var shape : CollisionShape2D = $CollisionShape2D

onready var dust_emitter : Node2D = $DustEmitter

onready var rc_up : RayCast2D = $Raycasts/Up
onready var rc_down : RayCast2D = $Raycasts/Down
onready var rc_downleft : RayCast2D = $Raycasts/Downleft
onready var rc_downright : RayCast2D = $Raycasts/Downright

onready var rc_left : RayCast2D = $Raycasts/Left
onready var rc_right : RayCast2D = $Raycasts/Right

func _ready():
	GameManager.register_player(self)
	
func _physics_process(_delta):
	if(!frozen):
		platforming_code()

func platforming_code():
	var platform = rc_down.get_collider()
	
	if(platform == null):
		platform = rc_downleft.get_collider()
		
	if(platform == null):
		platform = rc_downright.get_collider()
		
		
	
	if(platform != null && platform.is_in_group("Ridable")):
		print("riding")
		platform.is_riding = true
		riding = platform
	else:
		if(riding != null):
			velocity += riding.velocity
			riding = null
		apply_wind(GameManager.get_wind_value())
	
	var input : Vector2 = get_input()
	
	count_frames()
	
	do_x_movement(input)
	
	do_y_movement(input)
	
	emit_signal("animate", input, velocity, grounded)

func get_input() -> Vector2:
	var input = Vector2()
	if(Input.is_action_pressed("playermove_right")):
		input.x += 1
	elif(Input.is_action_pressed("playermove_left")):
		input.x -= 1
	
	if(Input.is_action_pressed("playermove_up")):
		input.y -= 1
	elif(Input.is_action_pressed("playermove_down")):
		input.y += 1
		
	if(frames_holding_jump_key > 0 && Input.is_action_pressed("jump_key")):
		frames_holding_jump_key += 1
		
		if(frames_holding_jump_key > 2048):
			frames_holding_jump_key = 2048
	else:
		frames_holding_jump_key = 0
	
	return input.normalized()
	
func do_x_movement(input : Vector2) -> void:
	velocity.x += input.x * HORIZONTAL_ACCEL
	if(grounded):
		velocity.x *= HORIZONTAL_DECEL
	else:
		velocity.x *= HORIZONTAL_AIR_DECEL
	
	# walls stop momentum
	if(rc_left.is_colliding() && velocity.x < 0):
		velocity.x = 0
	if(rc_right.is_colliding() && velocity.x > 0):
		velocity.x = 0
	
	# warning-ignore:return_value_discarded
	move_and_slide(Vector2(velocity.x, 0))
	
func do_y_movement(_input : Vector2) -> void:
	
	if(frames_holding_jump_key > 0 && frames_holding_jump_key < JUMP_LENGTH):
		velocity.y += JUMP_GRAVITY
	else:
		velocity.y += GRAVITY
	
	if(velocity.y > TERMINAL_FALL_VEL):
		velocity.y = TERMINAL_FALL_VEL
		falling_frames += 1
	else:
		falling_frames = 0
	
	if(rc_up.is_colliding()):
		velocity.y = GRAVITY
		frames_holding_jump_key = 2048
	
	var new_grounded = rc_down.is_colliding() || rc_downleft.is_colliding() || rc_downright.is_colliding()
	
	if(new_grounded && !grounded):
		emit_signal("land")
		if(velocity.y == TERMINAL_FALL_VEL && falling_frames > SHAKE_THRESHOLD):
			GameManager.camera.shake(25, 4)
	
	grounded = new_grounded
	
	if(grounded):
		if(velocity.y > 0):
			velocity.y = 0
		frames_since_last_grounded = 0
	else:
		frames_since_last_grounded += 1
		if(frames_since_last_grounded > 2048):
			frames_since_last_grounded = 2048
	
	if(frames_since_last_grounded < COYOTE_TIME_FRAMES):
		if(frames_since_last_jump_press < PRE_JUMP_LEEWAY):
			frames_holding_jump_key = 1
			
			emit_signal("jump")
			velocity.y = JUMP_POWER
			frames_since_last_grounded = 2048
			frames_since_last_jump_press = 2048
	
	# warning-ignore:return_value_discarded
	move_and_slide(Vector2(0, velocity.y))
		
	
func count_frames() -> void:
	if(Input.is_action_just_pressed("jump_key")):
		frames_since_last_jump_press = 0
	else:
		frames_since_last_jump_press += 1
		if(frames_since_last_jump_press > 2048):
			frames_since_last_jump_press = 2048


func apply_wind(direction : Vector2):
	velocity += direction
