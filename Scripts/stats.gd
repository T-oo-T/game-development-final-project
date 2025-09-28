extends Node

var stats = []

func _ready() -> void:
	stats = [-1.0, -1.0, -1.0]
	
func set_time(map_index: int, time: float) -> void:
	stats[map_index] = time

func get_stats() -> Array:
	return stats
