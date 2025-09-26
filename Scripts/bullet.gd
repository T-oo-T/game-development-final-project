class_name Bullet extends Area2D

const SPEED = 60.0

var facing_right
var lifetime

func _ready() -> void:
	lifetime = Timer.new()
	add_child(lifetime)
	lifetime.wait_time = 1.0
	lifetime.one_shot = true
	lifetime.start()
	lifetime.timeout.connect(_on_lifetime_end)
	$AnimatedSprite2D.play("shoot")
	Sound.play(["shoot1","shoot2","shoot3"].pick_random())
	
func _on_lifetime_end() -> void:
	queue_free()
	
func _process(delta: float) -> void:
	var direction = 1.0 if facing_right else -1.0
	$AnimatedSprite2D.flip_h = not facing_right
	position.x += direction * SPEED * delta
	

func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		queue_free()
		
	if body is Robo:
		Sound.play("gunhit")
		body.queue_free()
