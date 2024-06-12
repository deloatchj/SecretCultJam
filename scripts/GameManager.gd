extends Node

var minesweeperlosecounter: int = 0
var minesweeperwincounter : int = 0

var evil : bool = false
var recentflag : bool = false
var winstate : bool = false

var max_flags = 10
var current_flags = 0
var game_over = false

func _ready():
	pass
	
func _physics_process(_delta):
	if minesweeperlosecounter > 0:
		evil = true
	
	if minesweeperwincounter >= 5:
		winstate = true

	if winstate == true:
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func can_place_flag() -> bool:
	return current_flags < max_flags

func place_flag():
	if game_over:
		return 
	if can_place_flag():
		current_flags += 1

func remove_flag():
	if current_flags > 0:
		current_flags -= 1

func set_max_flags(num_mines):
	max_flags = num_mines
	current_flags = 0
