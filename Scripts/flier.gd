class_name Flier extends CharacterBody2D

var speed := 30
var player: CharacterBody2D

func _ready() -> void:
	player = get_parent().get_children().filter(func (child) -> bool:
		return child is Player
	)[0]
	
func _physics_process(delta: float) -> void:
	var towardsPlayer = player.global_position - global_position
	var distance = towardsPlayer.length()
	var player_near = distance < 300
	var direction = towardsPlayer.normalized()

	if is_on_wall():
		direction = Vector2(0, -1)
		
	if player_near:
		velocity.x = direction[0] * speed
		velocity.y = direction[1] * speed
	else:
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()
		

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
