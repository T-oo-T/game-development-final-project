class_name Map extends Node2D

signal player_reached_flag
var score: int

func _ready() -> void:
	score = 0
	for child in get_children():
		if child is Coin:
			print("do connect")
			child.player_entered_coin.connect(_player_collected_coin)

func _player_collected_coin() -> void:
	score += 1
	print("current score: " + str(score))

func _on_flag_body_entered(body: Node2D) -> void:
	if body is Player:
		player_reached_flag.emit()
