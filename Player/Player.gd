extends KinematicBody2D

onready var SM = $StateMachine
onready var Backup = get_node("/root/Game/Player_Container/Backup_Camera")

var velocity = Vector2.ZERO
var jump_power = Vector2.ZERO
var direction = 1

var health = Global.save_data["general"]["health"]



export var gravity = Vector2(0,30)

export var move_speed = 20
export var max_move = 300

export var jump_speed = 100
export var max_jump = 2000

export var leap_speed = 100
export var max_leap = 1000

var moving = false
var is_jumping = false
var animating = false

export var light_attack = 10
export var medium_attack = 20
export var heavy_attack = 30
export var special = 25



func _physics_process(_delta):
	velocity.x = clamp(velocity.x,-max_move,max_move)
		
	if direction < 0 and not $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = true
	if direction > 0 and $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = false
	if direction < 0 and $Attack/Slash.rotation_degrees != 180:  $Attack/Slash.rotation_degrees = 180
	if direction > 0 and $Attack/Slash.rotation_degrees == 180: $Attack/Slash.rotation_degrees = 0
	Backup.position = position
	if health <= 0: 
		die()

		

func is_moving():
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		return true
	return false

func move_vector():
	return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),1.0)

func _unhandled_input(event):
	if event.is_action_pressed("left"):
		direction = -1
	if event.is_action_pressed("right"):
		direction = 1

func set_animation(anim):
	animating = true
	if $AnimatedSprite.animation == anim: return
	if $AnimatedSprite.frames.has_animation(anim): $AnimatedSprite.play(anim)
	else: $AnimatedSprite.play()


func die():
	Backup.current = true
	queue_free()


func _on_AnimatedSprite_animation_finished():
	animating = false

func damage(d):
	health -= d
	if health <= 0:
		die()
