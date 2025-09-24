class_name UI extends CanvasLayer

func set_score(score: int) -> void:
	$Score/Label.text = str(score)

func set_lives(lives: int) -> void:
	if lives == 2:
		$Life.texture = load("res://Assets/Environment/life_full.png")
	if lives == 1:
		$Life.texture = load("res://Assets/Environment/life_half.png")
	if lives == 0:
		$Life.texture = load("res://Assets/Environment/life_empty.png")
