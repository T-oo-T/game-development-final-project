class_name Player extends CharacterBody2D

signal player_died
signal player_shot_gun(bullet_count: int)

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var jumping: bool
var lives: int
var has_gun: bool
var BulletScene = preload("res://Scenes/bullet.tscn")
var facing_right: bool
var bullet_count: int

func _ready() -> void:
	jumping = false
	has_gun = false
	facing_right = true
	bullet_count = 0
	
func die() -> void:
	Sound.play("game_over")
	player_died.emit()
	
func _play_animation(animation: String) -> void:
	if has_gun and bullet_count > 0:
		$AnimationPlayer.play("gun_" + animation)
	else:
		$AnimationPlayer.play(animation)
		
func _physics_process(delta: float) -> void:
	if position.y > 300:
		die()
		
	# Add the gravity.
	if not is_on_floor():
		jumping = true
		velocity += get_gravity() * delta
	else:
		jumping = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY	
		Sound.play("jump")
	
	# Handle direction	
	var direction := Input.get_axis("left", "right")
	if direction:
		_play_animation("run")
		velocity.x = direction * SPEED
		facing_right = direction == 1.0
		$Sprite2D.flip_h = not facing_right
	else:
		if jumping:
			_play_animation("jump")
		else:
			_play_animation("idle")
			
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# TODO: add some kind of cooldown to shooting
	if has_gun and Input.is_action_just_pressed("shoot") and bullet_count > 0:
		_play_animation("shoot")
		var bullet = BulletScene.instantiate()
		bullet.facing_right = facing_right
		# match bullets position with the gun
		bullet.position.x = position.x + (10 if facing_right else -10)
		bullet.position.y = position.y + 4
		get_tree().root.add_child(bullet)
		bullet_count -= 1
		player_shot_gun.emit(bullet_count)
		

	move_and_slide()
