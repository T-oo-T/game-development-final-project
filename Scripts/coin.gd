class_name Coin extends Area2D

signal player_entered_coin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("spin")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Sound.play("coin")
		queue_free()
		player_entered_coin.emit()
