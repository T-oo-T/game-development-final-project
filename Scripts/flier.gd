class_name Flier extends CharacterBody2D

var speed := 30
var player: CharacterBody2D
var state: int
const STATE_IDLE = 0
const STATE_CHASE = 1

func _ready() -> void:
	state = STATE_IDLE
	player = get_parent().get_children().filter(func (child) -> bool:
		return child is Player
	)[0]
	
func _physics_process(delta: float) -> void:
	var towardsPlayer = player.global_position - global_position
	
	if state == STATE_CHASE:
		var direction = towardsPlayer.normalized()	
		velocity.x = direction[0] * speed
		velocity.y = direction[1] * speed
	elif towardsPlayer.length() < 75:
		state = STATE_CHASE

	move_and_slide()
		

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
