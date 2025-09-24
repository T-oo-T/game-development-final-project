extends Node2D

const MAPS = [
	preload("res://Scenes/map1.tscn"),
	preload("res://Scenes/map2.tscn"),
	preload("res://Scenes/map3.tscn"),
]

var current_level_index: int
var current_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level_index = 0
	current_level = null
	_load_level(current_level_index)
	
func _load_level(level_idx: int) -> void:
	# remove old level if it exists
	if current_level:
		current_level.queue_free()
	
	# load new level
	current_level = MAPS[level_idx].instantiate()
	current_level.player_reached_flag.connect(_on_player_reached_flag)
	add_child(current_level)
	
func _on_player_reached_flag() -> void:
	current_level_index += 1
	
	if current_level_index == MAPS.size():
		print("you win the game!")
	else:
		# use call_deferred to get rid of warning
		call_deferred("_load_level", current_level_index)
