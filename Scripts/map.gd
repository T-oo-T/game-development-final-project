extends Node2D

signal player_reached_flag

func _on_flag_body_entered(body: Node2D) -> void:
	if body is Player:
		player_reached_flag.emit()
