class_name Robo extends CharacterBody2D

var speed := -30
var facing_left := true
@onready var ray := $RayCast2D

var GRAVITY := float(ProjectSettings.get_setting("physics/2d/default_gravity"))

func _ready() -> void:
	$AnimatedSprite2D.play("move")
	
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	if !ray.is_colliding() and is_on_floor():
		flip()
	
	velocity.x = speed
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
