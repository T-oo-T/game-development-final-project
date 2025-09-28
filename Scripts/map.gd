class_name Map extends Node2D

signal player_reached_portal(all_coins_collected: bool)
signal update_score(score: int)
signal update_bullet_count(bullet_count: int)
signal update_lives(lives: int)
signal game_over
signal player_died

var score: int
var player: Player
var gun: Gun
var coins_count: int

func _ready() -> void:
	score = 0
	coins_count = 0
	for child in get_children():
		if child is Coin:
			child.player_entered_coin.connect(_player_collected_coin)
			coins_count += 1
		if child is Player:
			player = child
		if child is Gun:
			gun = child
	player.player_died.connect(_player_died)	
	player.player_shot_gun.connect(_player_shot_gun)
	update_score.emit(score)
	update_lives.emit(Gamestate.lives)
	update_bullet_count.emit(player.bullet_count)
	
func _player_died() -> void:
	player_died.emit()
	
func _player_collected_coin() -> void:
	score += 1
	update_score.emit(score)	
	
func _player_shot_gun(bullet_count) -> void:
	update_bullet_count.emit(bullet_count)

func _on_gun_body_entered(body: Node2D) -> void:
	if body is Player:
		gun.queue_free()
		player.has_gun = true
		player.bullet_count = 3
		update_bullet_count.emit(body.bullet_count)

func _on_portal_body_entered(body: Node2D) -> void:
	if body is Player:
		Sound.play("level_over")
		player_reached_portal.emit(score == coins_count)
