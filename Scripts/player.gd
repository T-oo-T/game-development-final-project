class_name Player extends CharacterBody2D

signal player_died

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var jumping: bool
var lives: int

func _ready() -> void:
	jumping = false
	
func _physics_process(delta: float) -> void:
	if position.y > 1500:
		player_died.emit()
		
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
		$AnimationPlayer.play("run")
		velocity.x = direction * SPEED
		$Sprite2D.flip_h = direction == -1.0
	else:
		if jumping:
			$AnimationPlayer.play("jump")
		else:
			$AnimationPlayer.play("idle")
			
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
