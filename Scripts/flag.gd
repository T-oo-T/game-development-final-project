class_name Flag extends Area2D

signal player_entered_flag


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered_flag.emit()	
