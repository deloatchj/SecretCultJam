extends Node

var minesweeperlosecounter: int = 0
var minesweeperwincounter : int = 0

var evil : bool = false
var recentflag : bool = false
var winstate : bool = false

var max_flags = 10
var current_flags = 0

# TODO: increment losestate whenever player loses
# TODO: Make sure its impossible for state to cross 6
# TODO: use 'evil' to determine main menu UI

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
	if can_place_flag():
		current_flags += 1

func remove_flag():
	if current_flags > 0:
		current_flags -= 1
