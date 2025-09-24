class_name Bullet extends Area2D

const SPEED = 30.0

var going_right

func _ready() -> void:
	$AnimatedSprite2D.play("shoot")
	going_right = true

func _process(delta: float) -> void:
	var direction := 1.0 if going_right else -1.0
	position.x += direction * SPEED * delta
	

func _on_body_entered(body: Node2D) -> void:
	queue_free()
		
	if body is Robo:
		body.queue_free()
		print("bullet hit enemy!")
