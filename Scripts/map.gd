class_name Map extends Node2D

signal player_reached_flag
signal update_score(score: int)

var score: int

func _ready() -> void:
	score = 0
	update_score.emit(score)
	for child in get_children():
		if child is Coin:
			print("do connect")
			child.player_entered_coin.connect(_player_collected_coin)

func _player_collected_coin() -> void:
	score += 1
	update_score.emit(score)
	print("current score: " + str(score))

func _on_flag_body_entered(body: Node2D) -> void:
	if body is Player:
		player_reached_flag.emit()
