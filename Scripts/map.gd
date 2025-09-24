class_name Map extends Node2D

signal player_reached_flag
signal update_score(score: int)
signal update_lives(lives: int)
signal game_over

var score: int
var player: Player

func _ready() -> void:
	score = 0
	for child in get_children():
		if child is Coin:
			child.player_entered_coin.connect(_player_collected_coin)
		if child is Player:
			player = child
	player.lives = 2
	player.player_died.connect(_player_died)
	update_score.emit(score)
	update_lives.emit(player.lives)


	
func _player_died() -> void:
	player.lives -= 1
	player.position = Vector2.ZERO
	update_lives.emit(player.lives)
	if (player.lives == 0):
		game_over.emit()
		
	print(player.lives)

func _player_collected_coin() -> void:
	score += 1
	update_score.emit(score)

func _on_flag_body_entered(body: Node2D) -> void:
	if body is Player:
		player_reached_flag.emit()
