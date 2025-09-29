class_name UI extends CanvasLayer

signal restart_game

# TODO: make UI and background scale when maximizing game
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

func set_best_time(elapsed_time: float) -> void:
	$"Best time".text = "Best time: %3.1f" %elapsed_time
	
func is_approx(a: float, b: float) -> bool:
	return abs(a - b) < 0.0001

func show_stats(current_times, best_times, map_stats) -> void:	
	var elements = [$Victory/Map_1_time, $Victory/Map_2_time, $Victory/Map_3_time] 
	for i in range(elements.size()):
		elements[i].text = "Map " + str(i+1) + ": %3.1f" %current_times[i]
		if is_approx(current_times[i], best_times[i]):
			elements[i].text += " (new record!)"
		if map_stats[i]:
			elements[i].text += ", perfect finish!"
	
	$Victory.visible = true

func show_game_over() -> void:
	$Gameover.visible = true
	
func hide_game_over() -> void:
	$Gameover.visible = false

func hide_stats() -> void:
	$Victory.visible = false

func _on_restart_pressed() -> void:
	restart_game.emit()
