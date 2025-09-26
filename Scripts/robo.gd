class_name Robo extends CharacterBody2D

var speed := -30
var facing_left := true
@onready var ray := $RayCast2D

var GRAVITY := float(ProjectSettings.get_setting("physics/2d/default_gravity"))
var player: CharacterBody2D

func _ready() -> void:
	$AnimatedSprite2D.play("sleep")
	player = get_parent().get_children().filter(func (child) -> bool:
		return child is Player
	)[0]
	
func _physics_process(delta: float) -> void:
	var distance = (player.global_position - global_position).length()
	var player_near = distance < 100
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	if !ray.is_colliding() and is_on_floor():
		flip()
	
	if player_near:
		velocity.x = speed
		$AnimatedSprite2D.play("move")
	else:
		velocity.x = 0
		$AnimatedSprite2D.play("sleep")
	
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
