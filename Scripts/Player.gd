extends KinematicBody2D

var dimension_resources = preload("res://Resource/Dimension Resources.tres")

const GRAVITY = 400
const MAX_SPEED = 60
const ACCELERATION = 15
const JUMP_SPEED = 120
const FALL_ANIMATION_THRESHOLD = 50

const FLOOR_FRICTION_FACTOR = 0.3
const AIR_FRICTION_FACTOR = 0.05

const LOW_JUMP_FACTOR = 0.7
const CYOTE_TIME = 0.075
const JUMP_BUFFER_TIME = 0.1

const KNEEL_IMPACT_THRESHOLD = 100

const RIGID_BODY_PUSH_FACTOR = 0.05

var motion : Vector2 = Vector2(0,0)
var last_impulse : Vector2

var friction : bool = false
var walking : bool = false
var was_in_air : bool = false #was in the air on the last tick?
var kneeling : bool = false setget set_kneeling #Landing animation, stall movement

var cyote_time : float = 0
var jump_buffer : float = 0

onready var sprite : Sprite = $Sprite;
onready var animation_player : AnimationPlayer = $AnimationPlayer;

signal death_area_entered(area)

func death_area_entered(area):
	print("death area entered")
	emit_signal("death_area_entered", area)

func _ready():
	dimension_resources.player = self

func _exit_tree():
	dimension_resources.player = null

func play_or_continue(anim : String, speed : float = 1):
	animation_player.current_animation = anim
	animation_player.playback_speed = speed

func set_kneeling(value : bool): #method to allow the kneel animation to end itself
	kneeling = value

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		friction = false
		motion.x -= ACCELERATION;
		walking = true
		sprite.flip_h = true
	elif Input.is_action_pressed("right"):
		friction = false
		motion.x += ACCELERATION
		walking = true
		sprite.flip_h = false
	else:
		walking = false
		friction = true
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = JUMP_BUFFER_TIME
	if cyote_time >= 0 and jump_buffer >= 0:
		if not Input.is_action_pressed("jump"): #Buffered jump, low
			motion.y = -JUMP_SPEED * LOW_JUMP_FACTOR
		else:
			motion.y = -JUMP_SPEED
		kneeling = false
		cyote_time = -1
		jump_buffer = -1
	jump_buffer -= delta
		
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	motion.y += delta * GRAVITY
	
	if is_on_floor():
		if friction:
			motion.x = lerp(motion.x, 0, FLOOR_FRICTION_FACTOR)
		
		if was_in_air and last_impulse.y > KNEEL_IMPACT_THRESHOLD: #just landed!
			kneeling = true
			play_or_continue("Land")
			
		if not kneeling:
			if walking:
				play_or_continue("Walk", motion.x/MAX_SPEED)
			else:
				play_or_continue("Idle")
		
		cyote_time = CYOTE_TIME # reset cyote timer
		was_in_air = false
	else:
		if friction:
			motion.x = lerp(motion.x, 0, AIR_FRICTION_FACTOR)
		if abs(motion.y) > FALL_ANIMATION_THRESHOLD:
			if motion.y <= 0:
				play_or_continue("Jump")
			else:
				play_or_continue("Fall")
		
		if Input.is_action_just_released("jump") and motion.y <= 0:
			motion.y *= LOW_JUMP_FACTOR
		
		cyote_time -= delta # decrease cyote timer
		was_in_air = true
		kneeling = false
		
	var new_motion : Vector2 = move_and_slide(motion, Vector2.UP, false, 4, PI/4, false)
	last_impulse = motion-new_motion
	motion = new_motion
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("player_pushable"):
			var push_strength = last_impulse.dot(-collision.normal)
			collision.collider.apply_central_impulse(-collision.normal * push_strength * RIGID_BODY_PUSH_FACTOR)

func respawn(position: Vector2):
	global_position = position
	motion = Vector2(0,0)
	last_impulse = Vector2(0,0)
