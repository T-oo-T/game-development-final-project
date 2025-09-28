class_name Robo extends CharacterBody2D

var speed := -30
var facing_left := true
@onready var ray := $RayCast2D

var GRAVITY := float(ProjectSettings.get_setting("physics/2d/default_gravity"))
var player: CharacterBody2D
var state: int
var STATE_SLEEP = 0
var STATE_PATROL = 1
	
	
func _ready() -> void:
	state = STATE_SLEEP
	player = get_parent().get_children().filter(func (child) -> bool:
		return child is Player
	)[0]
	
func _update_state() -> void:
	if (player.global_position - global_position).length() < 100:
		state = STATE_PATROL
	else:
		state = STATE_SLEEP
	
func _handle_state(delta: float) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
	match state:
		STATE_PATROL:	
			if !ray.is_colliding() and is_on_floor():
				flip()
		
			velocity.x = speed
			$AnimatedSprite2D.play("move")
		STATE_SLEEP:
			velocity.x = 0
			$AnimatedSprite2D.play("sleep")
		

func _physics_process(delta: float) -> void:
	_update_state()
	_handle_state(delta)
	move_and_slide()

func flip():
	facing_left = !facing_left
	
	scale.x = scale.x * -1
	
	if facing_left:
		speed = abs(speed) * -1
	else:
		speed = abs(speed)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
