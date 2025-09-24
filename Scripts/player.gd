class_name Player extends CharacterBody2D

signal player_died

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var jumping: bool
var lives: int
var has_gun: bool

func _ready() -> void:
	jumping = false
	has_gun = false
	
func die() -> void:
	player_died.emit()
	
func _play_animation(animation: String) -> void:
	if has_gun:
		$AnimationPlayer.play("gun_" + animation)
	else:
		$AnimationPlayer.play(animation)
		
func _physics_process(delta: float) -> void:
	if position.y > 1500:
		die()
		
	# Add the gravity.
	if not is_on_floor():
		jumping = true
		velocity += get_gravity() * delta
	else:
		jumping = false

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY	
	
	# Handle direction	
	var direction := Input.get_axis("left", "right")
	if direction:
		_play_animation("run")
		velocity.x = direction * SPEED
		$Sprite2D.flip_h = direction == -1.0
	else:
		if jumping:
			_play_animation("jump")
		else:
			_play_animation("idle")
			
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# TODO: add some kind of cooldown to shooting
	if has_gun and Input.is_action_just_pressed("shoot"):
		print("shoot")
		_play_animation("shoot")
		

	move_and_slide()
