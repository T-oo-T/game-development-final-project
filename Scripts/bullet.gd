class_name Bullet extends Area2D

const SPEED = 30.0

var facing_right

func _ready() -> void:
	$AnimatedSprite2D.play("shoot")
	
func _process(delta: float) -> void:
	var direction = 1.0 if facing_right else -1.0
	$AnimatedSprite2D.flip_h = not facing_right
	position.x += direction * SPEED * delta
	

func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		queue_free()
		
	if body is Robo:
		body.queue_free()
