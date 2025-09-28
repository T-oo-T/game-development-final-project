extends Node2D

const MAPS = [
	preload("res://Scenes/map1.tscn"),
	preload("res://Scenes/map2.tscn"),
	preload("res://Scenes/map3.tscn"),
]

var current_level_index: int
var current_level
var start_time: float
var game_timer: Timer
var elapsed_time: float
var stats
var best_times
var current_times
var lives
const FILE_PATH = "user://stats.txt"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level = null	
	current_level_index = 0
	elapsed_time = 0
	#print(OS.get_data_dir())
	
	if not FileAccess.file_exists(FILE_PATH):
		print("stats file does not exists, init as empty stats")	
		var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
		file.store_var([INF, INF, INF])
		
	best_times = FileAccess.open(FILE_PATH, FileAccess.READ).get_var()
	current_times = [INF, INF, INF]
	_load_level(current_level_index)
	Sound.play("main_music")
		
	
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
	current_level.player_died.connect(_on_player_died)
	add_child(current_level)
	
	# start timer
	start_time = Time.get_unix_time_from_system()
	game_timer = Timer.new()
	game_timer.autostart = true
	game_timer.wait_time = 1.0 / 60.0
	game_timer.timeout.connect(_update_elapsed_time)
	game_timer.start()
	add_child(game_timer)
	
	_update_lives(Gamestate.lives)
	$UI.set_best_time(best_times[level_idx])
	
	
func _update_elapsed_time() -> void:
	var current_time = Time.get_unix_time_from_system()
	elapsed_time = current_time - start_time
	$UI.set_elapsed_time(elapsed_time)
	
func _restart_game() -> void:
	current_level_index = 0
	Gamestate.lives = 2
	_load_level(current_level_index)
	
func _on_player_died() -> void:
	if (Gamestate.lives == 0):
		current_level.queue_free()
		remove_child(game_timer)
		$UI.show_game_over()
	else:
		Gamestate.lives -= 1
		_load_level(current_level_index)
	
func _update_bullet_count(bullet_count) -> void:
	$UI.set_bullet_count(bullet_count)

func _update_score(score) -> void:
	$UI.set_score(score)
	
func _update_lives(lives) -> void:
	$UI.set_lives(lives)

func _on_player_reached_portal(all_coins_collected) -> void:
	Gamestate.map_stats[current_level_index] = all_coins_collected
	current_times[current_level_index] = elapsed_time
		
	if current_level_index == MAPS.size() - 1:
		current_level.queue_free()
		remove_child(game_timer)
		
		for i in range(current_times.size()):
			if current_times[i] < best_times[i]:
				best_times[i] = current_times[i]
		
		var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
		file.store_var(best_times)
		$UI.show_stats(current_times, best_times, Gamestate.map_stats)
	else:
		# use call_deferred to get rid of warning
		current_level_index += 1
		call_deferred("_load_level", current_level_index)


func _on_ui_restart_game() -> void:
	$UI.hide_stats()
	$UI.hide_game_over()
	_restart_game()	
