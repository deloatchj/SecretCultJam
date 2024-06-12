extends Control

func _on_button_pressed():
	GameManager.minesweeperlosecounter = 0
	GameManager.minesweeperwincounter  = 0
	GameManager.evil = false
	GameManager.recentflag = false
	GameManager.winstate = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
