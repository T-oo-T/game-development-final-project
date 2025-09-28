class_name UI extends CanvasLayer

# TODO: make UI and background scale when maximizing game
# TODO: Gamer can see how fast she passes the level
# TODO: There are various maps with _increasing_ difficulty
# TODO: The enemies have “some intelligence” (state machine is enough)
# TODO: All the settings and game records (high score / TOP10, passed levels, etc) are stored in a save file(s)
# TODO: Shader effects are used to improve the visual style and immersion
# TODO: Music adapts to game situations (e.g. the health level is lower, music is more intensive)
func set_score(score: int) -> void:
	$Score/Label.text = str(score)

func set_lives(lives: int) -> void:
	if lives == 2:
		$Life.texture = load("res://Assets/Environment/life_full.png")
	if lives == 1:
		$Life.texture = load("res://Assets/Environment/life_half.png")
	if lives == 0:
		$Life.texture = load("res://Assets/Environment/life_empty.png")

func set_bullet_count(bullet_count: int) -> void:
	$BulletCount/Label.text = str(bullet_count)

func set_elapsed_time(elapsed_time: float) -> void:
	$Time.text = "Time: %3.1f" %elapsed_time

func show_stats() -> void:
	var stats = Stats.get_stats()
	
	$Victory/Map_1_time.text = "Map 1: %3.1f" %stats[0]
	$Victory/Map_2_time.text = "Map 2: %3.1f" %stats[1]
	$Victory/Map_3_time.text = "Map 3: %3.1f" %stats[2]
	$Victory.visible = true
