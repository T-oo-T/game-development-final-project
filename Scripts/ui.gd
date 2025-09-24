class_name UI extends CanvasLayer

func set_score(score: int) -> void:
	$Score/Label.text = str(score)
