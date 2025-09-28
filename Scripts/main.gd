extends Node2D

const MAPS = [
	preload("res://Scenes/map1.tscn"),
	preload("res://Scenes/map2.tscn"),
	preload("res://Scenes/map3.tscn"),
]

const VICTORY_SCENE = preload("res://Scenes/victory.tscn")

var current_level_index: int
var current_level
var start_time: float
var game_timer: Timer
var elapsed_time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level = null	
	current_level_index = 2
	elapsed_time = 0
	_load_level(current_level_index)
	#Sound.play("main_music")
	
func _load_level(level_idx: int) -> void:
	# remove old level if it exists
	if current_level:
		current_level.queue_free()
	
	# load new level
	current_level = MAPS[level_idx].instantiate()
	current_level.player_reached_portal.connect(_on_player_reached_portal)
	current_level.update_score.connect(_update_score)
	current_level.update_lives.connect(_update_lives)
	current_level.update_bullet_count.connect(_update_bullet_count)
	current_level.game_over.connect(_game_over)
	add_child(current_level)
	
	# start timer
	start_time = Time.get_unix_time_from_system()
	game_timer = Timer.new()
	game_timer.autostart = true
	game_timer.wait_time = 1.0 / 60.0
	game_timer.timeout.connect(_update_elapsed_time)
	game_timer.start()
	add_child(game_timer)
	
	
func _update_elapsed_time() -> void:
	var current_time = Time.get_unix_time_from_system()
	elapsed_time = current_time - start_time
	$UI.set_elapsed_time(elapsed_time)
	
func _game_over() -> void:
	current_level_index = 0
	_load_level(0)
	
func _update_bullet_count(bullet_count) -> void:
	$UI.set_bullet_count(bullet_count)

func _update_score(score) -> void:
	$UI.set_score(score)
	
func _update_lives(lives) -> void:
	$UI.set_lives(lives)

func _on_player_reached_portal() -> void:
	Stats.set_time(current_level_index, elapsed_time)
		
	if current_level_index == MAPS.size() - 1:
		current_level.queue_free()
		game_timer.stop()
		$UI.show_stats()
	else:
		# use call_deferred to get rid of warning
		current_level_index += 1
		call_deferred("_load_level", current_level_index)
