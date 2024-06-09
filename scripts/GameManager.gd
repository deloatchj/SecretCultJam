extends Node

var minesweeperlosecounter: int = 0
var minesweeperwincounter : int = 0

var evil : bool = false
var recentflag : bool = false
var winstate : bool = false

# TODO: increment losestate whenever player loses
# TODO: Make sure its impossible for state to cross 6
# TODO: use 'evil' to determine main menu UI

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if minesweeperlosecounter > 0:
		evil = true
	
	if minesweeperwincounter >= 5:
		winstate = true

	if winstate == true:
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
