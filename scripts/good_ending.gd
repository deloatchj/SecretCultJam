extends Control

func _ready():
	if GameManager.minesweeperlosecounter > 0:
		$Label.text = "Just another little sunday evening
activity for a cultist....

Thinking about it now, its going to
be hard to explain the missing 
fingers to the uninitiated."
	else:
		$Label.text = "What a lovely evening,just playing 
le old game of minesweeper, with 
absolutely no creepy,painful or 
irreversible consequences, until
 the next ritual, that is..."


func _on_back_pressed():
	GameManager.minesweeperlosecounter = 0
	GameManager.minesweeperwincounter  = 0
	GameManager.evil = false
	GameManager.recentflag = false
	GameManager.winstate = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
